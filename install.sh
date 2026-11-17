#!/bin/bash
set -e

srcDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
binDir="$HOME/.local/bin"
configDir="${XDG_CONFIG_HOME:-$HOME/.config}/yt-dl"
configFile="$configDir/config"

# --- 1. Installer le script ---
mkdir -p "$binDir"
install -m 755 "$srcDir/yt-dl" "$binDir/yt-dl"
echo "yt-dl installé dans $binDir"

# --- 2. Config par défaut (sans écraser l'existante) ---
mkdir -p "$configDir"
if [ ! -f "$configFile" ]; then
	cat > "$configFile" <<'EOF'
audioFormat="wav"
videoFormat="mp4"
maxHeight=1080
EOF
	echo "Config créée : $configFile"
else
	echo "Config déjà présente, conservée : $configFile"
fi

# --- 3. Dépendances : ffmpeg + yt-dlp ---
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

install_pkg() {
	if command -v pacman >/dev/null; then $SUDO pacman -S --needed --noconfirm "$@"
	elif command -v apt-get >/dev/null; then $SUDO apt-get update && $SUDO apt-get install -y "$@"
	elif command -v dnf >/dev/null; then $SUDO dnf install -y "$@"
	elif command -v brew >/dev/null; then brew install "$@"
	else return 1
	fi
}

if ! command -v ffmpeg >/dev/null; then
	echo "→ Installation de ffmpeg..."
	install_pkg ffmpeg || echo "✘ Installe ffmpeg manuellement (requis pour mp3 et fusion vidéo)."
fi

if ! command -v yt-dlp >/dev/null; then
	echo "→ Installation de yt-dlp..."
	if command -v pacman >/dev/null || command -v brew >/dev/null; then
		install_pkg yt-dlp
	else
		# binaire officiel (les paquets apt/dnf sont souvent trop vieux pour YouTube)
		curl -fL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
			-o "$binDir/yt-dlp"
		chmod +x "$binDir/yt-dlp"
	fi
fi

# --- 4. ~/.local/bin dans le PATH, pour tous les shells ---
case ":$PATH:" in
*":$binDir:"*) ;;
	*)
		line='export PATH="$HOME/.local/bin:$PATH"'
		for rc in "$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc"; do
			[ -f "$rc" ] && ! grep -qF '.local/bin' "$rc" && echo "$line" >> "$rc"
		done
		command -v fish >/dev/null && fish -c "fish_add_path $binDir"
		echo "PATH mis à jour, ouvre un nouveau terminal."
		;;
esac

echo "Instalation ended. Try : yt-dl video <url>"