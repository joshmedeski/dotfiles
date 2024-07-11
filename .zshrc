[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export EDITOR=nvim
export PATH="~/config/bin:$PATH"
export PATH="~/go/bin:$PATH"

# source /Users/josh/.config/broot/launcher/bash/br
# source /Users/joshmedeski/.config/broot/launcher/bash/br

source <(pkgx --shellcode)  #docs.pkgx.sh/shellcode
if [ -f "/Users/joshmedeski/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/joshmedeski/.config/fabric/fabric-bootstrap.inc"; fi

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions
