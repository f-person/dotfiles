#!/usr/bin/fish

export ANDROID_SDK_ROOT=/home/fperson/dev/Android/Sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT

set -U fish_user_paths /home/fperson/dev/flutter/bin $ANDROID_HOME/platform-tool $ANDROID_HOME/tools $ANDROID_HOME/tools/bin /home/fperson/bin /home/fperson/go/bin /home/fperson/.config/nvm/12.16.3/bin /home/fperson/dev/flutter/.pub-cache/bin /home/fperson/.luarocks/bin /home/fperson/.pulumi/bin

alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

abbr ls lsd
abbr lst 'lsd --tree'
abbr vi nvim
abbr vim nvim
abbr rg 'rg -i'
abbr df 'df -h'
abbr du 'du -h'
abbr cls clear
abbr targz 'tar xvzf'

abbr gitst 'git status'
abbr gitaa 'git add .'
abbr gitc 'git commit -m'
abbr gitpl 'git pull'
abbr gitdf 'git diff'
abbr gitps 'git push'
abbr gitcl 'git clone'

# Colored man pages
set -xU LESS_TERMCAP_md (printf "\e[01;31m")
set -xU LESS_TERMCAP_me (printf "\e[0m")
set -xU LESS_TERMCAP_se (printf "\e[0m")
set -xU LESS_TERMCAP_so (printf "\e[01;44;33m")
set -xU LESS_TERMCAP_ue (printf "\e[0m")
set -xU LESS_TERMCAP_us (printf "\e[01;32m")
