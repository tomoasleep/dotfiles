---
name: opencode-session-collector
description: OpenCode SDK/APIでセッション一覧を取得し、必要なメッセージだけ抽出する方法を学ぶときに使う
---

# OpenCode セッション収集ガイド

## 目的

OpenCode のセッション情報を SDK / API で収集し、コンテキスト溢れを避けるために必要最小限のメッセージだけを抽出する。

## 使いどころ

- セッション一覧やセッション詳細を取得したい
- 特定のディレクトリやプロジェクトに関連するセッションを探したい
- メッセージ全量取得を避けたい（抽出スクリプトを推奨）

## サーバー起動

サーバー未起動なら SDK で起動する。起動済みならクライアントのみ作る。

```ts
import { createOpencode, createOpencodeClient } from '@opencode-ai/sdk'

const opencode = await createOpencode()
const { client } = opencode

const clientOnly = createOpencodeClient({ baseUrl: 'http://localhost:4096' })
```

## セッション収集フロー

1. セッション一覧を取得する
2. プロジェクトやディレクトリで絞り込む
3. 対象セッションのメッセージはスクリプトで必要分だけ抽出する

SDK

```ts
const sessions = await client.session.list()
```

API

```bash
curl -s "http://localhost:4096/session"
```

## プロジェクト / ディレクトリで絞り込み

セッション一覧の `projectID` と `directory` で絞る。

プロジェクト一覧（任意）

```ts
const projects = await client.project.list()
```

フィルタ方針

- `projectID` が一致するセッションだけ残す
- `directory` が指定パスのプレフィックスなら対象にする

## メッセージ抽出はスクリプト推奨

メッセージを直接 API で全量取得すると長くなり、コンテキストが溢れやすい。
同梱スクリプトで `user 全件 + 最終 assistant 1件` のみを抽出する運用を推奨する。

スクリプト

`config/opencode/skills/opencode-session-collector/scripts/extract-session-messages.js`

例

```bash
node config/opencode/skills/opencode-session-collector/scripts/extract-session-messages.js \
  --base-url http://localhost:4096 \
  --project-id PROJECT_ID
```

```bash
node config/opencode/skills/opencode-session-collector/scripts/extract-session-messages.js \
  --dir-prefix /path/to/worktree
```

```bash
node config/opencode/skills/opencode-session-collector/scripts/extract-session-messages.js \
  --session-id SESSION_ID
```

## 出力形式

JSON でセッションごとの抽出結果を返す。

```json
{
  "sessions": [
    {
      "session": {
        "id": "...",
        "title": "...",
        "directory": "...",
        "projectID": "...",
        "time": { "created": 0, "updated": 0 }
      },
      "messages": [
        { "role": "user", "time": { "created": 0 }, "text": "..." },
        { "role": "assistant", "time": { "created": 0 }, "text": "..." }
      ]
    }
  ]
}
```
