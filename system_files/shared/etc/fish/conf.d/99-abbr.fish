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

    abbr -a gp "git push -u origin HEAD"

    abbr -a grh "git add . && git reset --hard"
    abbr -a gr --set-cursor=! git reset @~1

    # BTRFS stuff
    abbr -a btrfs-compress --set-cursor=! sudo btrfs fi defragment -r -v -czstd !
    abbr -a btrfs-compsize --set-cursor=! sudo compsize !

    # OStree stuff
    abbr -a "rpm-ostree-diff" rpm-ostree db diff
end
