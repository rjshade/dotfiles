# ZSH precmd -- called just before every prompt display
# ------------------------------------------------------------------------------
#
# use this to build up a vcs_info_msg based on current VCS state
#
# additionally add current working directory to 'z' 


# green for staged changes
zstyle ':vcs_info:*' stagedstr   '%{'${fg[green]}'%}>'

# yellow for unstaged changes
zstyle ':vcs_info:*' unstagedstr '%{'${fg[yellow]}'%}>'

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn

# precmd is called just before the prompt is printed
precmd ()
{
    # vcs_info doesnt yet have support for untracked files so we check here
    # and add a red > to the vcs_info format if needed...
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
       # zstyle ':vcs_info:*' formats '%s:%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${reset_color}'%}'
       zstyle ':vcs_info:*' formats '%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${reset_color}'%}'
       # zstyle ':vcs_info:*' formats '%c%u%{'${reset_color}'%}'
    } else {
       # zstyle ':vcs_info:*' formats '%s:%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${fg[red]}'%}>%{'${reset_color}'%}'
       zstyle ':vcs_info:*' formats '%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${fg[red]}'%}>%{'${reset_color}'%}'
       # zstyle ':vcs_info:*' formats '%c%u%{'${fg[red]}'%}>%{'${reset_color}'%}'
    }

    vcs_info
}

