---
description: Create a detailed plan for addressing a specific issue or task.
---

引数で受け取った内容をもとに、実装プランを作成し、GitHub Issueを作成します。

## ステップ1: 実装プランの作成

- task-requirement-analyzerエージェントを使用して、タスク内容に基づく実装プランを作成します

### タスク内容

$ARGUMENTS

## ステップ2: GitHub Issueの作成

ステップ1で作成した実装プランをもとに、GitHub Issueを作成してください。

### Issue作成時の注意事項

- タイトル: タスクの目的を簡潔に表現したもの
- 本文: 以下の構造で作成

```markdown
## Why

(ユーザーから背景を聞き出して入力する)

## What

(ユーザーから依頼された内容を元に作成)

## Plan

(タスクの目的と達成すべきゴール)

### Order

(ユーザーから依頼された内容)

### Requirements

(機能要件と非機能要件のリスト)

### Phases

(task-requirement-analyzerが策定したフェーズごとの計画)

### 影響範囲

(変更が必要なファイルや関連コード)

### 確認事項

(実装前に確認が必要な点（あれば）)
```

## ステップ4: 実装プランの改善

- 以下の処理を繰り返してください
   - ユーザーにGitHub Issueの内容が適切か確認してください
   - ユーザーからフィードバックがあった場合、GitHub Issueの内容を改善してください
   - ユーザーからの承認が得られたら、処理を終了してください

### Issueの作成コマンド

`gh issue create --title "タイトル" --body "本文"`を使用してください。

## 完了条件

- 実装プランが策定されていること
- GitHub Issueが作成され、Issue番号が報告されていること
