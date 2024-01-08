function copilot --description 'Copilot CLI: What the shell?'
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if $copilot_cli_path what-the-shell "$argv" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

function copilot_git --description 'Copilot CLI: Git'
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if $copilot_cli_path git-assist "$argv" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

function copilot_gh --description 'Copilot CLI: Github'
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if $copilot_cli_path gh-assist "$argv" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end
