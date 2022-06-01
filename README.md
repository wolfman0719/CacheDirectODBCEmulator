# ODBC interface for Cache Direct(VisM.OCX) Emulation for IRIS

VisM.OCXのインタフェースをODBCを利用してエミュレーションしています。
ここでは.Net上で動作するように実装していますが、.NET以外の開発環境（Delphi等）からも利用可能です。
但し、その場合は、その環境にあったラッパーコードを作成する必要があります。
CacheDirectODBCWapper.csを参考にして、同様の処理を記述してください。


## 使用方法

### IRISサーバー

使用バージョンは、IRIS for Windows (x86-64) 2021.2 (Build 650U) Tue Jan 25 2022 13:12:18 ESTです。


### IRISサーバー側のクラス

ODBCEmulator.clsを適当なネームスペースにインポート（サンプルはUSERネームスペースで動かすことを前提にしています）

### C#のソリューションファイルをVisual Studioで読み込む

vismodbc.slnファイルをVisual Studioで読み込ます。

使用したバージョンは、以下になります。

Microsoft Visual Studio Community 2022 (64 ビット) - Current
Version 17.1.1

### 参照設定

このプログラムは、JSONを使用しているので、その処理のために

c:\InterSystems\IRIS\dev\dotnet\bin\v4.5\Newtonsoft.Json.dllを参照しています。


### ビルド

Visual Studioのビルドメニューからvismodbcのビルドをクリック

出力ウィンドウにエラーがないことを確認してください。

エラーが出る場合は、参照設定がうまくいっていない可能性が高いです。

### 実行

Visual Studioのデバッグメニューからデバッグの開始をクリックします。

このアプリケーションを正常終了するには、コンソール上のメッセージに従って5秒経過後、任意のキーを押す必要があります。

アプリケーションの出力結果は、Visual Studioの出力ウィンドウに表示されます。


## 制限事項

### サポートしていないプロパティ

- ConnectionState
- ConTag
- ElapsedTime
- ErrorTrap
- KeepAliveInterval
- KeepAliveTimeOut
- LogMask
- MServer
- MsgText
- NameSpace
- PromptInterval
- Server
- Tag
- TimeOut

### サポートしていないメソッド

- DeleteConnection
- SetMServer
- SetServer

### サポートしていないイベント

- Shutdown Events

### サポートされない追加機能

- ErrorTrapping
- The Keep Alive Feature
- Server Read Loop and Quick Check
- Read and Write Hooks
- Other Server Side Hooks
- User Cancel Option

### Visual Basic依存機能

Cache Directの機能の中で、Visual Basicの固有の機能は、サポートしていません。

- コールバック機能
- MessageBox
- DoEventsなど

## コンストラクター

１個のコンストラクターが用意されています。

cacheDirectWapper(string DSN)

