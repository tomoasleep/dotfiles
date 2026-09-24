---
description: AIのミスをObsidianのMistakes/に記録する。ユーザーからの明示的訂正で、AIの行動パターンへの訂正のみ記録。
---

# Obsidian Memory Write - Mistakes

AIのミスをObsidian Vaultの `Mistakes/` に記録する。

## トリガー

以下の条件を**すべて**満たす時に実行:

- ユーザーから**明示的な訂正**があった
- AIの**行動パターン**への指摘である
- 繰り返し起こり得るパターンである

**記録するもの**:
- コードスタイルの誤り（コメントの追加、AI attributionなど）
- テスト実行忘れ
- 不要なコメント追加
- 繰り返し起こり得るパターン

**記録しないもの**:
- 単なる今回の修正依頼（「これを直して」など）
- ユーザーの環境依存エラー
- 一度限りのtypo

## 手順

### Step 1: 記録の判断

以下の質問に自問:
1. 「これはユーザーからの明示的な訂正か？」（自分の気づきではない）→ Yesなら続行
2. 「これは繰り返し起こり得るパターンか？」→ Yesなら記録
3. 「具体的な『する/しない』で書けるか？」→ Yesなら記録

### Step 2: ファイルパスの決定

```
Mistakes/YYYY-MM-DD/mistake-topic.md
```

- `mistake-topic`: 英語のkebab-case（例: `no-ai-attribution`, `run-tests-first`）

### Step 3: ノート作成

```bash
obsidian create path="Mistakes/YYYY-MM-DD/mistake-topic.md" content="---
date: YYYY-MM-DD
tags: [mistake, category]
---

# [一言で何を間違えたか]

**NG Action**: 実際にやってしまった間違い
**Correct Action**: 次回からの正しい対応
**Trigger**: このルールが適用される状況"
```

### Step 4: 報告

ユーザーに以下のみ報告:
```
Obsidian: Mistakes/YYYY-MM-DD/mistake-topic.md に書き込みました
```

## 注意事項

- ユーザーの訂正文をそのまま使わない（一般化する）
- 具体的で実行可能な形式で記録
- 同じパターンのミスが複数回ある場合は、既存ファイルを更新ではなく新規作成
