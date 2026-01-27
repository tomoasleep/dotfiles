function cd-worktree() {
  local branch
  local repo_root
  local worktree_dir

  branch=$1
  test "$branch" || { echo "cd-worktree: branch is required" >&2; return 1; }

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "cd-worktree: not in a git repository" >&2
    return 1
  fi

  repo_root=$(git rev-parse --show-toplevel)
  test "$repo_root" || { echo "cd-worktree: failed to get repository root" >&2; return 1; }

  if ! command -v gwq >/dev/null 2>&1; then
    echo "cd-worktree: gwq not found" >&2
    return 1
  fi

  worktree_dir=$(cd "$repo_root" && gwq get "$branch" 2>/dev/null)
  if ! test "$worktree_dir"; then
    if ! (cd "$repo_root" && git show-ref --verify --quiet "refs/heads/$branch"); then
      echo "cd-worktree: branch not found: $branch" >&2
      return 1
    fi

    (cd "$repo_root" && gwq add "$branch") || { echo "cd-worktree: gwq add failed: $branch" >&2; return 1; }
    worktree_dir=$(cd "$repo_root" && gwq get "$branch" 2>/dev/null)
  fi

  test "$worktree_dir" || { echo "cd-worktree: worktree directory not found" >&2; return 1; }

  cd "$worktree_dir" || { echo "cd-worktree: failed to change directory" >&2; return 1; }

  if test "$ZELLIJ"; then
    zellij action rename-tab "$branch"
  fi
}

function _cd-worktree() {
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
  compdef _cd-worktree cd-worktree
fi
