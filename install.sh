#!/usr/bin/env bash
set -euo pipefail

REPO="spka/shellup"
REF="${SHELLUP_REF:-main}"

shell="$(basename "${SHELL:-}")"
case "$shell" in
    bash)
        src_file="bashup.sh"
        dest_name=".shellup.sh"
        rc="$HOME/.bashrc"
        ;;
    zsh)
        src_file="shellup.zsh"
        dest_name=".shellup.zsh"
        rc="${ZDOTDIR:-$HOME}/.zshrc"
        ;;
    *)
        echo "Error: shellup supports bash and zsh only (got: ${SHELL:-unknown})" >&2
        exit 1
        ;;
esac

DEST="$HOME/$dest_name"

url="https://raw.githubusercontent.com/${REPO}/${REF}/${src_file}"

if ! command -v fzf >/dev/null 2>&1; then
    echo "Warning: fzf not found. shellup needs fzf to work — install it first."
    echo "  https://github.com/junegunn/fzf"
fi

echo "Installing shellup ($shell) to $DEST"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$DEST"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "$DEST" "$url"
else
    echo "Error: neither curl nor wget found" >&2
    exit 1
fi

line="[ -f ~/$dest_name ] && source ~/$dest_name"
if grep -qsF "$line" "$rc"; then
    echo "Already sourced in $rc"
else
    printf '\n# shellup\n%s\n' "$line" >> "$rc"
    echo "Added source line to $rc"
fi

echo
echo "Done. Restart your shell or run: source $rc"
