# Defined in /Users/tomoya/.config/fish/config.fish @ line 35
function git_action_status
	if git_is_repo
    set -l git_dir (git rev-parse --git-dir 2> /dev/null)

    set -l rebase_dir $git_dir/rebase-apply $git_dir/rebase $git_dir/../.dotest
    for action_dir in $rebase_dir
      if test -d $action_dir
        if test -f $action_dir/rebasing
          printf "rebase"
        else if test -f $action_dir/applying
          printf "apply"
        else
          printf "rebase/apply"
        end

        return 0
      end
    end

    set -l rebase_interactive_dir $git_dir/rebase-merge/interactive $git_dir/.dotest-merge/interactive
    for action_dir in $rebase_interactive_dir
      if test -d $action_dir
        printf "rebase-interactive"
        return 0
      end
    end

    set -l rebase_merge_dir $git_dir/rebase-merge $git_dir/.dotest-merge
    for action_dir in $rebase_merge_dir
      if test -d $action_dir
        printf "rebase-merge"
        return 0
      end
    end

		if test -f $git_dir/MERGE_HEAD
			printf "merge"
			return 0
		end

		if test -f $git_dir/CHERRY_PICK_HEAD
			printf "cherry-pick"
			return 0
		end


		if test -f $git_dir/BISECT_LOG
			printf "bisect"
			return 0
		end
  end

	return 1
end
