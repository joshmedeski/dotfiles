set fish_greeting # disable fish greeting

switch (uname)
case Darwin
  eval (/opt/homebrew/bin/brew shellenv)
case Linux
  set -g fish_user_paths "/home/linuxbrew/.linuxbrew/bin" $fish_user_paths
end

starship init fish | source
zoxide init fish | source

# shell env variables
set -Ux BAT_THEME Nord 
set -Ux EDITOR nvim
set -Ux FZF_CTRL_R_OPTS "--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -Ux FZF_TMUX_OPTS "-p"
set -Ux FZF_DEFAULT_COMMAND "fd -H -E '.git'"
set -Ux GOPATH (go env GOPATH)

# user path
set -g fish_user_paths "~/go/bin" $fish_user_paths
set -x PATH (pwd)"/git-fuzzy/bin:$PATH"

# language
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# aliases
alias t="~/repos/dotfiles/bin/t.sh"
alias ls="lsd  --group-dirs first -A"
alias vim="nvim"
alias v="vim"

# abbreviations
abbr t "t"
abbr b "brew"
abbr bb "arch -arm64 brew"
abbr bc "brew cleanup"
abbr bd "brew doctor"
abbr bi "brew install"
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
abbr dc "docker-compose"
abbr dcd "docker-compose down"
abbr dcdv "docker-compose down -v"
abbr dcr "docker-compose restart"
abbr dcu "docker-compose up -d" 
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"
abbr e "exit"
abbr g "git status"
abbr ga "git add ."
abbr gb "git branch -v"
abbr gc "git commit"
abbr gca "git commit -av"
abbr gcl "git clone"
abbr gco "git checkout -b"
abbr gcom "~/bin/git-to-master-cleanup-branch.sh"
abbr gd "git diff"
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
abbr nvim "vim"
abbr sf "source ~/.config/fish/config.fish"
abbr st "tmux source ~/.config/tmux/tmux.conf"
abbr tn "tmux new -s"
abbr ta "tmux attach -t"
abbr u "~/bin/update.sh"
abbr vf "vim ~/.config/fish/config.fish"
abbr vh "vim ~/.local/share/fish/fish_history"
abbr vt "vim ~/.config/tmux/tmux.conf"
abbr y "yarn"
abbr yb "yarn build"
abbr yd "yarn dev"
abbr yo "yarn open"
abbr ys "yarn start"
abbr zat "docker run --rm -v (pwd):/data -p 4567:4567 -it pindar/zat zat"

# adjust color scheme
set fish_color_autosuggestion green
set fish_color_command normal
set fish_color_error red
set fish_color_param magenta
set fish_color_redirections yellow
set fish_color_terminators white
set fish_color_valid_path normal

set -Ux LF_ICONS "\
tw=:\
st=:\
ow=:\
dt=:\
di=:\
fi=:\
ln=:\
or=:\
ex=:\
*.c=:\
*.cc=:\
*.clj=:\
*.coffee=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.erl=:\
*.exs=:\
*.fs=:\
*.go=:\
*.h=:\
*.hh=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.java=:\
*.jl=:\
*.js=:\
*.json=:\
*.lua=:\
*.md=:\
*.php=:\
*.pl=:\
*.pro=:\
*.py=:\
*.rb=:\
*.rs=:\
*.scala=:\
*.ts=:\
*.vim=:\
*.cmd=:\
*.ps1=:\
*.sh=:\
*.bash=:\
*.zsh=:\
*.fish=:\
*.tar=:\
*.tgz=:\
*.arc=:\
*.arj=:\
*.taz=:\
*.lha=:\
*.lz4=:\
*.lzh=:\
*.lzma=:\
*.tlz=:\
*.txz=:\
*.tzo=:\
*.t7z=:\
*.zip=:\
*.z=:\
*.dz=:\
*.gz=:\
*.lrz=:\
*.lz=:\
*.lzo=:\
*.xz=:\
*.zst=:\
*.tzst=:\
*.bz2=:\
*.bz=:\
*.tbz=:\
*.tbz2=:\
*.tz=:\
*.deb=:\
*.rpm=:\
*.jar=:\
*.war=:\
*.ear=:\
*.sar=:\
*.rar=:\
*.alz=:\
*.ace=:\
*.zoo=:\
*.cpio=:\
*.7z=:\
*.rz=:\
*.cab=:\
*.wim=:\
*.swm=:\
*.dwm=:\
*.esd=:\
*.jpg=:\
*.jpeg=:\
*.mjpg=:\
*.mjpeg=:\
*.gif=:\
*.bmp=:\
*.pbm=:\
*.pgm=:\
*.ppm=:\
*.tga=:\
*.xbm=:\
*.xpm=:\
*.tif=:\
*.tiff=:\
*.png=:\
*.svg=:\
*.svgz=:\
*.mng=:\
*.pcx=:\
*.mov=:\
*.mpg=:\
*.mpeg=:\
*.m2v=:\
*.mkv=:\
*.webm=:\
*.ogm=:\
*.mp4=:\
*.m4v=:\
*.mp4v=:\
*.vob=:\
*.qt=:\
*.nuv=:\
*.wmv=:\
*.asf=:\
*.rm=:\
*.rmvb=:\
*.flc=:\
*.avi=:\
*.fli=:\
*.flv=:\
*.gl=:\
*.dl=:\
*.xcf=:\
*.xwd=:\
*.yuv=:\
*.cgm=:\
*.emf=:\
*.ogv=:\
*.ogx=:\
*.aac=:\
*.au=:\
*.flac=:\
*.m4a=:\
*.mid=:\
*.midi=:\
*.mka=:\
*.mp3=:\
*.mpc=:\
*.ogg=:\
*.ra=:\
*.wav=:\
*.oga=:\
*.opus=:\
*.spx=:\
*.xspf=:\
*.pdf=:\
*.nix=:\
"
