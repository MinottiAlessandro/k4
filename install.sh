#!/usr/bin/env bash
# Install k4 to $PREFIX/bin (default: ~/.local/bin).

set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$BIN_DIR"
install -m 0755 "$here/k4" "$BIN_DIR/k4"
echo "installed: $BIN_DIR/k4"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "note: $BIN_DIR is not in PATH — add it to use 'k4'" ;;
esac

missing=()
for cmd in ssh scp ssh-keygen file; do
  command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done

if (( ${#missing[@]} > 0 )); then
  echo
  echo "warning: missing runtime dependencies: ${missing[*]}"
  echo "  arch:    sudo pacman -S openssh file"
  echo "  debian:  sudo apt install openssh-client file"
  echo "  fedora:  sudo dnf install openssh-clients file"
fi

if ! command -v luac >/dev/null 2>&1; then
  echo
  echo "note: 'luac' not found — only needed for the 'add-patch' subcommand."
  echo "  arch:    sudo pacman -S lua"
  echo "  debian:  sudo apt install lua5.4"
  echo "  fedora:  sudo dnf install lua"
fi
