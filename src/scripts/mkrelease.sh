#!/bin/bash
if [ -z $QT_STATIC ]; then
    echo "QT_STATIC is not set. Please set it to the base directory of a statically compiled Qt";
    exit 1;
fi

if [ -z $APP_VERSION ]; then echo "APP_VERSION is not set"; exit 1; fi
if [ -z $PREV_VERSION ]; then echo "PREV_VERSION is not set"; exit 1; fi

if [ -z $ZKCASSIC_DIR ]; then
    echo "ZKCASSIC_DIR is not set. Please set it to the base directory of a zkCore project with built zkCore binaries."
    exit 1;
fi

if [ ! -f $ZKCASSIC_DIR/artifacts/zkcored ]; then
    echo "Couldn't find zkcored in $ZKCASSIC_DIR/artifacts/. Please build zkcored."
    exit 1;
fi

if [ ! -f $ZKCASSIC_DIR/artifacts/zkcore-cli ]; then
    echo "Couldn't find zkcore-cli in $ZKCASSIC_DIR/artifacts/. Please build zkcored."
    exit 1;
fi

# Ensure that zkcored is the right build
echo -n "zkcored version........."
if grep -q "zqwMagicBean" $ZKCASSIC_DIR/artifacts/zkcored && ! readelf -s $ZKCASSIC_DIR/artifacts/zkcored | grep -q "GLIBC_2\.25"; then
    echo "[OK]"
else
    echo "[ERROR]"
    echo "zkcored doesn't seem to be a zqwMagicBean build or zkcored is built with libc 2.25"
    exit 1
fi

echo -n "zkcored.exe version....."
if grep -q "zqwMagicBean" $ZKCASSIC_DIR/artifacts/zkcored.exe; then
    echo "[OK]"
else
    echo "[ERROR]"
    echo "zkcored doesn't seem to be a zqwMagicBean build"
    exit 1
fi

echo -n "Version files.........."
# Replace the version number in the .pro file so it gets picked up everywhere
sed -i "s/${PREV_VERSION}/${APP_VERSION}/g" zkc-qt-wallet.pro > /dev/null

# Also update it in the README.md
sed -i "s/${PREV_VERSION}/${APP_VERSION}/g" README.md > /dev/null
echo "[OK]"

echo -n "Cleaning..............."
rm -rf bin/*
rm -rf artifacts/*
make distclean >/dev/null 2>&1
echo "[OK]"

echo ""
echo "[Building on" `lsb_release -r`"]"

echo -n "Configuring............"
QT_STATIC=$QT_STATIC bash src/scripts/dotranslations.sh >/dev/null
$QT_STATIC/bin/qmake zkc-qt-wallet.pro -spec linux-clang CONFIG+=release > /dev/null
echo "[OK]"


echo -n "Building..............."
rm -rf bin/zkc-qt-wallet* > /dev/null
make -j$(nproc) > /dev/null
echo "[OK]"


# Test for Qt
echo -n "Static link............"
if [[ $(ldd zkc-qt-wallet | grep -i "Qt") ]]; then
    echo "FOUND QT; ABORT";
    exit 1
fi
echo "[OK]"


echo -n "Packaging.............."
mkdir bin/zkc-qt-wallet-v$APP_VERSION > /dev/null
strip zkc-qt-wallet

cp zkc-qt-wallet                  bin/zkc-qt-wallet-v$APP_VERSION > /dev/null
cp $ZKCASSIC_DIR/artifacts/zkcored    bin/zkc-qt-wallet-v$APP_VERSION > /dev/null
cp $ZKCASSIC_DIR/artifacts/zkcore-cli bin/zkc-qt-wallet-v$APP_VERSION > /dev/null
cp README.md                      bin/zkc-qt-wallet-v$APP_VERSION > /dev/null
cp LICENSE                        bin/zkc-qt-wallet-v$APP_VERSION > /dev/null

cd bin && tar czf linux-zkc-qt-wallet-v$APP_VERSION.tar.gz zkc-qt-wallet-v$APP_VERSION/ > /dev/null
cd ..

mkdir artifacts >/dev/null 2>&1
cp bin/linux-zkc-qt-wallet-v$APP_VERSION.tar.gz ./artifacts/linux-binaries-zkc-qt-wallet-v$APP_VERSION.tar.gz
echo "[OK]"


if [ -f artifacts/linux-binaries-zkc-qt-wallet-v$APP_VERSION.tar.gz ] ; then
    echo -n "Package contents......."
    # Test if the package is built OK
    if tar tf "artifacts/linux-binaries-zkc-qt-wallet-v$APP_VERSION.tar.gz" | wc -l | grep -q "6"; then
        echo "[OK]"
    else
        echo "[ERROR]"
        exit 1
    fi
else
    echo "[ERROR]"
    exit 1
fi

echo -n "Building deb..........."
debdir=bin/deb/zkc-qt-wallet-v$APP_VERSION
mkdir -p $debdir > /dev/null
mkdir    $debdir/DEBIAN
mkdir -p $debdir/usr/local/bin

cat src/scripts/control | sed "s/RELEASE_VERSION/$APP_VERSION/g" > $debdir/DEBIAN/control

cp zkc-qt-wallet               $debdir/usr/local/bin/
cp $ZKCASSIC_DIR/artifacts/zkcored $debdir/usr/local/bin/zqw-zkcored

mkdir -p $debdir/usr/share/pixmaps/
cp res/zkc-qt-wallet.xpm       $debdir/usr/share/pixmaps/

mkdir -p $debdir/usr/share/applications
cp src/scripts/desktopentry    $debdir/usr/share/applications/zkc-qt-wallet.desktop

dpkg-deb --build $debdir >/dev/null
cp $debdir.deb                 artifacts/linux-deb-zkc-qt-wallet-v$APP_VERSION.deb
echo "[OK]"



echo ""
echo "[Windows]"

if [ -z $MXE_PATH ]; then
    echo "MXE_PATH is not set. Set it to ~/github/mxe/usr/bin if you want to build Windows"
    echo "Not building Windows"
    exit 0;
fi

if [ ! -f $ZKCASSIC_DIR/artifacts/zkcored.exe ]; then
    echo "Couldn't find zkcored.exe in $ZKCASSIC_DIR/artifacts/. Please build zkcored.exe"
    exit 1;
fi


if [ ! -f $ZKCASSIC_DIR/artifacts/zkcore-cli.exe ]; then
    echo "Couldn't find zkcore-cli.exe in $ZKCASSIC_DIR/artifacts/. Please build zkcored.exe"
    exit 1;
fi

export PATH=$MXE_PATH:$PATH

echo -n "Configuring............"
make clean  > /dev/null
rm -f zkc-qt-wallet-mingw.pro
rm -rf release/
#Mingw seems to have trouble with precompiled headers, so strip that option from the .pro file
cat zkc-qt-wallet.pro | sed "s/precompile_header/release/g" | sed "s/PRECOMPILED_HEADER.*//g" > zkc-qt-wallet-mingw.pro
echo "[OK]"


echo -n "Building..............."
x86_64-w64-mingw32.static-qmake-qt5 zkc-qt-wallet-mingw.pro CONFIG+=release > /dev/null
make -j32 > /dev/null
echo "[OK]"


echo -n "Packaging.............."
mkdir release/zkc-qt-wallet-v$APP_VERSION
cp release/zkc-qt-wallet.exe          release/zkc-qt-wallet-v$APP_VERSION
cp $ZKCASSIC_DIR/artifacts/zkcored.exe    release/zkc-qt-wallet-v$APP_VERSION > /dev/null
cp $ZKCASSIC_DIR/artifacts/zkcore-cli.exe release/zkc-qt-wallet-v$APP_VERSION > /dev/null
cp README.md                          release/zkc-qt-wallet-v$APP_VERSION
cp LICENSE                            release/zkc-qt-wallet-v$APP_VERSION
cd release && zip -r Windows-binaries-zkc-qt-wallet-v$APP_VERSION.zip zkc-qt-wallet-v$APP_VERSION/ > /dev/null
cd ..

mkdir artifacts >/dev/null 2>&1
cp release/Windows-binaries-zkc-qt-wallet-v$APP_VERSION.zip ./artifacts/
echo "[OK]"

if [ -f artifacts/Windows-binaries-zkc-qt-wallet-v$APP_VERSION.zip ] ; then
    echo -n "Package contents......."
    if unzip -l "artifacts/Windows-binaries-zkc-qt-wallet-v$APP_VERSION.zip" | wc -l | grep -q "11"; then
        echo "[OK]"
    else
        echo "[ERROR]"
        exit 1
    fi
else
    echo "[ERROR]"
    exit 1
fi
