# MacOS上のVisual Studio Codeで動作させる

## IRISバージョン

UnixODBCのUnicode(ワイド)版のドライバーが必要なため、IRIS 2025.2以降のバージョンが必要です。

## UnixODBCのインストール

Homebrewを使用してインストールします。

```
brew install unixodbc
```

## 必要なunixodbc関連ライブラリをコピーする

```
cp /opt/iris/bin/libodbc*.dylib /usr/local/lib
cp /opt/iris/bin/irisconnect.so /usr/local/lib

ls /usr/local/lib
irisconnect.so		libodbc.dylib		libodbccr.dylib		libodbcinst.dylib
libodbc.2.dylib		libodbccr.2.dylib	libodbcinst.2.dylib
```

## odbc.iniとodbcinst.ini

/opt/homebrew/etcの下にodbc.iniとodbcinst.iniを置く

### odbcinst.iniの設定内容

例

```
[InterSystems ODBC]
UsageCount=1
Driver=/opt/iris/bin/libirisodbcuw35.so
Setup=/opt/iris/bin/libirisodbcuw35.so
SQLLevel=1
FileUsage=0
DriverODBCVer=02.10
ConnectFunctions=YYN
APILevel=1
DEBUG=1
CPTimeout=<not pooled>
```

### odbc.iniの設定内容

例

```
[iris user]
Driver=InterSystems ODBC
Protocol=TCP
Host=localhost
Port=1972
Database=USER
UID=_system
Password=sys
Description=Sample namespace
Query Timeout=0
Static Cursors=0
Trace=on
TraceFile=/Users/hsatoctr/unixodbc.log
```

## PATHの設定

例

```
export PATH="/opt/homebrew/Cellar/unixodbc/2.3.12:/lib/opt/homebrew/bin:/opt/iris/bin:/opt/iris/lib/python:/opt/iris/mgr/python:$PATH"
```
