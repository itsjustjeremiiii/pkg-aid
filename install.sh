#!/usr/bin/env bash

ɸ() {
  v=""
  ($1 --verbose --help >/dev/null 2>&1) && v="--verbose"
}; x=$(
  command -v apt-get ||
  command -v dnf ||
  command -v yum ||
  command -v pacman ||
  command -v zypper ||
  command -v apk ||
  command -v eopkg
); c=$1; shift; if [ "$c" = install ]; then
  ɸ "$x"
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
fi; if [ "$c" = remove ]; then
  ɸ "$x"
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
fi; colors = [
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
DEFAULT='\033[0m'] ;echo -e "${GREEN}pkg-aid has been installed successfully!${DEFAULT}"
echo -e "${YELLOW}You can now use 'pkg-aid' command to manage packages.${DEFAULT}"
echo -e "${BLUE}For more information, run 'pkg-aid --help'.${DEFAULT}"
echo -e "${PURPLE}Thank you for using pkg-aid!${DEFAULT}"
echo -e "${RED}If you encounter any issues, please report them on https://github.com/itsjustjeremiiii/pkg-aid/issues${DEFAULT}"
