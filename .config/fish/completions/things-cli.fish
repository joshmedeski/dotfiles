complete -c things-cli -d 'Simple read-only Thing 3 CLI' -s h -l help -d 'Show help message and exit' -a '(-h --help)' -r
complete -c things-cli -s p -l filter-project -d 'Filter by project' -r -a '(-p --filter-project)' -r
complete -c things-cli -s a -l filter-area -d 'Filter by area' -r -a '(-a --filter-area)' -r
complete -c things-cli -s t -l filter-tag -d 'Filter by tag' -r -a '(-t --filtertag)' -r
complete -c things-cli -s e -l only-projects -d 'Export only projects' -r -a '(-e --only-projects)' -r
complete -c things-cli -s o -l opml -d 'Output as OPML' -r -a '(-o --opml)' -r
complete -c things-cli -s j -l json -d 'Output as JSON' -r -a '(-j --json)' -r
complete -c things-cli -s c -l csv -d 'Output as CSV' -r -a '(-c --csv)' -r
complete -c things-cli -s g -l gantt -d 'Output as mermaid-js GANTT' -r -a '(-g --gantt)' -r
complete -c things-cli -s r -l recursive -d 'In-depth output' -r -a '(-r --recursive)' -r
complete -c things-cli -s d -l database -d 'Set path to database' -r -a '(-d --database)' -r
complete -c things-cli --description 'Show program version number and exit' -s v -l version
complete -c things-cli -n __fish_custom_command -a 'inbox today upcoming anytime completed someday canceled trash todos all areas projects logbook logtoday createdtoday tags deadlines feedback search'

# Custom completion command
function __fish_custom_command
    set cmd (commandline -opc)
    set options (commandline -opc)
    # Remove the 'command' argument from options
    set options[1] ''

    switch $cmd[1]
        case things-cli
            switch $cmd[2]
                case search
                    # List of possible search terms
                    complete -c things-cli --no-files -a term1 -a term2 -a term3
                    # Add more completions for specific subcommands here
            end

            # Completion for general options
            complete -c things-cli --no-files -s h -l help -d 'Show help message and exit'
            complete -c things-cli --no-files -s v -l version -d 'Show program version number and exit'

            # Completion for the '- Certainly! Here's the continuation of the completion script:

            # Completion for the '-p' and '--filter-project' options
            complete -c things-cli --no-files -s p -l filter-project -d 'Filter by project'

            # Completion for the '-a' and '--filter-area' options
            complete -c things-cli --no-files -s a -l filter-area -d 'Filter by area'

            # Completion for the '-t' and '--filter-tag' options
            complete -c things-cli --no-files -s t -l filter-tag -d 'Filter by tag'

            # Completion for the '-e' and '--only-projects' options
            complete -c things-cli --no-files -s e -l only-projects -d 'Export only projects'

            # Completion for the '-o' and '--opml' options
            complete -c things-cli --no-files -s o -l opml -d 'Output as OPML'

            # Completion for the '-j' and '--json' options
            complete -c things-cli --no-files -s j -l json -d 'Output as JSON'

            # Completion for the '-c' and '--csv' options
            complete -c things-cli --no-files -s c -l csv -d 'Output as CSV'

            # Completion for the '-g' and '--gantt' options
            complete -c things-cli --no-files -s g -l gantt -d 'Output as mermaid-js GANTT'

            # Completion for the '-r' and '--recursive' options
            complete -c things-cli --no-files -s r -l recursive -d 'In-depth output'

            # Completion for the '-d' and '--database' options
            complete -c things-cli --no-files -s d -l database -d 'Set path to database'

            # Completion for the subcommands
            for subcommand in inbox today upcoming anytime completed someday canceled trash todos all areas projects logbook logtoday createdtoday tags deadlines feedback search
                complete -c things-cli --no-files -a $subcommand
            end
    end
end
