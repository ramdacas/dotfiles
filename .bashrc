# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
_Z_CMD=j
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

 . `brew --prefix`/etc/profile.d/z.sh

alias tmuxa='tmux attach'

export EDITOR=vim

source /Users/ramdac/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh

cd() {
         builtin cd "$@"
         local ret=$?
         ((ret)) || _cdd_chpwd
         return $ret
}

#tmux用プロンプト
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
