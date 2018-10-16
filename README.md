zcash-qt-wallet is a z-Addr first wallet UI frontend for zcashd

![Screenshot](docs/screenshot-main.png?raw=true)

# Installation

zcash-qt-wallet needs a zcash node running zcashd. Download the zcash node software from https://z.cash/download/ and start zcashd.

## Prerequisites: zcashd
zcashd needs to run with RPC enabled and with a RPC username/password set. Add the following entries into ~/.zcash/zcash.conf

```
rpcuser=username
rpcpassword=password
```
and restart zcashd

## Installing zcash-qt-wallet
Head over to the releases page and grab the latest binary. Unzip and run the binary


### Note on running on Windows
Although zcashd is not technically supported on Windows, you can run it inside WSL (Windows Subsystem for Linux). 
Configure zcash inside WSL by setting the rpcuser/rpcpassword in ~/.zcash/zcash.conf. You can
then download the Windows build and connect to the local node inside WSL, after configuring the RPC username/password
in File->Settings.

## Compiling from source
zcash-qt-wallet depends on QT5, which you can get from here: https://www.qt.io/download

### Compiling on Linux
You need a C++14 compatible compiler like gcc or clang++

```
git clone https://github.com/adityapk00/zcash-qt-wallet.git
cd zcash-qt-wallet
/path/to/qt5/bin/qmake zcash-qt-wallet.pro CONFIG+=DEBUG
make -j$(nproc)
```

## Troubleshooting FAQ
### 1. "Connection Error"

Normally, zcash-qt-wallet can pick up the rpcuser/rpcpassword from zcash.conf. If it doesn't for some reason, you can set the username/password in the File->Settings menu. 
If you are connecting to a remote node, make sure that zcashd on the remote machine is accepting connections from your machine. The target machine's firewall needs to allow connections
from your host and also zcashd is set to be configured to accept connections from this host. 

The easiest way to connect to a remote node is probably to ssh to it with port forwarding like this:
```
ssh -L8232:127.0.0.1:8232 user@remotehost
```
### 2. "Not enough balance" when sending transactions
The most likely cause for this is that you are trying to spend unconfirmed funds. Unlike bitcoin, the zcash protocol doesn't let you spent unconfirmed funds yet. Please wait for 
1-2 blocks for the funds to confirm and retry the transaction. 
