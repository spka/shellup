if ! type "fzf" > /dev/null; then
  echo 'fzf not found, shellup will not work! :('
fi

SHELLUP_THRESHOLD=${SHELLUP_THRESHOLD:-4}
_shellup_hcounter=0

fzf-history-widget2() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | fzf --height=40%) )
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
  if [[ ${_shellup_hcounter} == $SHELLUP_THRESHOLD ]]; then
    zle backward-kill-line
    zle end-of-history
    ((_shellup_hcounter=0))
    zle fzf-history-widget2
  else
    ((_shellup_hcounter++))
    zle up-line-or-search
  fi
}

function history-down {
  [[ $_shellup_hcounter -gt 0 ]] && ((_shellup_hcounter--))
  zle down-line-or-search
}

function history-reset {
  ((_shellup_hcounter=0))
  zle accept-line
}

zle -N fzf-history-widget2
zle -N history-up
zle -N history-down
zle -N history-reset

bindkey '^[[A' history-up
bindkey '^[[B' history-down
bindkey '^M' history-reset
