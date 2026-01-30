# Custom Commands

## 概要

反復的なタスクのために実行したいプロンプトを指定できます。

## 作成方法

### JSON

```json
{
  "command": {
    "test": {
      "template": "テストを実行してください",
      "description": "テスト実行"
    }
  }
}
```

### Markdown

`.opencode/commands/test.md`:

```yaml
---
description: テスト実行
---
テストを実行してください
```

## プロンプト機能

- `$ARGUMENTS` - 引数の置換
- `$1`, `$2` - 位置パラメータ
- `!\`command\`` - シェル出力の挿入
- `@filename` - ファイル参照

## 公式ドキュメントの内容

- 詳細なオプション（Template, Description, Agent, Subtask, Model）
- ビルトインコマンド

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- 各オプションの詳しい使い方を知りたい場合

## 公式ドキュメント

https://opencode.ai/docs/commands
