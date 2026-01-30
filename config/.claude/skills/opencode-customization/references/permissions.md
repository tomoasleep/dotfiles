# Permissions

## 概要

操作に対する権限設定が可能です。`allow`, `ask`, `deny`で制御します。

## 基本設定

```json
{
  "permission": {
    "*": "allow",
    "edit": "ask",
    "bash": "allow"
  }
}
```

## 粒度なルール

```json
{
  "permission": {
    "bash": {
      "*": "ask",
      "git *": "allow",
      "rm *": "deny"
    }
  }
}
```

## 外部ディレクトリ

```json
{
  "permission": {
    "external_directory": {
      "~/projects/**": "allow"
    }
  }
}
```

## 公式ドキュメントの内容

- アクションの種類（allow, ask, deny）
- 粒度なルール（オブジェクト構文、ワイルドカード、ホームディレクトリ展開、外部ディレクトリ）
- すべての利用可能な権限の一覧
- デフォルト
- "Ask"が何をするか
- エージェントごとのオーバーライド

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- 粒度なルールの詳しい使い方を知りたい場合
- すべての利用可能な権限を確認したい場合
- デフォルト設定を詳しく知りたい場合
- エージェントごとの権限オーバーライド方法を知りたい場合

## 公式ドキュメント

https://opencode.ai/docs/permissions
