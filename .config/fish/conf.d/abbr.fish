#  █████╗ ██████╗ ██████╗ ██████╗
# ██╔══██╗██╔══██╗██╔══██╗██╔══██╗
# ███████║██████╔╝██████╔╝██████╔╝
# ██╔══██║██╔══██╗██╔══██╗██╔══██╗
# ██║  ██║██████╔╝██████╔╝██║  ██║
# ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝  ╚═╝
# abbreviations - user-defined words that are replaced with longer phrases when entered
# https://fishshell.com/docs/current/cmds/abbr.html
# cSpell:disable

abbr :FindAndReplace "nvim +FindAndReplace"
abbr :GoToCommand fzf-history-widget
abbr :GoToFile "nvim +GoToFile"
abbr :GoToSymbol "nvim +GoToSymbol"
abbr :SmartGoTo "nvim +SmartGoTo"
abbr :Grep "nvim +Grep"
abbr :bd exit
abbr :q "tmux kill-server"
abbr :qa! "tmux kill-server"

abbr ast "aw set -t (aw list | fzf-tmux -p --reverse --preview 'aw set -t {}')"
abbr av "NVIM_APPNAME=astronvim nvim"
abbr ai "opencode"

abbr b build
abbr bi "brew install"
abbr bic "brew install --cask"
abbr bin "brew info"
abbr binc "brew info --cask"
abbr bl "brew leaves"
abbr blr "brew leaves --installed-on-request"
abbr blp "brew leaves --installed-as-dependency"
abbr bs "brew search"
abbr bni "bun i"

abbr c clear
abbr cl clear
abbr claer clear
abbr clera clear
abbr cx "chmod +x"

abbr d dev
abbr dc "docker compose"
abbr dcd "docker compose down"
abbr dcdv "docker compose down -v"
abbr dcr "docker compose restart"
abbr dcu "docker compose up -d"
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"

abbr editor "nvim +GoToFile"
abbr e exit
abbr ee "espanso edit"
abbr er "espanso restart"

abbr fi "fisher install"
abbr ff "fastfetch"
abbr fr "fisher refresh"
abbr fu "fisher update"
abbr fl "fisher list | sed 's/.*/"&"/'"

abbr g generate
abbr ga "git add ."
abbr gb "git branch -v"
abbr gc "git commit"
abbr gca "git commit -av"
abbr gcl "git clone"
abbr gco "git checkout -b"
abbr gcom "~/bin/git-to-master-cleanup-branch.sh"
abbr gd "nvim +DiffviewOpen"
abbr gf "git fetch --prune --all"
abbr gl "git pull"
abbr gma "git merge --abort"
abbr gmc "git merge --continue"
abbr gp "git push"
abbr gpf "git push origin --force-with-lease"
abbr gpom "git pull origin main"
abbr gpo "git push origin --set-upstream HEAD"
abbr gpr "gh pr create"
abbr gpum "git pull upstream master"
abbr gr "git remote"
abbr gra "git remote add"
abbr grba "git rebase --abort"
abbr grbc "git rebase --continue"
abbr grbi "git rebase -i origin/main"
abbr grao "git remote add origin"
abbr grau "git remote add upstream"
abbr grv "git remote -v"
abbr gs "git status"
abbr gst "git status"

abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"

abbr ka killall
abbr kn "killall node"

abbr l "lsd  --group-dirs first -A"
abbr ld lazydocker
abbr lg lazygit
abbr ll "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"

abbr mnf "man fzf"
abbr mnt "man tmux"
abbr mnz "man zoxide"
abbr mb "make build"
abbr mt "make test"

abbr nb "npm run build"
abbr nd "npm run dev"
abbr ne "nvim .env"
abbr nf neofetch
abbr ni "npm install"
abbr nt "npm run test"
abbr nxdg "nx dep-graph"
abbr ns "nu seed"
abbr nw nu_new_worktree

abbr o "open ."
abbr oc "opencode"
abbr ok "overmind kill"
abbr or "overmind restart"
abbr os "overmind start -D"
abbr osl "overmind start -l"

abbr p "pnpm run (jq -r '.scripts|to_entries[]|((.key))' package.json | fzf-tmux -p --border-label='pnpm run')"
abbr pa "pnpm add"
abbr pb "pnpm build"
abbr pd "pnpm dev"
abbr pe "pnpm e2e"
abbr pg "pnpm generate"
abbr ph "pnpm help"
abbr pi "pnpm install"
abbr pim "pnpm import"
abbr pir "pnpm rebuild"
abbr pit "pnpm install-test"
abbr pl "pnpm lint"
abbr pls "pnpm ls"
abbr pr "pnpm run (jq -r '.scripts|to_entries[]|((.key))' package.json | fzf-tmux -p --border-label='pnpm run')"
abbr ps "pnpm start"
abbr psa "pnpm store add"
abbr psp "pnpm store prune"
abbr pss "pnpm store status"
abbr pt "pnpm test"
abbr pu "pnpm update"
abbr pul "pnpm unlink"
abbr pw "pnpm web"
abbr pwu "pnpm webUi"
abbr pwdc "pwd | pbcopy"

abbr rmr "rm -rf"

abbr s sesh_start
abbr s. "sesh connect ."
abbr sc "sesh clone --cmdDir ~/c (pbpaste)"
abbr sf "source ~/.config/fish/config.fish"
abbr sr "sesh root"

abbr ta "tmux attach"
abbr tk "tmux kill-server"
abbr tr "tldr --list | fzf --header 'tldr (tealdeer)' --reverse --preview 'tldr {1} --color=always' --preview-window=right,80% | xargs tldr"

abbr u update

abbr v "nvim +GoToFile"
abbr vfzf "nvim (fd --type f --hidden --follow --exclude .git | fzf-tmux -p -w 100 --reverse --preview 'bat --color=always --style=numbers --line-range=:500 {}')"
abbr va "nvim ~/.config/alacritty/alacritty.yml"
abbr vf "nvim ~/.config/fish/config.fish"
abbr vt "nvim ~/.config/tmux/tmux.conf"
abbr vp "nvim package.json"
abbr vpc "nvim +PlugClean"
abbr vpi "nvim +PlugInstall"
abbr vpu "nvim +PlugUpdate"
abbr vpug "nvim +PlugUpgrade"
abbr vt "nvim ~/.config/tmux/tmux.conf"

abbr x "chmod +x (ls | gum filter --limit 1 --header 'chmod +x')"

abbr za "zoxide add"
abbr zad "ls -d */ | xargs -I {} zoxide add {}"
abbr ze "zoxide edit"
