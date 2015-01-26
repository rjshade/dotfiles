# ZSH Prompt
# ------------------------------------------------------------------------------

setopt prompt_subst

# Display hostname in prompt if using ssh, but not in tmux
# (display hostname in tmux status line instead).
if [[ -n "${SSH_CONNECTION}" ]]; then
  if [[ -z "${TMUX}" ]]; then
    host_prefix='%{'$fg[yellow]'%}%m%{'$reset_color'%}'
  fi
fi

# ~/code/github/eighty-thousand-hours/ master >>>>
PROMPT='${host_prefix} %{$fg[blue]%}%4~%{$reset_color%} ${vcs_info_msg_0_}%(!.%{$fg[red]%}>.%{$fg[gray]%}>)%{$reset_color%} '

# right prompt: Thu 5th Oct 18:45
#RPROMPT='%{$fg[gray]%}%D{%a %e %b %H:%M}%{$reset_color%}'

# continuation prompt (open quote, etc.)
PROMPT2="%{$fg[blue]%}%_%{$reset_color%} > "
