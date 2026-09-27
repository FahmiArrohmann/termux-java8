#!/data/data/com.termux/files/usr/bin/bash
# Auto-setup OpenJDK 8 di Termux
# Usage: ./termux-setup.sh /path/to/jdk8-arm64-YYYYMMDD-release.tar.xz

set -e

TARBALL="$1"
if [ -z "$TARBALL" ] || [ ! -f "$TARBALL" ]; then
    echo "Usage: $0 /path/to/jdk8-arm64-*.tar.xz"
    exit 1
fi

echo "[*] Extracting JDK to \$PREFIX/share/java-8 ..."
mkdir -p $PREFIX/share/java-8
cd $PREFIX/share/java-8
tar -xJf "$TARBALL"

echo "[*] Writing Fish shell config ..."
mkdir -p ~/.config/fish
cat > ~/.config/fish/config.fish << 'FISHEOF'
set -gx JAVA_HOME $PREFIX/share/java-8
set -gx PATH $JAVA_HOME/bin $PATH
set -gx LD_LIBRARY_PATH $JAVA_HOME/lib/aarch64/jli $JAVA_HOME/lib/aarch64 $JAVA_HOME/lib $JAVA_HOME/jre/lib/aarch64/jli $JAVA_HOME/jre/lib/aarch64 $JAVA_HOME/jre/lib $LD_LIBRARY_PATH
FISHEOF

echo "[*] Building libnotag.so (fix Android heap tagging) ..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.local/lib
if command -v clang >/dev/null 2>&1; then
    clang -shared -fPIC "$SCRIPT_DIR/libnotag.c" -o ~/.local/lib/libnotag.so
else
    echo "[!] clang tidak ada. Jalankan: pkg install clang"
fi

echo "[*] Done!"
echo ""
echo "Restart Termux, lalu jalankan: java -version"
echo ""
echo "Untuk server MC, jalankan dengan:"
echo "  LD_PRELOAD=\$HOME/.local/lib/libnotag.so java -jar server.jar nogui"
