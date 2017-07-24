# 色を使用できるようにする
autoload -Uz colors
colors


##################################################
# history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 同時に起動したzsh間でhistoryを共有
setopt share_history
# 重複コマンドは保存しない
setopt hist_ignore_all_dups
# スペースから始まるコマンドは保存しない
setopt hist_ignore_space
# 保存時、余分なスペースを削除
setopt hist_reduce_blanks

# 履歴検索
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
# 前方検索に必要
setopt no_flow_control


##################################################
# vsc_info
autoload -Uz vcs_info
setopt prompt_subst # $PROMPT中で変数を展開
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"        # ステージされていてコミットされていないファイルがある場合
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"         # ステージされていない変更ファイルがある場合
zstyle ':vcs_info:git:*' formats "%F{green}%c%u[%b]%f"  # $vcs_info_msg_0_のフォーマット
zstyle ':vcs_info:git:*' actionformats "[%b|%a]%c%u"    # コンフリクトなど特殊な状況のフォーマット

# プロンプト表示前にvcs_infoを呼び出す
precmd () {
    LANG=en_US.UTF-8 vcs_info
}


##################################################
# プロンプト
PROMPT='%F{cyan}%~%f ${vcs_info_msg_0_}
%F{green}[%D %*]%f %F{white}%#%f '

# ssh時はhostnameを赤で全て表示する
if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
PROMPT='
%F{white}[%n%f%F{red}@%M%f%F{white}]%f '$PROMOT

else
PROMPT='
%F{white}[%n@%m]%f '$PROMPT
fi


##################################################
# vimキーバインド
bindkey -v

# vimのモードを右側に表示
function zle-line-init zle-keymap-select {
    VIM_NORMAL="-- NORMAL --"
    VIM_INSERT="-- INSERT --"
    RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# jjでノーマルモードへ
bindkey -M viins 'jj' vi-cmd-mode


##################################################
# 補完機能を有効化
autoload -Uz compinit
compinit
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を強調表示
zstyle ':completion:*:default' menu select=1

# これまでに移動したディレクトリをcd -[Tab]で補完
setopt auto_pushd
# 重複したディレクトリは追加しない
setopt pushd_ignore_dups

# 入力したコマンド名が間違っている場合に修正
setopt correct

# 補完候補を詰めて表示
setopt list_packed


##################################################
# ls color
# ディレクトリ、シンボリックリンク、実行ファイルを色つけ
export LSCOLORS=Gxfxxxxxcxxxxxxxxxgxgx
# 補完候補もLSCOLORSに合わせて色が付くようにする
export LS_COLORS='di=01;36;40:ln=35;40:ex=32;40'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


##################################################
# エイリアス
alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# OS 別の設定
case ${OSTYPE} in
    darwin*)
        # Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        # Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac


##################################################
# path
# nodebrew path
export PATH=$HOME/.nodebrew/current/bin:$PATH 
