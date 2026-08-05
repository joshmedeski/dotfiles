#!/usr/bin/env fish

# Nearest package.json, walking up from $PWD.
function __pnpm_package_json --description 'Path to the nearest package.json'
    set -l dir (pwd -P)
    while true
        if test -f "$dir/package.json"
            echo "$dir/package.json"
            return 0
        end
        test "$dir" = / && return 1
        set dir (path dirname "$dir")
    end
end

# Script names from that package.json, with their command as the description.
function __pnpm_scripts --description 'Scripts defined in the nearest package.json'
    set -l pkg (__pnpm_package_json)
    test -n "$pkg" || return
    jq -r '.scripts // {} | to_entries[] | "\(.key)\t\(.value)"' $pkg 2>/dev/null
end

# pnpm's own completion server (subcommands + flags).
function __pnpm_completion --description "pnpm's built-in completion server"
    set cmd (commandline -o)
    set cursor (commandline -C)
    set words (count $cmd)

    set completions (eval env DEBUG=\"" \"" COMP_CWORD=\""$words\"" COMP_LINE=\""$cmd \"" COMP_POINT=\""$cursor\"" SHELL=fish pnpm completion-server -- $cmd)

    if [ "$completions" = "__tabtab_complete_files__" ]
        set -l matches (commandline -ct)*
        if [ -n "$matches" ]
            __fish_complete_path (commandline -ct)
        end
    else
        for completion in $completions
            echo -e $completion
        end
    end
end

# `pnpm run <TAB>` / `pnpm run-script <TAB>` -> scripts only.
complete -f -c pnpm -n '__fish_seen_subcommand_from run run-script' \
    -a '(__pnpm_scripts)'

# `pnpm <TAB>` -> subcommands plus scripts (pnpm runs scripts without `run`).
complete -f -c pnpm -n __fish_is_first_arg -a '(__pnpm_scripts)'
complete -f -c pnpm -n 'not __fish_seen_subcommand_from run run-script' \
    -d pnpm -a '(__pnpm_completion)'
