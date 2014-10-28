# -*- shell-script -*-
#
# atykhonov's init file for Z-SHELL 4.3.10 on Gentoo Linux.

# {{{ Make possible to use colors a little bit easier
source /home/demi/bin/zsh-colors.sh
# }}}

# {{{ Environment
export PATH="${PATH}:${HOME}/bin:/usr/local/bin:${HOME}/.cask/bin"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
export LESSHISTFILE="-"
export PAGER="less"
export READNULLCMD="${PAGER}"
export VISUAL="emacsclient"
export EDITOR="${VISUAL}"
export BROWSER="firefox"
export XTERM="urxvt"

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'
# }}}

# {{{ ZSH settings
setopt emacs
setopt nohup # don't kill bg processes when exiting
setopt cdablevars # avoid the need for an explicit $
setopt ignoreeof
setopt nobgnice
setopt nobanghist
setopt clobber
setopt shwordsplit
setopt interactivecomments
setopt autopushd pushdminus pushdsilent pushdtohome
setopt histreduceblanks histignorespace inc_append_history
setopt printexitvalue          # alert me if something's failed
# unsetopt MULTIBYTE             # without it zkbd won't recognize the Alt key
# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
unsetopt flowcontrol

# Prompt requirements
setopt extended_glob prompt_subst
autoload colors zsh/terminfo

# New style completion system
autoload -U compinit; compinit
#  * List of completers to use
zstyle ":completion:*" completer _complete _match _approximate
#  * Allow approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
#  * Selection prompt as menu
zstyle ":completion:*" menu select=1
#  * Menu selection for PID completion
zstyle ":completion:*:*:kill:*" menu yes select
zstyle ":completion:*:kill:*" force-list always
zstyle ":completion:*:processes" command "ps -au$USER"
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;32"
#  * Don't select parent dir on cd
zstyle ":completion:*:cd:*" ignore-parents parent pwd
#  * Complete with colors
zstyle ":completion:*" list-colors ""
# }}}

# {{{ Setup zkbd (key bindings)

autoload zkbd

function zkbd_file() {
    [[ -f ~/.zkbd/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' ~/".zkbd/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ~/.zkbd/${TERM}-${DISPLAY}          ]] && printf '%s' ~/".zkbd/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret

[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
# }}}

# {{{ Aliases
function exists { which $1 &> /dev/null }
function mcd() { mkdir -p $1 && cd $1 }
function cdf() { cd *$1*/ }
alias i=sxiv
alias ..="cd .."
alias ...="cd ../.."
alias ls="ls -aF --color=always"
alias ll="ls -l"
alias lfi="ls -l | egrep -v '^d'"
alias ldi="ls -l | egrep '^d'"
alias lst="ls -htl | grep `date +%Y-%m-%d`"
alias grep="grep --color=always"

# By @ieure; copied from https://gist.github.com/1474072
#
# It finds a file, looking up through parent directories until it finds one.
# Use it like this:
#
#   $ ls .tmux.conf
#   ls: .tmux.conf: No such file or directory
#
#   $ ls `up .tmux.conf`
#   /Users/grb/.tmux.conf
#
#   $ cat `up .tmux.conf`
#   set -g default-terminal "screen-256color"
#
function up()
{
    local DIR=$PWD
    local TARGET=$1
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR != "/" && echo $DIR/$TARGET
}
# }}}

# {{{ Goodies
# Run Selecta in the current working directory, appending the selected path, if
# any, to the current command.
function insert-selecta-path-in-command-line() {
    local selected_path
    # Print a newline or we'll clobber the old prompt.
    echo
    # Find the path; abort if the user doesn't select anything.
    selected_path=$(find * -type f | selecta) || return
    # Append the selection to the current command buffer.
    eval 'LBUFFER="$LBUFFER$selected_path"'
    # Redraw the prompt since Selecta has drawn several new lines of text.
    zle reset-prompt
}
# Create the zle widget
zle -N insert-selecta-path-in-command-line
# Bind the key to the newly created widget
bindkey "^S" "insert-selecta-path-in-command-line"

## View history by means of percol
if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi
# }}}

# {{{ Terminal and prompt
function precmd {
    # Terminal width = width - 1 (for lineup)
    local TERMWIDTH
    ((TERMWIDTH=${COLUMNS} - 1))

    # Truncate long paths
    PR_FILLBAR=""
    PR_PWDLEN=""
    local PROMPTSIZE="${#${(%):---(%n@%m:%l)---()--}}"
    local PWDSIZE="${#${(%):-%~}}"
    if [[ "${PROMPTSIZE} + ${PWDSIZE}" -gt ${TERMWIDTH} ]]; then
        ((PR_PWDLEN=${TERMWIDTH} - ${PROMPTSIZE}))
    else
        PR_FILLBAR="\${(l.((${TERMWIDTH} - (${PROMPTSIZE} + ${PWDSIZE})))..${PR_HBAR}.)}"
    fi
}

function preexec () {
    # Screen window titles as currently running programs
    if [[ "${TERM}" == "screen-256color" ]]; then
        local CMD="${1[(wr)^(*=*|sudo|-*)]}"
        echo -n "\ek$CMD\e\\"
    fi
}

function prompt_char {
    if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

function emerge_info() {
    cat "/home/demi/emerge-info"
}

function setprompt () {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_"${color}"="%{${terminfo[bold]}$fg[${(L)color}]%}"
        eval PR_LIGHT_"${color}"="%{$fg[${(L)color}]%}"
    done

    PR_NO_COLOUR="%{${terminfo[sgr0]}%}"

    # Terminal prompt settings
    case "${TERM}" in
        dumb) # Simple prompt for dumb terminals
            unsetopt zle
            PROMPT='%n@%m:%~%% '
            ;;
        linux) # Simple prompt with Zenburn colors for the console
            echo -en "\e]P01e2320" # zenburn black (normal black)
            echo -en "\e]P8709080" # bright-black  (darkgrey)
            echo -en "\e]P1705050" # red           (darkred)
            echo -en "\e]P9dca3a3" # bright-red    (red)
            echo -en "\e]P260b48a" # green         (darkgreen)
            echo -en "\e]PAc3bf9f" # bright-green  (green)
            echo -en "\e]P3dfaf8f" # yellow        (brown)
            echo -en "\e]PBf0dfaf" # bright-yellow (yellow)
            echo -en "\e]P4506070" # blue          (darkblue)
            echo -en "\e]PC94bff3" # bright-blue   (blue)
            echo -en "\e]P5dc8cc3" # purple        (darkmagenta)
            echo -en "\e]PDec93d3" # bright-purple (magenta)
            echo -en "\e]P68cd0d3" # cyan          (darkcyan)
            echo -en "\e]PE93e0e3" # bright-cyan   (cyan)
            echo -en "\e]P7dcdccc" # white         (lightgrey)
            echo -en "\e]PFffffff" # bright-white  (white)
            PROMPT='$PR_GREEN%n@%m$PR_WHITE:$PR_YELLOW%l$PR_WHITE:$PR_RED%~$PR_YELLOW%%$PR_NO_COLOUR '
            ;;
        *)  # Main prompt
            # PROMPT='$PR_GREEN%n@%m $PR_YELLOW%(!.%1~.%~) $PR_NO_COLOUR%_$(prompt_char) $(emerge_info)'
            PROMPT='%(!.%{$FG[116]%}.%{$FG[151]%}%n@)%m %{$FG[223]%}%(!.%1~.%~) %{$reset_color%}%_$(prompt_char)%{$reset_color%} $(emerge_info)'
            ;;
    esac
}

# Prompt init
setprompt
# }}}

# {{{ Output quote
if [ -f ~/.quote ]; then
    . ~/.quote
fi
# }}}

# {{{ Dircolors
#     - with rxvt-256color support
eval `dircolors -b "${HOME}/.dir_colors"`
# }}}
