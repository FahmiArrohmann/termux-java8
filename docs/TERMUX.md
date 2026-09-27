Usage on Termux
Prerequisites

    Termux from F-Droid (not Play Store)

    Android 10 or newer

    aarch64 device (most modern phones)

Installation

    Download the tarball from Releases: jdk8-arm64-YYYYMMDD-release.tar.xz

    Extract to $PREFIX/share/java-8:

    mkdir -p $PREFIX/share/java-8
    cd $PREFIX/share/java-8
    tar -xJf /sdcard/Download/jdk8-arm64-*.tar.xz

    Set environment variables. For fish (Termux default):

    mkdir -p ~/.config/fish
    nano ~/.config/fish/config.fish

    set -gx JAVA_HOME $PREFIX/share/java-8
    set -gx PATH $JAVA_HOME/bin $PATH
    set -gx LD_LIBRARY_PATH $JAVA_HOME/lib/aarch64/jli $JAVA_HOME/lib/aarch64 $JAVA_HOME/lib $JAVA_HOME/jre/lib/aarch64/jli $JAVA_HOME/jre/lib/aarch64 $JAVA_HOME/jre/lib $LD_LIBRARY_PATH

    Restart Termux, then check: java -version

Fix Android Heap Tagging (for MC server)

Android 11+ has heap tagging that crashes the JVM. Compile libnotag.so and use LD_PRELOAD:

pkg install clang
mkdir -p ~/.local/lib
clang -shared -fPIC libnotag.c -o ~/.local/lib/libnotag.so

Run Installer Java Server with:

LD_PRELOAD=$HOME/.local/lib/libnotag.so java -jar server.jar nogui

MC Server Tuning

Edit server.properties:

online-mode=false #for Cracked Client 
view-distance=4
sync-chunk-writes=false
max-players=5

to start server 

java -Xms512m -Xmx1G -jar forge-1.12.2-*.jar nogui

#-Xmx =maximum memory limit example -Xmx1G 2G 3G etc..
