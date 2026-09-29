# Termux Java 8 (OpenJDK 8 for Android aarch64)

## Prebuilt OpenJDK 8u512 for Termux, compiled specifically for modern Android (aarch64). No proot, no root — runs natively in Termux !

### Designed to run Minecraft Forge 1.12.2 server on Android devices.
Features:

    OpenJDK 8u512 for aarch64 (ARM64)

    Runs natively in Termux (not proot/chroot)

#### Patches for modern Android issues:

        -Heap tagging (libnotag.so)

        -Heap >4GB from code cache (adrp -> movz/movk)

        -DTrace unavailable

        -GCC 4.9 from NDK r10e

## Quick Install (Termux)

1. Install tools:
```bash

pkg install git wget clang
```

2. Clone this repo:
```bash
git clone https://github.com/FahmiArrohmann/termux-java8.git
cd termux-java8
```

3. Download JDK:

open  the [Releases](https://github.com/FahmiArrohmann/termux-java8/releases) page and copy the download URL.
```bash
wget "url"
```

4. install
```bash
chmod +x extras/termux-setup.sh
./extras/termux-setup.sh ./jdk8-arm64-*.tar.xz
exec fish
java -version
```
## Documentation

Termux usage: [docs/TERMUX.md](docs/TERMUX.md) for details.


 Build instructions: [docs/BUILD.md](docs/BUILD.md)
 for Build from Scratch
# Applied Patches
 Patch	Reason
1. Disable GCC < 5 check	NDK r10e ships GCC 4.9
2. Force instantiate ArrayAllocator<BitMap::bm_word_t>	Fix undefined symbol in libjvm.so
3. Stub sys/sdt.h	DTrace not available in Android NDK
4. adrp -> movz/movk in eden_allocate	Android heap >4GB away from code cache
5. libnotag.so (not a source patch)	Disable Android heap tagging

## Known Issues

    "No monotonic clock" warning has been fixed

    Requires Android 10+ and aarch64. No support for older Android or 32-bit.

## Credits

    Based on https://github.com/PojavLauncherTeam/android-openjdk-build-multiarch

    OpenJDK: https://openjdk.org/

    Termux: https://termux.dev/


## License

GPLv2 with Classpath Exception.

See [LICENSE](LICENSE)
