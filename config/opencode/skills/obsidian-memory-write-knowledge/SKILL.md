---
description: バグ解決・技術的発見をObsidianのKnowledge/に記録する。再利用可能・再発可能な知見のみ記録。
---

# Obsidian Memory Write - Knowledge

バグ解決や技術的発見をObsidian Vaultの `Knowledge/` に記録する。

## トリガー

以下の条件を**すべて**満たす時に実行:

- バグが解決した（原因と解決策が明確）
- 再利用可能・再発可能な知見である
- 次回同じ作業で役立つもの

**記録しないもの**:
- 一度限りの偶発事象
- ユーザー固有の環境依存エラー
- 単純なtypo修正

## 手順

### Step 1: 記録の判断

以下の質問に自問:
1. 「この問題は他のプロジェクトでも起こり得るか？」→ Yesなら記録
2. 「同じエラーに遭遇した時、この記録が役立つか？」→ Yesなら記録

### Step 2: ファイルパスの決定

```
Knowledge/YYYY-MM-DD/topic-slug.md
```

- `topic-slug`: 英語のkebab-case（例: `nextjs-auth-cookie`, `docker-volume-permission`）
- 既存ファイルがある場合: 追記ではなく新規ファイルを作成

### Step 3: ノート作成

```bash
obsidian create path="Knowledge/YYYY-MM-DD/topic-slug.md" content="---
date: YYYY-MM-DD
tags: [knowledge, topic]
project: <git-repo-name>
---

# タイトル

## 問題
<問題の説明>

## 原因
<原因の分析>

## 解決策
<解決策>"
```

`<git-repo-name>` は `git rev-parse --show-toplevel 2>/dev/null | xargs basename 2>/dev/null` で取得。

### Step 4: 報告

ユーザーに以下のみ報告:
```
Obsidian: Knowledge/YYYY-MM-DD/topic-slug.md に書き込みました
```

## 注意事項

- 内容は簡潔に（200-300文字程度）
- 技術的な正確性を優先
- 関連する他のノートがあれば `[[wiki link]]` でリンク
