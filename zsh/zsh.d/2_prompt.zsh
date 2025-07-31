# ZSH Prompt
# ------------------------------------------------------------------------------
setopt prompt_subst

zstyle ':vcs_info:*' stagedstr   '%{'${fg[green]}'%}>'
zstyle ':vcs_info:*' unstagedstr '%{'${fg[yellow]}'%}>'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git svn

# Cache git status to avoid running git commands on every prompt
# Only check git status if we're in a git repo and haven't checked recently
_last_git_check=0
_git_untracked_cache=""

precmd () {
  local current_time=$(date +%s)
  local time_diff=$((current_time - _last_git_check))
  
  # Only check git status every 2 seconds instead of every prompt
  if [[ $time_diff -gt 2 ]] || [[ -z $_git_untracked_cache ]]; then
    _last_git_check=$current_time
    
    # First check if we're in a git repo to avoid unnecessary calls
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        _git_untracked_cache="clean"
      else
        _git_untracked_cache="untracked"
      fi
    else
      _git_untracked_cache="not_git"
    fi
  fi
  
  if [[ $_git_untracked_cache == "clean" ]] || [[ $_git_untracked_cache == "not_git" ]]; then
    zstyle ':vcs_info:*' formats '%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${reset_color}'%}'
  else
    zstyle ':vcs_info:*' formats '%{'${fg[yellow]}'%}%b%{'${reset_color}'%} %c%u%{'${fg[red]}'%}>%{'${reset_color}'%}'
  fi

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
    echo "%{$fg[blue]%}>%{$reset_color%}"
  else
    echo "%{$fg[red]%}>%{$reset_color%}"
  fi
}

# ~/path/to/git/repo/ branch_name >>>>
PROMPT='${host_prefix} %{$fg[blue]%}%4~%{$reset_color%} ${vcs_info_msg_0_}$(check_last_exit_code) '

# continuation prompt (open quote, etc.)
PROMPT2="%{$fg[blue]%}%_%{$reset_color%} > "