---
name: git-worktree-professional
description: Create, Manage Git worktrees. Read this when you use git worktree.
---

## How to access Git Worktree

- Git Worktree は https://github.com/d-kuro/gwq を使ってアクセスします。
    - 禁止事項: 作成や削除を `git worktree` コマンドを使ってはいけません。
- 利用方法は https://raw.githubusercontent.com/d-kuro/gwq/refs/heads/main/README.md を参照します。
    - 推奨: researcher エージェントを使って README.md を調査し、必要なコマンドを把握してください。

### Quick Start

> ```
> # Create a new worktree with new branch
> gwq add -b feature/new-ui
> 
> # List all worktrees
> gwq list
> 
> # Check status of all worktrees
> gwq status
> 
> # Get worktree path (for cd)
> cd $(gwq get feature)
> 
> # Execute command in worktree
> gwq exec feature -- npm test
> 
> # Remove a worktree
> gwq remove feature/old-ui
> ```
>
> from: https://github.com/d-kuro/gwq?tab=readme-ov-file#quick-start
