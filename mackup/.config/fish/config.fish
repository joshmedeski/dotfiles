set fish_greeting # disable fish greeting

starship init fish | source
zoxide init fish | source
pyenv init - | source

# variables
set -U BAT_THEME Nord 
set -U EDITOR 'nvim'
set -U FZF_CTRL_R_OPTS "--border-label=' History ' --prompt=' '"
set -U FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -U FZF_DEFAULT_OPTS "--reverse --no-info --prompt=' ' --pointer='' --marker='' --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U FZF_TMUX_OPTS "-p --no-info --ansi --color gutter:-1,bg+:-1,header:4,separator:0,info:0,label:4,border:4,prompt:7,pointer:5,query:7,prompt:7"
set -U GOPATH (go env GOPATH)
set -U KIT_EDITOR /opt/homebrew/bin/nvim
set -U LANG en_US.UTF-8
set -U LC_ALL en_US.UTF-8
set -U NODE_PATH "~/.nvm/versions/node/v16.15.0/bin/node"
set -U PAGER ~/.local/bin/nvimpager
set -gx PNPM_HOME "/Users/joshmedeski/Library/pnpm"

# path (ordered by priority - bottom up)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.config/bin # my custom scripts
fish_add_path $HOME/.config/tmux/plugins/tmux-nvr/bin
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin
fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin

# pnpm autocomplete
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

if test -n "$TMUX"
    eval (string replace "NVIM_LISTEN_ADDRESS=" "set -x NVIM_LISTEN_ADDRESS " (tmux show-environment -s NVIM_LISTEN_ADDRESS))
else
    set -x NVIM_LISTEN_ADDRESS /tmp/nvimsocket
end

# sqlite
fish_add_path /opt/homebrew/opt/sqlite/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/sqlite/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/sqlite/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/sqlite/lib/pkgconfig"

# fish colors
set -U fish_color_autosuggestion black
set -U fish_color_command normal
set -U fish_color_error red
set -U fish_color_param cyan
set -U fish_color_redirections yellow
set -U fish_color_terminators white
set -U fish_color_valid_path green

# aliases
alias aw "~/.config/aw/bin/run"
alias pn "pnpm"

# abbreviations
abbr :bd "exit"
abbr :q "tmux kill-server"
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
abbr gma "git merge --abort"
abbr gmc "git merge --continue"
abbr gp "git push"
abbr gpom "git pull origin main"
abbr gpr "gh pr create"
abbr gpum "git pull upstream master"
abbr gr "git remote"
abbr gra "git remote add"
abbr grao "git remote add origin"
abbr grau "git remote add upstream"
abbr grv "git remote -v"
abbr gs "git status"
abbr gst "git status"
abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"
abbr kn "killall node"
abbr l "lsd  --group-dirs first -A"
abbr ld "lazydocker"
abbr lg "lazygit"
abbr ll "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"
abbr nb "npm run build"
abbr nd "npm run dev"
abbr nf "neofetch"
abbr ni "npm install"
abbr nt "npm run test"
abbr nxdg "nx dep-graph"
abbr os "overmind start"
abbr pb "pnpm build"
abbr pd "pnpm dev"
abbr pg "pnpm generate"
abbr pi "pnpm install"
abbr pw "pnpm web"
abbr rmr "rm -rf"
abbr sa "SwitchAudioSource -t output -s (SwitchAudioSource -t output -a | fzf-tmux -p --reverse)"
abbr sai "SwitchAudioSource -t input -s (SwitchAudioSource -t input -a | fzf-tmux -p --reverse)"
abbr sao "SwitchAudioSource -t output -s (SwitchAudioSource -t output -a | fzf-tmux -p --reverse)"
abbr sb "sam build"
abbr sf "source ~/.config/fish/config.fish"
abbr st "tmux source ~/.config/tmux/tmux.conf"
abbr ta "tmux a"
abbr tat "tmux attach -t"
abbr td "t dotfiles"
abbr tk "tmux kill-server"
abbr tr "tldr --list | fzf --header 'tldr (tealdeer)' --reverse --preview 'tldr {1} --color=always' --preview-window=right,80% | xargs tldr"
# abbr tn "tmux new -s (pwd | sed 's/.*\///g')"
abbr tn "tmux new -s (basename (pwd))"
abbr u "~/bin/update.sh"
abbr v "tmux rename-window '' && nvr-tmux +GitFiles"
abbr vfzf "nvim (fd --type f --hidden --follow --exclude .git | fzf-tmux -p -w 100 --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}')"
abbr va "nvim ~/.config/alacritty/alacritty.yml"
abbr vf "nvim ~/.config/fish/config.fish"
abbr vp "nvim package.json"
abbr vpc "nvim +PlugClean"
abbr vpi "nvim +PlugInstall"
abbr vpu "nvim +PlugUpdate"
abbr vpug "nvim +PlugUpgrade"
abbr vt "nvim ~/.config/tmux/tmux.conf"
abbr y "yarn"
abbr ya "yarn add"
abbr yad "yarn add -D"
abbr yb "yarn build"
abbr yd "yarn dev"
abbr ye "yarn e2e"
abbr yg "yarn generate"
abbr yi "yarn install --frozen-lockfile"
abbr yl "yarn lint"
abbr yp "yarn plop"
abbr ypm "yarn plop model"
abbr ys "yarn server"
abbr yt "yarn test"
abbr yu "yarn ui"
abbr yw "yarn web"
