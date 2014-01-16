# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 色を使用出来るようにする
autoload -Uz colors
colors
 
########################################
# キーバインド
# emacs 風キーバインドにする
bindkey -e
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
# Ctrl-F, Ctrl-Bでワード単位
bindkey '^F' forward-word
bindkey '^B' backward-word
# Ctrl-Dでワードを削除
bindkey '^D' kill-word

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
 
# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
# hide rprompt after execute the command.
setopt transient_rprompt
REPORTTIME=2
#PROMPT="%{${fg[white]}%}[%n@Mac-mini]%{${reset_color}%} %~
#%# "
#PROMPT="%{${fg[white]}%}[%n@%m]%{${reset_color}%} %~
#%# "

# {{{ prompt (PS1)
setopt prompt_subst
local DARKC=$'%{\e[38;5;47m%}'
local LIGHTC=$'%{\e[38;5;46m%}'
local DEFAULTC=$'%{\e[m%}'
PROMPT=$DARKC"[%U$USER@Mac-mini "$LIGHTC"%~%u"$DARKC"]%# "$DEFAULTC
# }}}

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
 
########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit
 
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
 
# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
 
# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
#zstyle ':completion:*' completer _match _complete _expand _prefix _approximate _list _history 
zstyle ':completion:*' completer _complete _prefix _list _history
########################################
# vcs_info
 
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"
 
########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
 
# beep を無効にする
setopt no_beep
 
# フローコントロールを無効にする
setopt no_flow_control
 
# '#' 以降をコメントとして扱う
setopt interactive_comments
 
# ディレクトリ名だけでcdする
setopt auto_cd
 
# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups
 
# = の後はパス名として補完する
setopt magic_equal_subst
 
# 同時に起動したzshの間でヒストリを共有する
setopt share_history
 
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
 
# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups
 
# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
 
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
 
# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu
 
# 高機能なワイルドカード展開を使用する
setopt extended_glob
 
########################################
# エイリアス
 
alias la='ls -a'
alias ll='ls -l'
 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
 
alias mkdir='mkdir -p'

# vimrc/zshrc/zprofileで当該ファイルを編集
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias zprofile='vim ~/.zprofile'
alias zshenv='vim ~/.zshenv'

alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env_LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

. `brew --prefix`/etc/profile.d/z.sh
#. ~/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh
# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'
 
fpath=(/usr/local/share/zsh-completions $fpath)

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(history -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

# zaw.zsh
# http://shibayu36.hatenablog.com/entry/20120130/1327937835
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 5000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

source /Users/ramdac/.zsh/zaw/zaw.zsh
zstyle ':filter-select' case-insensitive yes # 絞り込みをcase-insensitiveに
bindkey '^q' zaw-cdr # zaw-cdrをbindkey 

#=============================
# source auto-fu.zsh
#=============================
source ~/.zsh/auto-fu.zsh/auto-fu.zsh
function zle-line-init () {
    auto-fu-init
    }
    zle -N zle-line-init
# antigen
source ~/.zsh/.zshrc.antigen

# PowerLine
source /Users/ramdac/Library/Python/2.7/lib/python/site-packages/powerline/bindings/zsh/powerline.zsh
source ~/.zsh/.zsh.scripts

unalias run-help
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

#PS1="$PS1"$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")
PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

#function powerline_precmd() {
#  export PS1="$(~/.zsh/powerline-shell/powerline-shell.py $? --shell zsh 2> /dev/null)"
#}

#function install_powerline_precmd() {
#  for s in "${precmd_functions[@]}"; do
#    if [ "$s" = "powerline_precmd" ]; then
#      return
#    fi
#  done
#  precmd_functions+=(powerline_precmd)
#}

#install_powerline_precmd

# {{{ override function
# Execute when pwd is changed
#function chpwd() { ll && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD" }

#zstyle ':completion:*:default' menu select=2
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z} r:|[._-]=*'
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' use-cache yes
# }}}
########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        ;;
esac
 
# vim:set ft=zsh:    
