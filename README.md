# Termux Java 8

Prebuilt **OpenJDK 8u512 for Termux on Android aarch64 (ARM64)**.

This project provides a native Java 8 runtime for Android/Termux without using proot, chroot, or root access.

It is primarily intended for running applications that still require Java 8, including **Minecraft Forge 1.12.2 servers**.

> **Note:** This is an unofficial OpenJDK build for Android/Termux. Compatibility may vary depending on the Android version, device, and workload.

## Features

- OpenJDK 8u512 for Android aarch64
- Native execution in Termux
- No proot or chroot required
- No root access required
- Patches for compatibility with modern Android systems
- `libnotag.so` helper for Android heap tagging issues
- Support for running Java 8 applications and Minecraft Forge 1.12.2 servers

## Quick Installation

Download the latest `jdk8-arm64-YYYYMMDD-release.tar.xz` archive from the [Releases](../../releases) page.

In Termux:

```bash
pkg install clang
./extras/termux-setup.sh /path/to/jdk8-arm64-*.tar.xz
```

Restart Termux and verify the installation:

```bash
java -version
```

For detailed installation instructions, see [docs/TERMUX.md](docs/TERMUX.md).

## Building from Source

If you want to build OpenJDK 8 yourself, see [docs/BUILD.md](docs/BUILD.md).

The build process uses the Android NDK and applies the patches included in this repository.

Basic requirements:

- Linux x86_64
- JDK 8 as the boot JDK
- Android NDK r10e
- `git`
- `wget`
- `unzip`
- `zip`
- `autoconf`
- `libtool`
- Python 3
- `base-devel` or equivalent build tools
- At least 30 GB of free disk space
- At least 4 GB of RAM

## Patches and Android Compatibility

This project contains several patches required to build and run OpenJDK 8 on Android.

| Patch / Change | Purpose |
|---|---|
| Disable GCC version check | Allows building with GCC 4.9 from NDK r10e |
| `ArrayAllocator<BitMap::bm_word_t>` instantiation | Fixes an undefined symbol in `libjvm.so` |
| `sys/sdt.h` stub | Handles the absence of DTrace on Android |
| `adrp` → `movz` / `movk` | Fixes an Android heap/code-cache issue on devices with memory above 4 GB |
| `libnotag.so` | Works around Android heap tagging issues |

See the files in [`patches/`](patches/) and the comments in [`buildjdk.sh`](buildjdk.sh) for implementation details.

## Android Heap Tagging

Some Android versions/devices may enable heap tagging features that can cause this JVM to crash.

The repository includes `extras/libnotag.c`, which can be compiled into `libnotag.so`.

The setup script attempts to build it automatically when `clang` is available.

For manual usage:

```bash
pkg install clang
mkdir -p ~/.local/lib

clang -shared -fPIC \
    extras/libnotag.c \
    -o ~/.local/lib/libnotag.so
```

Then run Java with:

```bash
LD_PRELOAD=$HOME/.local/lib/libnotag.so java -jar server.jar nogui
```

## Minecraft Forge 1.12.2

This project can be used to run Minecraft Forge 1.12.2 servers on supported Android devices.

Example:

```bash
LD_PRELOAD=$HOME/.local/lib/libnotag.so \
java -Xms512m -Xmx1024m -XX:+UseG1GC \
-jar forge-1.12.2-*.jar nogui
```

For better performance on mobile hardware, lower the server settings when necessary.

Example `server.properties` settings:

```properties
view-distance=4
sync-chunk-writes=false
max-players=5
```

For a persistent server session, `tmux` can be used:

```bash
pkg install tmux
tmux new -s mc
```

Start the server inside the tmux session, then detach with:

```text
Ctrl+B, then D
```

Reattach later with:

```bash
tmux attach -t mc
```

## Known Issues

- Server performance depends heavily on the Android device and its thermal limits.
- Minecraft servers may experience lag on lower-end devices.
- `No monotonic clock` warnings may appear on Android. These are not necessarily fatal.
- Android heap tagging may require `libnotag.so`.
- This project currently targets aarch64 (ARM64).
- Android 10 or newer is recommended.
- 32-bit ARM devices are not supported by the aarch64 build.

## Repository Structure

```text
.
├── buildjdk.sh
├── docs/
│   ├── BUILD.md
│   └── TERMUX.md
├── extras/
│   ├── libnotag.c
│   └── termux-setup.sh
├── patches/
│   ├── jdk8u_android_aarch32.diff
│   ├── jdk8u_android.diff
│   ├── jdk8u_android_main.diff
│   ├── jdk8u_android_page_trap_fix.diff
│   ├── jdk8u_ios.diff
│   └── jdk8u_ios_fix_clang.diff
├── LICENSE
└── README.md
```

## Credits

This project is based on work from:

- [PojavLauncherTeam/android-openjdk-build-multiarch](https://github.com/PojavLauncherTeam/android-openjdk-build-multiarch)
- [OpenJDK](https://openjdk.org/)
- [Termux](https://termux.dev/)

## License

This project is licensed under the **GNU General Public License v2 with Classpath Exception (GPLv2+CPE)**.

See [LICENSE](LICENSE) for the full license text.
