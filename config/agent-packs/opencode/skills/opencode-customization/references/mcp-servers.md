# MCP Servers

## 概要

MCP（Model Context Protocol）を使用して外部ツールを追加できます。

## ローカルサーバー

```json
{
  "mcp": {
    "my-local": {
      "type": "local",
      "command": ["npx", "-y", "@modelcontextprotocol/server-everything"]
    }
  }
}
```

## リモートサーバー

```json
{
  "mcp": {
    "sentry": {
      "type": "remote",
      "url": "https://mcp.sentry.dev/mcp"
    }
  }
}
```

## OAuth

```json
{
  "mcp": {
    "my-oauth": {
      "type": "remote",
      "url": "https://example.com/mcp",
      "oauth": {
        "clientId": "{env:CLIENT_ID}",
        "scope": "tools:read tools:execute"
      }
    }
  }
}
```

## 公式ドキュメントの内容

- 注意点（コンテキスト消費）
- 有効化、リモートデフォルトのオーバーライド
- ローカルサーバーのオプション
- リモートサーバーのオプション
- OAuth（自動、事前登録、認証、無効化、デバッグ）
- 管理（グローバル、エージェントごと）
- 例（Sentry, Context7, Grep by Vercel）

## 参照タイミング

以下の場合に公式ドキュメントを確認してください：

- 詳細なオプションや設定方法を知りたい場合
- OAuthの詳しい使い方を知りたい場合
- サーバーの管理方法を知りたい場合
- 具体的な例を参照したい場合

## 公式ドキュメント

https://opencode.ai/docs/mcp-servers
