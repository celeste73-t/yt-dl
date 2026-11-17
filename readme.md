# yt-dl

A small wrapper around [yt-dlp](https://github.com/yt-dlp/yt-dlp) to download audio or video with a single command, usable from any shell (bash, zsh, fish...).

## Features

- `yt-dl audio <url>`: extracts the audio (mp3 by default) with embedded metadata
- `yt-dl video <url>`: downloads the best video **up to a maximum height** (1080p by default). If that quality isn't available, it falls back to the best one below it, but never goes above the limit.
- Simple config file, with built-in defaults if it's missing
- Automatic installation of dependencies (`yt-dlp`, `ffmpeg`)

## Installation

```bash
git clone https://github.com/celeste73-t/yt-dl yt-dl
cd yt-dl
chmod +x install.sh
./install.sh
```

The install script:

1. copies `yt-dl` to `~/.local/bin`
2. creates `~/.config/yt-dl/config` with default values (without overwriting an existing config)
3. installs `ffmpeg` and `yt-dlp` if they're missing
4. adds `~/.local/bin` to your `PATH` if needed (`.profile`, `.bashrc`, `.zshrc`, fish)

Then open a new terminal so the `PATH` change takes effect.

### Supported package managers

`pacman`, `apt`, `dnf`, `brew`. On Debian/Ubuntu/Fedora, `yt-dlp` is downloaded from the official releases, because distro packages are often too old to keep up with YouTube changes.

## Usage

```bash
yt-dl audio "https://www.youtube.com/watch?v=XXXXXXXXXXX"
yt-dl video "https://www.youtube.com/watch?v=XXXXXXXXXXX"
```

Files are created in the current directory, named after the video title.

> Wrap the URL in quotes: a URL containing `&` (for example `&list=...`) would otherwise be split by the shell.

## Configuration

File: `~/.config/yt-dl/config` (or `$XDG_CONFIG_HOME/yt-dl/config`)

```bash
audioFormat="wav"
videoFormat="mp4"
maxHeight=1080
```

| Variable      | Description                                          | Default |
|---------------|------------------------------------------------------|---------|
| `audioFormat` | Audio output format (`mp3`, `m4a`, `opus`...)        | `wav`   |
| `videoFormat` | Video output container (`mp4`, `mkv`...)             | `mp4`   |
| `maxHeight`   | Maximum height in pixels (`720`, `1080`, `1440`, `2160`) | `1080`  |

The file is loaded with `source`, so it should only be writable by you.

## Updating

- **The script**: re-run `./install.sh` (your existing config is kept).
- **yt-dlp**: `yt-dlp -U` if installed via the official binary, otherwise use your package manager.

## Uninstalling

```bash
rm ~/.local/bin/yt-dl
rm -r ~/.config/yt-dl
```

## Troubleshooting

| Problem | What to check |
|---------|---------------|
| `yt-dl: command not found` | Open a new terminal, or check that `~/.local/bin` is in your `PATH` |
| Error during mp3 extraction or video merging | `ffmpeg` is not installed |
| YouTube download errors | Update `yt-dlp` |

## Dependencies

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [ffmpeg](https://ffmpeg.org/)
- bash, curl