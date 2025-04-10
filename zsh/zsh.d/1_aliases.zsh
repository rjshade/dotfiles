# open this file for editing
ALIASES_FILE=$0:A
alias ea='$EDITOR $ALIASES_FILE && source $ALIASES_FILE'

# nice listings
if [[ $platform == 'linux' ]]; then
    alias ls='ls --color=auto'
elif [[ $platform == 'osx' ]]; then
    alias ls='ls -G'
fi
alias l='ls -lh'

# grep
alias grep='grep --color=auto'
alias gi='grep -RIinF'

# fat fingers...
alias cd..='cd ..'
alias maek='make'
alias mkea='make'
alias mkae='make'

# vim dependency!
alias :q='exit'
alias :wq='exit'
if command -v nvim > /dev/null; then
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
else
  alias v='vim'
  alias vi='vim'
fi

# open a file browser in PWD
if [[ $platform == 'osx' ]]; then
  alias o='open .'
elif [[ $platform == 'linux' ]]; then
  # The &! is a zsh-specific instruction to background *and* disown
  alias o='nautilus . &> /dev/null &!'
fi

# Git.
# Prefer to have aliases here rather than gitconfig, otherwise all aliases must
# be prefixed with "git " (or "g ") and the repetitive typing of spaces is
# annoying.
alias g='git status'
alias gl='git log --pretty=format:"%C(yellow)%h %C(green)%>(12)%ad %C(blue)%<(10)%an%C(red)%d %C(reset)%s" --date=relative --graph'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
# List files changed between current branch and main branch.
alias gm='git diff --name-only main'
alias gmd='git diff main -- '

# Rename something in C/C++ files.
function rename_c() {
  if [ $# != 3 ]; then
    echo "Usage: rename_c /path/to/files/ text_to_find text_to_replace"
  else
    echo "Renaming: $2 -> $3, in the following files:"
    find $1 \(    -iname \*.h   \
               -o -iname \*.cpp \
               -o -iname \*.cc  \
               -o -iname \*.c   \
               -o -iname \*.hh  \
            \) -print -exec sed -i "s/$2/$3/g" {} \;
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

function rsync_backup {
  echo -e 'rsync -auh --progress --stats --delete SOURCE DESTINATION'
}

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
      return 0
    fi
    cd ..
  done

  # Print error and return to original dir.
  echo "Could not find parent directory $search_dir"
  cd $start_dir
  return 1
}

# Navigate to root of git repo.
alias gr='find_parent_dir .git'

# Creates a Github PR from command line.
# Copies url + title to clipboard on success.
function ghpr() {
  # Push to remote.
  # Stop-gap until `gh` supports this natively without prompting.
  # https://github.com/cli/cli/issues/1718#issuecomment-748292216
  git push -u origin HEAD
  if [ $? -ne 0 ]; then
    echo "\nFailed to push remote branch!"
    return
  fi

  # Create the PR.
  gh pr create --fill
  if [ $? -ne 0 ]; then
    echo "\nFailed to create PR!"
    return
  fi

  # Enable auto-merge.
  gh pr merge --squash --auto --delete-branch
  if [ $? -ne 0 ]; then
    echo "\nFailed to enable auto-merge!"
    return
  fi

  # Print (and copy) string for pasting into Slack pull requests channel.
  STATUS=$(gh pr view)
  URL=$(echo ${STATUS} | grep 'url:' | cut -f2)
  TITLE=$(echo ${STATUS} | grep 'title:' | cut -f2)
  OUTPUT="${URL} | ${TITLE}"
  echo "\n\nSuccess. Copied to clipboard:"
  echo ${OUTPUT} && echo -n ${OUTPUT} | pbcopy
}

alias am='gh pr checks --watch && gh pr merge --delete-branch --squash'
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
