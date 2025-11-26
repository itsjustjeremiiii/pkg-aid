#!/usr/bin/env bash
ɸ(){ v="";($1 --verbose --help >/dev/null 2>&1)&&v="--verbose";};x=$(command -v apt-get||command -v dnf||command -v yum||command -v pacman||command -v zypper||command -v apk||command -v eopkg);c=$1;shift;[ "$c" = install ]&&ɸ "$x"&&{ [ "$x" = "$(command -v apt-get)" ]&&sudo apt-get install $v "$@"; [ "$x" = "$(command -v dnf)" ]&&sudo dnf install $v "$@"; [ "$x" = "$(command -v yum)" ]&&sudo yum install $v "$@"; [ "$x" = "$(command -v pacman)" ]&&sudo pacman $v -S "$@"; [ "$x" = "$(command -v zypper)" ]&&sudo zypper install "$@"; [ "$x" = "$(command -v apk)" ]&&sudo apk add "$@"; [ "$x" = "$(command -v eopkg)" ]&&sudo eopkg install "$@"; };[ "$c" = remove ]&&ɸ "$x"&&{ [ "$x" = "$(command -v apt-get)" ]&&sudo apt-get remove $v "$@"; [ "$x" = "$(command -v dnf)" ]&&sudo dnf remove $v "$@"; [ "$x" = "$(command -v yum)" ]&&sudo yum remove $v "$@"; [ "$x" = "$(command -v pacman)" ]&&sudo pacman $v -R "$@"; [ "$x" = "$(command -v zypper)" ]&&sudo zypper remove "$@"; [ "$x" = "$(command -v apk)" ]&&sudo apk del "$@"; [ "$x" = "$(command -v eopkg)" ]&&sudo eopkg remove "$@"; }

colors = [
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
DEFAULT='\033[0m']

echo -e "${GREEN}pkg-aid has been installed successfully!${DEFAULT}"; sleep 1
echo -e "${YELLOW}You can now use 'pkg-aid' command to manage packages.${DEFAULT}"; sleep 1
echo -e "${BLUE}For more information, run 'pkg-aid --help'.${DEFAULT}"; sleep 1
echo -e "${PURPLE}Thank you for using pkg-aid!${DEFAULT}"; sleep 1
echo -e "${RED}If you encounter any issues, please report them on https://github.com/itsjustjeremiiii/pkg-aid/issues${DEFAULT}"; sleep 1
