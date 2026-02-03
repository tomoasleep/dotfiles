import type { Plugin } from "@opencode-ai/plugin";

export const TerminalNotifierPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`terminal-notifier -title "OpenCode" -message "Session completed"`;
      }
      if (event.type === "question.asked") {
        await $`terminal-notifier -title "OpenCode" -message "Question requested"`;
      }
    },
  };
};
