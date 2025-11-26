# pkg-aid

`pkg-aid` is a **universal package manager helper** for Linux.  
It provides a **friendly interface** for managing packages across multiple distributions, including Debian-based (APT), Red Hat-based (YUM/DNF), Arch-based (Pacman), and more.
---

## Features

- Install and remove packages with a single command
- Update package lists or upgrade system packages
- Upgrade individual packages
- Search for packages in repositories
- List installed packages
- Display files installed by a package
- Optional `--verbose` mode to show full command execution
- Automatically uses `sudo` when required

---

## Installation

```bash
git clone https://github.com/itsjustjeremiiii/pkg-aid.git
cd pkg-aid
chmod +x pkg-aid 
./install.sh
```

## Removal
```bash
sudo rm /usr/local/bin/pkg-aid
```

## Usage

```bash
pkg-aid [options] [command] [package]
``` 

## Examples

### Install a package

```bash
pkg-aid install [package]
```
### Remove a package

```bash
pkg-aid remove [package]
```
### Update package lists
```bash
pkg-aid update
```
### Upgrade system packages
```bash
pkg-aid upgrade
```
### Search for a package
```bash
pkg-aid search [package]
```
### List installed packages
```bash
pkg-aid list
```
### Display files installed by a package
```bash
pkg-aid files [package]
```
### Using `--verbose` flag
```bash
pkg-aid --verbose install [package]
```
---
## Supported Package Managers
- APT (Debian, Ubuntu, etc.)
- YUM/DNF (Red Hat, CentOS, Fedora, etc.)
- Pacman (Arch, Manjaro, CachyOS,etc.)
- Zypper (openSUSE)
- APK (Alpine)
- XBPS (Void)
- Emerge (Gentoo)
- Nix (NixOS)

---
