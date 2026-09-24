---
description: 設計判断・技術選択をObsidianのDecisions/に記録する。複数案を比較して選択した場合のみ記録。
---

# Obsidian Memory Write - Decisions

設計判断や技術選択の理由をObsidian Vaultの `Decisions/` に記録する。

## トリガー

以下の条件を**すべて**満たす時に実行:

- 複数の選択肢から1つを選んだ
- 選択理由が後で読み返す価値がある
- 軽微な実装判断ではない（変数名、インデントなどは除外）

**記録しないもの**:
- 軽微な実装判断
- 自明な選択（明らかに一方が優れている場合）
- ユーザーの指示に従っただけの場合

## 手順

### Step 1: 記録の判断

以下の質問に自問:
1. 「この判断の理由は1週間後に役に立つか？」→ Yesなら記録
2. 「他の人がこの選択を見た時に『なぜ？』と思うか？」→ Yesなら記録

### Step 2: ファイルパスの決定

```
Decisions/YYYY-MM-DD/topic-slug.md
```

- `topic-slug`: 英語のkebab-case（例: `database-choice`, `state-management`）

### Step 3: ノート作成

```bash
obsidian create path="Decisions/YYYY-MM-DD/topic-slug.md" content="---
date: YYYY-MM-DD
tags: [decision, topic]
project: <git-repo-name>
---

# タイトル

## 選択肢
- A: <選択肢Aの説明>
- B: <選択肢Bの説明>

## 決定理由
<なぜAを選んだかの理由>

## 結論
<最終的な決定>"
```

`<git-repo-name>` は `git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null` で取得。

### Step 4: 報告

ユーザーに以下のみ報告:
```
Obsidian: Decisions/YYYY-MM-DD/topic-slug.md に書き込みました
```

## 注意事項

- 選択肢は簡潔に（各1-2行）
- 決定理由を具体的に（「なんとなく」は不可）
- トレードオフを明記
