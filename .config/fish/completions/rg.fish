# Usage: __rg_contains_opt LONG [SHORT]
function __rg_contains_opt --description 'Specialized __fish_contains_opt'
    # Cache the config file because this function is called many times per
    # completion attempt.
    # The cache will persist for the entire shell session (even if the
    # variable or the file contents change).
    if not set -q __rg_config
        set -g __rg_config
        if set -qx RIPGREP_CONFIG_PATH
            set __rg_config (
                cat -- $RIPGREP_CONFIG_PATH 2>/dev/null \
                | string trim \
                | string match -rv '^$|^#'
            )
        end
    end

    set -l commandline (commandline -cpo) (commandline -ct) $__rg_config

    if contains -- "--$argv[1]" $commandline
        return 0
    end

    if set -q argv[2]
        if string match -qr -- "^-[^-]*$argv[2]" $commandline
            return 0
        end
    end

    return 1
end

complete -c rg -s e -l regexp -d 'A pattern to search for.' -r -f
complete -c rg -s f -l file -d 'Search for patterns from the given file.' -r -F
complete -c rg -s A -l after-context -d 'Show NUM lines after each match.' -r -f
complete -c rg -s B -l before-context -d 'Show NUM lines before each match.' -r -f
complete -c rg  -l binary -d 'Search binary files.'
complete -c rg -l no-binary -n '__rg_contains_opt binary ' -d 'Search binary files.'
complete -c rg  -l block-buffered -d 'Force block buffering.'
complete -c rg -l no-block-buffered -n '__rg_contains_opt block-buffered ' -d 'Force block buffering.'
complete -c rg -s b -l byte-offset -d 'Print the byte offset for each matching line.'
complete -c rg -l no-byte-offset -n '__rg_contains_opt byte-offset b' -d 'Print the byte offset for each matching line.'
complete -c rg -s s -l case-sensitive -d 'Search case sensitively (default).'
complete -c rg  -l color -d 'When to use color.' -r -f -a 'never auto always ansi'
complete -c rg  -l colors -d 'Configure color settings and styles.' -r -f
complete -c rg  -l column -d 'Show column numbers.'
complete -c rg -l no-column -n '__rg_contains_opt column ' -d 'Show column numbers.'
complete -c rg -s C -l context -d 'Show NUM lines before and after each match.' -r -f
complete -c rg  -l context-separator -d 'Set the separator for contextual chunks.' -r -f
complete -c rg -l no-context-separator -n '__rg_contains_opt context-separator ' -d 'Set the separator for contextual chunks.'
complete -c rg -s c -l count -d 'Show count of matching lines for each file.'
complete -c rg  -l count-matches -d 'Show count of every match for each file.'
complete -c rg  -l crlf -d 'Use CRLF line terminators (nice for Windows).'
complete -c rg -l no-crlf -n '__rg_contains_opt crlf ' -d 'Use CRLF line terminators (nice for Windows).'
complete -c rg  -l debug -d 'Show debug messages.'
complete -c rg  -l dfa-size-limit -d 'The upper size limit of the regex DFA.' -r -f
complete -c rg -s E -l encoding -d 'Specify the text encoding of files to search.' -r -f -a '# This is impossible to read, but these encodings rarely if ever change, so
# it probably does not matter. They are derived from the list given here:
# https://encoding.spec.whatwg.org/#concept-encoding-get
#
# The globbing here works in both fish and zsh (though they expand it in
# different orders). It may work in other shells too.

{{,us-}ascii,arabic,chinese,cyrillic,greek{,8},hebrew,korean}
logical visual mac {,cs}macintosh x-mac-{cyrillic,roman,ukrainian}
866 ibm{819,866} csibm866
big5{,-hkscs} {cn-,cs}big5 x-x-big5
cp{819,866,125{0,1,2,3,4,5,6,7,8}} x-cp125{0,1,2,3,4,5,6,7,8}
csiso2022{jp,kr} csiso8859{6,8}{e,i}
csisolatin{1,2,3,4,5,6,9} csisolatin{arabic,cyrillic,greek,hebrew}
ecma-{114,118} asmo-708 elot_928 sun_eu_greek
euc-{jp,kr} x-euc-jp cseuckr cseucpkdfmtjapanese
{,x-}gbk csiso58gb231280 gb18030 {,cs}gb2312 gb_2312{,-80} hz-gb-2312
iso-2022-{cn,cn-ext,jp,kr}
iso8859{,-}{1,2,3,4,5,6,7,8,9,10,11,13,14,15}
iso-8859-{1,2,3,4,5,6,7,8,9,10,11,{6,8}-{e,i},13,14,15,16} iso_8859-{1,2,3,4,5,6,7,8,9,15}
iso_8859-{1,2,6,7}:1987 iso_8859-{3,4,5,8}:1988 iso_8859-9:1989
iso-ir-{58,100,101,109,110,126,127,138,144,148,149,157}
koi{,8,8-r,8-ru,8-u,8_r} cskoi8r
ks_c_5601-{1987,1989} ksc{,_}5691 csksc56011987
latin{1,2,3,4,5,6} l{1,2,3,4,5,6,9}
shift{-,_}jis csshiftjis {,x-}sjis ms_kanji ms932
utf{,-}8 utf-16{,be,le} unicode-1-1-utf-8
windows-{31j,874,949,125{0,1,2,3,4,5,6,7,8}} dos-874 tis-620 ansi_x3.4-1968
x-user-defined auto none
'
complete -c rg -l no-encoding -n '__rg_contains_opt encoding E' -d 'Specify the text encoding of files to search.'
complete -c rg  -l engine -d 'Specify which regex engine to use.' -r -f -a 'default pcre2 auto'
complete -c rg  -l field-context-separator -d 'Set the field context separator.' -r -f
complete -c rg  -l field-match-separator -d 'Set the field match separator.' -r -f
complete -c rg  -l files -d 'Print each file that would be searched.'
complete -c rg -s l -l files-with-matches -d 'Print the paths with at least one match.'
complete -c rg  -l files-without-match -d 'Print the paths that contain zero matches.'
complete -c rg -s F -l fixed-strings -d 'Treat all patterns as literals.'
complete -c rg -l no-fixed-strings -n '__rg_contains_opt fixed-strings F' -d 'Treat all patterns as literals.'
complete -c rg -s L -l follow -d 'Follow symbolic links.'
complete -c rg -l no-follow -n '__rg_contains_opt follow L' -d 'Follow symbolic links.'
complete -c rg  -l generate -d 'Generate man pages and completion scripts.' -r -f -a 'man complete-bash complete-zsh complete-fish complete-powershell'
complete -c rg -s g -l glob -d 'Include or exclude file paths.' -r -f
complete -c rg  -l glob-case-insensitive -d 'Process all glob patterns case insensitively.'
complete -c rg -l no-glob-case-insensitive -n '__rg_contains_opt glob-case-insensitive ' -d 'Process all glob patterns case insensitively.'
complete -c rg  -l heading -d 'Print matches grouped by each file.'
complete -c rg -l no-heading -n '__rg_contains_opt heading ' -d 'Print matches grouped by each file.'
complete -c rg -s h -l help -d 'Show help output.'
complete -c rg -s . -l hidden -d 'Search hidden files and directories.'
complete -c rg -l no-hidden -n '__rg_contains_opt hidden .' -d 'Search hidden files and directories.'
complete -c rg  -l hostname-bin -d 'Run a program to get this system\'s hostname.' -r -f -a '(__fish_complete_command)'
complete -c rg  -l hyperlink-format -d 'Set the format of hyperlinks.' -r -f -a 'default none file grep+ kitty macvim textmate vscode vscode-insiders vscodium'
complete -c rg  -l iglob -d 'Include/exclude paths case insensitively.' -r -f
complete -c rg -s i -l ignore-case -d 'Case insensitive search.'
complete -c rg  -l ignore-file -d 'Specify additional ignore files.' -r -F
complete -c rg  -l ignore-file-case-insensitive -d 'Process ignore files case insensitively.'
complete -c rg -l no-ignore-file-case-insensitive -n '__rg_contains_opt ignore-file-case-insensitive ' -d 'Process ignore files case insensitively.'
complete -c rg  -l include-zero -d 'Include zero matches in summary output.'
complete -c rg -l no-include-zero -n '__rg_contains_opt include-zero ' -d 'Include zero matches in summary output.'
complete -c rg -s v -l invert-match -d 'Invert matching.'
complete -c rg -l no-invert-match -n '__rg_contains_opt invert-match v' -d 'Invert matching.'
complete -c rg  -l json -d 'Show search results in a JSON Lines format.'
complete -c rg -l no-json -n '__rg_contains_opt json ' -d 'Show search results in a JSON Lines format.'
complete -c rg  -l line-buffered -d 'Force line buffering.'
complete -c rg -l no-line-buffered -n '__rg_contains_opt line-buffered ' -d 'Force line buffering.'
complete -c rg -s n -l line-number -d 'Show line numbers.'
complete -c rg -s N -l no-line-number -d 'Suppress line numbers.'
complete -c rg -s x -l line-regexp -d 'Show matches surrounded by line boundaries.'
complete -c rg -s M -l max-columns -d 'Omit lines longer than this limit.' -r -f
complete -c rg  -l max-columns-preview -d 'Show preview for lines exceeding the limit.'
complete -c rg -l no-max-columns-preview -n '__rg_contains_opt max-columns-preview ' -d 'Show preview for lines exceeding the limit.'
complete -c rg -s m -l max-count -d 'Limit the number of matching lines.' -r -f
complete -c rg -s d -l max-depth -d 'Descend at most NUM directories.' -r -f
complete -c rg  -l max-filesize -d 'Ignore files larger than NUM in size.' -r -f
complete -c rg  -l mmap -d 'Search with memory maps when possible.'
complete -c rg -l no-mmap -n '__rg_contains_opt mmap ' -d 'Search with memory maps when possible.'
complete -c rg -s U -l multiline -d 'Enable searching across multiple lines.'
complete -c rg -l no-multiline -n '__rg_contains_opt multiline U' -d 'Enable searching across multiple lines.'
complete -c rg  -l multiline-dotall -d 'Make \'.\' match line terminators.'
complete -c rg -l no-multiline-dotall -n '__rg_contains_opt multiline-dotall ' -d 'Make \'.\' match line terminators.'
complete -c rg  -l no-config -d 'Never read configuration files.'
complete -c rg  -l no-ignore -d 'Don\'t use ignore files.'
complete -c rg -l ignore -n '__rg_contains_opt no-ignore ' -d 'Don\'t use ignore files.'
complete -c rg  -l no-ignore-dot -d 'Don\'t use .ignore or .rgignore files.'
complete -c rg -l ignore-dot -n '__rg_contains_opt no-ignore-dot ' -d 'Don\'t use .ignore or .rgignore files.'
complete -c rg  -l no-ignore-exclude -d 'Don\'t use local exclusion files.'
complete -c rg -l ignore-exclude -n '__rg_contains_opt no-ignore-exclude ' -d 'Don\'t use local exclusion files.'
complete -c rg  -l no-ignore-files -d 'Don\'t use --ignore-file arguments.'
complete -c rg -l ignore-files -n '__rg_contains_opt no-ignore-files ' -d 'Don\'t use --ignore-file arguments.'
complete -c rg  -l no-ignore-global -d 'Don\'t use global ignore files.'
complete -c rg -l ignore-global -n '__rg_contains_opt no-ignore-global ' -d 'Don\'t use global ignore files.'
complete -c rg  -l no-ignore-messages -d 'Suppress gitignore parse error messages.'
complete -c rg -l ignore-messages -n '__rg_contains_opt no-ignore-messages ' -d 'Suppress gitignore parse error messages.'
complete -c rg  -l no-ignore-parent -d 'Don\'t use ignore files in parent directories.'
complete -c rg -l ignore-parent -n '__rg_contains_opt no-ignore-parent ' -d 'Don\'t use ignore files in parent directories.'
complete -c rg  -l no-ignore-vcs -d 'Don\'t use ignore files from source control.'
complete -c rg -l ignore-vcs -n '__rg_contains_opt no-ignore-vcs ' -d 'Don\'t use ignore files from source control.'
complete -c rg  -l no-messages -d 'Suppress some error messages.'
complete -c rg -l messages -n '__rg_contains_opt no-messages ' -d 'Suppress some error messages.'
complete -c rg  -l no-require-git -d 'Use .gitignore outside of git repositories.'
complete -c rg -l require-git -n '__rg_contains_opt no-require-git ' -d 'Use .gitignore outside of git repositories.'
complete -c rg  -l no-unicode -d 'Disable Unicode mode.'
complete -c rg -l unicode -n '__rg_contains_opt no-unicode ' -d 'Disable Unicode mode.'
complete -c rg -s 0 -l null -d 'Print a NUL byte after file paths.'
complete -c rg  -l null-data -d 'Use NUL as a line terminator.'
complete -c rg  -l one-file-system -d 'Skip directories on other file systems.'
complete -c rg -l no-one-file-system -n '__rg_contains_opt one-file-system ' -d 'Skip directories on other file systems.'
complete -c rg -s o -l only-matching -d 'Print only matched parts of a line.'
complete -c rg  -l path-separator -d 'Set the path separator for printing paths.' -r -f
complete -c rg  -l passthru -d 'Print both matching and non-matching lines.'
complete -c rg -s P -l pcre2 -d 'Enable PCRE2 matching.'
complete -c rg -l no-pcre2 -n '__rg_contains_opt pcre2 P' -d 'Enable PCRE2 matching.'
complete -c rg  -l pcre2-version -d 'Print the version of PCRE2 that ripgrep uses.'
complete -c rg  -l pre -d 'Search output of COMMAND for each PATH.' -r -f -a '(__fish_complete_command)'
complete -c rg -l no-pre -n '__rg_contains_opt pre ' -d 'Search output of COMMAND for each PATH.'
complete -c rg  -l pre-glob -d 'Include or exclude files from a preprocessor.' -r -f
complete -c rg -s p -l pretty -d 'Alias for colors, headings and line numbers.'
complete -c rg -s q -l quiet -d 'Do not print anything to stdout.'
complete -c rg  -l regex-size-limit -d 'The size limit of the compiled regex.' -r -f
complete -c rg -s r -l replace -d 'Replace matches with the given text.' -r -f
complete -c rg -s z -l search-zip -d 'Search in compressed files.'
complete -c rg -l no-search-zip -n '__rg_contains_opt search-zip z' -d 'Search in compressed files.'
complete -c rg -s S -l smart-case -d 'Smart case search.'
complete -c rg  -l sort -d 'Sort results in ascending order.' -r -f -a 'none path modified accessed created'
complete -c rg  -l sortr -d 'Sort results in descending order.' -r -f -a 'none path modified accessed created'
complete -c rg  -l stats -d 'Print statistics about the search.'
complete -c rg -l no-stats -n '__rg_contains_opt stats ' -d 'Print statistics about the search.'
complete -c rg  -l stop-on-nonmatch -d 'Stop searching after a non-match.'
complete -c rg -s a -l text -d 'Search binary files as if they were text.'
complete -c rg -l no-text -n '__rg_contains_opt text a' -d 'Search binary files as if they were text.'
complete -c rg -s j -l threads -d 'Set the approximate number of threads to use.' -r -f
complete -c rg  -l trace -d 'Show trace messages.'
complete -c rg  -l trim -d 'Trim prefix whitespace from matches.'
complete -c rg -l no-trim -n '__rg_contains_opt trim ' -d 'Trim prefix whitespace from matches.'
complete -c rg -s t -l type -d 'Only search files matching TYPE.' -r -f -a '(rg --type-list | string replace : \t)'
complete -c rg -s T -l type-not -d 'Do not search files matching TYPE.' -r -f -a '(rg --type-list | string replace : \t)'
complete -c rg  -l type-add -d 'Add a new glob for a file type.' -r -f
complete -c rg  -l type-clear -d 'Clear globs for a file type.' -r -f
complete -c rg  -l type-list -d 'Show all supported file types.'
complete -c rg -s u -l unrestricted -d 'Reduce the level of "smart" filtering.'
complete -c rg -s V -l version -d 'Print ripgrep\'s version.'
complete -c rg  -l vimgrep -d 'Print results in a vim compatible format.'
complete -c rg -s H -l with-filename -d 'Print the file path with each matching line.'
complete -c rg -s I -l no-filename -d 'Never print the path with each matching line.'
complete -c rg -s w -l word-regexp -d 'Show matches surrounded by word boundaries.'
complete -c rg  -l auto-hybrid-regex -d '(DEPRECATED) Use PCRE2 if appropriate.'
complete -c rg -l no-auto-hybrid-regex -n '__rg_contains_opt auto-hybrid-regex ' -d '(DEPRECATED) Use PCRE2 if appropriate.'
complete -c rg  -l no-pcre2-unicode -d '(DEPRECATED) Disable Unicode mode for PCRE2.'
complete -c rg -l pcre2-unicode -n '__rg_contains_opt no-pcre2-unicode ' -d '(DEPRECATED) Disable Unicode mode for PCRE2.'
complete -c rg  -l sort-files -d '(DEPRECATED) Sort results by file path.'
complete -c rg -l no-sort-files -n '__rg_contains_opt sort-files ' -d '(DEPRECATED) Sort results by file path.'
