# Complete Installation Guide for Linkarzu's Dotfiles

This guide provides step-by-step instructions for installing the complete dotfiles environment on macOS, including all applications, scripts, and launch agents.

## 🚀 Quick Start (Automated Installation)

The easiest way to install everything is using the automated installation script:

```bash
# Download and run the installation script
curl -fsSL https://raw.githubusercontent.com/linkarzu/dotfiles-latest/main/install-dotfiles.sh | bash
```

Or if you prefer to review the script first:

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/linkarzu/dotfiles-latest/main/install-dotfiles.sh -o install-dotfiles.sh

# Make it executable
chmod +x install-dotfiles.sh

# Run the installation
./install-dotfiles.sh
```

## 📋 What Gets Installed

### Core System Components
- **Homebrew** - Package manager for macOS
- **Xcode Command Line Tools** - Essential development tools
- **Git** - Version control system

### Shell Environment
- **Zsh Configuration** - Custom shell with modules
- **Starship Prompt** - Cross-shell prompt
- **Zsh Plugins** - Auto-suggestions, vi-mode, syntax highlighting

### Terminal Emulators
- **Ghostty** - Primary terminal (with shaders support)
- **Kitty** - GPU-accelerated terminal
- **Alacritty** - Minimal, fast terminal
- **Wezterm** - Cross-platform terminal

### Development Tools
- **Neovim** - Modern Vim-based editor
- **Neobean Config** - Linkarzu's Neovim configuration
- **tmux** - Terminal multiplexer
- **Lazygit** - Terminal UI for Git
- **fzf** - Fuzzy finder
- **ripgrep** - Fast text search
- **bat** - Enhanced cat with syntax highlighting
- **eza** - Modern ls replacement
- **zoxide** - Smart directory navigation

### Window Management
- **Yabai** - Tiling window manager
- **SketchyBar** - Custom status bar
- **Hammerspoon** - macOS automation

### Productivity Tools
- **Obsidian** - Note-taking application
- **Raindrop.io** - Bookmark manager
- **1Password CLI** - Password manager CLI
- **Various browsers** - Chrome, Brave, Zen, Edge, Vivaldi

## 🛠️ Manual Installation Steps

If you prefer to install components manually or want to understand each step:

### 1. Prerequisites

```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (for Apple Silicon Macs)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 2. Clone the Dotfiles Repository

```bash
# Create directory structure
mkdir -p ~/github

# Clone the repository
git clone https://github.com/linkarzu/dotfiles-latest.git ~/github/dotfiles-latest

# Navigate to the directory
cd ~/github/dotfiles-latest
```

### 3. Install Packages by Category

Install packages in order of priority:

```bash
# Base packages (essential system tools)
brew bundle --file=~/github/dotfiles-latest/brew/00-base/Brewfile

# Essential packages (development tools)
brew bundle --file=~/github/dotfiles-latest/brew/10-essential/Brewfile

# Nice-to-have packages (productivity tools)
brew bundle --file=~/github/dotfiles-latest/brew/15-nice-to-haves/Brewfile

# Optional packages (additional utilities)
brew bundle --file=~/github/dotfiles-latest/brew/20-optional/Brewfile
```

### 4. Setup Shell Configuration

```bash
# Backup existing zshrc (if it exists)
cp ~/.zshrc ~/.zshrc.backup 2>/dev/null || true

# Link the dotfiles zshrc
ln -snf ~/github/dotfiles-latest/zshrc/zshrc-file.sh ~/.zshrc

# Reload shell configuration
source ~/.zshrc
```

### 5. Setup Neovim Configuration

```bash
# Create config directory
mkdir -p ~/.config/linkarzu/dotfiles-latest

# Link Neovim configuration
ln -snf ~/github/dotfiles-latest/neovim ~/.config/linkarzu/dotfiles-latest/neovim

# Add alias to your shell config
echo 'alias neobean="NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/neobean nvim"' >> ~/.zshrc

# Test the configuration
neobean
```

### 6. Setup Terminal Emulator Configurations

#### Ghostty
```bash
mkdir -p ~/.config/ghostty
ln -snf ~/github/dotfiles-latest/ghostty/config ~/.config/ghostty/config
```

#### Kitty
```bash
mkdir -p ~/.config/kitty
ln -snf ~/github/dotfiles-latest/kitty/kitty.conf ~/.config/kitty/kitty.conf
```

#### Alacritty
```bash
mkdir -p ~/.config/alacritty
ln -snf ~/github/dotfiles-latest/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```

#### Wezterm
```bash
mkdir -p ~/.config/wezterm
ln -snf ~/github/dotfiles-latest/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

### 7. Setup Window Management

#### Yabai
```bash
mkdir -p ~/.config/yabai
ln -snf ~/github/dotfiles-latest/yabai/yabairc ~/.config/yabai/yabairc
chmod +x ~/.config/yabai/yabairc

# Start Yabai service
yabai --start-service
```

#### SketchyBar
```bash
ln -snf ~/github/dotfiles-latest/sketchybar ~/.config/sketchybar
find ~/.config/sketchybar -name "*.sh" -exec chmod +x {} \;

# Start SketchyBar service
sketchybar --start-service
```

### 8. Setup Additional Tools

#### tmux
```bash
ln -snf ~/github/dotfiles-latest/tmux/tmux.conf ~/.tmux.conf
```

#### Color Scheme System
```bash
# Make color scheme scripts executable
find ~/github/dotfiles-latest/colorscheme -name "*.sh" -exec chmod +x {} \;

# Test color scheme selector
~/github/dotfiles-latest/colorscheme/colorscheme-selector.sh
```

## 🎨 Color Scheme Management

The dotfiles include a centralized color scheme system:

```bash
# Interactive color scheme selector
~/github/dotfiles-latest/colorscheme/colorscheme-selector.sh

# Apply specific color scheme
~/github/dotfiles-latest/zshrc/colorscheme-set.sh [scheme-name]
```

Available color schemes:
- Catppuccin (Mocha, Macchiato, Frappe, Latte)
- Tokyo Night
- Gruvbox
- Nord
- And many more...

## 🔧 Post-Installation Configuration

### 1. Grant Permissions

Some tools require additional permissions:

1. **Yabai & SketchyBar**: Grant accessibility permissions in System Preferences > Security & Privacy > Accessibility
2. **Hammerspoon**: Grant accessibility permissions for automation
3. **Terminal Emulators**: Grant full disk access if needed

### 2. Disable System Integrity Protection (Optional)

For advanced Yabai features:

```bash
# Boot into Recovery Mode (Command + R during startup)
# Open Terminal and run:
csrutil disable

# Reboot normally
# Load Yabai scripting addition:
sudo yabai --load-sa
```

### 3. Configure Launch Agents

Some services can be configured to start automatically:

```bash
# Yabai
brew services start yabai

# SketchyBar
brew services start sketchybar
```

## 📚 Useful Commands

After installation, you'll have access to these commands:

### Navigation & File Management
```bash
z <directory>      # Smart directory navigation with zoxide
eza -la --icons    # Enhanced file listing with icons
bat <file>         # View file with syntax highlighting
fd <pattern>       # Fast file search
rg <pattern>       # Fast text search in files
```

### Development
```bash
neobean           # Launch Neovim with Neobean config
lazygit           # Terminal UI for Git
tmux              # Terminal multiplexer
gh                # GitHub CLI
```

### System Management
```bash
pulldeez          # Update dotfiles and reload shell
fastfetch         # System information display
btop              # System monitor
brew bundle dump # Generate Brewfile from installed packages
```

### Color Schemes
```bash
# Interactive color scheme selector
~/github/dotfiles-latest/colorscheme/colorscheme-selector.sh

# List available schemes
ls ~/github/dotfiles-latest/colorscheme/list/
```

## 🔄 Updating Your Setup

To keep your dotfiles up to date:

```bash
# Update dotfiles and reload shell
pulldeez

# Or manually:
cd ~/github/dotfiles-latest
git pull
source ~/.zshrc
```

## 🐛 Troubleshooting

### Common Issues

1. **Homebrew not in PATH**
   ```bash
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   source ~/.zprofile
   ```

2. **Neovim plugins not loading**
   ```bash
   # Remove plugin cache and restart
   rm -rf ~/.local/share/linkarzu
   neobean
   ```

3. **Yabai not working**
   - Check accessibility permissions
   - Verify SIP status: `csrutil status`
   - Check service status: `brew services list | grep yabai`

4. **Color scheme not applying**
   ```bash
   # Reload color scheme system
   source ~/github/dotfiles-latest/colorscheme/active/active-colorscheme.sh
   ```

### Getting Help

1. Check the [main README](README.md) for detailed documentation
2. Review individual tool configurations in their respective directories
3. Watch Linkarzu's YouTube videos for visual guides
4. Check the [GitHub Issues](https://github.com/linkarzu/dotfiles-latest/issues) for known problems

## 📁 Directory Structure

After installation, your setup will look like this:

```
~/github/dotfiles-latest/          # Main dotfiles repository
~/.config/
├── ghostty/                       # Ghostty terminal config
├── kitty/                         # Kitty terminal config
├── alacritty/                     # Alacritty terminal config
├── wezterm/                       # Wezterm terminal config
├── yabai/                         # Yabai window manager config
├── sketchybar/                    # SketchyBar status bar config
└── linkarzu/dotfiles-latest/
    └── neovim/neobean/            # Neobean Neovim config
~/.zshrc                           # Shell configuration (symlinked)
~/.tmux.conf                       # tmux configuration (symlinked)
```

## 🎯 Next Steps

After installation:

1. **Customize**: Explore the configurations and modify them to your preferences
2. **Learn**: Watch Linkarzu's YouTube videos to understand the workflow
3. **Experiment**: Try different color schemes and terminal emulators
4. **Contribute**: Share your improvements and feedback with the community

Enjoy your new development environment! 🚀