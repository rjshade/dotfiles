#**************************************#
# Functions
#**************************************#

# refactor files
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
               -o -name CMakeLists.txt \) -print -exec sed -i 's/$2/$3/g' {} \;
  fi
}


#**************************************#
# VCS
#**************************************#

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

function autotmux ()
{
  if [[ $# -lt 1 ]]; then
    echo "Expected ssh destination in argument list."
    return 1;
  fi
  while true
  do
    ssh -t $1 tmux attach
    echo 'reconnecting... ctrl-c to cancel...'
    sleep 3
  done
}
