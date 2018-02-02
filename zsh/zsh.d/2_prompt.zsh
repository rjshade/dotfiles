# ZSH Prompt
# ------------------------------------------------------------------------------
setopt prompt_subst

zstyle ':vcs_info:*' stagedstr   '%{'${fg[green]}'%}>'
zstyle ':vcs_info:*' unstagedstr '%{'${fg[yellow]}'%}>'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn

# precmd is called just before the prompt is printed
precmd () {
    # vcs_info doesnt yet have support for untracked files so we check here
    # and add a red > to the vcs_info format if needed...
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
       zstyle ':vcs_info:*' formats '%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${reset_color}'%}'
    } else {
       zstyle ':vcs_info:*' formats '%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${fg[red]}'%}>%{'${reset_color}'%}'
    }

    vcs_info
}

# Display hostname in prompt if using ssh, but not in tmux
# (display hostname in tmux status line instead).
if [[ -n "${SSH_CONNECTION}" ]]; then
  if [[ -z "${TMUX}" ]]; then
    host_prefix='%{'$fg[yellow]'%}%m%{'$reset_color'%}'
  fi
fi

function check_last_exit_code() {
  if [[ $? -eq 0 ]]; then
    echo "%{$fg[gray]%}>%{$reset_color%}"
  else
    echo "%{$fg[red]%}>%{$reset_color%}"
  fi
}

# ~/path/to/git/repo/ branch_name >>>>
PROMPT='${host_prefix} %{$fg[blue]%}%4~%{$reset_color%} ${vcs_info_msg_0_}$(check_last_exit_code) '

# right prompt shows time: 18:45:01
RPROMPT='%{$fg[yellow]%}%D{%H:%M:%S}%{$reset_color%}'

# continuation prompt (open quote, etc.)
PROMPT2="%{$fg[blue]%}%_%{$reset_color%} > "
