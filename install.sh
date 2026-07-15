#!/usr/bin/env bash

set -Eeuo pipefail

########################################
# Javen Dotfiles Installer
########################################

REPO_OWNER="zjw27"
REPO_NAME="javen-dotfiles"
BRANCH="main"

BASE_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}"

JAVENRC_URL="${BASE_URL}/javenrc"
JAVENRC_PATH="${HOME}/.javenrc"
BASHRC_PATH="${HOME}/.bashrc"

LOAD_LINE='[ -f "$HOME/.javenrc" ] && source "$HOME/.javenrc"'

info() {
    printf '\033[38;5;109m[Javen]\033[0m %s\n' "$1"
}

warn() {
    printf '\033[38;5;180m[Warning]\033[0m %s\n' "$1"
}

error() {
    printf '\033[38;5;181m[Error]\033[0m %s\n' "$1" >&2
}

########################################
# Check environment
########################################

if ! command -v apt-get >/dev/null 2>&1; then
    error "This version currently supports Debian and Ubuntu only."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    info "Installing curl..."
    apt-get update
    apt-get install -y curl
fi

########################################
# Install packages
########################################

info "Updating package index..."
apt-get update

info "Installing grc, bat and ccze..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    grc \
    bat \
    ccze

########################################
# Backup existing config
########################################

if [[ -f "$JAVENRC_PATH" ]]; then
    BACKUP_PATH="${JAVENRC_PATH}.backup.$(date +%Y%m%d-%H%M%S)"
    info "Backing up existing configuration:"
    info "$BACKUP_PATH"
    cp "$JAVENRC_PATH" "$BACKUP_PATH"
fi

########################################
# Download javenrc
########################################

info "Downloading Javen configuration..."

curl -fsSL "$JAVENRC_URL" -o "$JAVENRC_PATH"

chmod 644 "$JAVENRC_PATH"

########################################
# Load javenrc from bashrc
########################################

touch "$BASHRC_PATH"

if ! grep -Fqx "$LOAD_LINE" "$BASHRC_PATH"; then
    info "Adding loader to ~/.bashrc..."

    {
        printf '\n'
        printf '%s\n' '# Javen Dotfiles'
        printf '%s\n' "$LOAD_LINE"
    } >> "$BASHRC_PATH"
else
    info "~/.bashrc already loads ~/.javenrc."
fi

########################################
# Finish
########################################

printf '\n'
info "Installation completed."
info "Run the following command to apply it immediately:"
printf '\n'
printf '    source ~/.bashrc\n'
printf '\n'