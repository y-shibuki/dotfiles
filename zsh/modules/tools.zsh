# Starship prompt
if ! command -v starship &> /dev/null; then
  echo "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh
fi

# Initialize Starship
eval "$(starship init zsh)"

# Function to setup Homebrew environment
setup_homebrew_env() {
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/Homebrew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# Setup Homebrew environment
setup_homebrew_env

# Install Homebrew if not found
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Set up environment after installation
  setup_homebrew_env
fi

# Install Neovim
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim from GitHub releases..."
  cd /tmp
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  tar xzvf nvim-linux-x86_64.tar.gz
  sudo mv nvim-linux-x86_64 /opt/nvim
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  echo "Neovim installed successfully!"
  cd - > /dev/null
fi

# fnm (Node.js version manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# FZF Config
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="\
--exact \
--tmux 80% \
--ansi \
--color=bg+:#313244,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=border:#6C7086,label:#CDD6F4"

