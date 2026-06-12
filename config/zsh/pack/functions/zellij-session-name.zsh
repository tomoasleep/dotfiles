function _zellij_session_name() {
  local owner_repo=$1
  local branch=$2
  local max_len=${3:-30}

  local owner="${owner_repo%%/*}"
  local repo="${owner_repo#*/}"
  local digest=$(printf '%s' "$owner_repo" | cksum | awk '{print $1}' | tail -c 7)

  if test "$branch"; then
    local branch_sanitized=$(printf '%s' "$branch" | tr './' '__')
    local overhead=11
    local b_max=$((max_len - overhead))
    [[ $b_max -lt 0 ]] && b_max=0
    branch_sanitized="${branch_sanitized:0:$b_max}"
    local r_avail=$((max_len - overhead - ${#branch_sanitized}))
    [[ $r_avail -lt 0 ]] && r_avail=0
    printf '%s' "${owner[1]}_${repo:0:$r_avail}_${digest}__${branch_sanitized}"
  else
    local r_avail=$((max_len - 9))
    [[ $r_avail -lt 0 ]] && r_avail=0
    printf '%s' "${owner[1]}_${repo:0:$r_avail}_${digest}"
  fi
}
