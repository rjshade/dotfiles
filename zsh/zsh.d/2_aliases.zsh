# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

# open this file for editing
alias ea='$EDITOR $FILE_ALIASES && source $FILE_ALIASES'


# DPhil
# ------------------------------------------------------------------------------
alias t='cd $DIR_THESIS_SVN'
alias tbld='cd $DIR_THESIS_SVN && make'
alias tview='tbld && open thesis.pdf'

alias tcom='cd $DIR_THESIS_SVN && svn add * --depth infinity --force && svn ci -m "auto-commit" && cp $DIR_THESIS_SVN/thesis.pdf $DIR_THESIS_BAK'
alias tbib='cd $DIR_THESIS_SVN && bibtex thesis'


# Coding
# ------------------------------------------------------------------------------

# find all cpp,h,c files in current tree
alias find_cpp_src='find . \( -iname \*cpp -o -iname \*h -o -iname \*.c \)'

# CLI
# ------------------------------------------------------------------------------

# nice listings
if [[ $platform == 'linux' ]]; then
    alias ls='ls --color=auto'
elif [[ $platform == 'osx' ]]; then
    alias ls='ls -G'
fi
alias l='ls -lh'

# use gnu du/sort to display human readable sorted sizes
# (from coreutils in homebrew)
alias ds='gdu -sh * | gsort -h'

alias df='df -h'

alias la='ls -al'

# list most recently modified at bottom
alias lt='l -tr'

# colorize tree
alias tree='tree -C'

# grep 
alias grep='grep --color=always'
alias gi='grep -RIinF'

# ack > grep
alias a='ack'

# fat fingers...
alias cd..='cd ..'
alias maek='make'
alias mkea='make'
alias mkae='make'

alias ...='cd ../../'
alias ....='cd ../../../'

# make and enter a directory
function cmd() {
  mkdir -p $1
  cd $1
}

# vim dependency!
alias :q='exit'
alias :wq='exit'
alias v='vim'
alias vi='vim'
alias :e='vim'

# run bc with mathlib
alias calc='bc -l'

# list top-10 most used commands
alias most="history 1 | awk '{a[\$2]++}END{for(i in a){print a[i] \" \" i}}' | sort -rn | head"


# Network
# ------------------------------------------------------------------------------
alias etf='ssh fred'
alias ets='ssh shadow'

# start simple web server serving current dir on port 8000 (ctrl-c kills it)
alias websharedir='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'

alias myip='curl icanhazip.com'



# Compilation
# ------------------------------------------------------------------------------
if [[ $platform == 'osx' ]]; then
    NUM_CORES=`sysctl -n hw.ncpu`
else
    NUM_CORES=`grep processor /proc/cpuinfo | tail -n 1 | awk '{ print $3 }'`
    # cores are 0 indexed in /proc/cpuinfo
    NUM_CORES=`expr $NUM_CORES + 1`
fi

MAKE_CORES=`expr $NUM_CORES + 1`
alias make='make -j$MAKE_CORES'
alias m='make'

alias mj='make -j1' #single core compile

alias mcm='make clean && make'

alias cm='ccmake ./'
alias cmg='cmake-gui ./ &'



# MRG
# ------------------------------------------------------------------------------
alias moos='cd $DIR_MOOS && l'
alias mrg='cd $DIR_MRG && l && git status'
alias mb='cd $DIR_MRG/bld && make && cd -'
alias mvl='cd $DIR_MVL && l'
alias mrgb='cd $DIR_MRGBASE && l'

#runs cmake with some MRG sensible defaults
alias ccm='ccmake\
            -D EXECUTABLE_OUTPUT_PATH:string=$DIR_MY_BIN \
            -D LIBRARY_OUTPUT_PATH:string=$DIR_MY_LIB \
            -D MVL_DIR:string=$DIR_MVL \
            -D MOOS_DIR:string=$DIR_MOOS \
            -D GLConsole_DIR:string=$DIR_GLCONSOLE' \
            -D CMAKE_INSTALL_PREFIX:string=$DIR_MY_BUILD

alias lds='cd $DIR_MRG/Libraries/libDenseStereo && l'

alias dv='cd $DIR_MRG/Devel/rjs/ && l && git status'
alias dva='cd $DIR_MRG/Devel/rjs/Apps/ && l && git status'
alias dvl='cd $DIR_MRG/Devel/rjs/Libs/ && l && git status'

# dphil dir
alias dp='cd $DIR_DPHIL && l'

# icra 2011
alias icra='cd $DIR_ICRA2011/ && ls -l'
alias icra_bld='icra && pdflatex -output-directory ./bld/ ./rjs_pmn_icra2011.tex && bibtex ./bld/rjs_pmn_icra2011 && cp bld/rjs_pmn_icra2011.pdf ./ && evince ./rjs_pmn_icra2011.pdf &'

# set up tunnel to MRG Wiki
alias xerxestunnel='echo -e "Opening SSH tunnel to xerxes.robots.ox.ac.uk, on local port 8827...\n" && ssh -L 8827:xerxes.robots.ox.ac.uk:80 login2.robots.ox.ac.uk'

#tunnel to shadow
alias shadowtunnel='echo -e "Opening SSH tunnel to shadow.robots.ox.ac.uk, on local port 8826...\n" && ssh -L 8826:shadow.robots.ox.ac.uk:2626 login2.robots.ox.ac.uk'

# Europa robot while in Begbroke
alias europa='ssh -X mrg@europa'





# Misc
# ------------------------------------------------------------------------------

# play Go
alias playGo='javaws http://files.gokgs.com/javaBin/cgoban.jnlp'


# Linux specific
# ------------------------------------------------------------------------------
if [[ $platform == 'linux' ]]; then
    alias startx='ssh-agent startx' #ssh-agent wraps X
    alias music='ncmpcpp'
    alias vol='alsamixer'
    alias t='(thunar&) >/dev/null 2>&1'
    alias kp='(keepassx &) > /dev/null 2>&1'
    alias record_desktop='xvidcap --quality 80 --gui no --auto --cap_geometry 1680x1050 --rescale 50 --file test.mpg'
fi


# OSX specific
if [[ $platform == 'osx' ]]; then
    alias o='open .'
fi


# Torrents
# ------------------------------------------------------------------------------

#alias tup='scp ~/Downloads/*torrent torrentHost:~/private/rtorrent/watch/ && rm ~/Downloads/*torrent'
#alias tdo='rsync -auh --progress --stats --delete torrentHost:~/private/rtorrent/data/ ~/sync'
#alias tdo_300='rsync -auh --bwlimit=300 --progress --stats --delete torrentHost:~/private/rtorrent/data/ ~/sync'
#alias tdo_500='rsync -auh --bwlimit=500 --progress --stats --delete torrentHost:~/private/rtorrent/data/ ~/sync'
#alias tsh='ssh torrentHost'

alias tup='mv ~/Downloads/*torrent ~/torrents'

# VCS (Git, Subversion, etc.)
# ------------------------------------------------------------------------------

# Git
# -------------------------------------
alias g='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gb='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcm='git commit -m'
alias gl=' git log --decorate --graph --date=short'
alias gpgph='git push && git push heroku'

if [[ $platform == 'osx' ]]; then
    alias gitgui='/Applications/GitX.app/Contents/MacOS/GitX'
else
    alias gitgui='gitg'
fi

alias gpull='git pull'
alias gpush='git push'

alias spull='git svn fetch && git svn rebase'
alias spush='git svn rebase && git svn dcommit'

# SVN
# -------------------------------------

#display modified, missing, deleted, added etc. svn items - *not* unknown
alias svnmod='svn status | grep --color=always "^[ACDRM!]"'


# MplayerX
# -------------------------------------
alias mpx='/Applications/MPlayerX.app/Contents/MacOS/MPlayerX'
alias mplayer='/Applications/MPlayerX.app/Contents/MacOS/MPlayerX'

# Network
# -------------------------------------
alias pg='ping google.com'


# File system
# -------------------------------------
# size of files/directories at depth 0, sorted by size in kb
alias dus='du -ks ./* | sort -n'


# Rails
# -------------------------------------
alias cuke='cucumber --drb'
alias be='bundle exec'

alias rc='rails console'


# Import new music using Beets (http://beets.radbox.org/)
BEETS_IMPORT=~/Music/.beets_import
alias bim='if [ ! -d $BEETS_IMPORT ]; then mkdir $BEETS_IMPORT; fi; beet import "$@"'
function itunes_im() {
  ITUNES_IMPORT=~/Music/Automatically\ Add\ to\ iTunes.localized
  rm -rf $ITUNES_IMPORT/*
  mv $BEETS_IMPORT/* $ITUNES_IMPORT
}

## secrets that we may or may not have such as API keys
if [ -f ~/.secrets.sh ]; then
  source ~/.secrets.sh;
fi

function c {
  cd "$@"
  ls -l
  local new_path="$(pwd)"
  echo -e "\\033[31m${new_path}\\033[0m"
}