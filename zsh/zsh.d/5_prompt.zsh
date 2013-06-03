# ZSH Prompt
# ------------------------------------------------------------------------------

setopt prompt_subst

# display [hostname] at start of prompt if sshed in...
if [[ -n "${SSH_CONNECTION}" ]]; then
    host_prefix='%{'$fg[yellow]'%}%m%{'$reset_color'%}'
fi

# host_name ~/code/github/eighty-thousand-hours/ master >>>>
PROMPT='${host_prefix} %{$fg[blue]%}%4~%{$reset_color%} ${vcs_info_msg_0_}%(!.%{$fg[red]%}>.%{$fg[gray]%}>)%{$reset_color%} '

# right prompt: Thu 5th Oct 18:45
RPROMPT='%{$fg[gray]%}%D{%a %e %b %H:%M}%{$reset_color%}'

# continuation prompt (open quote, etc.)
PROMPT2="%{$fg[blue]%}%_%{$reset_color%} > "
