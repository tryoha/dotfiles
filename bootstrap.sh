#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
LOCAL_BIN="${HOME}/.local/bin"

echo "[1/9] apt update"
sudo apt update

echo "[2/9] install apt packages"
sudo xargs -a "${DOTFILES_DIR}/packages/apt.txt" apt install -y

echo "[3/9] ensure pipx path"
pipx ensurepath || true

export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:${PATH}"

echo "[4/9] install npm global tools"
while IFS= read -r pkg; do
  [ -n "${pkg}" ] && npm install -g "${pkg}"
done < "${DOTFILES_DIR}/packages/npm.txt"

echo "[5/9] install pipx tools"
while IFS= read -r pkg; do
  [ -n "${pkg}" ] && pipx install "${pkg}" --force
done < "${DOTFILES_DIR}/packages/pipx.txt"

echo "[6/9] install Neovim config"
mkdir -p "${HOME}/.config"
rm -rf "${NVIM_CONFIG_DIR}"
ln -s "${DOTFILES_DIR}/nvim" "${NVIM_CONFIG_DIR}"

echo "[7/9] ensure fd alias exists"
if command -v fdfind >/dev/null 2>&1; then
  sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

echo "[8/9] install latest stable Neovim"
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo mv nvim-linux64 /opt/nvim

if ! grep -q '/opt/nvim/bin' "${HOME}/.bashrc"; then
  echo 'export PATH="/opt/nvim/bin:$PATH"' >> "${HOME}/.bashrc"
fi

export PATH="/opt/nvim/bin:${PATH}"


echo "[9/9] install plugins and parsers"
nvim --headless "+Lazy! sync" +qa
nvim --headless "+TSUpdateSync" +qa || true

echo
echo "Bootstrap complete."
echo "Open Neovim once with: nvim"
