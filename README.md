Termux Java 8 (OpenJDK 8 for Android aarch64)

Prebuilt OpenJDK 8u512 for Termux, compiled specifically for modern Android (aarch64). No proot, no root — runs natively in Termux.

Designed to run Minecraft Forge 1.12.2 server on Android devices.
Features

    OpenJDK 8u512 for aarch64 (ARM64)

    Runs natively in Termux (not proot/chroot)

    Patches for modern Android issues:

        Heap tagging (libnotag.so)

        Heap >4GB from code cache (adrp -> movz/movk)

        DTrace unavailable

        GCC 4.9 from NDK r10e

Quick Install

    Download jdk8-arm64-YYYYMMDD-release.tar.xz from Releases

    In Termux:

    pkg install clang

    ./extras/termux-setup.sh /path/to/jdk8-arm64-*.tar.xz

    Restart Termux, then check: java -version

See docs/TERMUX.md for details.
Build from Scratch

See docs/BUILD.md.
Applied Patches
#	Patch	Reason
1	Disable GCC < 5 check	NDK r10e ships GCC 4.9
2	Force instantiate ArrayAllocator<BitMap::bm_word_t>	Fix undefined symbol in libjvm.so
3	Stub sys/sdt.h	DTrace not available in Android NDK
4	adrp -> movz/movk in eden_allocate	Android heap >4GB away from code cache
5	libnotag.so (not a source patch)	Disable Android heap tagging
Known Issues

    Lag on MC server — mid-range devices thermal throttle. Tuning: view-distance=4, -Xmx1024m.

    "No monotonic clock" warning — normal on Android, not fatal.

    Requires Android 10+ and aarch64. No support for older Android or 32-bit.

Credits

    Based on PojavLauncherTeam/android-openjdk-build-multiarch

    OpenJDK: https://openjdk.org/

    Termux: https://termux.dev/

License

GPLv2 with Classpath Exception. See LICENSE.
