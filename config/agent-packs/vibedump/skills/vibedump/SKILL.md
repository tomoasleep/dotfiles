---
name: vibedump
description: カレントディレクトリの .vibedump.jsonl に作業ログを追記し、jq でタスク状況を集計するときに使う
---

# vibedump 作業ログガイド

## 目的

.vibedump.jsonl に行単位の JSON を追記し、作業の進捗を他のエージェントやフックから追跡できるようにする。

## 使いどころ

- エージェントの開始/終了やタスクの開始/完了を記録したい
- フックや外部ツールから同じ形式で追記したい
- jq でタスクの最終状態や未完了を集計したい

## ログ出力

送信スクリプトで `.vibedump.jsonl` に追記する。

スクリプト

`./scripts/vibedump.sh` (この skill からの相対パス)

例

```bash
./scripts/vibedump.sh \
  --task-id T-001 \
  --task-name "ログ設計" \
  --status done \
  --sender agent-main \
  --event task_done \
  --details '{"note":"初版"}'
```

## スキーマと集計

詳細は以下を参照。

- `references/schema.md`
- `references/jq.md`
