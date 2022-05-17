set fish_greeting # disable fish greeting
starship init fish | source
zoxide init fish | source

set -Ux BAT_THEME Nord 
set -Ux EDITOR nvim
set -Ux FZF_CTRL_R_OPTS "--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -Ux FZF_DEFAULT_OPTS "--color=spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
set -Ux FZF_TMUX_OPTS "-p"
set -Ux GOPATH (go env GOPATH)
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# adjust color scheme
set fish_color_autosuggestion green
set fish_color_command normal
set fish_color_error red
set fish_color_param magenta
set fish_color_redirections yellow
set fish_color_terminators white
set fish_color_valid_path normal

# os specific homebrew setup
switch (uname)
case Darwin
  eval (/opt/homebrew/bin/brew shellenv)
  fish_add_path /opt/homebrew/bin
case Linux
  fish_add_path "/home/linuxbrew/.linuxbrew/bin"
end

# user path
fish_add_path /opt/homebrew/opt/node@14/bin
fish_add_path /Users/joshmedeski/.nvm/versions/node/v16.15.0/bin
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/bin"

# aliases
alias aw="~/.config/aw/bin/run"
alias ls="lsd  --group-dirs first -A"

# abbreviations
abbr ast "aw set -t (aw list | fzf-tmux -p --reverse --preview 'aw set -t {}')"
abbr bc "brew cleanup"
abbr bd "brew doctor"
abbr bi "brew install"
abbr bic "brew install --cask"
abbr bif "brew info"
abbr bifc "brew info --cask"
abbr bo "brew outdated"
abbr bs "brew services"
abbr bsr "brew services restart"
abbr bu "brew update"
abbr bug "brew upgrade"
abbr c "clear"
abbr cl "clear"
abbr claer "clear"
abbr clera "clear"
abbr cx "chmod +x"
abbr dc "docker compose"
abbr dcd "docker compose down"
abbr dcdv "docker compose down -v"
abbr dcr "docker compose restart"
abbr dcu "docker compose up -d" 
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"
abbr e "exit"
abbr ee "espanso edit"
abbr er "espanso restart"
abbr g "git status"
abbr ga "git add ."
abbr gb "git branch -v"
abbr gc "git commit"
abbr gca "git commit -av"
abbr gcl "git clone"
abbr gco "git checkout -b"
abbr gcom "~/bin/git-to-master-cleanup-branch.sh"
abbr gd "git diff"
abbr gf "git fetch --all"
abbr gl "git pull"
abbr gp "git push"
abbr gpr "gh pr create"
abbr gpum "git pull upstream master"
abbr gr "git remote"
abbr gra "git remote add"
abbr grao "git remote add origin"
abbr grau "git remote add upstream"
abbr grv "git remote -v"
abbr gs "git status"
abbr gst "git status"
abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m --reverse)\'"
abbr l "lsd  --group-dirs first -A"
abbr ld "lazydocker"
abbr lg "lazygit"
abbr ll "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"
abbr nd "npm run dev"
abbr nf "neofetch"
abbr nxdg "nx dep-graph"
abbr os "overmind start"
abbr rmr "rm -rf"
abbr sa "SwitchAudioSource -t output -s (SwitchAudioSource -t output -a | fzf-tmux -p --reverse)"
abbr sai "SwitchAudioSource -t input -s (SwitchAudioSource -t input -a | fzf-tmux -p --reverse)"
abbr sao "SwitchAudioSource -t output -s (SwitchAudioSource -t output -a | fzf-tmux -p --reverse)"
abbr sb "sam build"
abbr sf "source ~/.config/fish/config.fish"
abbr st "tmux source ~/.config/tmux/tmux.conf"
abbr ta "tmux a"
abbr tat "tmux attach -t"
abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr u "~/bin/update.sh"
abbr vf "nvim ~/.config/fish/config.fish"
abbr vh "nvim ~/.local/share/fish/fish_history"
abbr vim "nvim"
abbr vp "nvim package.json"
abbr vpc "nvim +PlugClean"
abbr vpi "nvim +PlugInstall"
abbr vpu "nvim +PlugUpdate"
abbr vpug "nvim +PlugUpgrade"
abbr vt "vim ~/.config/tmux/tmux.conf"
abbr y "yarn"
abbr ya "yarn add"
abbr yad "yarn add -D"
abbr yb "yarn build"
abbr yd "tmux rename-window dev && yarn dev"
abbr ye "tmux rename-window e2e && yarn e2e"
abbr yg "yarn generate"
abbr yl "yarn lint"
abbr yt "tmux rename-window test && yarn test"
