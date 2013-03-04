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
        if [[ "$platform" == 'osx' ]]; then
          find $1 \( -iname \*.h -o -iname \*.cpp -o -iname \*.cc -o -iname \*.hh -o -name CMakeLists.txt \) -print -exec sed -i "" -e "s/$2/$3/g" {} \;
        else
          find $1 \( -iname \*.h -o -iname \*.cpp -o -iname \*.cc -o -iname \*.hh -o -name CMakeLists.txt \) -print -exec sed -i "s/$2/$3/g" {} \;
        fi
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

# the have function checks for existence of executable
have()
{
    unset -v have
    type $1 >/dev/null 2>&1 && have="yes"
}

function rsync_backup
{
    echo -e 'rsync -auh --progress --stats --delete SOURCE DESTINATION'
}
