# Project Structure

## Repository Organization

This dotfiles repository is organized by application/tool, with each top-level directory containing configuration files for specific software.

## Key Directories

### Core Configuration
- **`zshrc/`** - Zsh shell configuration with modular structure
  - `zshrc-file.sh` - Main entry point that detects OS and loads appropriate configs
  - `zshrc-common.sh` - Cross-platform shell configuration
  - `zshrc-macos.sh` / `zshrc-linux.sh` - OS-specific configurations
  - `modules/` - Modular components (aliases, colors, history, etc.)

### Package Management
- **`brew/`** - Homebrew package definitions organized by priority
  - `00-base/` - Essential system tools
  - `10-essential/` - Core development tools
  - `15-nice-to-haves/` - Productivity enhancements
  - `20-optional/` - Additional utilities

### Color Scheme System
- **`colorscheme/`** - Centralized theme management
  - `colorscheme-selector.sh` - Interactive theme picker using fzf
  - `list/` - Individual color scheme definitions
  - `active/` - Currently applied theme

### Terminal Emulators
- **`ghostty/`** - Primary terminal emulator config with shaders
- **`kitty/`** - Alternative terminal with extensive theme collection
- **`alacritty/`** - Lightweight terminal configuration
- **`wezterm/`** - Cross-platform terminal config

### Editor Configurations
- **`neovim/`** - Multiple Neovim distributions
  - `neobean/` - Primary config used in videos (most important)
  - `lazyvim/` - LazyVim-based distribution
  - `kickstart.nvim/` - Minimal starter config
  - `old-plugins/` - Archived plugin configurations

### Window Management
- **`yabai/`** - Tiling window manager configuration
- **`sketchybar/`** - Status bar with multiple variants
- **`hammerspoon/`** - macOS automation scripts

### Development Tools
- **`tmux/`** - Terminal multiplexer with custom layouts
- **`lazygit/`** - Git TUI configuration
- **`fastfetch/`** - System information display

## File Naming Conventions

- **Configuration Files**: Often include `-default` variants for backup/reference
- **Shell Scripts**: Use `.sh` extension, executable permissions
- **Theme Files**: Consistent naming across applications (e.g., `catppuccin-mocha`)
- **Backup Identification**: Files contain `UNIQUE_ID` comments for backup systems

## Symlink Strategy

Configuration files are typically symlinked from the repository to their expected locations:
```bash
# Example symlink pattern
ln -snf ~/github/dotfiles-latest/[app]/[config-file] ~/.[config-location]
```

## Modular Design Principles

1. **OS Detection**: Configurations automatically adapt to macOS vs Linux
2. **Conditional Loading**: Shell modules loaded based on available tools
3. **Theme Consistency**: Color schemes propagate across all applications
4. **Backup Safety**: Original configs preserved before applying symlinks
5. **Isolation**: Multiple Neovim configs can coexist without conflicts

## Special Directories

- **`assets/`** - Images and media for documentation
- **`scripts/`** - Utility scripts and automation tools
- **`dictionaries/`** - Custom word lists for spell checking
- **`obs/`** - OBS Studio configuration for content creation
- **`windows/`** - Windows-specific configurations (AutoHotkey)

## Configuration Hierarchy

1. **Base System** - Shell, package manager, core tools
2. **Terminal Layer** - Emulator configs, multiplexer, prompt
3. **Editor Layer** - Neovim distributions and plugins  
4. **Desktop Layer** - Window manager, status bar, automation
5. **Application Layer** - Individual tool configurations