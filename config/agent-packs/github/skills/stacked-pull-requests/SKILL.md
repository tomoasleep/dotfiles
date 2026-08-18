---
name: stacked-pull-requests
description: GitHub の stacked pull request（積み上げ PR、stacked PR）を gh stack で作成・更新・同期・マージする。ユーザーが「stacked PR」「積み上げ PR」「依存する PR を分割したい」「PR のベースを別の PR にしたい」「gh stack」と言った場合は、明示的に Skill の利用を求めていなくても使う。
---

# Stacked Pull Requests

`gh stack` は GitHub CLI の `github/gh-stack` 拡張機能で、トランクから順番に積み上げたブランチと Pull Request を管理する。スタックは次のような線形のチェーンになる。

```text
main <- layer-1 <- layer-2 <- layer-3
```

各 PR は直下のブランチをベースにするため、レビューではそのレイヤーの差分だけを表示できる。すべてのブランチは同じリポジトリに存在する必要があり、クロスフォークのスタックは作成できない。

## 前提条件

1. `gh` 2.0 以降と Git が利用できることを確認する。
2. 拡張機能がなければインストールする。

   ```bash
   gh extension install github/gh-stack
   ```

3. GitHub CLI の認証状態を確認する。

   ```bash
   gh auth status
   ```

4. `git status --short`、現在のブランチ、リモートを確認する。未コミット変更を勝手に stash、reset、削除してはいけない。
5. `gh stack init`、`gh stack submit`、`gh stack push`、`gh stack merge` など、ブランチやリモートを変更する操作は、ユーザーが作成・更新・マージを依頼した場合にだけ実行する。説明だけを求められた場合はコマンドを提示するに留める。

## 新しいスタックを作る

ユーザーの作業を、トランクに近い小さな論理単位から順に分割する。

1. トランクから最初のレイヤーを作る。既定のトランク以外を使う場合は `--base` を指定する。

   ```bash
   gh stack init feature-auth
   gh stack init --base develop feature-auth
   ```

2. 最初のレイヤーを実装してコミットする。

   ```bash
   git add .
   git commit -m "Add authentication layer"
   ```

3. 現在のスタック最上位に次のブランチを追加する。新しいブランチを作成して、そのブランチを checkout する。

   ```bash
   gh stack add feature-api
   ```

4. 新しいレイヤーを実装してコミットし、必要なレイヤー数だけ `gh stack add` と実装・コミットを繰り返す。
5. 全ブランチを push し、各ブランチのベースを正しく設定した PR と GitHub 上のスタックを作る。

   ```bash
   gh stack submit
   ```

`gh stack add` にはコミット作成をまとめる短縮形もある。`-A` は追跡対象外を含めて stage、`-u` は追跡済みファイルだけを stage する。`-A` と `-u` は同時に指定しない。

```bash
gh stack add -Am "Add API layer" feature-api
gh stack add -um "Fix API tests" feature-api-tests
```

非対話で送信する場合は `--auto` を使う。`--auto` で新規作成される PR は、`--open` を付けない限り下書きになる。

```bash
gh stack submit --auto
gh stack submit --auto --open
```

## 既存のブランチや PR を使う

既存ブランチを採用してスタックを初期化する場合は、下から上の順に渡す。

```bash
gh stack init layer-1 layer-2 layer-3
```

他のローカルツールでブランチを管理している場合や、既存 PR を GitHub 上のスタックにリンクする場合は `gh stack link` を使う。これはローカルのスタック追跡を作成・変更しない。

```bash
gh stack link feature-auth feature-api feature-ui
gh stack link 10 20 30
gh stack link https://github.com/owner/repo/pull/10 https://github.com/owner/repo/pull/20
```

引数はトランクに近い順に並べる。ブランチを指定すると必要に応じて push と PR 作成が行われ、既存 PR のベースが期待するチェーンと異なる場合は修正される。既存スタックの番号を先頭に渡せば、そのスタックの上に追加できる。

```bash
gh stack link 7 48 feature-ui
```

## 確認と移動

スタックの構成と PR のリンクを確認する。

```bash
gh stack view
gh stack view --short
gh stack view --json
```

現在のスタック内では、ブランチ名を覚えなくても次のコマンドで移動できる。

```bash
gh stack checkout
gh stack switch
gh stack up
gh stack down
gh stack top
gh stack bottom
gh stack trunk
```

特定のスタック、PR、URL、ブランチへ移動する場合は `gh stack checkout <stack-number|pr-number|pr-url|branch>` を使う。

## 下位レイヤーを変更する

最上位レイヤーで作業中に下位レイヤーを変更する必要がある場合、最上位で直接変更せず、対象ブランチで変更して上位へ連鎖リベースする。

```bash
gh stack checkout layer-1
git add .
git commit -m "Refine authentication layer"
gh stack rebase --upstack
gh stack push
gh stack top
```

`gh stack push` は PR の作成や更新を行わず、リベース後のブランチを `--force-with-lease` で push する。PR を新規作成したりスタックを再作成したりする必要がある場合は `gh stack submit` を使う。

## トランクやリモートの変更を同期する

トランクの更新、リモートスタックの変更、連鎖リベース、push、PR 状態の同期をまとめて行う場合は `sync` を使う。

```bash
gh stack sync
gh stack sync --prune
```

`--prune` はマージ済み PR のローカルブランチを削除する。ローカルとリモートのスタックが分岐している場合、非対話ターミナルでは push や PR 更新を行わず中断するため、差分を確認してから対話的に解決する。

単にスタック全体をリベースする場合は、リベース後に明示的に push する。

```bash
gh stack rebase
gh stack push
```

範囲を限定する場合は `--downstack`、`--upstack`、`--no-trunk` を使う。

## リベース競合を解決する

競合が発生したら、解決内容を確認してから続行する。

```bash
git status
# 競合を解決する
git add <resolved-files>
gh stack rebase --continue
gh stack push
```

最初からやり直す場合は、スタック全体をリベース前に戻す。

```bash
gh stack rebase --abort
```

`gh stack modify` の適用中に競合した場合は `gh stack modify --continue`、変更を破棄する場合は `gh stack modify --abort` を使う。

## スタックを再構築する

ブランチの挿入、削除、折りたたみ、並べ替え、名前変更が必要な場合は `gh stack modify` を使う。実行前に、アクティブなスタックが checkout 済みで、作業ツリーがクリーンであり、進行中のリベースやマージキューがないことを確認する。

```bash
gh stack modify
gh stack submit
```

変更適用後は `gh stack submit` で更新済みブランチを push し、GitHub 上のスタックを再作成する。大きく構成を変える場合は、必要に応じて `gh stack unstack` でスタックを解除してから `gh stack init` で作り直す。`--local` は GitHub 上のスタックを変更せずローカル追跡だけを削除する。

## マージする

スタック内の PR をマージするには `gh stack merge` を使う。対象 PR より下のすべての PR も一緒に対象になり、必要なレビュー・チェックを満たし、履歴が完全に線形である必要がある。

```bash
gh stack merge
gh stack merge --yes --squash
gh stack merge 42
```

マージキューが有効な場合は、スタックが正しい順序でキューに追加される。マージメソッドの選択や保護ルールの確認を省略してはいけない。

## 完了時の確認

操作後は次を確認し、スタックの順序、トランク、現在のブランチ、各 PR の URL と状態、未解決の競合を報告する。

```bash
gh stack view
git status --short
```

公式ドキュメント:

- https://docs.github.com/ja/pull-requests/how-tos/create-pull-requests/creating-stacked-pull-requests
- https://docs.github.com/ja/pull-requests/reference/stacked-prs-cli-commands
- https://docs.github.com/ja/pull-requests/how-tos/create-pull-requests/managing-stacked-pull-requests
