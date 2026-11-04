import { describe, expect, test } from "bun:test"
import {
  MARKER,
  MAX_CONSECUTIVE_REMINDS,
  planReminder,
  reminder,
  type MessageLike,
} from "../plugins/tool-call-reminder"

const LT = String.fromCharCode(60)
const GT = String.fromCharCode(62)
const SLASH = "/"
const RAW_TOOL_CALL = LT + SLASH + "tool_call" + GT + "\n" + LT + "arg_key" + GT + "command" + LT + SLASH + "arg_key" + GT + "\necho hello\n" + LT + SLASH + "arg_value" + GT + "\n" + LT + SLASH + "tool_call" + GT

let n = 0

function assistant(text: string, created?: number): MessageLike {
  const id = `msg_a${++n}`
  return { id, type: "assistant", time: { created: created ?? n }, content: [{ type: "text", text }] }
}

function synthetic(forID: string, created?: number): MessageLike {
  const id = `msg_s${++n}`
  return { id, type: "synthetic", time: { created: created ?? n }, metadata: { source: MARKER, for: forID } }
}

function user(text = "hello", created?: number): MessageLike {
  const id = `msg_u${++n}`
  return { id, type: "user", time: { created: created ?? n }, text }
}

function idle(outcome: string, created?: number): MessageLike {
  const id = `msg_i${++n}`
  return { id, type: "idle", time: { created: created ?? n }, outcome }
}

describe("planReminder", () => {
  test("returns a plan when the last assistant message ends with an opening tag", () => {
    const plan = planReminder([user(), assistant("done\n<vibedump_log_placeholder>")])
    expect(plan?.tag).toBe("vibedump_log_placeholder")
    expect(plan?.assistantID).toBe("msg_a2")
    expect(plan?.snippet).toBe("done\n<vibedump_log_placeholder>")
  })

  test("detects a paired block ending with a closing tag", () => {
    const plan = planReminder([user(), assistant("<vibed task_id=\"T-1\">\n{}\n</vibed>")])
    expect(plan?.tag).toBe("vibed")
  })

  test("detects a raw tool call ending with a closing tool_call tag", () => {
    const plan = planReminder([user(), assistant("作業します\n" + RAW_TOOL_CALL)])
    expect(plan?.tag).toBe("tool_call")
    expect(plan?.snippet).toContain("echo hello")
  })

  test("detects mangled tags with inner whitespace", () => {
    for (const text of ["< / tool_call >", "</ tool_call>", "< /tool_call >", "作業\n\n< / tool_call >"]) {
      expect(planReminder([user(), assistant(text)])?.tag).toBe("tool_call")
    }
  })

  test("ignores inline code and fenced blocks", () => {
    expect(planReminder([user(), assistant("wrap it in `<foo>` like this")])).toBeNull()
    expect(planReminder([user(), assistant("example:\n```xml\n<foo bar=\"1\">\n```")])).toBeNull()
    expect(planReminder([user(), assistant("no tags here")])).toBeNull()
  })

  test("ignores messages without an assistant message", () => {
    expect(planReminder([user()])).toBeNull()
  })

  test("skips when the run did not succeed", () => {
    const messages = [user(), assistant("done\n<foo>"), idle("interrupted")]
    expect(planReminder(messages)).toBeNull()
  })

  test("does not re-remind the same assistant message", () => {
    const assistantMessage = assistant("done\n<foo>")
    const messages = [user(), assistantMessage, synthetic(assistantMessage.id)]
    expect(planReminder(messages)).toBeNull()
  })

  test("stops after the consecutive reminder cap", () => {
    const first = assistant("a\n<foo>", 1)
    let messages: MessageLike[] = [user("go", 0), first]
    for (let i = 0; i < MAX_CONSECUTIVE_REMINDS; i++) {
      messages.push(synthetic(first.id))
      const offense = assistant(`offense ${i}\n<foo>`)
      messages.push(offense)
      if (i < MAX_CONSECUTIVE_REMINDS - 1) {
        expect(planReminder(messages), `offense ${i}`).not.toBeNull()
      }
    }
    expect(planReminder(messages)).toBeNull()
  })

  test("a clean assistant message or a user message resets the streak", () => {
    const first = assistant("a\n<foo>", 1)
    const clean = assistant("all good", 4)
    const next = assistant("b\n<foo>", 7)
    expect(planReminder([user("go", 0), first, synthetic(first.id, 2), clean, next])).not.toBeNull()
    expect(planReminder([user("again", 8), next])).toEqual({
      assistantID: next.id,
      tag: "foo",
      snippet: "b\n<foo>",
    })
  })
})

test("reminder text quotes the actual trailing snippet", () => {
  const text = reminder(RAW_TOOL_CALL)
  expect(text).toContain("echo hello")
  expect(text).toContain("tool_call")
  expect(text).toMatch(/^<system-reminder>\n/)
})
