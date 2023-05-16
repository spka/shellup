if ! type "fzf" > /dev/null; then
  echo 'fzf not found, shellback will not work!'
fi

hcounter=0

fzf-history-widget2() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); print $0 }' | fzf --height=40%) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}

function history-up {
  if [[ ${hcounter} == 4 ]]; then
    zle backward-kill-line
    zle end-of-history
    ((hcounter=0))
    zle fzf-history-widget2
  else
    ((hcounter++))
    zle up-line-or-search
  fi
}

function history-down {
  if [[ ${hcounter} > 0 ]]; then
    ((hcounter--))
  fi
  zle down-line-or-search
}

function history-reset { 
  ((hcounter=0))
  zle accept-line
}

zle -N fzf-history-widget2
zle -N history-up
zle -N history-down
zle -N history-reset

bindkey '^[[A' history-up
bindkey '^[[B' history-down
bindkey '^M' history-reset
