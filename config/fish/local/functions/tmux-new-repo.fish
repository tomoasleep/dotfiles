function tmux-new-repo --argument query
	set -l ghq_root (ghq root)/github.com
  if ! test -d $ghq_root/$query
    mkdir -p $ghq_root/$query
    git -C $ghq_root/$query init
  end

  tmux-look $query
end
