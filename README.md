zkc-qt-wallet is a z-Addr first, Sapling compatible wallet and full node for zkcored that runs on Linux, Windows and macOS.

![Screenshot](docs/screenshot-main.png?raw=true)
![Screenshots](docs/screenshot-sub.png?raw=true)
# Installation

Head over to the releases page and grab the latest installers or binary. https://github.com/zkCoreCommunity/zkc-qt-wallet/releases

### Linux

If you are on Debian/Ubuntu, please download the `.deb` package and install it.
```
sudo dpkg -i linux-deb-zkc-qt-wallet-v0.5.9.deb
sudo apt install -f
```

Or you can download and run the binaries directly.
```
tar -xvf zkc-qt-wallet-v0.5.9.tar.gz
./zkc-qt-wallet-v0.5.9/zkc-qt-wallet
```

### Windows
Download and run the .msi installer and follow the prompts. Alternately, you can download the release binary, unzip it and double click on zkc-qt-wallet to start.

### macOS
Double-click on the .dmg file to open it, and drag zkc-qt-wallet on to the Applications link to install.

## zkcored
zkc-qt-wallet needs a zkCore node running zkcored. If you already have a zkcored node running, zkc-qt-wallet will connect to it.

If you don't have one, zkc-qt-wallet will start its embedded zkcored node.

Additionally, if this is the first time you're running zkc-qt-wallet or a zkcored daemon, zkc-qt-wallet will download the zkcore params (~1.7 GB) and configure `zkcore.conf` for you.

Pass `--no-embedded` to disable the embedded zkcored and force zkc-qt-wallet to connect to an external node.

## Compiling from source
zkc-qt-wallet is written in C++ 14, and can be compiled with g++/clang++/visual c++. It also depends on Qt5, which you can get from [here](https://www.qt.io/download). Note that if you are compiling from source, you won't get the embedded zkcored by default. You can either run an external zkcored, or compile zkcored as well.

See detailed build instructions [on the wiki](https://github.com/zkCoreCommunity/zkc-qt-wallet/wiki/Compiling-from-source-code)

### Building on Linux

Pre-Requisites;
```
sudo apt install libgl1-mesa-dev

```
Build;

```
git clone https://github.com/zkCoreCommunity/zkc-qt-wallet.git
cd zkc-qt-wallet
/path/to/qt5/bin/qmake zkc-qt-wallet.pro CONFIG+=debug
make -j$(nproc)

./zkc-qt-wallet
```

### Building on Windows
You need Visual Studio 2017 (The free C++ Community Edition works just fine).

From the VS Tools command prompt
```
git clone https://github.com/zkCoreCommunity/zkc-qt-wallet.git
cd zkc-qt-wallet
c:\Qt5\bin\qmake.exe zkc-qt-wallet.pro -spec win32-msvc CONFIG+=debug
nmake

debug\zkc-qt-wallet.exe
```

To create the Visual Studio project files so you can compile and run from Visual Studio:
```
c:\Qt5\bin\qmake.exe zkc-qt-wallet.pro -tp vc CONFIG+=debug
```

### Building on macOS
You need to install the Xcode app or the Xcode command line tools first, and then install Qt.

```
git clone https://github.com/zkCoreCommunity/zkc-qt-wallet.git
cd zkc-qt-wallet
/path/to/qt5/bin/qmake zkc-qt-wallet.pro CONFIG+=debug
make

./zkc-qt-wallet.app/Contents/MacOS/zkc-qt-wallet
```

### [Troubleshooting Guide & FAQ](https://github.com/zkCoreCommunity/zkc-qt-wallet/wiki/Troubleshooting-&-FAQ)
Please read the [troubleshooting guide](https://github.com/zkCoreCommunity/zkc-qt-wallet/wiki/Troubleshooting-&-FAQ) for common problems and solutions.
For support or other questions, tweet at [@zkcqtwallet](https://twitter.com/zkcqtwallet) or [file an issue](https://github.com/zkCoreCommunity/zkc-qt-wallet/issues).

_PS: zkc-qt-wallet is NOT an official wallet, and is not affiliated with the Zerocoin Electric Coin Company in any way._
