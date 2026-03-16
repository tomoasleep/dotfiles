---
name: cmux-workspace
description: "cmux CLI で workspace とセッションを管理。git worktree 連携サポート。Use when: (1) workspace 作成/一覧/選択/閉じる, (2) window/pane/tab 管理, (3) git worktree から workspace 作成, (4) cmux 経由でコマンド送信・通知"
---

# cmux Workspace

cmux CLI を使って workspace、window、pane、tab を管理するための Skill。git worktree との連携ワーフローも含む。

## ID 形式

cmux のコマンドは複数の ID 形式を受け付ける：

| 形式 | 例 | 説明 |
|------|-----|------|
| ref | `window:1/workspace:2/pane:3/surface:4` | 人間可読な参照 |
| uuid | `550e8400-e29b-41d4-a716-446655440000` | 一意識別子 |
| index | `0`, `1`, `2` | 0始まりのインデックス |

デフォルトの出力は ref 形式。`--id-format uuids` または `--id-format both` で UUID を含められる。

## 環境変数

cmux 端末内では以下が自動設定される：

- `CMUX_WORKSPACE_ID` - デフォルトの `--workspace` として使用
- `CMUX_TAB_ID` - `tab-action`/`rename-tab` のデフォルト `--tab`
- `CMUX_SURFACE_ID` - デフォルトの `--surface` として使用

## Workspace 操作

```bash
# 一覧
cmux list-workspaces

# 現在の workspace
cmux current-workspace

# 新規作成
cmux new-workspace
cmux new-workspace --command "cd ~/project && nvim"

# 選択
cmux select-workspace --workspace workspace:2

# 名前変更
cmux rename-workspace --workspace workspace:2 "Project X"

# 閉じる
cmux close-workspace --workspace workspace:2
```

## Window 操作

```bash
# 一覧
cmux list-windows

# 現在の window
cmux current-window

# 新規作成
cmux new-window

# フォーカス
cmux focus-window --window window:1

# 閉じる
cmux close-window --window window:1

# Workspace を別の window へ移動
cmux move-workspace-to-window --workspace workspace:1 --window window:2
```

## Pane / Surface 操作

```bash
# 一覧
cmux list-panes --workspace workspace:1
cmux list-pane-surfaces --workspace workspace:1 --pane pane:1

# 新規 pane
cmux new-pane --type terminal --direction right
cmux new-pane --type browser --url https://example.com

# 新規 surface
cmux new-surface --type terminal
cmux new-surface --type browser --url https://github.com

# 分割
cmux new-split left
cmux new-split right --workspace workspace:1

# フォーカス
cmux focus-pane --pane pane:1

# 閉じる
cmux close-surface --surface surface:1
```

## Tab 操作

```bash
# アクション実行
cmux tab-action --action new-tab

# 名前変更
cmux rename-tab "Main"
```

## コマンド送信・読み取り

```bash
# テキスト送信
cmux send "ls -la"
cmux send --workspace workspace:1 --surface surface:1 "git status"

# キー送信
cmux send-key Enter
cmux send-key --workspace workspace:1 Ctrl+C

# 画面読み取り
cmux read-screen
cmux read-screen --scrollback --lines 100

# tmux 互換（詳細は commands.md）
cmux capture-pane --workspace workspace:1
```

## 通知

```bash
cmux notify --title "タスク完了" --body "ビルドが成功しました"
cmux notify --title "エラー" --subtitle "Test" --body "テストが失敗しました"
```

## Git Worktree 連携ワークフロー

gwq (git-worktree-queue) と組み合わせて、worktree から workspace を作成：

```bash
# ブランチの worktree を作成し、そこで workspace を開く
branch="feature/new-feature"
repo_root=$(git rev-parse --show-toplevel)
worktree_dir=$(cd "$repo_root" && gwq get "$branch" 2>/dev/null)

if [ -z "$worktree_dir" ]; then
  (cd "$repo_root" && gwq add "$branch")
  worktree_dir=$(cd "$repo_root" && gwq get "$branch" 2>/dev/null)
fi

cmux new-workspace --cwd "$worktree_dir"
```

または対話的に選択：

```bash
branch=$(gwq list --json | jq -r '.[].branch' | fzf --prompt="Select worktree: ")
worktree_dir=$(cd "$(git rev-parse --show-toplevel)" && gwq get "$branch")
cmux new-workspace --cwd "$worktree_dir"
```

## 共通オプション

| オプション | 説明 |
|-----------|------|
| `--workspace <id>` | 対象 workspace（省略時は現在の workspace） |
| `--surface <id>` | 対象 surface（省略時は現在の surface） |
| `--pane <id>` | 対象 pane |
| `--window <id>` | 対象 window |
| `--json` | JSON 形式で出力 |
| `--id-format <refs|uuids|both>` | ID 出力形式 |

## 認証

`--password` オプション、または `CMUX_SOCKET_PASSWORD` 環境変数でソケット認証。

## 全コマンド詳細

詳細なコマンドリファレンスは [commands.md](references/commands.md) を参照。