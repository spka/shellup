echo "The bashup script"

HCOUNTER=0

__fzf_history2__() {
    echo "test"
}

if (( BASH_VERSINFO[0] < 4 )); then
  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard '"\e[A": "\C-e \C-u\C-y\ey\C-u"$(__fzf_history2__)"\e\C-e\er"'
  bind -m vi-command '"\e[A": "\C-z\e[A\C-z"'
  bind -m vi-insert '"\e[A": "\C-z\e[A\C-z"'
else
  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard -x '"\e[A": __fzf_history2__'
  bind -m vi-command -x '"\e[A": __fzf_history2__'
  bind -m vi-insert -x '"\e[A": __fzf_history2__'
fi
