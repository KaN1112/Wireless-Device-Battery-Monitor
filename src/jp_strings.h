#pragma once
// Wireless Battery JP localization strings.
// Modified 2026-11-17 for the unofficial Japanese edition.
// Kept as UTF-16 literals so all user-visible Win32 text remains Unicode.

namespace jp {
inline constexpr wchar_t AppName[] = L"Wireless Battery JP";
inline constexpr wchar_t NoDevices[] = L"バッテリー情報を取得できるデバイスが見つかりません";
inline constexpr wchar_t DeviceHint[] = L"デバイスをクリックすると表示／非表示を切り替えます";
inline constexpr wchar_t HideSleeping[] = L"最終取得値／スリープ中のデバイスを非表示";
inline constexpr wchar_t Taskbar[] = L"タスクバーに表示（アイコン＋残量）";
inline constexpr wchar_t Tray[] = L"通知領域に表示";
inline constexpr wchar_t Refresh[] = L"今すぐ更新";
inline constexpr wchar_t Autostart[] = L"Windows起動時に自動起動";
inline constexpr wchar_t Exit[] = L"終了";
inline constexpr wchar_t PollInterval[] = L"更新間隔";
inline constexpr wchar_t LowBattery[] = L"バッテリー残量低下";
inline constexpr wchar_t NotConnected[] = L"接続されていません";
inline constexpr wchar_t Unknown[] = L"不明";
inline constexpr wchar_t Charging[] = L"充電中";
inline constexpr wchar_t Asleep[] = L"スリープ中";
inline constexpr wchar_t LastKnown[] = L"最終取得値";
}
