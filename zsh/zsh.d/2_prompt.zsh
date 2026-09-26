# ZSH Prompt
# ------------------------------------------------------------------------------
setopt prompt_subst

# Git state is fetched asynchronously: the prompt is drawn immediately with the
# last known state and redrawn once `git status` returns.
typeset -g _git_prompt=''
typeset -g _git_prompt_fd=''

_git_prompt_render() {
  local line branch='' oid='' staged='' unstaged='' untracked=''
  for line in ${(f)1}; do
    case $line in
      '# branch.head '*) branch=${line#'# branch.head '} ;;
      '# branch.oid '*)  oid=${line#'# branch.oid '} ;;
      '# '*) ;;
      '? '*) untracked='%F{red}>' ;;
      'u '*) unstaged='%F{yellow}>' ;;
      [12]' '*)
        [[ ${line[3]} != . ]] && staged='%F{green}>'
        [[ ${line[4]} != . ]] && unstaged='%F{yellow}>'
        ;;
    esac
  done
  [[ $branch == '(detached)' ]] && branch=${oid[1,7]}
  if [[ -n $branch ]]; then
    _git_prompt="%F{yellow}${branch}%f ${staged}${unstaged}${untracked}%f"
  else
    _git_prompt=''
  fi
}

_git_prompt_cancel() {
  if [[ -n $_git_prompt_fd ]]; then
    zle -F $_git_prompt_fd
    exec {_git_prompt_fd}<&-
    _git_prompt_fd=''
  fi
}

_git_prompt_read() {
  local fd=$1 line out=''
  while IFS= read -r -u $fd line; do
    out+=$line$'\n'
  done
  zle -F $fd
  exec {fd}<&-
  _git_prompt_fd=''
  _git_prompt_render "$out"
  zle reset-prompt
}

_git_prompt_start() {
  _git_prompt_cancel
  exec {_git_prompt_fd}< <(git --no-optional-locks status --porcelain=v2 --branch 2>/dev/null)
  zle -F $_git_prompt_fd _git_prompt_read
}

_git_prompt_chpwd() {
  _git_prompt=''
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _git_prompt_start
add-zsh-hook chpwd _git_prompt_chpwd

# Display hostname in prompt if using ssh, but not in tmux
# (display hostname in tmux status line instead).
if [[ -n "${SSH_CONNECTION}" ]]; then
  if [[ -z "${TMUX}" ]]; then
    host_prefix='%F{yellow}%m%f'
  fi
fi

# ~/path/to/git/repo/ branch_name >>>>
PROMPT='${host_prefix} %F{blue}%4~%f ${_git_prompt}%(?.%F{blue}.%F{red})>%f '

# continuation prompt (open quote, etc.)
PROMPT2='%F{blue}%_%f > '
