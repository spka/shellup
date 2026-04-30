if ! type "fzf" > /dev/null; then
  echo 'fzf not found, shellup will not work! :('
  return
fi

SHELLUP_THRESHOLD=${SHELLUP_THRESHOLD:-4}
_shellup_hcounter=0

_shellup_reset() { _shellup_hcounter=0 }
autoload -Uz add-zsh-hook
add-zsh-hook precmd _shellup_reset

# Keep the terminal in application keypad mode while zle is active so
# terminfo[kcuu1]/[kcud1] match what zle actually receives.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function _shellup_appmode_start { echoti smkx }
  function _shellup_appmode_stop  { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init   _shellup_appmode_start
  add-zle-hook-widget -Uz zle-line-finish _shellup_appmode_stop
fi

shellup-fzf-history() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | fzf --height=40% --bind 'down:transform:[ $FZF_POS -eq 1 ] && echo abort || echo down') )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    [ -n "$num" ] && zle vi-fetch-history -n $num
  fi
  zle reset-prompt
  return $ret
}

function history-up {
  if [[ ${_shellup_hcounter} == $SHELLUP_THRESHOLD ]]; then
    zle backward-kill-line
    zle end-of-history
    _shellup_hcounter=0
    zle shellup-fzf-history
  else
    ((_shellup_hcounter++))
    zle up-line-or-search
  fi
}

function history-down {
  [[ $_shellup_hcounter -gt 0 ]] && ((_shellup_hcounter--))
  zle down-line-or-search
}

zle -N shellup-fzf-history
zle -N history-up
zle -N history-down

# Bind via terminfo, plus literal fallbacks for both common encodings
# (CSI '^[[' and SS3 '^[O') to cover terminals/tmux sessions that ignore smkx.
bindkey "${terminfo[kcuu1]:-^[[A}" history-up
bindkey "${terminfo[kcud1]:-^[[B}" history-down
bindkey '^[[A' history-up
bindkey '^[OA' history-up
bindkey '^[[B' history-down
bindkey '^[OB' history-down
