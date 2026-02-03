function zellij-look() {
  local query
  local branch
  local ghq_get_query
  local ghq_look_query
  local repo_dir
  local zellij_dir
  local zellij_name
  local branch_sanitized

  query=$1
  branch=$2

  test "$query" || {
    query=$(ghq list | fzf --height=40% --reverse) || return 0
  }

  local pr_number
  local pr_owner
  local pr_repo

  if [[ $query =~ 'https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+)' ]] || [[ $query =~ 'github\.com/([^/]+)/([^/]+)/pull/([0-9]+)' ]]; then
    pr_owner=$match[1]
    pr_repo=$match[2]
    pr_number=$match[3]
  fi

  if test "$pr_number"; then
    ghq_get_query="${pr_owner}/${pr_repo}"
    ghq_look_query="${pr_owner}/${pr_repo}"

    if command -v gh >/dev/null 2>&1; then
      repo_dir=$(ghq list -p -e "$ghq_look_query") 2>/dev/null
      if test "$repo_dir" && ! test "$branch"; then
        branch=$(cd "$repo_dir" && gh pr view "$pr_number" --json headRefName -q '.headRefName' 2>/dev/null)
        if test "$branch"; then
          (cd "$repo_dir" && git fetch origin "refs/pull/$pr_number/head:$branch" 2>/dev/null)
        fi
      fi
    fi
  else
    ghq_get_query=$(echo "$query" | sed -e 's/^github\.com\///')
    ghq_look_query=$(echo "$query" | sed -e 's/^https:\/\///' -e 's/^git@github\.com://' -e 's/^github\.com\///' -e 's/\.git$//')
  fi

  ghq get $ghq_get_query || { echo "zellij-look: ghq get failed: $ghq_get_query" >&2; return 1; }

  repo_dir=$(ghq list -p -e $ghq_look_query)
  test "$repo_dir" || { echo "zellij-look: ghq list failed: $ghq_look_query" >&2; return 1; }

  if test "$pr_number" && ! test "$branch"; then
    local pr_branch
    pr_branch=$(cd "$repo_dir" && gh pr view "$pr_number" --json headRefName -q '.headRefName' 2>/dev/null)
    if ! test "$pr_branch"; then
      echo "zellij-look: gh pr view failed: $pr_number" >&2
      return 1
    fi
    branch="$pr_branch"
  fi

  if test "$branch"; then
    branch=${branch#origin/}

    command -v gwq >/dev/null 2>&1 || { echo "zellij-look: gwq not found" >&2; return 1; }

    zellij_dir=$(cd "$repo_dir" && gwq get "$branch" 2>/dev/null)
    if ! test "$zellij_dir"; then
      if ! (cd "$repo_dir" && git show-ref --verify --quiet "refs/heads/$branch"); then
        echo "zellij-look: local branch not found: $branch" >&2
        return 1
      fi

      if ! (cd "$repo_dir" && git remote get-url origin >/dev/null 2>&1); then
        echo "zellij-look: remote 'origin' not found" >&2
        return 1
      fi

      (cd "$repo_dir" && gwq add "$branch") || { echo "zellij-look: gwq add failed: $branch" >&2; return 1; }
      zellij_dir=$(cd "$repo_dir" && gwq get "$branch" 2>/dev/null)
    fi

    branch_sanitized=$(printf '%s' "$branch" | tr './' '__')
    zellij_name=$(ghq list -e $ghq_look_query | sed -e 's/^github\.com\///' | tr './' '__')
    zellij_name="${zellij_name}__${branch_sanitized}"
  else
    zellij_dir="$repo_dir"
    zellij_name=$(ghq list -e $ghq_look_query | sed -e 's/^github\.com\///' | tr './' '__')
  fi

  test "$zellij_dir" || { echo "zellij-look: worktree directory not found" >&2; return 1; }

  if test "$ZELLIJ"; then
    echo "zellij-look: switch session: $zellij_name" >&2
    echo "zellij-look: worktree dir: $zellij_dir" >&2
    zellij pipe --plugin file:$HOME/.config/zellij/plugins/zellij-switch.wasm -- "-s $zellij_name --cwd $zellij_dir"
  else
    echo "zellij-look: attach in dir: $zellij_dir" >&2
    echo "zellij-look: session name: $zellij_name" >&2
    (cd "$zellij_dir" && zellij attach -c "$zellij_name")
  fi
}

function _zellij-look() {
  local -a completions
  local query
  local ghq_look_query
  local repo_dir

  if (( CURRENT == 2 )); then
    completions=($(ghq list | univ-grep -Po "(?<=github\.com/).+"))
    compadd $completions

    return 1;
  fi

  if (( CURRENT == 3 )); then
    query=$words[2]

    ghq_look_query=$(echo "$query" | sed -e 's/^https:\/\///' -e 's/^git@github\.com://' -e 's/^github\.com\///' -e 's/\.git$//' -e 's/\/pull\/[0-9]*$//')
    repo_dir=$(ghq list -p -e $ghq_look_query 2>/dev/null)
    test "$repo_dir" || return 1

    completions=($(cd "$repo_dir" && git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null))
    compadd $completions

    return 1;
  fi

  return 1;
}

compdef _zellij-look zellij-look
