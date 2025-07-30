# CRUSH Configuration

## Build/Install Commands
- **Install dotfiles**: `stow . -t ~` (from repo root)
- **Full setup**: `./install.sh` (includes homebrew, OSX settings)
- **Quick setup**: `./quickstart.sh` (minimal install)
- **Link configs**: `source install/link.sh`
- **Install homebrew packages**: `source install/brew.sh`

## Testing
- **Test stow**: `stow --no --verbose . -t ~` (dry run)
- **Validate symlinks**: Check `~/.config` for broken links

## Code Style Guidelines
- **Shell scripts**: Use `#!/bin/bash`, 2-space indentation
- **Config files**: Follow existing patterns in `.config/`
- **Lua (Neovim)**: 2 spaces, 120 char width (see `.config/lazyvim/stylua.toml`)
- **File naming**: Use kebab-case for scripts, follow app conventions for configs
- **Comments**: Use `#` for shell, `--` for Lua, document complex configurations

## Structure
- **Root**: Stow packages (directories symlinked to `~`)
- **`.config/`**: XDG config directory contents
- **`install/`**: Setup scripts
- **`raycast/`**: Raycast extensions
- **`app_support/`**: Application support files

## Error Handling
- Check file existence before symlinking
- Use conditional logic for OS-specific configs
- Backup existing configs before overwriting