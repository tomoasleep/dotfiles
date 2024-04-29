function tmux-look() {
  local query
  local ghq_get_query
  local ghq_look_query
  local tmux_dir
  local tmux_name

  query=$1
  ghq_get_query=$(echo $query | sed -e 's/^github\.com\///')
  ghq_look_query=$(echo $query | sed -e 's/^https:\/\///' -e 's/^git@github\.com://' -e 's/^github\.com\///' -e 's/\.git$//')
  ghq get $ghq_get_query || return 1

  tmux_dir=$(ghq list -p -e $ghq_look_query)
  tmux_name=$(ghq list -e $ghq_look_query | sed -e 's/^github\.com\///' | tr '.' '_')
  test $tmux_dir || return 1

  if test $TMUX; then
    tmux -2 new-session -d -c $tmux_dir -s $tmux_name
    tmux switch-client -t $tmux_name
  else
    tmux -2 new-session -A -c $tmux_dir -s $tmux_name
  fi
}

function _tmux-look() {
  local -a completions

  completions=($(ghq list | univ-grep -Po "(?<=github\.com/).+"))
  compadd $completions

  return 1;
}

compdef _tmux-look tmux-look
