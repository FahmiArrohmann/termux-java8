#!/data/data/com.termux/files/usr/bin/bash
set -e

TARBALL="$1"
[ -f "$TARBALL" ] || { echo "Usage: $0 /path/to/jdk8-arm64-*.tar.xz"; exit 1; }
TARBALL=$(realpath "$TARBALL")

echo "[*] Removing old install..."
rm -rf "$PREFIX/share/java-8"
mkdir -p "$PREFIX/share/java-8"

echo "[*] Extracting..."
tar -xJf "$TARBALL" -C "$PREFIX/share/java-8" --strip-components=1

# --- fish ---
FISH_CONF="$HOME/.config/fish/config.fish"
mkdir -p "$(dirname "$FISH_CONF")"
touch "$FISH_CONF"

echo "[*] Cleaning old Java lines from fish config..."
grep -v 'JAVA_HOME\|java-8\|JAVA_HOME/bin' "$FISH_CONF" > "$FISH_CONF.tmp" || true
mv "$FISH_CONF.tmp" "$FISH_CONF"

echo "[*] Appending Java 8 config..."
cat >> "$FISH_CONF" <<'FISHEOF'

# --- Java 8 (added by termux-setup.sh) ---
set -gx JAVA_HOME $PREFIX/share/java-8
set -gx PATH $JAVA_HOME/bin $PATH
set -gx LD_LIBRARY_PATH $JAVA_HOME/lib/aarch64/jli $JAVA_HOME/lib/aarch64 $LD_LIBRARY_PATH
FISHEOF

# --- bash (login shells) ---
PROFILE="$PREFIX/etc/profile.d/java.sh"
mkdir -p "$(dirname "$PROFILE")"
cat > "$PROFILE" <<'SHEOF'
# --- Java 8 (added by termux-setup.sh) ---
export JAVA_HOME=$PREFIX/share/java-8
export PATH=$JAVA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$JAVA_HOME/lib/aarch64/jli:$JAVA_HOME/lib/aarch64:$LD_LIBRARY_PATH
SHEOF

echo "[*] Verifying..."
"$PREFIX/share/java-8/bin/java" -version

echo "[*] Done. Restart Termux or run: source ~/.config/fish/config.fish"
