#!/usr/bin/env bash
# Usage: pkg-aid [options] <command> [package(s)]

set -e

VERSION="0.2.1"
CONFIG_FILE="$HOME/.config/pkg-aid/config"
CUSTOM_PM=""
VERBOSE=false
PM=""

# Bedrock
is_bedrock() { [[ -f /bedrock || -f /etc/bedrock-release ]]; }

list_pm() {
    local available=()
    for pm in apt-get dnf yum pacman zypper apk xbps-install emerge nix-env; do
        command -v $pm &>/dev/null && available+=($pm)
    done
    echo "${available[@]}"
}

choose_pm() {
    local pms=($(list_pm))
    if [ ${#pms[@]} -eq 0 ]; then
        echo "No supported package managers found in Bedrock strata."
        exit 1
    elif [ ${#pms[@]} -eq 1 ]; then
        PM="${pms[0]}"
    else
        echo "Multiple package managers detected. Choose one:"
        select pm_choice in "${pms[@]}"; do
            [[ -n "$pm_choice" ]] && { PM="$pm_choice"; break; }
        done
    fi
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo "PM=$PM" > "$CONFIG_FILE"
}

load_pm_choice() { [[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"; }

# PM Detector
detect_pm() {
    load_pm_choice
    if [[ -n "$CUSTOM_PM" ]]; then
        PM="$CUSTOM_PM"
    elif is_bedrock && [[ -z "$PM" ]]; then
        choose_pm
    elif command -v apt-get &>/dev/null; then
        PM="apt"
    elif command -v dnf &>/dev/null; then
        PM="dnf"
    elif command -v yum &>/dev/null; then
        PM="yum"
    elif command -v pacman &>/dev/null; then
        PM="pacman"
    elif command -v zypper &>/dev/null; then
        PM="zypper"
    elif command -v apk &>/dev/null; then
        PM="apk"
    elif command -v xbps-install &>/dev/null; then
        PM="xbps"
    elif command -v emerge &>/dev/null; then
        PM="emerge"
    elif command -v nix-env &>/dev/null; then
        PM="nix"
    else
        echo "No supported package manager found."
        exit 1
    fi
}

# Operations
install_package() {
    local pkgs=("$@")
    local flags=""
    $VERBOSE && flags+="--verbose "
    case $PM in
        apt)     sudo apt-get install -y $flags "${pkgs[@]}" ;;
        dnf)     sudo dnf install -y $flags "${pkgs[@]}" ;;
        yum)     sudo yum install -y $flags "${pkgs[@]}" ;;
        pacman)  sudo pacman -S --noconfirm $flags "${pkgs[@]}" ;;
        zypper)  sudo zypper install -y $flags "${pkgs[@]}" ;;
        apk)     sudo apk add $flags "${pkgs[@]}" ;;
        xbps)    sudo xbps-install -Sy $flags "${pkgs[@]}" ;;
        emerge)  sudo emerge $flags "${pkgs[@]}" ;;
        nix)     nix-env -iA nixpkgs."${pkgs[@]}" $flags ;;
    esac
}

remove_package() {
    local pkgs=("$@")
    local flags=""
    $VERBOSE && flags+="--verbose "
    case $PM in
        apt)     sudo apt-get remove -y $flags "${pkgs[@]}" ;;
        dnf)     sudo dnf remove -y $flags "${pkgs[@]}" ;;
        yum)     sudo yum remove -y $flags "${pkgs[@]}" ;;
        pacman)  sudo pacman -Rns --noconfirm $flags "${pkgs[@]}" ;;
        zypper)  sudo zypper remove -y $flags "${pkgs[@]}" ;;
        apk)     sudo apk del $flags "${pkgs[@]}" ;;
        xbps)    sudo xbps-remove -Ry $flags "${pkgs[@]}" ;;
        emerge)  sudo emerge --unmerge $flags "${pkgs[@]}" ;;
        nix)     nix-env -e "${pkgs[@]}" $flags ;;
    esac
}

update_system() {
    case $PM in
        apt)     sudo apt-get update ;;
        dnf)     sudo dnf check-update ;;
        yum)     sudo yum check-update ;;
        pacman)  sudo pacman -Sy ;;
        zypper)  sudo zypper refresh ;;
        apk)     sudo apk update ;;
        xbps)    sudo xbps-install -S ;;
        emerge)  sudo emerge --sync ;;
        nix)     nix-channel --update ;;
    esac
}

upgrade_system() {
    case $PM in
        apt)     sudo apt-get upgrade -y ;;
        dnf)     sudo dnf upgrade -y ;;
        yum)     sudo yum update -y ;;
        pacman)  sudo pacman -Syu --noconfirm ;;
        zypper)  sudo zypper update -y ;;
        apk)     sudo apk upgrade ;;
        xbps)    sudo xbps-install -Su ;;
        emerge)  sudo emerge --update --deep --with-bdeps=y @world ;;
        nix)     nix-env -u '*' ;;
    esac
}

search_package() {
    local pkg="$1"
    case $PM in
        apt)     apt-cache search "$pkg" ;;
        dnf)     dnf search "$pkg" ;;
        yum)     yum search "$pkg" ;;
        pacman)  pacman -Ss "$pkg" ;;
        zypper)  zypper search "$pkg" ;;
        apk)     apk search "$pkg" ;;
        xbps)    xbps-query -Rs "$pkg" ;;
        emerge)  emerge --search "$pkg" ;;
        nix)     nix-env -qaP "$pkg" ;;
    esac
}

list_installed() {
    case $PM in
        apt)     dpkg --get-selections ;;
        dnf)     dnf list installed ;;
        yum)     yum list installed ;;
        pacman)  pacman -Q ;;
        zypper)  zypper se --installed-only ;;
        apk)     apk info ;;
        xbps)    xbps-query -l ;;
        emerge)  emerge --list-sets ;;
        nix)     nix-env -q ;;
    esac
}

show_files() {
    local pkg="$1"
    case $PM in
        apt)     dpkg -L "$pkg" ;;
        dnf|yum|zypper) rpm -ql "$pkg" ;;
        pacman)  pacman -Ql "$pkg" ;;
        apk)     apk info -L "$pkg" ;;
        xbps)    xbps-query -L "$pkg" ;;
        emerge)  equery files "$pkg" ;;
        nix)     nix-env -q --out-path "$pkg" ;;
    esac
}

# Parse
ARGS=()
for ((i=1; i<=$#; i++)); do
    case "${!i}" in
        --version) echo "pkg-aid $VERSION"; exit 0 ;;
        --verbose) VERBOSE=true ;;
        --pm) i=$((i+1)); CUSTOM_PM="${!i}" ;;
        *) ARGS+=("${!i}") ;;
    esac
done

COMMAND="${ARGS[0]}"
PACKAGES=("${ARGS[@]:1}")

# Execute
detect_pm

case "$COMMAND" in
    install) install_package "${PACKAGES[@]}" ;;
    remove)  remove_package "${PACKAGES[@]}" ;;
    update)
        if [ ${#PACKAGES[@]} -eq 0 ]; then update_system; else install_package "${PACKAGES[@]}"; fi ;;
    upgrade)
        if [ ${#PACKAGES[@]} -eq 0 ]; then upgrade_system; else install_package "${PACKAGES[@]}"; fi ;;
    search)  search_package "${PACKAGES[0]}" ;;
    list)    list_installed ;;
    files)   show_files "${PACKAGES[0]}" ;;
    version) echo "pkg-aid $VERSION" ;;
    help|* ) cat <<EOF
Usage: pkg-aid [options] <command> [package(s)]

Options:
    --version     Show pkg-aid version
    --verbose     Show detailed output
    --pm <pm>     Use specific package manager (Bedrock Linux support)

Commands:
  install [pkg...]    Install one or more packages
  remove  [pkg...]    Remove one or more packages
  update  [pkg...]    Update specific packages or all
  upgrade [pkg...]    Upgrade specific packages or all
  search  <pkg>       Search for a package
  list                List installed packages
  files   <pkg>       Show files installed by a package
  help                Show this help message
EOF
    ;;
esac
