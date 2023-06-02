function ff
    set -l ANIMAL (random choice {default,bud-frogs,dragon,dragon-and-cow,elephant,moose,stegosaurus,tux,vader})
    fortune -s | cowsay -f $ANIMAL | lolcat
end
