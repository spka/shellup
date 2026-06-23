if ! type "fzf" > /dev/null 2>&1; then
    echo 'fzf not found, shellup will not work! :('
    return
fi

SHELLUP_THRESHOLD=${SHELLUP_THRESHOLD:-4}
_shellup_hcounter=0
_shellup_histindex=0
_shellup_saved_line=""
_shellup_tmp="${TMPDIR:-/tmp}/.shellup.$$"
_shellup_entry=""

# Capture `fc -ln OFFSET OFFSET` into $_shellup_entry WITHOUT a $(...) subshell.
# A command-substitution subshell spawned inside a `bind -x` keybinding silently
# drops the most recent history entry, so Up landed on the second-to-last
# command. Running fc as a builtin with a plain file redirect keeps the full
# history visible, then we read it back with the `read` builtin.
_shellup_fc() {
    _shellup_entry=
    fc -ln "$1" "$1" > "$_shellup_tmp" 2>/dev/null
    IFS= read -r _shellup_entry < "$_shellup_tmp" 2>/dev/null
    rm -f "$_shellup_tmp"
    _shellup_entry="${_shellup_entry#"${_shellup_entry%%[![:space:]]*}"}"
}

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
        fc -ln 1 > "$_shellup_tmp" 2>/dev/null
        selected=$(awk '!seen[$0]++' "$_shellup_tmp" | fzf --height=40% --bind 'down:transform:[ $FZF_POS -eq 1 ] && echo abort || echo down')
        rm -f "$_shellup_tmp"
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
        _shellup_fc -$_shellup_histindex
        if [[ -n "$_shellup_entry" ]]; then
            READLINE_LINE="$_shellup_entry"
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
        _shellup_fc -$_shellup_histindex
        if [[ -n "$_shellup_entry" ]]; then
            READLINE_LINE="$_shellup_entry"
            READLINE_POINT=${#READLINE_LINE}
        fi
    fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }_shellup_reset"

bind -x '"\e[A": _shellup_history_up'
bind -x '"\e[B": _shellup_history_down'
