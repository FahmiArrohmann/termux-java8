Building OpenJDK 8 for Termux from Scratch
Prerequisites (on Linux PC)

    Linux x86_64 (Arch/Debian/etc)

    JDK 8 (boot JDK)

    Android NDK r10e

    Packages: git wget unzip zip autoconf libtool python3 base-devel

    Disk space: at least 30GB free

    RAM: at least 4GB

Steps

    Clone the repo:

    git clone https://github.com/FahmiArrohmann/termux-java8
    cd termux-java8

    Download NDK r10e:
    text

    wget https://dl.google.com/android/repository/android-ndk-r10e-linux-x86_64.zip

    Set env:

    export TARGET=aarch64-linux-android
    export TARGET_JDK=aarch64

    Extract NDK and build toolchain:

    ./extractndk.sh
    ./maketoolchain.sh

    Build supporting libs:

    ./getlibs.sh
    ./buildlibs.sh

    Clone OpenJDK source:

    ./clonejdk.sh

    (Optional) Create sys/sdt.h stub in NDK include. See comments in buildjdk.sh.

    Build JDK:

    systemd-inhibit --what=sleep ./buildjdk.sh 2>&1 | tee build.log

    Pack:

    rm -rf termux-elf-cleaner
    ./removejdkdebuginfo.sh
    ./tarjdk.sh

    Result tarball: jdk8-arm64-YYYYMMDD-release.tar.xz in repo root.

Applied Patches

All patches are automated in buildjdk.sh. Read the comments in the script for details.
Time Estimate

On a dual-core AMD A4-9125 laptop:

    NDK + toolchain setup: ~15 min

    Build freetype + libs: ~15 min

    Clone source: ~15 min

    Build JDK: ~30 min (with JOBS=2)

    Total: ~1-2 hours
