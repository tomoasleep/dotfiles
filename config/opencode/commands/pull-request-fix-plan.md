---
name: pull-request-fix-plan
description: Suggest TODO from the given code review comments.
---

# pull-request-fix-plan

あなたが行うことは、

- 既に与えられたコードレビューコメントがある場合、それらを満たしているか
- Pull Request で CI (GitHub Actions) の実行が完了している場合に、それらをすべてパスしているか

を確認することです。ある場合は、それらを解決するための具体的な修正タスクを提案してください。
コードの修正は行いません。必要に応じて、追加の修正タスクを提案してください。

## 進め方の手順

### レビュー対応提案

1. lookup-github-unresolved-review-comments スキルを用いて、Resolveしていないレビューコメントを確認する
  - 新たなコメントが見つからなくなるまで繰り返し取得する
2. Resolveしていないレビューコメントの内容を理解する
3. 現状の差分と比較し、指摘が解消されているかを確認する。
4. 解消されていない指摘があれば、それを解決するための具体的な修正タスクを提案する。なければ完了

### CI 対応提案

1. gh pr checks コマンドなど用いて、実行した GitHub Actions の結果と詳細を確認する
  - すべての実行結果及び、失敗しているすべての GitHub Actions の詳細ログを取得する
2. それらを解決するための具体的な修正タスクを提案する。なければ完了
