function herdr-look() {
  local query
  local branch
  local ghq_get_query
  local ghq_look_query
  local repo_dir
  local worktree_dir
  local workspace_label

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

  ghq get $ghq_get_query || { echo "herdr-look: ghq get failed: $ghq_get_query" >&2; return 1; }

  repo_dir=$(ghq list -p -e $ghq_look_query)
  test "$repo_dir" || { echo "herdr-look: ghq list failed: $ghq_look_query" >&2; return 1; }

  if test "$pr_number" && ! test "$branch"; then
    local pr_branch
    pr_branch=$(cd "$repo_dir" && gh pr view "$pr_number" --json headRefName -q '.headRefName' 2>/dev/null)
    if ! test "$pr_branch"; then
      echo "herdr-look: gh pr view failed: $pr_number" >&2
      return 1
    fi
    branch="$pr_branch"
  fi

  local owner_repo=$(ghq list -e $ghq_look_query | sed -e 's/^github\.com\///')

  command -v herdr >/dev/null 2>&1 || { echo "herdr-look: herdr not found" >&2; return 1; }

  if ! _herdr_server_running; then
    workspace_label=$(_herdr_workspace_label "$owner_repo" "$branch")
    echo "herdr-look: server not running, launching herdr" >&2
    echo "herdr-look: repo dir: $repo_dir" >&2
    echo "herdr-look: workspace label: $workspace_label" >&2
    (cd "$repo_dir" && herdr)
    return $?
  fi

  if test "$branch"; then
    branch=${branch#origin/}
    workspace_label=$(_herdr_workspace_label "$owner_repo" "$branch")

    command -v gwq >/dev/null 2>&1 || { echo "herdr-look: gwq not found" >&2; return 1; }

    worktree_dir=$(cd "$repo_dir" && gwq get "$branch" 2>/dev/null)
    if ! test "$worktree_dir"; then
      if ! (cd "$repo_dir" && git show-ref --verify --quiet "refs/heads/$branch"); then
        echo "herdr-look: local branch not found: $branch" >&2
        return 1
      fi

      if ! (cd "$repo_dir" && git remote get-url origin >/dev/null 2>&1); then
        echo "herdr-look: remote 'origin' not found" >&2
        return 1
      fi

      (cd "$repo_dir" && gwq add "$branch") || { echo "herdr-look: gwq add failed: $branch" >&2; return 1; }
      worktree_dir=$(cd "$repo_dir" && gwq get "$branch" 2>/dev/null)
    fi

    test "$worktree_dir" || { echo "herdr-look: worktree directory not found" >&2; return 1; }

    echo "herdr-look: open worktree: $branch" >&2
    echo "herdr-look: worktree dir: $worktree_dir" >&2
    echo "herdr-look: workspace label: $workspace_label" >&2
    herdr worktree open --cwd "$repo_dir" --path "$worktree_dir" --label "$workspace_label" --focus 2>&1
  else
    workspace_label=$(_herdr_workspace_label "$owner_repo")

    echo "herdr-look: create workspace: $workspace_label" >&2
    echo "herdr-look: cwd: $repo_dir" >&2
    herdr workspace create --cwd "$repo_dir" --label "$workspace_label" --focus 2>&1
  fi
}

function _herdr_server_running() {
  herdr status server --json 2>/dev/null | grep -q '"running":true'
}

function _herdr_workspace_label() {
  local owner_repo=$1
  local branch=$2

  if test "$branch"; then
    printf '%s::%s' "$owner_repo" "$branch"
  else
    printf '%s' "$owner_repo"
  fi
}

function _herdr-look() {
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

compdef _herdr-look herdr-look
