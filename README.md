zcl-qt-wallet is a z-Addr first, Sapling compatible wallet and full node for zclassicd that runs on Linux, Windows and macOS.

![Screenshot](docs/screenshot-main.png?raw=true)
![Screenshots](docs/screenshot-sub.png?raw=true)
# Installation

Head over to the releases page and grab the latest installers or binary. https://github.com/ZclassicCommunity/zcl-qt-wallet/releases

### Linux

If you are on Debian/Ubuntu, please download the `.deb` package and install it.
```
sudo dpkg -i linux-deb-zcl-qt-wallet-v0.5.9.deb
sudo apt install -f
```

Or you can download and run the binaries directly.
```
tar -xvf zcl-qt-wallet-v0.5.9.tar.gz
./zcl-qt-wallet-v0.5.9/zcl-qt-wallet
```

### Windows
Download and run the .msi installer and follow the prompts. Alternately, you can download the release binary, unzip it and double click on zcl-qt-wallet to start.

### macOS
Double-click on the .dmg file to open it, and drag zcl-qt-wallet on to the Applications link to install.

## zclassicd
zcl-qt-wallet needs a Zclassic node running zclassicd. If you already have a zclassicd node running, zcl-qt-wallet will connect to it.

If you don't have one, zcl-qt-wallet will start its embedded zclassicd node.

Additionally, if this is the first time you're running zcl-qt-wallet or a zclassicd daemon, zcl-qt-wallet will download the zclassic params (~1.7 GB) and configure `zclassic.conf` for you.

Pass `--no-embedded` to disable the embedded zclassicd and force zcl-qt-wallet to connect to an external node.

## Compiling from source
zcl-qt-wallet is written in C++ 14, and can be compiled with g++/clang++/visual c++. It also depends on Qt5, which you can get from [here](https://www.qt.io/download). Note that if you are compiling from source, you won't get the embedded zclassicd by default. You can either run an external zclassicd, or compile zclassicd as well.

See detailed build instructions [on the wiki](https://github.com/ZclassicCommunity/zcl-qt-wallet/wiki/Compiling-from-source-code)

### Building on Linux

Pre-Requisites;
```
sudo apt install libgl1-mesa-dev

```
Build;

```
git clone https://github.com/ZclassicCommunity/zcl-qt-wallet.git
cd zcl-qt-wallet
/path/to/qt5/bin/qmake zcl-qt-wallet.pro CONFIG+=debug
make -j$(nproc)

./zcl-qt-wallet
```

### Building on Windows
You need Visual Studio 2017 (The free C++ Community Edition works just fine).

From the VS Tools command prompt
```
git clone https://github.com/ZclassicCommunity/zcl-qt-wallet.git
cd zcl-qt-wallet
c:\Qt5\bin\qmake.exe zcl-qt-wallet.pro -spec win32-msvc CONFIG+=debug
nmake

debug\zcl-qt-wallet.exe
```

To create the Visual Studio project files so you can compile and run from Visual Studio:
```
c:\Qt5\bin\qmake.exe zcl-qt-wallet.pro -tp vc CONFIG+=debug
```

### Building on macOS
You need to install the Xcode app or the Xcode command line tools first, and then install Qt.

```
git clone https://github.com/ZclassicCommunity/zcl-qt-wallet.git
cd zcl-qt-wallet
/path/to/qt5/bin/qmake zcl-qt-wallet.pro CONFIG+=debug
make

./zcl-qt-wallet.app/Contents/MacOS/zcl-qt-wallet
```

### [Troubleshooting Guide & FAQ](https://github.com/ZclassicCommunity/zcl-qt-wallet/wiki/Troubleshooting-&-FAQ)
Please read the [troubleshooting guide](https://github.com/ZclassicCommunity/zcl-qt-wallet/wiki/Troubleshooting-&-FAQ) for common problems and solutions.
For support or other questions, tweet at [@zclqtwallet](https://twitter.com/zclqtwallet) or [file an issue](https://github.com/ZclassicCommunity/zcl-qt-wallet/issues).

_PS: zcl-qt-wallet is NOT an official wallet, and is not affiliated with the Zerocoin Electric Coin Company in any way._
