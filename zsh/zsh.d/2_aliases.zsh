# open this file for editing
alias ea='$EDITOR $FILE_ALIASES && source $FILE_ALIASES'

# nice listings
if [[ $platform == 'linux' ]]; then
    alias ls='ls --color=auto'
elif [[ $platform == 'osx' ]]; then
    alias ls='ls -G'
fi
alias l='ls -lh'

# grep
alias grep='grep --color=always'
alias gi='grep -RIinF'

# fat fingers...
alias cd..='cd ..'
alias maek='make'
alias mkea='make'
alias mkae='make'

# vim dependency!
alias :q='exit'
alias :wq='exit'
alias v='vim'
alias vi='vim'
alias :e='vim'

# run bc with mathlib
alias calc='bc -l'

# list top-10 most used commands
alias most_used="history 1 | awk '{a[\$2]++}END{for(i in a){print a[i] \" \" i}}' | sort -rn | head"

# play Go
alias playGo='javaws http://files.gokgs.com/javaBin/cgoban.jnlp'

# open a file browser in PWD
if [[ $platform == 'osx' ]]; then
  alias o='open .'
elif [[ $platform == 'linux' ]]; then
  alias o='nautilus . 1&> /dev/null'
fi

alias tup='scp ~/Downloads/*torrent torrentHost:~/torrents/ && rm ~/Downloads/*torrent'

# Git
alias g='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gb='git branch'
alias gco='git checkout'

# size of files/directories at depth 0, sorted by size in kb
alias dus='du -ks ./* | sort -n'

# secrets that we may or may not have such as API keys
if [ -f ~/.secrets.sh ]; then
  source ~/.secrets.sh;
fi

# refactor C++ files
function refactor()
{
  if [ $# != 3 ]; then
    echo "Usage: refactor /path/to/files/ text_to_find text_to_replace"
  else
    echo "Refactoring: $2 -> $3, in the following files:"
    find $1 \( -iname \*.h \
               -o -iname \*.cpp \
               -o -iname \*.cc \
               -o -iname \*.hh \
               -o -name CMakeLists.txt \) -print -exec sed -i "s/$2/$3/g" {} \;
  fi
}

# use ex to extract compressed files
ex () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar e $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.xz)        tar xvJf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

# ficd = find in current directory
# e.g. ficd PartOfFileName
function ficd()
{
  find . -iname "*$1*"
}

function rsync_backup
{
  echo -e 'rsync -auh --progress --stats --delete SOURCE DESTINATION'
}

# tmux
alias tmux="TERM=xterm-256color /usr/bin/tmux"

# Traverses upwards through directory tree until it finds a matching directory.
# If a matching directory is found, change to that directory, otherwise print error.
# e.g. $ find_parent_dir .git
function find_parent_dir () {
  if [[ $# != 1 ]]; then
    echo "usage: $0 directory_name"
    return 1
  fi

  start_dir="$PWD"
  search_dir="$1"

  while [[ "$PWD" != / ]]; do
    # Does the directory exist and is it a directory (not a file)?
    if [[ -e $search_dir && -d $search_dir ]]; then
      cd "$1"
      return 0
    fi
    cd ..
  done

  # Print error and return to original dir.
  echo "Could not find parent directory $search_dir"
  cd $start_dir
  return 1
}
