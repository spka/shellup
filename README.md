# Shellup 🐚☝️

_Small zsh script to trigger (fzf) history._

### Usecase

I like the default shell history ux, but after 5 or so commands i lose track.<br>
Time to press `ctrl + R`, but im lazy...
<img src="https://github.com/spka/shellup/assets/13484241/37bde3ba-4c8d-4836-98db-53037b5a1709" width="800">

### Requires fzf

[fzf - a general-purpose command-line fuzzy finder](https://github.com/junegunn/fzf)

### Install for zsh
1. Clone this repository somewhere on your machine. This guide will assume `~/.zsh/shellup`.

    ```sh
    git clone https://github.com/spka/shellup ~/.zsh/shellup
    ```

2. Add the following to your `.zshrc`:

    ```sh
    source ~/.zsh/shellup/shellup.zsh
    ```

3. Start a new terminal session.
