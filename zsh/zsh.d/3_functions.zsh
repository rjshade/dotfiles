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
        find $1 \( -iname \*.h -o -iname \*.cpp -o -iname \*.cc -o -iname \*.hh -o -name CMakeLists.txt \) -print -exec sed -i '' -e "s/$2/$3/g" {} \;
    fi
}


#**************************************#
# VCS 
#**************************************#
function sup ()
{
    # check if first argument is NULL and run full update if so
    if [ -z $1 ] ; then
        CWD=`pwd`
        vcs_update $DIR_MOOS
        vcs_update $DIR_MRG
        vcs_update $DIR_MRGBASE
        vcs_update $DIR_MRGSIM
        echo "Ctags..." 
        gen_cpp_ctags moos $DIR_MOOS
        gen_cpp_ctags mrg $DIR_MRG
        cd $CWD
    else 
        # if first argument is a directory then svn up there
        if [ -d $1 ] ; then
            vcs_update $1
        else
            echo usage: $0 directory
        fi
    fi
}

function vcs_update()
{
    cd $1
    zstyle ':vcs_info:*' formats '%s'; vcs_info; vcs=$vcs_info_msg_0_
    case "$vcs" in
        'git-svn')
            git_svn_update $1
            ;;
        'svn')
            svn_update $1
            ;;
        'git')
            git_update $1
            ;;
    esac 
}

function git_update()
{
    # changes to the specified git repository which is tracking
    # an external svn branch
    # updates to HEAD, prints new log messages
    
    cd $1
    
    #note that 'echo -e' enables use of backslash escapes in string
    echo -e '\n///////////////////////////////////////////////////////////////////////'
    echo 'Updating Git repository in directory:' 
    echo $1
    echo -e '///////////////////////////////////////////////////////////////////////\n'
    
    git pull
    
    git log 
}

function git_svn_update()
{
    # changes to the specified git repository which is tracking
    # an external svn branch
    # updates to HEAD, prints new log messages
    
    cd $1
    
    #note that 'echo -e' enables use of backslash escapes in string
    echo -e '\n///////////////////////////////////////////////////////////////////////'
    echo 'Updating Git+SVN repository in directory:' 
    echo $1
    echo -e '///////////////////////////////////////////////////////////////////////\n'
    
    PreRev=`git svn info | awk '/Revision/{print $2}'`
    
    git svn rebase
    
    PostRev=`git svn info | awk '/Revision/{print $2}'`
    
    git svn log -r $PreRev:$PostRev
}

function svn_update()
{
    # changes to the specified svn repository
    # updates to HEAD, prints new log messages
    
    cd $1
    
    #note that 'echo -e' enables use of backslash escapes in string
    echo -e '\n///////////////////////////////////////////////////////////////////////'
    echo 'Updating SVN repository in local directory (ignoring externals):' 
    echo $1
    echo -e '///////////////////////////////////////////////////////////////////////\n'
    
    PreRev=`svn info | awk '/Revision/{print $2}'`
    
    svn up --ignore-externals
    
    PostRev=`svn info | awk '/Revision/{print $2}'`
    
    svn log -r $PreRev:$PostRev
}



# if given a path then svn up in that directory and
# display logs - otherwise we do an update of moos/mrg/pymrg and ctags

gen_cpp_ctags()
{
    CTAG_DIR="$HOME/.ctags"
    CTAG_FILE="$CTAG_DIR/$1"
    touch CTAG_FILE

    SRC_DIR=$2

    ctags -R --c++-kinds=+p --exclude=*.tex --fields=+iaS --extra=+q -f $CTAG_FILE $SRC_DIR
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
# Usage: smartcompress <file> (<type>)
#f5# Smart archive creator
comp() {
    if [[ -n $2 ]] ; then
        case $2 in
            tgz | tar.gz)   tar -zcvf$1.$2 $1 ;;
            tbz2 | tar.bz2) tar -jcvf$1.$2 $1 ;;
            tar.Z)          tar -Zcvf$1.$2 $1 ;;
            tar)            tar -cvf$1.$2  $1 ;;
            gz | gzip)      gzip           $1 ;;
            bz2 | bzip2)    bzip2          $1 ;;
            *)
                echo "Error: $2 is not a valid compression type"
                ;;
        esac
    else
        comp $1 tar.gz
    fi
}
# Usage: show-archive <archive>
#f5# List an archive's content
lsarc() {
    if [[ -f $1 ]] ; then
        case $1 in
            *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
            *.tar)         tar -tf $1 ;;
            *.tgz)         tar -ztf $1 ;;
            *.zip)         unzip -l $1 ;;
            *.bz2)         bzless $1 ;;
            *.deb)         dpkg-deb --fsys-tarfile $1 | tar -tf - -- ;;
            *)             echo "'$1' Error. Please go away" ;;
        esac
    else
        echo "'$1' is not a valid archive"
    fi
}

# cd and ls - together at last
function cl () {
   if [ $# = 0 ]; then
      cd && ls
   else
    cd "$*" && ls
   fi
}

# open .h and .cpp files in vim with vertical split
function vs()
{
    if [ $# = 0 ]; then
        vi
    else
        vi -O $1h $1cpp
    fi
}

# ficd = find in current directory
# e.g. ficd PartOfFileName
function ficd()
{
    find . -iname "*$1*"
}

# open google search in browser
google() 
{
    python -c "import sys, webbrowser, urllib;   webbrowser.open('http://www.google.com/search?' + urllib.urlencode({'q': ' '.join(sys.argv[1:]) }))" $@
}

# the have function checks for existence of executable
have()
{
    unset -v have
    type $1 >/dev/null 2>&1 && have="yes"
}

# check if we have apt-get installed and set aliases appropriately
function _agi()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    COMPREPLY=( $( apt-cache pkgnames $cur 2> /dev/null ) )
    return 0
}
if have apt-get ; then
    alias acs='apt-cache search'
    alias acS='apt-cache show'
    alias agi='sudo apt-get install'
    complete -F _agi $filenames agi acs acS

    alias agu='sudo apt-get update && sudo apt-get upgrade' 
fi

# pacman stuff (on Arch)
if have yaourt ; then
    function ins() 
    {
        yaourt -Ss $@
        #echo    -e "$(pacman -Ss "$@" | sed \
        #        -e 's#^core/.*#\\033[1;31m&\\033[0;37m#g' \
        #        -e 's#^extra/.*#\\033[0;32m&\\033[0;37m#g' \
        #        -e 's#^community/.*#\\033[1;35m&\\033[0;37m#g' \
        #        -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' ) \
        #        \033[0m"
    }
    
    #alias inu="sudo pacman -Syu"
    alias inu="yaourt -Syu"

    alias inr="yaourt -R"

    function in()
    {
        if [ $# -eq 0 ]; then
            echo "usage: in <package to install>"
        else
            yaourt -S $@
        fi
    }
fi


function rsync_backup
{
    echo -e 'rsync -auh --progress --stats --delete SOURCE DESTINATION'
}

# go to new dir
function md() 
{
    mkdir -p "$1" && cd "$1";
}

# note: option AUTO_PUSHD has to be set
# Jump between directories
d() {
    emulate -L zsh
    autoload -U colors
    local color=$fg_bold[blue]
    integer i=0
    dirs -p | while read dir; do
        local num="${$(printf "%-4d " $i)/ /.}"
        printf " %s  $color%s$reset_color\n" $num $dir
        (( i++ ))
    done
    integer dir=-1
    read -r 'dir?Jump to directory: ' || return
    (( dir == -1 )) && return
    if (( dir < 0 || dir >= i )); then
        echo d: no such directory stack entry: $dir
        return 1
    fi
    cd ~$dir
}

# Setting color profiles with iTerm on OSX

function toggle_colors()
{
  if [ -e ~/.color_profile_dark ]
  then
    rm ~/.color_profile_dark
  else
    touch ~/.color_profile_dark
  fi
  set_colors
}

function set_colors()
{
  if [ -e ~/.color_profile_dark ]
  then
    echo -en "\033]50;SetProfile=light\a" && export ITERM_PROFILE=light && export COLORFGBG="11;15"
  else
    echo -en "\033]50;SetProfile=dark\a" && export ITERM_PROFILE=dark && export COLORFGBG="12;8"
  fi
}
set_colors


# read man pages as PDF
function pman()
{
    PMANFILE="/tmp/pman-${1}.pdf"
    if [ ! -e $PMANFILE ]; then   # only create if it doesn't already exist
        man -t "${1}" | pstopdf -i -o "$PMANFILE"
    fi
    if [ -e $PMANFILE ]; then     # in case create failed
        open -a /Applications/Preview.app/ "$PMANFILE"
    fi
}
