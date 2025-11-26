# pkg-aid

`pkg-aid` is a **universal package manager helper** for Linux.  
It provides a **simple and unified interface** for managing packages across various Linux distributions, including Debian-based (APT), Red Hat-based (YUM/DNF), Arch-based (Pacman), and more.

---

## Features

- Install and remove packages with a single command
- Update package lists or upgrade system packages
- Upgrade individual packages
- Search for packages in repositories
- List installed packages
- Display files installed by a package
- Optional `--verbose` mode to show detailed command execution
- Automatically uses `sudo` when required for required operations

---

## Installation

To install `pkg-aid`, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/itsjustjeremiiii/pkg-aid.git
    ```

2. Change to the `pkg-aid` directory:

    ```bash
    cd pkg-aid
    ```

3. Run the installer script:

    ```bash
    ./install.sh
    ```

You can also run the installer with optional flags:

- `--install`: Explicitly install `pkg-aid`
- `--uninstall`: Remove `pkg-aid` from `/usr/local/bin`
- `--help`: Show help information about the installer script

    ```bash
    ./install.sh --install
    ./install.sh --uninstall
    ./install.sh --help
    ```

If your shell cannot find `pkg-aid` after installation, refresh the command hash:

```bash
hash -r
```
