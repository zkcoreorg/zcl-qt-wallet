param (
    [Parameter(Mandatory=$true)][string]$version
)

$target="zkc-qt-wallet-v$version"

Remove-Item -Path release/wininstaller -Recurse -ErrorAction Ignore  | Out-Null
New-Item release/wininstaller -itemtype directory                    | Out-Null

Copy-Item release/$target/zkc-qt-wallet.exe release/wininstaller/
Copy-Item release/$target/LICENSE           release/wininstaller/
Copy-Item release/$target/README.md         release/wininstaller/
Copy-Item release/$target/zkcored.exe        release/wininstaller/
Copy-Item release/$target/zkcore-cli.exe     release/wininstaller/

Get-Content src/scripts/zkc-qt-wallet.wxs | ForEach-Object { $_ -replace "RELEASE_VERSION", "$version" } | Out-File -Encoding utf8 release/wininstaller/zkc-qt-wallet.wxs

candle.exe release/wininstaller/zkc-qt-wallet.wxs -o release/wininstaller/zkc-qt-wallet.wixobj
if (!$?) {
    exit 1;
}

light.exe -ext WixUIExtension -cultures:en-us release/wininstaller/zkc-qt-wallet.wixobj -out release/wininstaller/zkc-qt-wallet.msi
if (!$?) {
    exit 1;
}

New-Item artifacts -itemtype directory -Force | Out-Null
Copy-Item release/wininstaller/zkc-qt-wallet.msi ./artifacts/Windows-installer-$target.msi