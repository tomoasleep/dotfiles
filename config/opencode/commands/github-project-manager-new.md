---
description: GitHub Project からタスクを取得し、実装を進めます。
---

あなたのタスクは $1 という GitHub Project のタスクのマネジメント (タスクの依頼、進捗の確認) を行うことです。
あなた自身はタスクを行ってはなりません。

以下を行ってください。

## 1. 指定された GitHub Project の取得

github-project skill を読み、 GitHub Project ($1) の説明文などの情報を取得します。

## 2. 取り組む Project Item (タスク) の選定

$1 の GitHub Project の Ready カラムから、取り組むタスクを1つ選びます。なければ中断します。

- タスクの取得は github-project skill を活用してください。
- タスクの取得には github-project skill のヘルパースクリプトを使用してください:
  - スキルの配置場所からの相対パス: `scripts/gh-project-items`
  - 実行例: `$SKILL_DIR/scripts/gh-project-items <project-number> --owner <owner> --column "Ready"`

## 3. タスクを実行する場所 (Git Worktree) の選定

以下の手順でタスクを行うべき Git Worktree を選定します。

1. タスクを行うべき Git Repository の選定
  - Description や TargetRepository field に指示があれば、それを使います。なければタスク内容から適切なリポジトリを判断します。
  - ghq を利用し GitHub Repository のリストを取得できるため、ここから探します。
2. タスクを行うべき Git Branch の選定
  - 以下のいずれかから選びます。
    - 既に worktree が存在するブランチ
    - master or main ブランチをベースにブランチを作成
    - Issue に指示があればそのブランチ
  - worktree は git-worktree-professional skill を使って取得を行ってください。
3. タスクを行うべき Git Workspace の作成 (なければ)
  - git-worktree-profesional skill の手順で作成を行ってください。
  - 選定した GitHub Repository 内で作成を行ってください。
4. 選定した Git Repository, Git Branch に対応した Worktree が作成できていることを確認

## 4. cmux workspace にタスク実行の委託

cmux-workspace skill を参照し、以下の手順で、workspace の作成及びタスク実行の委託を行います。
以下の形式に従ってください。 `--json`, `--stay` などの余計なオプションは付けないでください。

```bash
~/.local/bin/cmux new-workspace
  --command 'cd <working-directory> && opencode --prompt "/exec-github-project-item <project-item-idenfitier>" --agent <agent> --model <model-name>'
```

* project-task-identifier は GitHub Project の Owner, Project ID と GitHub Project Item の id を伝えてください。
* model-name, agent はユーザーのプロンプトに指示されているものを使ってください。指定がなかったらそのオプションを省略してください。
* 実行コマンドは ~/.local/bin/cmux を使ってください

**作成したら、 新規 workspace で opencode が起動できているかを確認してください。**
その後、その workspace の metadata として、どの Git Repository のどの Worktree でどのタスクに取り組んでいるかが分かる情報を付与してください。

## 5. vibedump にタスクを移譲したことを記録

- タスクを移譲したことを vibedump に記録してください。
- 記録する内容は以下の通りです。
  - GitHub Project task の ID
  - GitHub Project task の URL
  - GitRepository
  - worktree
  - 作成した cmux surface id

## 6. 委託したタスクを GitHub Project の In progress に移動

- 委託したタスクを In progress カラムに移動します。
