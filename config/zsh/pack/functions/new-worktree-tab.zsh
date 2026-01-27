function new-worktree-tab() {
  local branch
  local repo_root
  local worktree_dir

  branch=$1
  test "$branch" || { echo "new-worktree-tab: branch is required" >&2; return 1; }

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "new-worktree-tab: not in a git repository" >&2
    return 1
  fi

  repo_root=$(git rev-parse --show-toplevel)
  test "$repo_root" || { echo "new-worktree-tab: failed to get repository root" >&2; return 1; }

  if ! command -v gwq >/dev/null 2>&1; then
    echo "new-worktree-tab: gwq not found" >&2
    return 1
  fi

  worktree_dir=$(cd "$repo_root" && gwq get "$branch" 2>/dev/null)
  if ! test "$worktree_dir"; then
    if ! (cd "$repo_root" && git show-ref --verify --quiet "refs/heads/$branch"); then
      echo "new-worktree-tab: branch not found: $branch" >&2
      return 1
    fi

    (cd "$repo_root" && gwq add "$branch") || { echo "new-worktree-tab: gwq add failed: $branch" >&2; return 1; }
    worktree_dir=$(cd "$repo_root" && gwq get "$branch" 2>/dev/null)
  fi

  test "$worktree_dir" || { echo "new-worktree-tab: worktree directory not found" >&2; return 1; }

  if ! command -v zellij >/dev/null 2>&1; then
    echo "new-worktree-tab: zellij not found" >&2
    return 1
  fi

  zellij action new-tab --cwd "$worktree_dir" --name "$branch" || { echo "new-worktree-tab: zellij action new-tab failed" >&2; return 1; }
}

function _new-worktree-tab() {
  local -a completions
  local repo_root

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    return 1
  fi

  repo_root=$(git rev-parse --show-toplevel)
  test "$repo_root" || return 1

  completions=($(cd "$repo_root" && git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null))
  compadd $completions

  return 1
}

if command -v compdef >/dev/null 2>&1; then
  compdef _new-worktree-tab new-worktree-tab
fi
