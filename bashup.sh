#!/bin/bash
echo "The bashup script"

# COUNTER=1

# __history_up__() {
#     # echo $COUNTER
#     ((COUNTER++))
#     $(previous-history)
# }
# __history_down__() {
#     # echo $COUNTER
#     if ((COUNTER > 0)); then
#         ((COUNTER--))
#     fi
#     $(next-history)
# }
# # bind -r "\e[A"
# # bind -m emacs-standard -x '"\e[A":__fzf_history2__'
# # bind '"\e[A":"\C-u`__fzf_history2__`\e\C-e\C-a\C-y\C-e"'

# if (( BASH_VERSINFO[0] < 4 )); then
#     echo 'Bash version lower then 4 not supported!'
# #   bind -m emacs-standard '"\e[A": "\C-e \C-u\C-y\ey\C-u"$(__fzf_history2__)"\e\C-e\er"'
# else
#     bind -m emacs-standard -x '"\e[A": __history_up__'
#     bind -m emacs-standard -x '"\e[B": __history_down__'
# fi
