# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/home/mandrews/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

my-backward-delete-word () {
   local WORDCHARS='~!#$%^&*(){}[]<>?+;'
   zle backward-delete-word
}
zle -N my-backward-delete-word

bindkey    '\e^?' my-backward-delete-word

alias grep='grep --color=auto '
alias fgrep='fgrep --color=auto '
alias egrep='egrep --color=auto '

export EDITOR=nvim

function ls() {
    /usr/bin/env ls -lASh --color "$@"
}

alias sudo='sudo '
alias ns='netstat -lnutp'
alias ssh='TERM=xterm-256color \ssh '
alias g='git'
alias tmux='tmux -2 '
alias vim='nvim '
alias forget='ssh-keygen -f "/home/mandrews/.ssh/known_hosts" -R '

setopt histignorespace

touch ~/.localrc
source ~/.localrc

setopt prompt_subst # enable command substition in prompt

# Set RHS prompt for git repositories
GIT_PROMPT_PREFIX="["
GIT_PROMPT_SUFFIX="]"
GIT_PROMPT_AHEAD="+NUM"
GIT_PROMPT_BEHIND="-NUM"
GIT_PROMPT_UNTRACKED="%%"
GIT_PROMPT_MODIFIED="*"
GIT_PROMPT_STAGED="+"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function parse_git_detached() {
    if ! git symbolic-ref HEAD >/dev/null 2>&1; then
        echo "($1)"
    else
        echo "$1"
    fi
}

# Show different symbols as appropriate for various Git repository states
function parse_git_state() {
    # Compose this value via multiple conditional appends.
    local GIT_STATE=""

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        if [[ -n $GIT_STATE ]]; then
            GIT_STATE="$GIT_STATE "
        fi
        GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
    fi

    local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ]; then
        if test -r $GIT_DIR/MERGE_HEAD; then
            GIT_ACTION="MERGE"
        elif test -d $GIT_DIR/rebase-apply -o -d $GIT_DIR/rebase-merge; then
            GIT_ACTION="REBASE"
        fi

        if [[ -n $GIT_ACTION ]]; then
            GIT_STATE="$GIT_STATE "
        fi
        GIT_STATE=$GIT_STATE$GIT_ACTION
    fi

    GIT_DIFF=''
    if ! git diff --quiet 2> /dev/null; then
        GIT_DIFF=$GIT_DIFF$GIT_PROMPT_MODIFIED
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_DIFF=$GIT_DIFF$GIT_PROMPT_STAGED
    fi

    if [[ -n $(git ls-files --other --exclude-standard :/ 2> /dev/null) ]]; then
        GIT_DIFF=$GIT_DIFF$GIT_PROMPT_UNTRACKED
    fi

    if [[ -n $GIT_DIFF ]]; then
        GIT_STATE="$GIT_STATE "
    fi
    GIT_STATE="$GIT_STATE$GIT_DIFF"

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_STATE"
    fi
}

# If inside a Git repository, print its branch and state
RPR_SHOW_GIT=true # Set to false to disable git status in rhs prompt
function git_prompt_string() {
    if [[ "${RPR_SHOW_GIT}" == "true" ]]; then
        local git_where="$(parse_git_branch)"
        local git_where="$(parse_git_detached "${git_where#(refs/heads/|tags/)}")"
        local git_state="$(parse_git_state)"
        [ -n "$git_where" ] && echo "%F{21}%B$GIT_PROMPT_PREFIX${git_where}${git_state}$GIT_PROMPT_SUFFIX%b%f"
    fi
}

function extract_envnames () {
    echo -n "$1" | perl -e '
my $prompt = join("", <STDIN>);
@matches = $prompt =~ /(?:\G(?!\A)|^)[(](\S+)[)]\s*/g;

foreach (@matches) {
    print "$_\n";
}
'
}

ENVNAMES=($(extract_envnames "$PS1"))
PROMPT3='%k╰%F{2}%n%F{6}@%F{15}%M%f %F{12}%1d %F{10}$%f %F{31}%F{0}'
PROMPT="$PROMPT3"
RPROMPT=''
zle_highlight=(default:bg=31,fg=black)

zle-line-init() { POSTDISPLAY=' 
' }
zle -N zle-line-init
zle-line-finish() { POSTDISPLAY=' ' }
zle -N zle-line-finish

ASYNC_PROC=0
function preexec() {
    echo -e "\e[m\e[38;5;235m -- $(date "+%T.%N")\e[m"
}

function precmd() {
    e=$?
    ENVNAMES=("${ENVNAMES[@]}" $(extract_envnames "$PS1"))
    ENVPREFIX=""
    for name in "${ENVNAMES[@]}"; do
        ENVPREFIX="$ENVPREFIX(%F{240}$name%f) "
    done
    if [ -z "$ENVPREFIX" ]; then
        ENVPREFIX="(%F{240}noenv%f) "
    fi
    if [ "$e" = 0 ]; then
        RPROMPT="%k%F{238}(0)%f"
    else
        RPROMPT="%k%F{52}($e)%f"
    fi
    PROMPT1="%k%F{235} -- $(date "+%T.%N")%f"
    PROMPT2="%k╭${ENVPREFIX}"
    PROMPT="$PROMPT1
$PROMPT2
$PROMPT3"

    function async() {
        # save to temp file
        printf "%s" "$(git_prompt_string)" > "/tmp/zsh_prompt_$$"

        # signal parent
        kill -s USR1 $$
    }

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    PROMPT2="$PROMPT2$(cat /tmp/zsh_prompt_$$)"
    PROMPT="$PROMPT1
$PROMPT2
$PROMPT3"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}

