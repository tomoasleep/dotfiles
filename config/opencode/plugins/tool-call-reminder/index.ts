import { closeSync, mkdirSync, openSync, unlinkSync } from "node:fs"
import { homedir } from "node:os"
import { join } from "node:path"
import { Plugin } from "@opencode/plugin"

const TAG_AT_END = /<\s*\/?\s*([A-Za-z][A-Za-z0-9_.:-]*)[^<>]*>\s*$/
const SNIPPET_CONTEXT = 80
const SNIPPET_MAX = 480
const MAX_CONSECUTIVE_REMINDS = 10
export const MARKER = "tool-call-reminder"
export { MAX_CONSECUTIVE_REMINDS }

const LOCK_DIR = join(homedir(), ".cache", "opencode", "tool-call-reminder")

export interface MessageLike {
  id: string
  type: string
  time: { created: number }
  metadata?: Record<string, unknown>
  text?: string
  outcome?: string
  content?: Array<{ type: string; text?: string }>
}

export interface ReminderPlan {
  assistantID: string
  tag: string
  snippet: string
}

function lastText(message: MessageLike): string | undefined {
  const texts = (message.content ?? []).filter((part) => part.type === "text")
  return texts.at(-1)?.text
}

function trailingTag(message: MessageLike): { tag: string; snippet: string } | null {
  const text = lastText(message)?.trimEnd()
  if (!text) return null
  const match = text.match(TAG_AT_END)
  if (!match) return null
  const raw = text.slice(Math.max(0, match.index - SNIPPET_CONTEXT))
  return { tag: match[1], snippet: raw.length > SNIPPET_MAX ? `…${raw.slice(-SNIPPET_MAX)}` : raw }
}

export function reminder(snippet: string) {
  return `<system-reminder>
Your previous message ended with the following tool-call-like tag written as plain message text:

${snippet}

A tag written as text is not a tool call and has no effect. If you intended a tool call, re-issue it now through the actual tool-call mechanism (never as message text). If this was inline markup rather than a tool call, no tool call is needed.
</system-reminder>`
}

export function planReminder(messages: readonly MessageLike[]): ReminderPlan | null {
  const assistant = messages.findLast((m) => m.type === "assistant")
  if (!assistant) return null

  const idleAfter = messages.findLast(
    (m) => m.type === "idle" && m.time.created > assistant.time.created,
  )
  if (idleAfter && idleAfter.outcome !== "succeeded") return null

  const trailing = trailingTag(assistant)
  if (!trailing) return null

  let consecutive = 0
  for (let i = messages.length - 1; i >= 0; i--) {
    const message = messages[i]
    if (message.type === "synthetic") {
      if (message.metadata?.source !== MARKER) continue
      if (message.metadata.for === assistant.id) return null
      consecutive++
      continue
    }
    if (message.type === "assistant") {
      if (message.id === assistant.id) continue
      if (trailingTag(message)) continue
      break
    }
    if (message.type === "user") break
  }
  if (consecutive >= MAX_CONSECUTIVE_REMINDS) return null

  return { assistantID: assistant.id, tag: trailing.tag, snippet: trailing.snippet }
}

function acquireLock(sessionID: string, messageID: string): boolean {
  try {
    mkdirSync(LOCK_DIR, { recursive: true })
    const fd = openSync(join(LOCK_DIR, `${sessionID}.${messageID}`), "wx")
    closeSync(fd)
    return true
  } catch {
    return false
  }
}

function releaseLock(sessionID: string, messageID: string) {
  try {
    unlinkSync(join(LOCK_DIR, `${sessionID}.${messageID}`))
  } catch {}
}

export default Plugin.define({
  id: "tool-call-reminder",
  async setup(ctx) {
    const controller = new AbortController()

    void (async () => {
      for await (const event of ctx.event.subscribe({
        types: ["session.execution.succeeded"],
        signal: controller.signal,
      })) {
        const sessionID = event.data.sessionID
        try {
          const session = await ctx.session.get({ sessionID })
          if (session.parentID) continue

          const messages = await ctx.session.context({ sessionID })
          const plan = planReminder(messages)
          if (!plan) continue
          if (!acquireLock(sessionID, plan.assistantID)) continue

          try {
            await ctx.session.synthetic({
              sessionID,
              text: reminder(plan.snippet),
              metadata: { source: MARKER, for: plan.assistantID },
            })
          } catch (error) {
            releaseLock(sessionID, plan.assistantID)
            throw error
          }
        } catch (error) {
          console.error("[tool-call-reminder]", error)
        }
      }
    })()

    return () => controller.abort()
  },
})
