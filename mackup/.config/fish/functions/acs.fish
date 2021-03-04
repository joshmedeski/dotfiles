function acs -d "Alacritty Colorscheme Switcher"
  command alacritty-colorscheme -a (
    alacritty-colorscheme -l | fzf-tmux -p 80%,80% --preview \
      'alacritty-colorscheme -a {} && msgcat --color=test'
  )
end
