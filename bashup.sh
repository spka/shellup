if ! type "fzf" > /dev/null 2>&1; then
    echo 'fzf not found, shellup will not work! :('
    return
fi

SHELLUP_THRESHOLD=${SHELLUP_THRESHOLD:-4}
_shellup_hcounter=0
_shellup_histindex=0
_shellup_saved_line=""

_shellup_reset() {
    _shellup_hcounter=0
    _shellup_histindex=0
    _shellup_saved_line=""
}

_shellup_history_up() {
    if [[ $_shellup_hcounter -eq $SHELLUP_THRESHOLD ]]; then
        _shellup_hcounter=0
        _shellup_histindex=0
        local selected
        selected=$(fc -ln 1 | awk '!seen[$0]++' | fzf --height=40% --bind 'down:transform:[ $FZF_POS -eq 1 ] && echo abort || echo down')
        if [[ -n "$selected" ]]; then
            selected="${selected#"${selected%%[![:space:]]*}"}"
            READLINE_LINE="$selected"
            READLINE_POINT=${#READLINE_LINE}
        fi
    else
        if [[ $_shellup_histindex -eq 0 ]]; then
            _shellup_saved_line="$READLINE_LINE"
        fi
        ((_shellup_hcounter++))
        ((_shellup_histindex++))
        local entry
        entry=$(fc -ln -$_shellup_histindex -$_shellup_histindex 2>/dev/null)
        entry="${entry#"${entry%%[![:space:]]*}"}"
        if [[ -n "$entry" ]]; then
            READLINE_LINE="$entry"
            READLINE_POINT=${#READLINE_LINE}
        fi
    fi
}

_shellup_history_down() {
    [[ $_shellup_hcounter -gt 0 ]] && ((_shellup_hcounter--))
    [[ $_shellup_histindex -gt 0 ]] && ((_shellup_histindex--))
    if [[ $_shellup_histindex -eq 0 ]]; then
        READLINE_LINE="$_shellup_saved_line"
        READLINE_POINT=${#READLINE_LINE}
    else
        local entry
        entry=$(fc -ln -$_shellup_histindex -$_shellup_histindex 2>/dev/null)
        entry="${entry#"${entry%%[![:space:]]*}"}"
        if [[ -n "$entry" ]]; then
            READLINE_LINE="$entry"
            READLINE_POINT=${#READLINE_LINE}
        fi
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }_shellup_reset"

bind -x '"\e[A": _shellup_history_up'
bind -x '"\e[B": _shellup_history_down'
