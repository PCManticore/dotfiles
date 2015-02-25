# -*- shell-script -*-
#
# atykhonov's init file for Z-SHELL 4.3.10 on Gentoo Linux.

# {{{ Make possible to use colors a little bit easier
. ${HOME}/.zsh/zsh-colors.sh
# }}}

# {{{ Source resty
. resty
# }}}

# {{{ Environment
export HOMEBIN="${HOME}/bin"
export PATH="/usr/lib/distcc/bin:${PATH}:${HOMEBIN}:/usr/local/bin:${HOME}/.cask/bin:${HOME}/go/bin"
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
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="C"
export PROJECTS_DIR="/str/development/projects"
export OO_PROJECT_DIR="${PROJECTS_DIR}/open-source/"
export GOPATH="${HOME}/go"
export DISTCC_HOSTS="gnt.home"
export REPORTTIME=5

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'
# }}}

# {{{ Dircolors
#     - with rxvt-256color support
eval `dircolors -b "${HOME}/.dir_colors"`
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
setopt BASH_AUTO_LIST # show all completions after two TABS
setopt NO_AUTO_MENU # don't cycle completions
setopt NO_ALWAYS_LAST_PROMPT # put the prompt always below the completions
# history management
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY

# Prompt requirements
setopt extended_glob prompt_subst
autoload colors zsh/terminfo

# Load zgit (https://github.com/jcorbin/zsh-git)
autoload -U zgitinit
zgitinit

# New style completion system
zmodload zsh/complist
autoload -Uz compinit && compinit
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
#  * Complete with colors (like in ls(1))
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#  * Don't complete the same twice for kill/diff.
zstyle ':completion:*:(kill|diff):*'       ignore-line yes

# Magic tab-completion trickery to pull hostnames from ~/.ssh/known_hosts:
hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
# hosts=(${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*})
zstyle ':completion:*:hosts' hosts $hosts

#
# The following makes possible to navigate through the last used args. For example:
#
# % echo a b c
# % echo 1 2 3
# % echo <M-.><M-.><M-m>
# % echo b
#
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word

# Sometimes it is useful to kill backward whole path (ignoring slash):
function _backward_kill_default_word() {
    WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e]' backward-kill-default-word

zle -C complete-menu menu-select _generic
_complete_menu() {
    setopt localoptions alwayslastprompt
    zle complete-menu
}
zle -N _complete_menu
bindkey '^F' _complete_menu
bindkey -M menuselect '^F' accept-and-infer-next-history
bindkey -M menuselect '/'  accept-and-infer-next-history
bindkey -M menuselect '^?' undo
bindkey -M menuselect ' ' accept-and-hold
bindkey -M menuselect '*' history-incremental-search-forward

# Keep the last line in all cases, allowing you to fix it:
function _recover_line_or_else() {
    if [[ -z $BUFFER && $CONTEXT = start && $zsh_eval_context = shfunc
                && -n $ZLE_LINE_ABORTED
                && $ZLE_LINE_ABORTED != $history[$((HISTCMD-1))] ]]; then
        LBUFFER+=$ZLE_LINE_ABORTED
        unset ZLE_LINE_ABORTED
    else
        zle .$WIDGET
    fi
}
zle -N up-line-or-history _recover_line_or_else
function _zle_line_finish() {
    ZLE_LINE_ABORTED=$BUFFER
}
zle -N zle-line-finish _zle_line_finish

# Quote stuff that looks like URLs automatically.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# This will make C-z on the command line resume vi again, so you can toggle between
# them easily. Even if you typed something already!
foreground-vi() {
    fg %vi
}
zle -N foreground-vi
bindkey '^Z' foreground-vi

# Persist the dirstack across sessions:
DIRSTACKSIZE=9
DIRSTACKFILE=~/.zdirs
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

# h -- grep history
h() {
    fc -l 0 -1 | sed -n "/${1:-.}/s/^ */!/p" | tail -n ${2:-10}
}
alias h=' h'

# pstop -- ps with top-like output
pstop() {
    ps -eo pid,user,pri,ni,vsz,rsz,stat,pcpu,pmem,time,comm --sort -pcpu |
    head "${@:--n 20}"
}

# sfetch (sftp|scp)://HOST/PATH [DEST] -- file by scp/sftp with resuming
sfetch() {
    curl -k -u $USER -C- ${2:--O}${2:+-o $2} $1
}

# d -- use g to find a definition (start of line, Go, Ocaml, Ruby)
d() {
    g -Hn '(^|\b(#define|func|let|let rec|class|module|def)\s+)'"$@" | sed 's/:/ /2'
}

# l -- find file names, recursively
l() {
    local p=$argv[-1]
    [[ -d $p ]] && { argv[-1]=(); } || p='.'
    find $p ! -type d | sed 's:^./::' | egrep "${@:-.}"
}

# Word completion in tmux (completion is based on the output)
_tmux_pane_words() {
    local expl
    local -a w
    if [[ -z "$TMUX_PANE" ]]; then
        _message "not running inside tmux!"
        return 1
    fi
    w=( ${(u)=$(tmux capture-pane \; show-buffer \; delete-buffer)} )
    _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
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
alias list-fonts="fc-list | cut -f2 -d: | sort -u"
alias ven=". venv/bin/activate"
alias shareclip="wgetpaste -x -C"
alias du="du -kh"
alias df="df -kh"
alias xtr="extract"
alias ec="emacsclient -a emacs -n "
alias ect="emacsclient -a emacs -t "
alias ping="ping -c 5"
alias psptree="ps auxwwwf"
alias upmem="ps -eo pmem,pcpu,rss,vsize,args | sort -k 1"
alias cp="cp -ia"
alias mv="mv -i"
alias rm="rm -i"
alias homegit="GIT_DIR=~/dotfiles/.git GIT_WORK_TREE=~ git"
alias df.="df -h | grep 'sda8\|sda7'"
alias ahss="ah s 10"
alias aht="ah t --"
alias ahc="ah gt --all"
alias chubuntu="mount /dev/sda6 /mnt/ubuntu; chroot /mnt/ubuntu"
# retrieve kernel config
alias kconfig="modprobe configs && zcat /proc/config.gz > kconfig"
# The bogomips line tells something about its performance
alias cpu-perfomance="cat /proc/cpuinfo | grep bogo"
# To see how enthusiastic the kernel is to use the swap. 60 is the default 100 means
# the kernel really likes to use the swap and 0 means the kernel avoids to use the
# swap.
alias swappiness="cat /proc/sys/vm/swappiness"

# Turn on/off shell divider
function sd() {
    if [[ $SHOW_DIVIDER -eq 1 ]]; then
        SHOW_DIVIDER=0
    else
        SHOW_DIVIDER=1
    fi
}

# The manpage zshall(1) contains everything, and this function will make it easy to
# search in (Try zman fc or zman HIST_IGNORE_SPACE!):
function zman() {
    PAGER="less -g -s '+/^       "$1"'" man zshall
}

# find file case insensitively
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

# Sometimes, very rare, there is a need to switch to the qwerty and back to dvorak
function asdf() { setxkbmap -model pc101 -layout dvorak }
function aoeu() { setxkbmap -model pc101 -layout us }

# Gentoo Linux specific
alias uses="vim /usr/portage/profiles/use.desc"
alias usesd="/usr/portage/profiles/use.local.desc"
alias etree="equery files --tree"
alias strip_ansii_colors="perl -pe 's/\e\[?.*?[\@-~]//g'"

# Start tmux server and attach to it.
function tm () {
    if [ $TERM != "screen" ]; then
        ( (tmux has-session -t remote && tmux attach-session -t remote) || (tmux new-session -s remote) ) && exit 0
        echo "tmux failed to start"
    fi
}

# Interactive mv for easier renaming of files with long names
imv() {
    local src dst
    for src; do
        [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
        dst=$src
        vared dst
        [[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst &&
        print -s mv -n $src $dst   # save to history, thus M-. works
    done
}

# make screenshot and view it
function scr() {
    screenshots_root="${HOME}/images/screenshots/"
    `rm ${screenshots_root}*.png`
    logfile="${screenshots_root}/screenshots.log"
    rm ${logfile}
    screenshot win
    while [ ! -f ${logfile} ]
    do
        sleep 1
    done
    sxiv `tail -n 1 ${logfile}`
}

# Handy Extract Program
function extract () {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tbz2 | *.tar.bz2) tar -xvjf  "$1"     ;;
            *.txz | *.tar.xz)   tar -xvJf  "$1"     ;;
            *.tgz | *.tar.gz)   tar -xvzf  "$1"     ;;
            *.tar | *.cbt)      tar -xvf   "$1"     ;;
            *.zip | *.cbz)      unzip      "$1"     ;;
            *.rar | *.cbr)      unrar x    "$1"     ;;
            *.arj)              unarj x    "$1"     ;;
            *.ace)              unace x    "$1"     ;;
            *.bz2)              bunzip2    "$1"     ;;
            *.xz)               unxz       "$1"     ;;
            *.gz)               gunzip     "$1"     ;;
            *.7z)               7z x       "$1"     ;;
            *.Z)                uncompress "$1"     ;;
            *.gpg)       gpg2 -d "$1" | tar -xvzf - ;;
            *) echo "Error: failed to extract $1" ;;
        esac
    else
        echo "Error: $1 is not a valid file for extraction"
    fi
}

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

# Switch projects
function switch_project() {
    base_dir="$1"
    proj=$(ls ${base_dir} | selecta)
    if [[ -n "${proj}" ]]; then
        proj=$(echo "${proj}" | strip_ansii_colors)
        cd ${base_dir}/${proj}
    fi
}

# Switch to the ghq project
function switch_ghq_project() {
    GHQ_PROJECT_DIR="${OO_PROJECT_DIR}/.ghq"
    proj=$(find $GHQ_PROJECT_DIR -maxdepth 3 -type d | selecta)
    if [[ -n "${proj}" ]]; then
        cd ${proj}
    fi
}
# cd to the common project dir
function cdp() { switch_project ${PROJECTS_DIR} }
# cd to the open source project dir
function cdop() { switch_project ${OO_PROJECT_DIR} }
# cd to the emacs projects
function cdep() { switch_project ${OO_PROJECT_DIR}/elisp/ }
# cd to the ghq github directory
function cdgh() { switch_ghq_project }
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

# Find the directory of the named Python module.
python_module_dir () {
    echo "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
    )"
}

# mess -- switch to current mess folder, creating it if needed
mess() {
    set +e
    DIR=~/mess/$(date +%Y/%V)
    [[ -d $DIR ]] || {
        mkdir -p $DIR
        ln -sfn $DIR ~/mess/current
        echo "Created $DIR."
    }
    cd ~/mess/current
}

# px -- verbose pgrep
px() {
    ps uwwp ${$(pgrep -d, "${(j:|:)@}"):?no matches}
}

# tracing -- run zsh function with tracing
tracing() {
    local f=$1; shift
    functions -t $f
    $f "$@"
    functions +t $f
}

# n -- quickest note taker
n() {
    [[ $# == 0 ]] && tail ~/.n || echo "$(date +'%F %R'): $*" >>~/.n
}
alias n=' noglob n'

# nf [-NUM] [COMMENTARY...] -- never forget last N commands
nf() {
    local n=-1
    [[ "$1" = -<-> ]] && n=$1 && shift
    fc -lnt ": %Y-%m-%d %H:%M ${*/\%/%%} ;" $n | tee -a .neverforget
}

# imgur - post image to imgur.com
imgur() {
    curl -F "image=@$1" -F key=b3625162d3418ac51a9ee805b1840452 \
        http://imgur.com/api/upload.xml |
    sed -ne 's|.*<original_image>\(.*\)</original_image>.*|\1|p'
}

# sprunge FILES... - paste to sprunge.us
sprunge() {
    local f
    if [ $# -lt 2 ]; then
        cat "$@"
    else
        for f; do
            echo "## $f"
            cat "$f"
            echo
        done
    fi | curl -sF 'sprunge=<-' http://sprunge.us | tr -d ' '
}

# unfmt - convert paragraphs into long lines
unfmt() {
    perl -00 -e '
    while(<>) {
      chomp;
      s/(?<=\S)\r?\n(?=\S)/ /g;
      s/\r?\n//g;
      print "$_\n";
    }
  '
}

# execute command with ah
function execute_with_ah {
    BUFFER="ah t -- $BUFFER"
    zle accept-line
}

zle -N execute_with_ah_widget execute_with_ah
bindkey '^[-' execute_with_ah_widget
# }}}

# {{{ Terminal and prompt
function precmd () {print -Pn "\e]0;%n@%m: %d\a"}

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
    if [ -f "${HOME}/emerge-info" ]; then
        cat "${HOME}/emerge-info"
    fi
}

function zgit_branch_except_home() {
    if [ $(pwd) != ${HOME} ]; then
        echo $(zgit_branch)
    fi
}

function shell_divider() {
    if [[ $SHOW_DIVIDER -eq 1 ]]; then
        echo $(repeat $COLUMNS printf '-')
    fi
}

function setgitprompt() {
    # zgitinit and prompt_wunjo_setup must be somewhere in your $fpath, see README for more.
    setopt promptsubst

    # Load the prompt theme system
    autoload -U promptinit
    promptinit

    # Use the wunjo prompt theme
    prompt wunjo
}

function setprompt () {
    if [[ "${terminfo[colors]}" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_"${color}"="%{${terminfo[bold]}$fg[${(L)color}]%}"
        eval PR_LIGHT_"${color}"="%{$fg[${(L)color}]%}"
    done

    nbsp=$'\u00A0'
    bindkey -s $nbsp '^u'

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
            #
            # The last character (I mean nbsp) is a Unicode non-breaking space
            # (U+00A0). Which will look like a plain space and behave like
            # one. Except that we can bindkey it to clear the input buffer:
            #
            # $ bindkey -s $nbsp '^u'
            #
            # As result you have the benefit that you can copy the whole line in your
            # terminal emulator and just paste it to run it again.
            #
            PROMPT=''
            PROMPT+='%{$FG[000]%}$(shell_divider)%{$reset_color%}'
            PROMPT+='%(!.%{$FG[116]%}.%{$FG[151]%}%n@)%m '
            PROMPT+='%{$FG[223]%}%(!.%1~.%~) %{$reset%}'
            PROMPT+='%_$(prompt_char)%{$reset_color%}$nbsp'
            PROMPT+='$(emerge_info)'

            RPROMPT='$(zgit_branch_except_home)'
            ;;
    esac
}

# Prompt init
setprompt
# }}}

# {{{ On start up
## Output quote
if [ -f ~/.quote ]; then
    . ~/.quote
fi
## if switching to the root then go to HOME directory
cd ${HOME}
# }}}
