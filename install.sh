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

VIVID_VERSION="0.11.1"
VIVID_URL="https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid-v${VIVID_VERSION}-x86_64-unknown-linux-gnu.tar.gz"

LOAD_LINE='[ -f "$HOME/.javenrc" ] && source "$HOME/.javenrc"'


########################################
# Output
########################################

info() {
    printf '\033[38;5;109m[Javen]\033[0m %s\n' "$1"
}

optional() {
    printf '\033[38;5;151m[Optional]\033[0m %s\n' "$1"
}

warn() {
    printf '\033[38;5;180m[Warning]\033[0m %s\n' "$1"
}

error() {
    printf '\033[38;5;181m[Error]\033[0m %s\n' "$1" >&2
}


########################################
# Install vivid enhancement
########################################

install_vivid() {

    if command -v vivid >/dev/null 2>&1; then
        optional "vivid already installed."
        return
    fi


    ARCH=$(uname -m)

    if [[ "$ARCH" != "x86_64" ]]; then
        optional "vivid skipped: unsupported architecture ($ARCH)."
        return
    fi


    optional "Installing vivid enhancement..."


    TMP_DIR=$(mktemp -d)

    if ! curl -fsSL "$VIVID_URL" -o "$TMP_DIR/vivid.tar.gz"; then
        warn "Failed to download vivid. Skipping."
        rm -rf "$TMP_DIR"
        return
    fi


    tar -xzf "$TMP_DIR/vivid.tar.gz" -C "$TMP_DIR"


    if [[ ! -f "$TMP_DIR/vivid-v${VIVID_VERSION}-x86_64-unknown-linux-gnu/vivid" ]]; then
        warn "vivid binary not found. Skipping."
        rm -rf "$TMP_DIR"
        return
    fi


    install -m 755 \
        "$TMP_DIR/vivid-v${VIVID_VERSION}-x86_64-unknown-linux-gnu/vivid" \
        /usr/local/bin/vivid


    rm -rf "$TMP_DIR"


    optional "vivid installed successfully."
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
# Install enhancements
########################################

install_vivid



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

printf '\n'

printf '    source ~/.bashrc\n'

printf '\n'