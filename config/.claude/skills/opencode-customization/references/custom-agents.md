# Custom Agents

## 概要

特定のタスクとワークフロー用に設定できる特殊なAIアシスタントです。カスタムプロンプト、モデル、ツールアクセスを持つフォーカスされたツールを作成できます。

## タイプ

- **Primary**: 直接対話するメインアシスタント（Tabで切り替え）
- **Subagent**: プライマリエージェントが呼び出す特殊なアシスタント（@で呼び出し）

## 作成方法

### JSON

```json
{
  "agent": {
    "review": {
      "description": "コードレビュー",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer."
    }
  }
}
```

### Markdown

`.opencode/agents/review.md`:

```yaml
---
description: コードレビュー
mode: subagent
---
You are a code reviewer.
```

## 公式ドキュメントの内容

- ビルトインエージェント（Build, Plan, General, Explore）の説明
- 詳細なオプション（Temperature, Max Steps, Disable, Prompt, Model, Tools, Permissions, Mode, Hidden, Task permissions, Additional）
- エージェントの作成方法
- ユースケース
- 例

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- ビルトインエージェントの説明や使用方法を知りたい場合
- 詳細なオプションの使い方を知りたい場合
- エージェントの作成方法を詳しく知りたい場合

## 公式ドキュメント

https://opencode.ai/docs/agents
