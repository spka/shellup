# Shellup 🐚☝️

_Small zsh script to trigger (fzf) history._

### Usecase

I like the default shell history ux, but after 5 or so commands i lose track.<br>
Time to press `ctrl + R`, but im lazy...
<img src="https://github.com/spka/shellup/assets/13484241/37bde3ba-4c8d-4836-98db-53037b5a1709" width="800">

### Requires fzf

[fzf - a general-purpose command-line fuzzy finder](https://github.com/junegunn/fzf)

### Install manually

**zsh**
1. Download the script:
    ```sh
    curl -fsSL https://raw.githubusercontent.com/spka/shellup/main/shellup.zsh -o ~/.shellup.zsh
    ```
2. Add to your `.zshrc`:
    ```sh
    [ -f ~/.shellup.zsh ] && source ~/.shellup.zsh
    ```

**bash**
1. Download the script:
    ```sh
    curl -fsSL https://raw.githubusercontent.com/spka/shellup/main/bashup.sh -o ~/.shellup.sh
    ```
2. Add to your `.bashrc`:
    ```sh
    [ -f ~/.shellup.sh ] && source ~/.shellup.sh
    ```

3. Start a new terminal session.

## Install

  With curl:
  ```bash
  curl -fsSL https://raw.githubusercontent.com/spka/shellup/main/install.sh | bash
  ```
  With wget:

  ```bash
  wget -qO- https://raw.githubusercontent.com/spka/shellup/main/install.sh | bash
  ```
