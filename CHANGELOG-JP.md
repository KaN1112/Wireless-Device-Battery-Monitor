# Wireless Battery JP 変更履歴

この文書は、元プロジェクトからの主な変更と日付を記録します。既存ファイルの著作権表示とGit履歴はそのまま維持されます。

## 2026-11-17 — 1.0.0-jp.1 開発版

- `src/main.cpp`：日本語UI、英語版と独立した識別子、更新間隔設定を追加。
- `src/jp_strings.h`：UTF-16日本語文字列を一か所で管理する軽量な文字列表を追加。
- `src/widget.cpp`、`res/app.rc`、`res/app.manifest`：製品名とツールチップをWireless Battery JPへ変更。
- `installer/WirelessBattery.iss`：日本語セットアップ、固定の日本語版AppId、独立した保存先・自動起動・アンインストール処理へ変更。
- `installer/build-installer.ps1`：日本語版ファイル名、README同梱、SHA-256一覧生成を追加。
- `.github/workflows/build.yml`：日本語版成果物検証、GPL同梱確認、チェックサム、日本語リリース説明を追加。
- `README.md`：非公式日本語版向けの説明、検証状況、ビルド・配布・ライセンス情報へ改訂。
- `installer/THIRD_PARTY_NOTICES.txt`：元プロジェクトとHeadsetControlのクレジット、ライセンス、対応ソース情報を明記。

Logicoolを含むメーカー別HID通信コードは、安全性と互換性を優先して変更していません。
