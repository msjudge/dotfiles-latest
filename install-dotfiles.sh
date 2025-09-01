#!/bin/bash

# =============================================================================
# Linkarzu's Dotfiles Complete Installation Script
# =============================================================================
# This script provides a full step-by-step installation of the dotfiles
# repository with proper error handling, backups, and user interaction.
# =============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_REPO="https://github.com/linkarzu/dotfiles-latest.git"
DOTFILES_DIR="$HOME/github/dotfiles-latest"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# =============================================================================
# Utility Functions
# =============================================================================

print_header() {
    echo -e "\n${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}\n"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

confirm_action() {
    local message="$1"
    local default="${2:-n}"
    
    if [[ "$default" == "y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi
    
    echo -e "${YELLOW}$message $prompt${NC}"
    read -r response
    
    if [[ -z "$response" ]]; then
        response="$default"
    fi
    
    [[ "$response" =~ ^[Yy]$ ]]
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

backup_file() {
    local file="$1"
    if [[ -f "$file" ]] || [[ -L "$file" ]]; then
        print_info "Backing up existing file: $file"
        mkdir -p "$BACKUP_DIR"
        cp -L "$file" "$BACKUP_DIR/$(basename "$file")" 2>/dev/null || true
    fi
}

# =============================================================================
# Installation Steps
# =============================================================================

step_welcome() {
    clear
    print_header "Welcome to Linkarzu's Dotfiles Installation"
    
    cat << 'EOF'
This script will help you install a complete macOS development environment
including:

📦 Package Management (Homebrew)
🐚 Shell Configuration (Zsh with custom modules)
🖥️  Terminal Emulators (Ghostty, Kitty, Alacritty, Wezterm)
✏️  Editor Setup (Neovim with Neobean config)
🪟 Window Management (Yabai + SketchyBar)
🎨 Color Scheme System
🔧 Development Tools (tmux, lazygit, fzf, etc.)

⚠️  IMPORTANT NOTES:
- This will modify your shell configuration
- Existing configs will be backed up
- You can choose which components to install
- The process may take 15-30 minutes

EOF

    if ! confirm_action "Do you want to continue with the installation?"; then
        print_info "Installation cancelled by user."
        exit 0
    fi
}

step_check_os() {
    print_header "System Check"
    
    print_step "Checking operating system..."
    
    if [[ "$(uname -s)" != "Darwin" ]]; then
        print_error "This script is designed for macOS only."
        print_info "While the dotfiles support Linux, this installer is macOS-specific."
        exit 1
    fi
    
    print_success "macOS detected"
    
    # Check macOS version
    local macos_version=$(sw_vers -productVersion)
    print_info "macOS version: $macos_version"
    
    # Check if running on Apple Silicon or Intel
    local arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        print_info "Apple Silicon (M1/M2/M3) detected"
    else
        print_info "Intel Mac detected"
    fi
}

step_install_xcode_tools() {
    print_header "Xcode Command Line Tools"
    
    print_step "Checking for Xcode Command Line Tools..."
    
    if ! xcode-select -p >/dev/null 2>&1; then
        print_warning "Xcode Command Line Tools not found"
        print_step "Installing Xcode Command Line Tools..."
        
        # Trigger the installation
        xcode-select --install
        
        print_info "Please complete the Xcode Command Line Tools installation in the popup window."
        print_info "Press any key after the installation is complete..."
        read -n 1 -s
        
        # Verify installation
        if ! xcode-select -p >/dev/null 2>&1; then
            print_error "Xcode Command Line Tools installation failed or incomplete"
            exit 1
        fi
    fi
    
    print_success "Xcode Command Line Tools are installed"
}

step_install_homebrew() {
    print_header "Homebrew Package Manager"
    
    print_step "Checking for Homebrew..."
    
    if ! check_command brew; then
        print_warning "Homebrew not found"
        
        if confirm_action "Install Homebrew? (Required for most tools)"; then
            print_step "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            
            # Verify installation
            if ! check_command brew; then
                print_error "Homebrew installation failed"
                exit 1
            fi
            
            print_success "Homebrew installed successfully"
        else
            print_warning "Skipping Homebrew installation (many features will not work)"
        fi
    else
        print_success "Homebrew is already installed"
        
        # Update Homebrew
        print_step "Updating Homebrew..."
        brew update
    fi
}

step_clone_dotfiles() {
    print_header "Cloning Dotfiles Repository"
    
    print_step "Setting up dotfiles directory..."
    
    # Create github directory if it doesn't exist
    mkdir -p "$HOME/github"
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        print_warning "Dotfiles directory already exists: $DOTFILES_DIR"
        
        if confirm_action "Remove existing directory and re-clone?"; then
            rm -rf "$DOTFILES_DIR"
        else
            print_step "Updating existing repository..."
            cd "$DOTFILES_DIR"
            git pull origin main
            print_success "Repository updated"
            return 0
        fi
    fi
    
    print_step "Cloning dotfiles repository..."
    
    if ! git clone "$DOTFILES_REPO" "$DOTFILES_DIR"; then
        print_error "Failed to clone dotfiles repository"
        print_info "Please check your internet connection and try again"
        exit 1
    fi
    
    print_success "Dotfiles repository cloned successfully"
    
    # Verify the clone
    if [[ ! -f "$DOTFILES_DIR/README.md" ]]; then
        print_error "Repository clone appears incomplete"
        exit 1
    fi
}

step_install_packages() {
    print_header "Installing Packages"
    
    if ! check_command brew; then
        print_warning "Homebrew not available, skipping package installation"
        return 0
    fi
    
    local brewfiles=(
        "$DOTFILES_DIR/brew/00-base/Brewfile"
        "$DOTFILES_DIR/brew/10-essential/Brewfile"
        "$DOTFILES_DIR/brew/15-nice-to-haves/Brewfile"
        "$DOTFILES_DIR/brew/20-optional/Brewfile"
    )
    
    local brewfile_names=(
        "Base packages (essential system tools)"
        "Essential packages (development tools)"
        "Nice-to-have packages (productivity tools)"
        "Optional packages (additional utilities)"
    )
    
    for i in "${!brewfiles[@]}"; do
        local brewfile="${brewfiles[$i]}"
        local name="${brewfile_names[$i]}"
        
        if [[ -f "$brewfile" ]]; then
            echo -e "\n${CYAN}Package Category: $name${NC}"
            
            if confirm_action "Install this package category?" "y"; then
                print_step "Installing packages from $(basename "$(dirname "$brewfile")")/Brewfile..."
                
                if brew bundle --file="$brewfile"; then
                    print_success "Package category installed successfully"
                else
                    print_warning "Some packages may have failed to install"
                    if ! confirm_action "Continue with installation?"; then
                        exit 1
                    fi
                fi
            else
                print_info "Skipping package category: $name"
            fi
        else
            print_warning "Brewfile not found: $brewfile"
        fi
    done
}

step_setup_shell() {
    print_header "Shell Configuration"
    
    print_step "Setting up Zsh configuration..."
    
    # Backup existing zshrc
    if [[ -f "$HOME/.zshrc" ]]; then
        backup_file "$HOME/.zshrc"
        print_info "Existing .zshrc backed up"
    fi
    
    # Create symlink to dotfiles zshrc
    print_step "Creating symlink to dotfiles zshrc..."
    ln -snf "$DOTFILES_DIR/zshrc/zshrc-file.sh" "$HOME/.zshrc"
    
    print_success "Shell configuration linked"
    
    # Set Zsh as default shell if not already
    if [[ "$SHELL" != "/bin/zsh" ]] && [[ "$SHELL" != "/usr/bin/zsh" ]]; then
        if confirm_action "Set Zsh as your default shell?"; then
            chsh -s /bin/zsh
            print_success "Default shell changed to Zsh"
        fi
    fi
}

step_setup_neovim() {
    print_header "Neovim Configuration"
    
    if ! check_command nvim; then
        print_warning "Neovim not installed, skipping configuration"
        return 0
    fi
    
    print_step "Setting up Neobean Neovim configuration..."
    
    local nvim_config_dir="$HOME/.config/linkarzu/dotfiles-latest/neovim/neobean"
    
    if [[ -d "$nvim_config_dir" ]]; then
        print_info "Neobean config already exists"
    else
        print_step "Creating Neovim config directory..."
        mkdir -p "$(dirname "$nvim_config_dir")"
        
        # The config should already be there from the git clone
        if [[ -d "$DOTFILES_DIR/neovim/neobean" ]]; then
            ln -snf "$DOTFILES_DIR/neovim" "$HOME/.config/linkarzu/dotfiles-latest/neovim"
            print_success "Neobean configuration linked"
        else
            print_error "Neobean configuration not found in dotfiles"
            return 1
        fi
    fi
    
    # Create alias for easy access
    local alias_line='alias neobean="NVIM_APPNAME=linkarzu/dotfiles-latest/neovim/neobean nvim"'
    
    if ! grep -q "alias neobean=" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Neobean Neovim configuration alias" >> "$HOME/.zshrc"
        echo "$alias_line" >> "$HOME/.zshrc"
        print_success "Neobean alias added to .zshrc"
    fi
    
    print_info "You can now use 'neobean' command to launch Neovim with the configuration"
    print_info "First launch will install plugins automatically (this may take a few minutes)"
}

step_setup_terminal_configs() {
    print_header "Terminal Emulator Configurations"
    
    local terminals=("ghostty" "kitty" "alacritty" "wezterm")
    
    for terminal in "${terminals[@]}"; do
        if [[ -d "$DOTFILES_DIR/$terminal" ]]; then
            print_step "Setting up $terminal configuration..."
            
            local config_dir=""
            local config_file=""
            
            case "$terminal" in
                "ghostty")
                    config_dir="$HOME/.config/ghostty"
                    config_file="config"
                    ;;
                "kitty")
                    config_dir="$HOME/.config/kitty"
                    config_file="kitty.conf"
                    ;;
                "alacritty")
                    config_dir="$HOME/.config/alacritty"
                    config_file="alacritty.toml"
                    ;;
                "wezterm")
                    config_dir="$HOME/.config/wezterm"
                    config_file="wezterm.lua"
                    ;;
            esac
            
            if [[ -n "$config_dir" ]]; then
                mkdir -p "$config_dir"
                
                # Backup existing config
                if [[ -f "$config_dir/$config_file" ]]; then
                    backup_file "$config_dir/$config_file"
                fi
                
                # Find the main config file in dotfiles
                local dotfiles_config=""
                for file in "$DOTFILES_DIR/$terminal"/*; do
                    if [[ -f "$file" ]] && [[ "$(basename "$file")" == "$config_file" || "$(basename "$file")" == "${terminal}.conf" || "$(basename "$file")" == "${terminal}.toml" ]]; then
                        dotfiles_config="$file"
                        break
                    fi
                done
                
                if [[ -n "$dotfiles_config" ]]; then
                    ln -snf "$dotfiles_config" "$config_dir/$config_file"
                    print_success "$terminal configuration linked"
                else
                    print_warning "Main config file not found for $terminal"
                fi
            fi
        else
            print_info "$terminal configuration not found in dotfiles"
        fi
    done
}

step_setup_color_scheme() {
    print_header "Color Scheme System"
    
    if [[ -d "$DOTFILES_DIR/colorscheme" ]]; then
        print_step "Setting up color scheme system..."
        
        # Make color scheme scripts executable
        find "$DOTFILES_DIR/colorscheme" -name "*.sh" -exec chmod +x {} \;
        
        print_success "Color scheme system ready"
        print_info "Use '$DOTFILES_DIR/colorscheme/colorscheme-selector.sh' to change themes"
    else
        print_warning "Color scheme system not found in dotfiles"
    fi
}

step_setup_window_management() {
    print_header "Window Management (Yabai + SketchyBar)"
    
    # Check if yabai and sketchybar are installed
    local yabai_installed=false
    local sketchybar_installed=false
    
    if check_command yabai; then
        yabai_installed=true
    fi
    
    if check_command sketchybar; then
        sketchybar_installed=true
    fi
    
    if [[ "$yabai_installed" == false ]] && [[ "$sketchybar_installed" == false ]]; then
        print_warning "Yabai and SketchyBar not installed, skipping window management setup"
        print_info "Install them with: brew install koekeishiya/formulae/yabai FelixKratz/formulae/sketchybar"
        return 0
    fi
    
    # Setup Yabai
    if [[ "$yabai_installed" == true ]] && [[ -f "$DOTFILES_DIR/yabai/yabairc" ]]; then
        print_step "Setting up Yabai configuration..."
        
        local yabai_config_dir="$HOME/.config/yabai"
        mkdir -p "$yabai_config_dir"
        
        backup_file "$yabai_config_dir/yabairc"
        ln -snf "$DOTFILES_DIR/yabai/yabairc" "$yabai_config_dir/yabairc"
        chmod +x "$yabai_config_dir/yabairc"
        
        print_success "Yabai configuration linked"
    fi
    
    # Setup SketchyBar
    if [[ "$sketchybar_installed" == true ]] && [[ -d "$DOTFILES_DIR/sketchybar" ]]; then
        print_step "Setting up SketchyBar configuration..."
        
        local sketchybar_config_dir="$HOME/.config/sketchybar"
        
        if [[ -d "$sketchybar_config_dir" ]]; then
            backup_file "$sketchybar_config_dir"
        fi
        
        ln -snf "$DOTFILES_DIR/sketchybar" "$sketchybar_config_dir"
        
        # Make scripts executable
        find "$sketchybar_config_dir" -name "*.sh" -exec chmod +x {} \;
        
        print_success "SketchyBar configuration linked"
    fi
    
    print_info "Window management tools require additional setup:"
    print_info "1. Grant accessibility permissions in System Preferences"
    print_info "2. Disable System Integrity Protection for advanced features"
    print_info "3. Start services: 'yabai --start-service' and 'sketchybar --start-service'"
}

step_final_setup() {
    print_header "Final Setup and Verification"
    
    print_step "Creating useful aliases and functions..."
    
    # Add pulldeez alias if not present
    local pulldeez_alias='alias pulldeez="cd ~/github/dotfiles-latest && git pull && source ~/.zshrc && cd -"'
    
    if ! grep -q "alias pulldeez=" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Dotfiles update alias" >> "$HOME/.zshrc"
        echo "$pulldeez_alias" >> "$HOME/.zshrc"
        print_success "Added 'pulldeez' alias for updating dotfiles"
    fi
    
    print_step "Setting up tmux configuration..."
    if [[ -f "$DOTFILES_DIR/tmux/tmux.conf" ]]; then
        backup_file "$HOME/.tmux.conf"
        ln -snf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
        print_success "tmux configuration linked"
    fi
    
    print_step "Verifying installation..."
    
    local verification_passed=true
    
    # Check if main components are working
    if [[ ! -f "$HOME/.zshrc" ]]; then
        print_error "Zsh configuration not found"
        verification_passed=false
    fi
    
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_error "Dotfiles directory not found"
        verification_passed=false
    fi
    
    if [[ "$verification_passed" == true ]]; then
        print_success "Installation verification passed"
    else
        print_error "Installation verification failed"
        return 1
    fi
}

step_completion() {
    print_header "Installation Complete!"
    
    cat << EOF

🎉 Congratulations! Your dotfiles installation is complete.

📋 What was installed:
   ✅ Dotfiles repository cloned to ~/github/dotfiles-latest
   ✅ Shell configuration (Zsh) linked
   ✅ Package management (Homebrew packages)
   ✅ Terminal emulator configurations
   ✅ Neovim configuration (Neobean)
   ✅ Color scheme system
   ✅ Development tools and utilities

🚀 Next steps:
   1. Restart your terminal or run: source ~/.zshrc
   2. Launch Neovim with: neobean
   3. Explore color schemes: ~/github/dotfiles-latest/colorscheme/colorscheme-selector.sh
   4. Update dotfiles anytime with: pulldeez

📚 Useful commands:
   - neobean          # Launch Neovim with Neobean config
   - pulldeez         # Update dotfiles and reload shell
   - z <directory>    # Smart directory navigation with zoxide
   - eza -la --icons  # Enhanced file listing

⚠️  Important notes:
   - Some tools may require additional permissions (Yabai, SketchyBar)
   - First Neovim launch will install plugins (be patient)
   - Check ~/github/dotfiles-latest/README.md for detailed documentation

🔧 Backup location: $BACKUP_DIR

EOF

    if confirm_action "Would you like to restart your terminal now?"; then
        print_info "Please restart your terminal manually to apply all changes."
    fi
    
    print_success "Enjoy your new development environment! 🚀"
}

# =============================================================================
# Main Installation Flow
# =============================================================================

main() {
    # Trap to handle interruption
    trap 'print_error "Installation interrupted by user"; exit 1' INT
    
    # Run installation steps
    step_welcome
    step_check_os
    step_install_xcode_tools
    step_install_homebrew
    step_clone_dotfiles
    step_install_packages
    step_setup_shell
    step_setup_neovim
    step_setup_terminal_configs
    step_setup_color_scheme
    step_setup_window_management
    step_final_setup
    step_completion
}

# Run the main function
main "$@"