#!/usr/bin/env bash
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='macos'
fi

echo $platform

#if [[ $platform == 'linux' ]]; then
#   alias ls='ls --color=auto'
#elif [[ $platform == 'freebsd' ]]; then
#   alias ls='ls -G'
#fi
