# ODBC interface for Cache Direct(VisM.OCX) Emulation for IRIS

VisM.OCXのインタフェースをODBCを利用してエミュレーションしています。
ここでは.Net上で動作するように実装していますが、.NET以外の開発環境（Delphi等）からも利用可能です。


## 使用方法

### IRISサーバー

使用バージョンは、IRIS for Windows (x86-64) 2020.1 (Build 215U) Mon Mar 30 2020 20:14:33 EDTです。



### IRISサーバー側のクラス

CacheDirect.ODBCEmulator.clsを適当なネームスペースにインポート（サンプルはUSERネームスペースで動かすことを前提にしています）

### C#のプロジェクトファイルをVisual Studioで読み込む

ファイルをVisual Studioで読み込ます。

使用したバージョンは、以下になります。

Microsoft Visual Studio Community 2019

Version 16.6.0

### 参照設定

Visual Studioのプロジェクト設定から参照の追加を選び、以下のファイルを追加してください。


### ビルド

Visual StudioのビルドメニューからC_SharpConsoleApplicationのビルドをクリック

出力ウィンドウにエラーがないことを確認してください。

エラーが出る場合は、参照設定がうまくいっていない可能性が高いです。

### 実行

Visual Studioのデバッグメニューからデバッグの開始をクリックします。

このアプリケーションを終了するには、任意のキーを押す必要があります。

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

2個のコンストラクターが用意されています。

cacheDirectWapper(string constr)

cacheDirectWapper(IRISConnection irisconn)

