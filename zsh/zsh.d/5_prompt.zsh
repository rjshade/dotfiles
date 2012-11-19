# ZSH Prompt
# ------------------------------------------------------------------------------

setopt prompt_subst

# display [hostname] at start of prompt if sshed in...
if [[ -n "${SSH_CONNECTION}" ]]; then
    host_prefix='%{'$fg[yellow]'%}'${HOST}'%{'$reset_color'%} '
fi

# prompt:  (git-svn:master) >>> 
#          ~/code/mrg/ 

#terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]

#PS1='%{$terminfo_down_sc%{$fg[blue]%}%~ %{$reset_color%} $terminfo[rc]%}${host_prefix}${vcs_info_msg_0_}%(!.%{$fg[red]%}>.%{$fg[gray]%}>)%{$reset_color%} '

#preexec(){ print -rn -- $terminfo[el]; }


# ~/code/github/eighty-thousand-hours/ git:master >>>>
PROMPT='${host_prefix}%{$fg[blue]%}%~%{$reset_color%} ${vcs_info_msg_0_}%(!.%{$fg[red]%}>.%{$fg[gray]%}>)%{$reset_color%} '

# git:master >>>>
#PROMPT='${host_prefix}%{$reset_color%}${vcs_info_msg_0_}%(!.%{$fg[red]%}>.%{$fg[gray]%}>)%{$reset_color%} '

# right prompt: Thu 5th Oct 18:45
RPROMPT='%{$fg[gray]%}%D{%a %e %b %H:%M}%{$reset_color%}'

PROMPT2="%{$fg[blue]%}%_%{$reset_color%} > "
