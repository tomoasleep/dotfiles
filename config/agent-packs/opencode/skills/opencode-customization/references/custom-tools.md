# Custom Tools

## 概要

TypeScriptまたはJavaScriptで定義されたカスタム関数を作成できます。LLMが会話中に呼び出すことができます。

## ファイルの配置

- `.opencode/tools/` (プロジェクト)
- `~/.config/opencode/tools/` (グローバル)

## 基本構造

```typescript
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "ツールの説明",
  args: {
    param: tool.schema.string().describe("引数の説明"),
  },
  async execute(args) {
    return "結果"
  },
})
```

## 公式ドキュメントの内容

- 複雑な例（Pythonでツールを作成するなど）
- コンテキストの使用方法
- Zodを直接使用する方法

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- 他の言語（Pythonなど）でツールを作成したい場合
- コンテキスト情報（directory, worktree）を使用したい場合
- Zodを直接使用してツールを定義したい場合

## 公式ドキュメント

https://opencode.ai/docs/custom-tools
