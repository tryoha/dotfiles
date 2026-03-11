#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
BASHRC="${HOME}/.bashrc"
BASH_ALIASES="${HOME}/.bash_aliases"
NVM_VERSION="v0.40.4"
NODE_VERSION="${NODE_VERSION:-20}"
NVIM_INSTALL_DIR="/opt/nvim-linux-x86_64"
NVIM_BIN_DIR="${NVIM_INSTALL_DIR}/bin"

append_if_missing() {
  local line="$1"
  local file="$2"

  touch "$file"
  grep -Fqx "$line" "$file" || echo "$line" >> "$file"
}

load_nvm() {
  export NVM_DIR="${HOME}/.nvm"
  if [ -s "${NVM_DIR}/nvm.sh" ]; then
    . "${NVM_DIR}/nvm.sh"
  fi
}

echo "[1/11] apt update"
sudo apt update

echo "[2/11] install apt packages"
if [ -f "${DOTFILES_DIR}/packages/apt.txt" ]; then
  sudo xargs -a "${DOTFILES_DIR}/packages/apt.txt" apt install -y
else
  echo "No apt.txt found, skipping apt packages"
fi

echo "[3/11] install latest Neovim"
if [ ! -x "${NVIM_BIN_DIR}/nvim" ]; then
  cd /tmp
  rm -f nvim-linux-x86_64.tar.gz

  curl -fL -o nvim-linux-x86_64.tar.gz \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

  sudo rm -rf "${NVIM_INSTALL_DIR}"
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
fi

append_if_missing 'export PATH="/opt/nvim-linux-x86_64/bin:$PATH"' "${BASHRC}"
export PATH="${NVIM_BIN_DIR}:${PATH}"

echo "[4/11] ensure pipx path"
pipx ensurepath --force || true
append_if_missing 'export PATH="$HOME/.local/bin:$PATH"' "${BASHRC}"
export PATH="${HOME}/.local/bin:${PATH}"

echo "[5/11] install nvm"
if [ ! -s "${HOME}/.nvm/nvm.sh" ]; then
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh" | bash
fi

append_if_missing 'export NVM_DIR="$HOME/.nvm"' "${BASHRC}"
append_if_missing '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' "${BASHRC}"

load_nvm

if ! command -v nvm >/dev/null 2>&1; then
  echo "ERROR: nvm was not loaded correctly"
  exit 1
fi

echo "[6/11] clean old npm config incompatible with nvm"
npm config delete prefix >/dev/null 2>&1 || true
npm config delete globalconfig >/dev/null 2>&1 || true
rm -f "${HOME}/.npmrc"

echo "[7/11] install Node ${NODE_VERSION} via nvm"
nvm install "${NODE_VERSION}"
nvm alias default "${NODE_VERSION}"
nvm use --delete-prefix "${NODE_VERSION}"

echo "[8/11] install npm global tools"
if [ -f "${DOTFILES_DIR}/packages/npm.txt" ]; then
  while IFS= read -r pkg; do
    [ -n "${pkg}" ] && npm install -g "${pkg}"
  done < "${DOTFILES_DIR}/packages/npm.txt"
else
  echo "No npm.txt found, skipping npm tools"
fi

echo "[9/11] install pipx tools"
if [ -f "${DOTFILES_DIR}/packages/pipx.txt" ]; then
  while IFS= read -r pkg; do
    [ -n "${pkg}" ] && pipx install "${pkg}" --force
  done < "${DOTFILES_DIR}/packages/pipx.txt"
else
  echo "No pipx.txt found, skipping pipx tools"
fi

echo "[10/11] install Neovim config"
mkdir -p "${HOME}/.config"
if [ -d "${NVIM_CONFIG_DIR}" ] && [ ! -L "${NVIM_CONFIG_DIR}" ]; then
  mv "${NVIM_CONFIG_DIR}" "${NVIM_CONFIG_DIR}.backup.$(date +%s)"
fi
rm -rf "${NVIM_CONFIG_DIR}"
ln -s "${DOTFILES_DIR}/nvim" "${NVIM_CONFIG_DIR}"

echo "[11/11] ensure fd alias exists"
if command -v fdfind >/dev/null 2>&1; then
  sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
fi

echo "[extra] install plugins and parsers"
nvim --headless "+Lazy! sync" +qa
nvim --headless "+TSUpdateSync" +qa || true

append_if_missing 'alias vim="nvim"' "${BASH_ALIASES}"

echo
echo "Bootstrap complete."
echo "Restart shell or run: source ~/.bashrc"
echo "Neovim: $(nvim --version | head -n 1)"
echo "Node: $(node -v)"
echo "npm: $(npm -v)"
