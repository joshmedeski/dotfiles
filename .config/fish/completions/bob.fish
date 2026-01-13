# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_bob_global_optspecs
	string join \n h/help V/version
end

function __fish_bob_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_bob_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_bob_using_subcommand
	set -l cmd (__fish_bob_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c bob -n "__fish_bob_needs_command" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_needs_command" -s V -l version -d 'Print version'
complete -c bob -n "__fish_bob_needs_command" -f -a "use" -d 'Switch to the specified version, by default will auto-invoke install command if the version is not installed already'
complete -c bob -n "__fish_bob_needs_command" -f -a "install" -d 'Install the specified version, can also be used to update out-of-date nightly version'
complete -c bob -n "__fish_bob_needs_command" -f -a "sync" -d 'If `Config::version_sync_file_location` is set, the version in that file will be parsed and installed'
complete -c bob -n "__fish_bob_needs_command" -f -a "uninstall" -d 'Uninstall the specified version'
complete -c bob -n "__fish_bob_needs_command" -f -a "rm" -d 'Uninstall the specified version'
complete -c bob -n "__fish_bob_needs_command" -f -a "rollback" -d 'Rollback to an existing nightly rollback'
complete -c bob -n "__fish_bob_needs_command" -f -a "erase" -d 'Erase any change bob ever made, including neovim installation, neovim version downloads and registry changes'
complete -c bob -n "__fish_bob_needs_command" -f -a "list" -d 'List all installed and used versions'
complete -c bob -n "__fish_bob_needs_command" -f -a "ls" -d 'List all installed and used versions'
complete -c bob -n "__fish_bob_needs_command" -f -a "list-remote"
complete -c bob -n "__fish_bob_needs_command" -f -a "ls-remote"
complete -c bob -n "__fish_bob_needs_command" -f -a "complete" -d 'Generate shell completion'
complete -c bob -n "__fish_bob_needs_command" -f -a "update" -d 'Update existing version |nightly|stable|--all|'
complete -c bob -n "__fish_bob_needs_command" -f -a "run"
complete -c bob -n "__fish_bob_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c bob -n "__fish_bob_using_subcommand use" -s n -l no-install -d 'Whether not to auto-invoke install command'
complete -c bob -n "__fish_bob_using_subcommand use" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c bob -n "__fish_bob_using_subcommand install" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c bob -n "__fish_bob_using_subcommand sync" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand uninstall" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c bob -n "__fish_bob_using_subcommand rm" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c bob -n "__fish_bob_using_subcommand rollback" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand erase" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand list" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand ls" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand list-remote" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand ls-remote" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand complete" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand update" -s a -l all -d 'Apply the update to all versions'
complete -c bob -n "__fish_bob_using_subcommand update" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand run" -s h -l help -d 'Print help'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "use" -d 'Switch to the specified version, by default will auto-invoke install command if the version is not installed already'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "install" -d 'Install the specified version, can also be used to update out-of-date nightly version'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "sync" -d 'If `Config::version_sync_file_location` is set, the version in that file will be parsed and installed'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "uninstall" -d 'Uninstall the specified version'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "rollback" -d 'Rollback to an existing nightly rollback'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "erase" -d 'Erase any change bob ever made, including neovim installation, neovim version downloads and registry changes'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "list" -d 'List all installed and used versions'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "list-remote"
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "complete" -d 'Generate shell completion'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "update" -d 'Update existing version |nightly|stable|--all|'
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "run"
complete -c bob -n "__fish_bob_using_subcommand help; and not __fish_seen_subcommand_from use install sync uninstall rollback erase list list-remote complete update run help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
