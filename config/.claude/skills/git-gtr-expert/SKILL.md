---
name: git-gtr-expert
description: Git GTR (Git Worktree Runner) の利用方法を熟知しています。 git worktree を使ったブランチの管理や操作は git-gtr を使ってください。
---

# git-gtr Expert

git-gtr (Git Worktree Runner) は https://github.com/coderabbitai/git-worktree-runner で提供されている、 git worktree を使ったブランチ管理を実現するツールです。

git worktree を使ったブランチの管理や操作は git-gtr を使ってください。

## Examples

```bash
# Create new worktree
git gtr new my-feature                              # Creates folder: my-feature
git gtr new hotfix --from v1.2.3                    # Create from specific ref
git gtr new variant-1 --from-current                # Create from current branch
git gtr new feature/auth                            # Creates folder: feature-auth
git gtr new feature-auth --name backend --force     # Same branch, custom name
git gtr new my-feature --name descriptive-variant   # Optional: custom name without --force

# If you want to create new worktree with remote branch. Use --track option.
## --track <mode>: Tracking mode (auto|remote|local|none)

# Run commands in worktree
git gtr run my-feature npm test # Run tests

# Navigate to worktree (alternative)
cd "$(git gtr go my-feature)"

# List all worktrees
git gtr list

# Remove when done
git gtr rm my-feature

# Or remove all worktrees with merged PRs (requires gh CLI)
git gtr clean --merged
```

(from: https://github.com/coderabbitai/git-worktree-runner)
