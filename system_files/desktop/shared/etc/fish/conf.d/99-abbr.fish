if status is-interactive
    # Going through folders
    abbr -a cdtemp "cd \$(mktemp -d)"

    # Git stuff
    abbr -a gc "git commit"
    abbr -a gca "git add . && git commit -a"
    abbr -a amend "git commit --amend"

    abbr -a gcm --set-cursor=! git commit -m \"!\"
    abbr -a gcam --set-cursor=! "git add . && git commit -a -m \"!\""
    abbr -a gsp --set-cursor=! git stash push -m \"!\"
end
