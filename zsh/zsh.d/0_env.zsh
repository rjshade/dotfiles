# ZSH environment - Optimized
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Platform detection
# ------------------------------------------------------------------------------
platform='unknown'
unamestr=$(uname)

if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
  platform='osx'
fi

# ------------------------------------------------------------------------------
# History settings
# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt extendedhistory # timestamp history entries

# ------------------------------------------------------------------------------
# Load ZSH modules
# ------------------------------------------------------------------------------
autoload -U zutil
autoload -U complist
autoload -U compinit && compinit -C  # -C skips security check for faster startup
autoload -U colors && colors
autoload -Uz vcs_info
autoload -U promptinit && promptinit

# ------------------------------------------------------------------------------
# Terminal settings
# ------------------------------------------------------------------------------
if [[ $platform == 'osx' ]]; then
  export TERM=rxvt-256color
else
  export TERM=rxvt-unicode-256color
fi

# for tmux: export 256color
[ -n "$TMUX" ] && export TERM=screen-256color

# ------------------------------------------------------------------------------
# Editor settings
# ------------------------------------------------------------------------------
export EDITOR=vim
export VISUAL=vim
bindkey -e  # emacs bindings on CLI

# ------------------------------------------------------------------------------
# Key bindings
# ------------------------------------------------------------------------------

# up/down arrows search through history like MATLAB
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------
# home directory scripts
export PATH=~/bin:$PATH

# python/pip path
export PATH=~/.local/bin:~/Library/Python/3.6/bin:$PATH

# node
export PATH="/usr/local/opt/node@20/bin:$PATH"

# ------------------------------------------------------------------------------
# ZSH options
# ------------------------------------------------------------------------------
setopt append_history       # Append to history file at end of session
setopt hist_ignore_all_dups # Do not store duplicate entries in history (even if non consecutive)
setopt histignorealldups    # If  a  new  command  line being added to the history
                            # list duplicates an older one, the older command is removed from the list
setopt auto_cd              # if a command is issued that cant be executed as a normal command,
                            # and the command is the name of a directory, perform the cd command to that directory
setopt extended_glob        # in order to use #, ~ and ^ for filename generation
                            # grep word *~(*.gz|*.bz|*.bz2|*.zip|*.Z) ->
                            # -> searches for word not in compressed files
                            # don't forget to quote '^', '~' and '#'!
setopt longlistjobs         # display PID when suspending processes as well
setopt notify               # report the status of backgrounds jobs immediately
setopt hash_list_all        # Whenever a command completion is attempted, make sure \
                            # the entire command path is hashed first.
setopt completeinword       # not just at the end
setopt nohup                # and don't kill them, either
setopt nonomatch            # try to avoid the 'zsh: no matches found...'
setopt nobeep               # avoid "beep"ing
setopt noglobdots           # * shouldn't match dotfiles. ever.
setopt no_clobber           # Keep echo "station" > station from clobbering station

# ------------------------------------------------------------------------------
# Completion options
# ------------------------------------------------------------------------------
#
# coloured tab completion options
highlights='${PREFIX:+=(#bi)($PREFIX:t)(?)*==$color[red]=$color[green];$color[bold]}':${(s.:.)LS_COLORS}}
zstyle -e ':completion:*' list-colors 'reply=( "'$highlights'" )'
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

unset highlights

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# format on completion
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

# complete 'cd -<tab>' with menu
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'        tag-order all-expansions
zstyle ':completion:*:history-words'   list false

# activate menu
zstyle ':completion:*:history-words'   menu yes

# ignore duplicate entries
zstyle ':completion:*:history-words'   remove-all-dups yes
zstyle ':completion:*:history-words'   stop yes

# match uppercase from lowercase
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

# separate matches into groups
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''

zstyle ':completion:*:messages'        format '%d'
zstyle ':completion:*:options'         auto-description '%d'

# describe options in full
zstyle ':completion:*:options'         description 'yes'

# on processes completion complete all user processes
zstyle ':completion:*:processes'       command 'ps -au$USER'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# provide verbose completion information
zstyle ':completion:*'                 verbose true

# recent (as of Dec 2007) zsh versions are able to provide descriptions
# for commands (read: 1st word in the line) that it will list for the user
# to choose from. The following disables that, because it's not exactly fast.
zstyle ':completion:*:-command-:*:'    verbose false

# set format for warnings
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'          prompt 'correct to: %e'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# provide .. as a completion
zstyle ':completion:*' special-dirs ..

# what's causing the completion delay?
zstyle ":completion:*" show-completer true

# if there are more than 5 options allow selecting from a menu
zstyle ':completion:*'               menu select=5

bindkey ' '   magic-space    # also do history expansion on space

# Syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fuzzyfinder defaults
FZF_DEFAULT_OPTS='--height 40% --reverse'
FZF_CTRL_T_OPTS='--review "head -n 100 {}" --preview-window right'
FZF_DEFAULT_COMMAND='rg --hidden --files ""'
FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [[ "$platform" == 'osx' ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
