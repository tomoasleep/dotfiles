# Defined in /Users/tomoya/.config/fish/config.fish @ line 18
function tmux-look --argument query
	set -l ghq_get_query (echo $query | sed -e 's/^github\.com\///')
  set -l ghq_look_query (echo $query | sed -e 's/^https:\/\///' -e 's/^git@github\.com://' -e 's/^github\.com\///' -e 's/\.git$//')
  ghq get $ghq_get_query; or return 1

  set -l tmux_dir (ghq list -p -e $ghq_look_query)
  set -l tmux_name (ghq list -e $ghq_look_query | sed -e 's/^github\.com\///' | tr '.' '_')
  test $tmux_dir; or return 1

  if test $TMUX
    tmux -2 new-session -d -c $tmux_dir -s $tmux_name
    tmux switch-client -t $tmux_name
  else
    tmux -2 new-session -A -c $tmux_dir -s $tmux_name
  end
end
