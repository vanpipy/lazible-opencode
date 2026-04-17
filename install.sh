#!/bin/bash
#
# install.sh - Lazible OpenCode Config Installer
#
# This script handles installation and post-setup for packages that OpenCode
# cannot fully auto-configure (e.g., skill discovery, symlinks, etc.).
#
# Usage:
#   ./install.sh              # Run all installation steps
#   ./install.sh --skills     # Only setup skill symlinks
#   ./install.sh --verify     # Only verify installation
#
# OpenCode's skill tool discovers skills from:
#   - ~/.config/openills (user global skills)
#   - ./.opencode/skills (project-local skills)
#
# However, some npm packages (like superpowers) install skills to their own
# node_modules path, which OpenCode doesn't auto-discover. This script
# creates symlinks to make those skills visible to OpenCode.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${OPENCODE_CONFIG_DIR:-$HOME/.config/opencode}"
SKILLS_DIR="$CONFIG_DIR/skills"
NODE_MODULES="$CONFIG_DIR/node_modules"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

#
# Install npm packages that are defined in package.json but not yet installed
#
install_npm_packages() {
    log_info "Installing npm packages..."

    if [ ! -f "$CONFIG_DIR/package.json" ]; then
        log_warn "No package.json found, skipping npm install"
        return
    fi

    cd "$CONFIG_DIR" && npm install
}

#
# Setup skill symlinks for packages that don't auto-register with OpenCode
#
# Some packages (like superpowers) install skills to node_modules/<package>/skills/
# but OpenCode only discovers skills from ~/.config/opencode/skills/ or
# ./.opencode/skills/. This function creates symlinks to bridge that gap.
#
setup_skill_symlinks() {
    log_info "Setting up skill symlinks..."

    mkdir -p "$SKILLS_DIR"

    # superpowers: https://github.com/obra/superpowers
    # Skills location: node_modules/superpowers/skills/
    if [ -d "$NODE_MODULES/superpowers/skills" ]; then
        if [ -L "$SKILLS_DIR/superpowers" ]; then
            log_info "Removing old superpowers symlink..."
            rm "$SKILLS_DIR/superpowers"
        fi
        log_info "Creating superpowers skill symlink..."
        ln -sf "$NODE_MODULES/superpowers/skills" "$SKILLS_DIR/superpowers"
    else
        log_warn "superpowers not found, skipping its skill symlink"
    fi

    # Add more packages here as needed, e.g.:
    # if [ -d "$NODE_MODULES/another-package/skills" ]; then
    #     ln -sf "$NODE_MODULES/another-package/skills" "$SKILLS_DIR/another-package"
    # fi
}

#
# Verify that skills are properly symlinked and discoverable
#
verify_installation() {
    log_info "Verifying installation..."

    local errors=0

    echo ""
    echo "=== Skills Directory ==="
    if [ -d "$SKILLS_DIR" ]; then
        ls -la "$SKILLS_DIR/"
    else
        log_error "Skills directory not found: $SKILLS_DIR"
        ((errors++))
    fi

    echo ""
    echo "=== Skill Symlinks ==="

    # Check superpowers
    if [ -L "$SKILLS_DIR/superpowers" ]; then
        target=$(readlink -f "$SKILLS_DIR/superpowers")
        if [ -d "$target" ]; then
            log_info "superpowers: OK ($target)"
            echo "  Contents: $(ls "$SKILLS_DIR/superpowers" | tr '\n' ' ')"
        else
            log_error "superpowers: BROKEN SYMLINK ($target not a directory)"
            ((errors++))
        fi
    else
        log_error "superpowers: NOT LINKED"
        ((errors++))
    fi

    echo ""
    if [ $errors -eq 0 ]; then
        log_info "Verification passed!"
        return 0
    else
        log_error "Verification failed with $errors error(s)"
        return 1
    fi
}

#
# Print usage
#
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all       Run all installation steps (default)"
    echo "  --skills    Only setup skill symlinks"
    echo "  --verify    Only verify installation"
    echo "  --help      Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  OPENCODE_CONFIG_DIR  Override config directory (default: ~/.config/opencode)"
}

# Main
case "${1:---all}" in
    --all)
        install_npm_packages
        setup_skill_symlinks
        verify_installation
        ;;
    --skills)
        setup_skill_symlinks
        ;;
    --verify)
        verify_installation
        ;;
    --help)
        usage
        ;;
    *)
        log_error "Unknown option: $1"
        usage
        exit 1
        ;;
esac