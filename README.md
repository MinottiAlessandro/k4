# k4

A single-file bash CLI that pushes files to a Kindle running [KOReader](https://github.com/koreader/koreader) over SSH — books, wallpapers, lua patches, and SSH keys.

No language runtime, no dependencies beyond what `openssh-client` already gives you. It's just `scp` and `ssh`, wrapped to know where things go on the device.

## Install

```sh
git clone https://github.com/MinottiAlessandro/k4
cd k4
./install.sh
```

This copies `k4` to `~/.local/bin` (override with `PREFIX=...`) and warns about anything missing.

**Requirements:** `ssh`, `scp`, `ssh-keygen`, `file` (all from `openssh-client` + `file`). `luac` (from the `lua` package) is only needed for `add-patch`, and `git` only for `update`.

## Configure

Copy the example config and edit it:

```sh
cp k4.config.example ~/.config/k4.config
```

```sh
ip="192.168.1.100"
port="22"
user="root"
```

The file is sourced as shell — use lowercase keys. Remote paths can be overridden too (see the example file). Command-line flags override config values.

## Usage

```sh
k4 [SUBCOMMAND] [OPTIONS] [PATH]
```

| Subcommand | Alias | What it does |
|---|---|---|
| `book` | `b` | Upload a book to `/mnt/us/documents/` (default) |
| `authorized-key` | `a` | Append a public key to KOReader's `authorized_keys` |
| `wallpaper` | `w` | Upload an image to `/mnt/us/wallpaper/` |
| `add-patch` | `p` | Upload a lua patch to `/mnt/us/koreader/patches/` |
| `check` | `c` | Test the connection and report which remote dirs exist |
| `update` | `u` | Pull the latest `k4` from your clone and reinstall |

### Examples

```sh
# Send a book (book is the default, so the subcommand is optional)
k4 my-novel.epub
k4 book my-novel.epub

# Authorize your SSH key on the device
k4 authorized-key ~/.ssh/id_ed25519.pub

# Set a wallpaper
k4 w cover.png

# Add a KOReader patch (filename must be '<digits>-<name>.lua')
k4 add-patch 2-dark-mode.lua

# Check connectivity and remote directories
k4 check

# Update k4 itself (git pull on your clone, then reinstall)
k4 update

# Upload every top-level file in a directory
k4 book -r ~/Downloads/epubs/
```

## Options

| Flag | Effect |
|---|---|
| `--ip <addr>` | Device IP (required unless set in config) |
| `--port <port>` | SSH port (default `22`) |
| `--user <user>` | SSH user (default `root`) |
| `--recursive`, `-r` | Treat PATH as a directory and upload its top-level files |
| `--yes`, `-y` | Auto-create missing remote directories without prompting |
| `--help`, `-h` | Show help |

## Notes

- **Validation runs locally first.** Wallpapers must be images, patches must be valid lua named `<digits>-<name>.lua` (e.g. `123-my_patch.lua`), and keys must parse as SSH public keys — checked before anything touches the network.
- **Recursive uploads** cover top-level files only (subdirectories are skipped). Files that fail validation are reported and skipped; the rest go up in a single `scp` connection.
- **Missing remote directories** prompt you to create them, or pass `--yes` to create automatically.
- **`update`** does a fast-forward `git pull` on the clone you installed from, then re-runs `install.sh`. It refuses if that clone has uncommitted changes, and does nothing if you're already up to date.

## License

MIT
