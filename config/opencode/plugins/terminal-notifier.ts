import { Plugin } from "@opencode/plugin"

export default Plugin.define({
  id: "terminal-notifier",
  setup(ctx) {
    const controller = new AbortController()

    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        if (event.type === "session.idle") {
          await Bun.$`znotify :bell:`.quiet().catch(() => {})
          await Bun.$`terminal-notifier -title "OpenCode" -message "Session completed"`
            .quiet()
            .catch(() => {})
        }
        if (event.type === "form.created" && (event.data.form.metadata as any)?.kind === "question") {
          await Bun.$`znotify :question:`.quiet().catch(() => {})
          await Bun.$`terminal-notifier -title "OpenCode" -message "Question requested"`
            .quiet()
            .catch(() => {})
        }
      }
    })()

    return () => controller.abort()
  },
})
