# Formatters

## 概要

言語固有のフォーマッタを自動的に適用します。

## ビルトインフォーマッタ

gofmt, prettier, biome, clang-format, ktlint, ruff, rustfmt, rubocop, shfmt など

## 設定

### 有効化/無効化

```json
{
  "formatter": {
    "prettier": {
      "disabled": false
    }
  }
}
```

### カスタムフォーマッタ

```json
{
  "formatter": {
    "my-formatter": {
      "command": ["npx", "formatter", "$FILE"],
      "extensions": [".js", ".ts"]
    }
  }
}
```

## 公式ドキュメントの内容

- すべてのビルトインフォーマッタの一覧（拡張子、要件）
- 動作の仕組み
- 詳細な設定例

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- すべてのビルトインフォーマッタを確認したい場合
- 動作の仕組みを詳しく知りたい場合
- カスタムフォーマッタの詳しい設定方法を知りたい場合

## 公式ドキュメント

https://opencode.ai/docs/formatters
