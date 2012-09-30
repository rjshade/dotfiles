# ZSH environment
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# this can be used to toggle platform specific aliases (e.g. ls -G for colors on OSX)
# ------------------------------------------------------------------------------
platform='unknown'
unamestr=$(uname)

if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='osx'
fi


#--- Autojump
if [[ $platform == 'osx' ]]; then
  if [[ -f `brew --prefix`/etc/autojump ]]; then
    . `brew --prefix`/etc/autojump
  fi
fi

# ------------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# ------------------------------------------------------------------------------
autoload -U zutil
autoload -U complist
autoload -U compinit && compinit
autoload -U colors && colors
autoload -Uz vcs_info
autoload -U promptinit && promptinit

# ------------------------------------------------------------------------------
export TERM=xterm-256color
#if [[ $platform == 'osx' ]]; then
#    export TERM=rxvt-256color
#else
#    export TERM=rxvt-unicode-256color
#fi
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# ruby rvm
[[ -s "/Users/rjs/.rvm/scripts/rvm" ]] && source "/Users/rjs/.rvm/scripts/rvm"


# ------------------------------------------------------------------------------
export EDITOR=vim   # use a sensible editor...
export VISUAL=vim
bindkey -e          # but still use emacs bindings on CLI

# ------------------------------------------------------------------------------
# up/down arrows search through history like MATLAB
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward


# ------------------------------------------------------------------------------
# Paths
# ------------------------------------------------------------------------------

# homebrew gets priority
export PATH=/usr/local/sbin:/usr/local/bin:$PATH

# homebrew python
export PATH=/usr/local/share/python:$PATH

# fix for cgoban3
export _JAVA_AWT_WM_NONREPARENTING=1

# path
export PATH=~/bin:~/build/bin:$PATH

# node package manager
export PATH=/usr/local/share/npm/bin/:$PATH

# Amazon EC2
export JAVA_HOME="$(/usr/libexec/java_home)"
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
export EC2_AMITOOL_HOME="/usr/local/Cellar/ec2-ami-tools/1.3-45758/jars"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.5.2.5/jars"

# ------------------------------------------------------------------------------
# ZSH options
# ------------------------------------------------------------------------------

# history:
setopt append_history       # append history list to the history file (important for multiple parallel zsh sessions!)
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
setopt auto_pushd           # make cd push the old directory onto the directory stack.
setopt nonomatch            # try to avoid the 'zsh: no matches found...'
setopt nobeep               # avoid "beep"ing
setopt pushd_ignore_dups    # don't push the same dir twice.
setopt noglobdots           # * shouldn't match dotfiles. ever.

setopt no_clobber           # Keep echo "station" > station from clobbering station

#################################################################
# Miscellaneous options blindly copied/pasted from somewhere...

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

## TODO: This could use some additional information
if [[ "$NOMENU" -eq 0 ]] ; then
    # if there are more than 5 options allow selecting from a menu
    zstyle ':completion:*'               menu select=5
else
    # don't use any menus at all
    setopt no_auto_menu
fi

# some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
bindkey ' '   magic-space    # also do history expansion on space


