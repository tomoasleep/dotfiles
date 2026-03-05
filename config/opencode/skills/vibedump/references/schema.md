# vibedump スキーマ

## 必須フィールド

- `ts` : ISO8601 (例: 2026-03-05T12:34:56Z)
- `event` : ログ種別 (例: agent_start, task_start, task_done, user_question)
- `sender` : 送信元 (例: agent-main, hook-pre-push, cron)
- `status` : 状態 (例: open, done, blocked, skipped)
- `task_id` : タスク識別子
- `task_name` : タスク名
- `details` : 任意 JSON (message/event などの追加情報)

## 例

```json
{
  "ts": "2026-03-05T12:34:56Z",
  "event": "task_done",
  "sender": "agent-main",
  "status": "done",
  "task_id": "T-001",
  "task_name": "ログ設計",
  "details": {
    "note": "初版",
    "message": "作業完了"
  }
}
```
