---
inclusion: always
---

# Dotfiles Repository Guidelines

This is linkarzu's comprehensive macOS dotfiles repository optimized for content creation and development. Follow these patterns when working with configurations.

## Core Architecture Principles

### Configuration Management
- **Symlink Strategy**: Always preserve original configs before creating symlinks from repository to system locations
- **Modular Design**: Use reusable modules (see `zshrc/modules/`) rather than monolithic configs
- **OS Detection**: Implement conditional logic for macOS vs Linux compatibility
- **Backup Safety**: Include `UNIQUE_ID` comments in all configuration files for backup identification

### File Organization Rules
- **Application-Based Structure**: Each top-level directory = one tool/application
- **Priority Grouping**: Homebrew packages in `brew/` organized by necessity (00-base → 20-optional)
- **Theme Consistency**: All color schemes managed centrally via `colorscheme/` system

## Code Style Requirements

### Shell Scripts
- Use `.sh` extension with proper shebang (`#!/bin/zsh` for zsh, `#!/bin/bash` for bash)
- Make executable with `chmod +x`
- Include descriptive comments for complex logic
- Use consistent variable naming (lowercase with underscores)

### Configuration Files
- Create `-default` variants as backup references
- Use consistent naming across applications (theme names, file patterns)
- Include inline documentation for non-obvious settings
- Preserve original formatting when modifying existing configs

### Neovim Specific Rules
- **Primary Config**: `neovim/neobean/` is the main configuration used in video content
- **Testing**: Use `NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/[config]` for isolation
- **Plugin Management**: Prefer lazy-loading, minimize startup impact
- **Multiple Distributions**: Keep neobean, lazyvim, and kickstart configs independent

## Critical Workflow Patterns

### Color Scheme Management
- **Centralized System**: Always use `colorscheme/colorscheme-selector.sh` for theme changes
- **Propagation**: Theme changes must update terminal, editor, status bar, and window manager
- **Active State**: Update `colorscheme/active/active-colorscheme.sh` when switching themes
- **Video Consistency**: Maintain stable themes during content creation periods

### Package Management
- **Brewfile Categories**: Add packages to appropriate priority level (base/essential/nice-to-have/optional)
- **Dependencies**: Document manual setup steps in README files
- **Testing**: Verify installations work in clean environments
- **Organization**: Keep Brewfiles commented and logically grouped

## Safety and Integration Rules

### Before Making Changes
- Backup existing configurations (check for `UNIQUE_ID` comments)
- Test in isolated environments when possible (especially Neovim configs)
- Verify symlinks point to correct repository locations
- Ensure shell configurations reload without errors

### Cross-Application Dependencies
- **Color Schemes**: Changes affect ghostty, kitty, alacritty, neovim, tmux, sketchybar
- **Shell Config**: Affects terminal multiplexer, prompt, and application behavior
- **Font Changes**: Update terminal emulators, editor, and status bar configs simultaneously
- **Window Manager**: Yabai settings impact terminal and editor window behavior

### Content Creation Considerations
- Prioritize visual consistency and readability for screen recording
- Test configuration changes in recording environment before publishing
- Maintain stable setups during active content creation periods
- Ensure configurations work well with common screen recording tools

## Error Handling Standards
- Include error checking in all automation scripts
- Provide clear error messages with suggested solutions
- Implement rollback mechanisms for critical configuration changes
- Document common troubleshooting steps in relevant README files