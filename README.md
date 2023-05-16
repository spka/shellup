# Shellup 🐚☝️
_Small zsh script to trigger (fzf) history._

### Usecase

I like the default shell history ux, but after 5 or so commands i lose track. Time to press `ctrl + R`, but im lazy...
![Screen Recording 2023-05-16 at 21 23 15](https://github.com/spka/shellup/assets/13484241/0f3e7c2f-e64c-4bcd-a156-27acab75edb6)

### Requires fzf

[fzf - a general-purpose command-line fuzzy finder](https://github.com/junegunn/fzf)

### Install Zsh

1. Clone this repository somewhere on your machine. This guide will assume `~/.zsh/shellup`.

    ```sh
    git clone https://github.com/spka/shellup ~/.zsh/shellup
    ```

2. Add the following to your `.zshrc`:

    ```sh
    source ~/.zsh/shellup/shellup.zsh
    ```

3. Start a new terminal session.
