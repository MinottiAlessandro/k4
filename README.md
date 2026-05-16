## What `k4` is

A single-file bash CLI that wraps `scp`/`ssh` to push files to a Kindle running KOReader.

## Files

- `k4` — the script. Single file, no sourced helpers.
- `install.sh` — copies `k4` to `$PREFIX/bin` (default `~/.local/bin`) and warns about missing runtime deps.
- `k4.config.example` — example config to drop at `~/.config/k4.config`.
- `claude.md` — original prose spec (lowercase). Source of truth for intent.

## Setting up defaults
Copy k4.config.example to ~/.config/k4.config and adjust.
