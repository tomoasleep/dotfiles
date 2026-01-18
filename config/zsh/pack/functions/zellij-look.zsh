function zellij-look() {
  local query
  local ghq_get_query
  local ghq_look_query
  local zellij_dir
  local zellij_name

  query=$1
  ghq_get_query=$(echo $query | sed -e 's/^github\.com\///')
  ghq_look_query=$(echo $query | sed -e 's/^https:\/\///' -e 's/^git@github\.com://' -e 's/^github\.com\///' -e 's/\.git$//')
  ghq get $ghq_get_query || return 1

  zellij_dir=$(ghq list -p -e $ghq_look_query)
  zellij_name=$(ghq list -e $ghq_look_query | sed -e 's/^github\.com\///' | tr './' '__')
  test $zellij_dir || return 1

  if test $ZELLIJ; then
    zellij pipe --plugin file:$HOME/.config/zellij/plugins/zellij-switch.wasm -- "-s $zellij_name"
  else
    (cd $zellij_dir && zellij attach -c $zellij_name)
  fi
}

function _zellij-look() {
  local -a completions

  completions=($(ghq list | univ-grep -Po "(?<=github\.com/).+"))
  compadd $completions

  return 1;
}

compdef _zellij-look zellij-look
