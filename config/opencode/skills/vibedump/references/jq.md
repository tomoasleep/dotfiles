# jq 集計レシピ

対象ファイルはカレントディレクトリの `.vibedump.jsonl` を想定する。

## タスクごとの最終状態

```bash
jq -s 'sort_by(.ts) | group_by(.task_id) | map({
  task_id: .[-1].task_id,
  task_name: .[-1].task_name,
  status: .[-1].status,
  event: .[-1].event,
  ts: .[-1].ts,
  sender: .[-1].sender
})' .vibedump.jsonl
```

## 未完了タスク一覧

```bash
jq -s 'sort_by(.ts) | group_by(.task_id) | map(select(.[-1].status != "done") | {
  task_id: .[-1].task_id,
  task_name: .[-1].task_name,
  status: .[-1].status,
  event: .[-1].event,
  ts: .[-1].ts
})' .vibedump.jsonl
```

## タスクごとのログ抽出

```bash
jq -c 'select(.task_id == "T-001")' .vibedump.jsonl
```
