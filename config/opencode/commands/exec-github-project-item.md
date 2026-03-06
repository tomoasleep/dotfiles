---
description: Execute github project item
---

指定された github project item (task) の内容を確認し、タスクを実行する処理を行なってください。
実行する処理のステップは以下のとおりです。

## TODO

1. 対象の task の内容を確認する
  - github-project skillを用いて対象の item の内容やコメントを取得する
2. task のタスクを遂行してください。
3. task が完了したら、その GitHub Project item を In review カラムに移動します。
  - github-project skill を用いて操作方法は把握してください。

## 重要な制約

- タスクはすべて現在のworktree内で行います
  - 現在の worktree以外の場所で作業を行わず、コードの変更も行わないでください
  - `cd`コマンドを利用する場合は`pwd`コマンドで現在のディレクトリを確認し、開始時のworktree内であることを確認してください
