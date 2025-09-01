# Technology Stack

## Core Technologies

- **Shell**: Zsh with custom configuration modules
- **Package Manager**: Homebrew (macOS) with organized Brewfiles
- **Terminal Emulators**: Ghostty (primary), Kitty, Alacritty, Wezterm
- **Editor**: Neovim with multiple distributions (Neobean, LazyVim, Kickstart)
- **Window Management**: Yabai + SketchyBar
- **Version Control**: Git with custom configurations
- **Terminal Multiplexer**: tmux with custom layouts

## Configuration Languages

- **Shell Scripts**: Bash/Zsh for automation and setup
- **Lua**: Neovim configuration and Hammerspoon automation
- **TOML**: Various application configs (Alacritty, Starship, etc.)
- **YAML**: Some configuration files and CI/CD
- **JSON**: Application settings and package definitions

## Key Dependencies

- **fzf**: Fuzzy finder for file/command selection
- **bat**: Enhanced cat with syntax highlighting  
- **eza**: Modern ls replacement
- **zoxide**: Smart directory navigation
- **starship**: Cross-shell prompt
- **lazygit**: Terminal UI for Git
- **Node.js/yarn**: Required for some tools

## Common Commands

### Setup and Installation
```bash
# Install Homebrew packages by category
brew bundle --file=~/github/dotfiles-latest/brew/00-base/Brewfile
brew bundle --file=~/github/dotfiles-latest/brew/10-essential/Brewfile

# Apply dotfiles symlinks
ln -snf ~/github/dotfiles-latest/zshrc/zshrc-file.sh ~/.zshrc
source ~/.zshrc
```

### Color Scheme Management
```bash
# Interactive color scheme selector
~/github/dotfiles-latest/colorscheme/colorscheme-selector.sh

# Apply specific color scheme
~/github/dotfiles-latest/zshrc/colorscheme-set.sh [scheme-name]
```

### Neovim Configuration Testing
```bash
# Test Neobean config without affecting existing setup
NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/neobean nvim

# Create alias for regular use
alias neobean='NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/neobean nvim'
```

### Development Workflow
```bash
# Pull latest changes and reload shell
pulldeez  # Custom alias that pulls and sources zshrc

# Quick directory navigation with zoxide
z [partial-path]

# Enhanced file listing
eza -la --icons
```

## Build System

No traditional build system - this is a configuration repository. Setup involves:
1. Cloning the repository
2. Installing Homebrew dependencies via Brewfiles
3. Creating symlinks to configuration files
4. Sourcing shell configurations

## Testing

Configuration testing is done through:
- Isolated Neovim instances with `NVIM_APPNAME`
- Backup and restore mechanisms for original configs
- Modular loading of shell configurations