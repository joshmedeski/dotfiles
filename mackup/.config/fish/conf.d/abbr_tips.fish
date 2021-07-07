bind " " '__abbr_tips_bind_space'
bind \n '__abbr_tips_bind_newline'
bind \r '__abbr_tips_bind_newline'

set -g __abbr_tips_used 0


function __abbr_tips_install --on-event abbr_tips_install
    # Regexes used to find abbreviation inside command
    # Only the first matching group will be tested as an abbr
    set -Ux ABBR_TIPS_REGEXES
    set -a ABBR_TIPS_REGEXES '(^(\w+\s+)+(-{1,2})\w+)(\s\S+)'
    set -a ABBR_TIPS_REGEXES '(^(\s?(\w-?)+){3}).*'
    set -a ABBR_TIPS_REGEXES '(^(\s?(\w-?)+){2}).*'
    set -a ABBR_TIPS_REGEXES '(^(\s?(\w-?)+){1}).*'

    set -Ux ABBR_TIPS_PROMPT "\n💡 \e[1m{{ .abbr }}\e[0m => {{ .cmd }}"
    set -gx ABBR_TIPS_AUTO_UPDATE 'background'

    # Locking mechanism
    # Prevent this file to spawn more than one subshell
    if test "$USER" != 'root'
        fish -c '__abbr_tips_init' &
    end
end

function __abbr_tips --on-event fish_postexec -d "Abbreviation reminder for the current command"
    set -l command (string split ' ' -- "$argv")
    set -l cmd (string replace -r -a '\\s+' ' ' -- "$argv" )

    # Update abbreviations lists when adding/removing abbreviations
    if test "$command[1]" = "abbr"
        if string match -q -r '^--add|-a$' -- "$command[2]"
            and not contains -- "$command[3]" $__ABBR_TIPS_KEYS
            set -a __ABBR_TIPS_KEYS "$command[3]"
            set -a __ABBR_TIPS_VALUES "$command[4..-1]"
        else if string match -q -r '^--erase|-e$' -- "$command[2]"
            and set -l abb (contains -i -- "$command[3]" $__ABBR_TIPS_KEYS)
            set -e __ABBR_TIPS_KEYS[$abb]
            set -e __ABBR_TIPS_VALUES[$abb]
        end
    else if test "$command[1]" = "alias"
        # Update abbreviations list when adding aliases
        set -l alias_key
        set -l alias_value

        if string match -q '*=*' -- "$command[2]"
            if test (count $command) = 2
                set command_split (string split '=' -- $command[2])
                set alias_key "a__$command_split[1]"
                set alias_value $command_split[2]
                set -a alias_value $command[3..-1]
            end
        else
            set alias_key "a__$command[2]"
            set alias_value $command[3..-1]
        end

        if set -l abb (contains -i -- "$command[3..-1]" $__ABBR_TIPS_KEYS)
            set __ABBR_TIPS_KEYS[$abb] $alias_key
            set __ABBR_TIPS_VALUES[$abb] (string trim -c '\'"' -- $alias_value | string join ' ')
        else
            set -a __ABBR_TIPS_KEYS $alias_key
            set -a __ABBR_TIPS_VALUES (string trim -c '\'"' -- $alias_value | string join ' ')
        end
    else if test "$command[1]" = "functions"
        # Update abbreviations list when removing aliases
        and string match -q -r '^--erase|-e$' -- "$command[2]"
        and set -l abb (contains -i -- a__{$command[3]} $__ABBR_TIPS_KEYS)
        set -e __ABBR_TIPS_KEYS[$abb]
        set -e __ABBR_TIPS_VALUES[$abb]
    end

    # Exit in the following cases :
    #  - abbreviation has been used
    #  - command is already an abbreviation
    #  - command not found
    #  - or it's a function (alias)
    if test $__abbr_tips_used = 1
        set -g __abbr_tips_used 0
        return
    else if abbr -q "$cmd"
        or not type -q "$command[1]"
        return
    else if string match -q -- "alias $cmd *" (alias)
        return
    else if test (type -t "$command[1]") = 'function'
        and count $ABBR_TIPS_ALIAS_WHITELIST >/dev/null
        and not contains "$command[1]" $ABBR_TIPS_ALIAS_WHITELIST
        return
    end

    set -l abb
    if not set abb (contains -i -- "$cmd" $__ABBR_TIPS_VALUES)
        for r in $ABBR_TIPS_REGEXES
            if set abb (contains -i -- (string replace -r -a -- "$r" '$1' "$cmd") $__ABBR_TIPS_VALUES)
                break
            end
        end
    end

    if test -n "$abb"
        if string match -q "a__*" -- "$__ABBR_TIPS_KEYS[$abb]"
            set -l alias (string sub -s 4 -- "$__ABBR_TIPS_KEYS[$abb]")
            if functions -q "$alias"
                echo -e (string replace -a '{{ .cmd }}' -- "$__ABBR_TIPS_VALUES[$abb]" \
                        (string replace -a '{{ .abbr }}' -- "$alias" "$ABBR_TIPS_PROMPT"))
            else
                set -e __ABBR_TIPS_KEYS[$abb]
                set -e __ABBR_TIPS_VALUES[$abb]
            end
        else
            echo -e (string replace -a '{{ .cmd }}' -- "$__ABBR_TIPS_VALUES[$abb]" \
                    (string replace -a '{{ .abbr }}' -- "$__ABBR_TIPS_KEYS[$abb]" "$ABBR_TIPS_PROMPT"))
        end
    end

    return
end

function __abbr_tips_uninstall --on-event abbr_tips_uninstall
    bind --erase \n
    bind --erase \r
    bind --erase " "
    set --erase __abbr_tips_used
    set --erase __abbr_tips_run_once
    set --erase __ABBR_TIPS_VALUES
    set --erase __ABBR_TIPS_KEYS
    set --erase ABBR_TIPS_PROMPT
    set --erase ABBR_TIPS_AUTO_UPDATE
    set --erase ABBR_TIPS_ALIAS_WHITELIST
    set --erase ABBR_TIPS_REGEXES
    functions --erase __abbr_tips_init
    functions --erase __abbr_tips_bind_newline
    functions --erase __abbr_tips_bind_space
    functions --erase __abbr_tips
end
