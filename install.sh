#!/usr/bin/env bash

# Self-install
SELF_INSTALL_PATH="/usr/local/bin/pkg-aid"

show_usage() {
	cat <<EOF
Usage: ./install.sh [--install|--uninstall|--help]

Options:
  --install, -i     Copy the 'pkg-aid' program from this repo to $SELF_INSTALL_PATH
  --uninstall, -u   Remove $SELF_INSTALL_PATH (requires sudo)
  --help, -h        Show this help message

If no option is provided the script will perform --install (backwards compatible).
EOF
}

install_pkg_aid() {
	if [ ! -f "$(dirname "$0")/pkg-aid" ]; then
		echo "Error: pkg-aid program not found in the repository."
		exit 1
	fi
	echo "Installing pkg-aid to $SELF_INSTALL_PATH..."
	sudo cp "$(dirname "$0")/pkg-aid" "$SELF_INSTALL_PATH"
	sudo chmod +x "$SELF_INSTALL_PATH"
	echo "Installed as 'pkg-aid'. You can now run: pkg-aid --help"
}

uninstall_pkg_aid() {
	if [ -f "$SELF_INSTALL_PATH" ]; then
		echo "Removing $SELF_INSTALL_PATH..."
		sudo rm -f "$SELF_INSTALL_PATH"
		echo "Removed $SELF_INSTALL_PATH"
	else
		echo "$SELF_INSTALL_PATH does not exist; nothing to do."
	fi
}

# Parse installer flags
case "$1" in
	--install|-i)
		install_pkg_aid
		exit 0
		;;
	--uninstall|-u)
		uninstall_pkg_aid
		exit 0
		;;
	--help|-h)
		show_usage
		exit 0
		;;
	"")
		# Default (No flag)
		install_pkg_aid
		exit 0
		;;
	*)
		# Unknown flag
		show_usage
		exit 1
		;;
esac

# Check whether package manager supports --verbose
check_verbose() {
	v=""
	($1 --verbose --help >/dev/null 2>&1) && v="--verbose"
}

# Detect package manager
x=$(
	command -v apt-get ||
	command -v dnf ||
	command -v yum ||
	command -v pacman ||
	command -v zypper ||
	command -v apk ||
	command -v eopkg
)

c=$1
shift

if [ "$c" = install ]; then
	check_verbose "$x"
	if [ "$x" = "$(command -v apt-get)" ]; then
		sudo apt-get install $v "$@"
	elif [ "$x" = "$(command -v dnf)" ]; then
		sudo dnf install $v "$@"
	elif [ "$x" = "$(command -v yum)" ]; then
		sudo yum install $v "$@"
	elif [ "$x" = "$(command -v pacman)" ]; then
		sudo pacman $v -S "$@"
	elif [ "$x" = "$(command -v zypper)" ]; then
		sudo zypper install "$@"
	elif [ "$x" = "$(command -v apk)" ]; then
		sudo apk add "$@"
	elif [ "$x" = "$(command -v eopkg)" ]; then
		sudo eopkg install "$@"
	fi
fi

if [ "$c" = remove ]; then
	check_verbose "$x"
	if [ "$x" = "$(command -v apt-get)" ]; then
		sudo apt-get remove $v "$@"
	elif [ "$x" = "$(command -v dnf)" ]; then
		sudo dnf remove $v "$@"
	elif [ "$x" = "$(command -v yum)" ]; then
		sudo yum remove $v "$@"
	elif [ "$x" = "$(command -v pacman)" ]; then
		sudo pacman $v -R "$@"
	elif [ "$x" = "$(command -v zypper)" ]; then
		sudo zypper remove "$@"
	elif [ "$x" = "$(command -v apk)" ]; then
		sudo apk del "$@"
	elif [ "$x" = "$(command -v eopkg)" ]; then
		sudo eopkg remove "$@"
	fi
fi
