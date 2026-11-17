# Wireless Battery JP

ワイヤレスマウス、ヘッドセット、キーボード、コントローラーのバッテリー残量をWindowsのタスクバーへ直接表示する、軽量なC++17／Win32アプリです。

> 本ソフトウェアはkrisgfx9氏による[Wireless-Device-Battery-Monitor](https://github.com/krisgfx9/Wireless-Device-Battery-Monitor)を基に制作された非公式日本語版です。元作者による公式な承認・サポートを受けた製品ではありません。

日本語版の実画面スクリーンショットは公開前のWindows 10／11実機確認後に追加します。英語版の画像を日本語版の動作画面として掲載しません。

## 主な機能

- タスクバーへ `🎧 30%  🖱 93%` のように直接表示（既定）
- デバイスごとの通知領域アイコンへ切り替え可能
- 充電中、低残量、スリープ中、最終取得値を区別
- ダーク／ライトテーマ、DPIスケーリング、Explorer再起動に追従
- タスクバーへ配置できない場合は通知領域へ安全にフォールバック
- 10／30／60（既定）／120／300秒の更新間隔
- Windows自動起動、デバイスごとの表示切り替え
- デバイス情報の外部送信や自動更新を行わない

単体の`WirelessBattery.exe`でも基本機能が動作します。`headsetcontrol.exe`がない場合はHeadsetControl経由の追加ヘッドセット対応だけが無効になります。

## 対応デバイス

元プロジェクトの既存ドライバーをすべて維持しています。

| メーカー／方式 | 対応範囲 | 取得方法 |
|---|---|---|
| Logicool（Logitech） | Unifying、Bolt、LIGHTSPEED、Nano、USB、Bluetooth接続の対応マウス／キーボード、対応Gヘッドセット | HID++ 1.0／2.0、Unified Battery、Battery Status、Battery Voltage、ADC |
| Razer | 対応マウス、キーボード、ドングル、BlackShark V3系列 | ベンダーHID |
| SteelSeries | 対応Arctis、Aerox、Prime、Rival系列 | ベンダーHID |
| Corsair／HyperX | 対応ヘッドセット、マウス、キーボード | ベンダーHID |
| Sony／Xbox／GameSir | 対応コントローラー、INZONE | 入力レポート／Windows.Gaming.Input／XInput等 |
| Bluetooth | Windows設定に残量が表示される機器 | Windowsデバイスプロパティ |
| Generic HID | Battery Strength usageを公開する機器 | 標準HID usage |
| HeadsetControl | HeadsetControl 4.3.0の対応機器 | 同梱CLIのJSON出力 |

そのほかGlorious、Hitscan、Kysona、Pulsar、ATK、G-Wolves、Keychron、LAMZU、Redragon、AULA、ASUS ROG、ZOWIE、Rapoo、Motospeed、Delux、Ajazz、Attack Shark、Cooler Masterなどの既存ドライバーを含みます。詳細は[`src/drivers/`](src/drivers)を参照してください。

### Logicool製マウス

認識済みインターフェースに対して読み取り用の既知HID++コマンドだけを送信します。G PRO Wireless、G PRO X SUPERLIGHT系列、G502 LIGHTSPEED系列、G703系列、G304／G305系列、MX Master系列はプロトコル上の対象になり得ますが、本日本語版では実機検証していないため動作確認済みとは表記しません。接続方式と機種により取得可能な情報は異なります。

## 実機検証済みデバイス

日本語版としての実機検証は未実施です。元READMEにはGlorious Model O Wireless、HyperX Cloud III Wireless、Cooler Master MM712、Rapoo VT3 Max Gen 2、Redragon M916 Pro 1Kの確認記録がありますが、日本語版による再検証結果ではありません。

## インストール

GitHub Releasesでは次を配布予定です。

- `WirelessBatteryJP-Setup-1.0.0-jp.1.exe`
- `WirelessBatteryJP-1.0.0-jp.1-portable.zip`
- `SHA256SUMS.txt`
- HeadsetControl対応ソースアーカイブ

セットアップ版は通常、管理者権限が不要です。英語版とは別のAppId、インストール先、設定キー、自動起動名を使うため共存でき、アンインストール時も英語版のファイルや設定を削除しません。

コード署名されていない配布物ではSmartScreen警告が表示される場合があります。警告を不正に回避する処理は実装していません。`SHA256SUMS.txt`で検証してください。

### ポータブル版

ZIPを任意のフォルダーへ展開し`WirelessBattery.exe`を実行します。設定は`HKEY_CURRENT_USER\Software\WirelessBatteryJP`へ保存されるため、設定まで完全に持ち運ぶ方式ではありません。

## タスクバーと日本語メニュー

表示をクリックすると、デバイスの表示切り替え、スリープ機器の非表示、タスクバー／通知領域モード、更新間隔、今すぐ更新、Windows自動起動、終了を操作できます。通常は60秒更新を推奨します。

## コマンドライン

```text
WirelessBattery.exe --list   # 検出機器と残量をUTF-8で表示
WirelessBattery.exe --dump   # HIDコレクションを表示
WirelessBattery.exe --quit   # 実行中の日本語版を終了
```

## トラブルシューティング

- タスクバーに出ない：通知領域（`^`を含む）を確認してください。配置失敗時は自動で通知領域方式になります。
- デバイスがない：接続方式を確認し、`--list`と`--dump`を添えてIssueへ報告してください。
- スリープ中：レシーバーが一時的に列挙しない場合、最終取得値を薄く表示します。
- Explorer再起動後：最大数秒で表示を再作成します。
- HeadsetControl機器だけ出ない：`headsetcontrol.exe`が同じフォルダーにあるか確認してください。

## 開発環境とビルド

MinGW-w64（MSYS2 MINGW64推奨）とGNU Makeを使います。同名の別実装`make`ではビルドできません。

```text
make
make test
```

コマンドプロンプトでは`g++`と`windres`をPATHへ追加して`build.bat`を実行できます。配布物にはInno Setup 6または7が必要です。

```powershell
powershell -File installer\build-installer.ps1 -Version 1.0.0-jp.1
```

GitHub ActionsはPRで読み取り権限だけを使います。`v1.0.0-jp.1`形式のタグでは、ビルドとテスト成功後に限りインストーラー、ZIP、SHA-256一覧、HeadsetControl対応ソースを生成します。

## 仕組みとセキュリティ

メーカー別ドライバーはvendor／product IDと固有HIDコレクションで対象を限定し、未知の機器へ推測コマンドを送りません。タスクバー表示は`Shell_TrayWnd`内へ配置する非公開構造依存方式のため、通知領域フォールバックを維持します。本アプリはデバイス情報を外部送信せず、不要なネットワーク通信や管理者権限を追加しません。

## ライセンスと謝辞

[GNU General Public License v3.0 or later](LICENSE)です。元作者の著作権表示、ライセンスヘッダー、第三者クレジットを維持します。バイナリの再配布時は対応ソースとライセンス資料を同じGPL条件で提供してください。

HeadsetControl同梱物には`THIRD_PARTY_NOTICES.txt`、GPL本文、対応する`headsetcontrol-4.3.0.tar.gz`を用意します。原作者krisgfx9氏、全コントリビューター、HeadsetControl、OpenRazer、Solaarほか各プロトコル調査元へ感謝します。詳細な出典はGit履歴と各ドライバー先頭コメントに保持されています。

貢献方法は[CONTRIBUTING.md](CONTRIBUTING.md)を参照してください。
