# cSpell:words mktemp multishells shellout
function copilot_what-the-shell
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli what-the-shell $argv --shellout $TMPFILE
        if test -e "$TMPFILE"
            set FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end
alias copilot copilot_what-the-shell

function copilot_git-assist
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli git-assist $argv --shellout $TMPFILE
        if test -e "$TMPFILE"
            set FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end
alias git-copilot copilot_git-assist

function copilot_gh-assist
    set TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli gh-assist $argv --shellout $TMPFILE
        if test -e "$TMPFILE"
            set FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end
alias gh-copilot copilot_gh-assist
alias wts copilot_what-the-shell
