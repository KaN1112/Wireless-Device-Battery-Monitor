; Inno Setup script for Wireless Battery JP (modified 2026-11-17).
; Per-user install by default: no administrator rights needed, installs to %LOCALAPPDATA%\Programs.
; Setup also offers "Install for all users" (Program Files, needs administrator rights).
; Build with installer\build-installer.ps1 (or: ISCC /DAppVersion=1.2.3 installer\WirelessBattery.iss).

#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif
#define Root ".."

[Setup]
AppId={{D16A577B-3523-4D8F-A9CF-8D87AF89E92A}
AppName=Wireless Battery JP
AppVersion={#AppVersion}
AppVerName=Wireless Battery JP {#AppVersion}
AppPublisher=Wireless Battery JP contributors
AppPublisherURL=https://github.com/KaN1112/Wireless-Device-Battery-Monitor
DefaultDirName={autopf}\Wireless Battery JP
DisableProgramGroupPage=yes
DisableDirPage=auto
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
OutputDir={#Root}\dist
OutputBaseFilename=WirelessBatteryJP-Setup-{#AppVersion}
SetupIconFile={#Root}\res\app.ico
UninstallDisplayIcon={app}\WirelessBattery.exe
UninstallDisplayName=Wireless Battery JP
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
ShowLanguageDialog=no
CloseApplications=no

[Languages]
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Tasks]
Name: "autostart"; Description: "Windows起動時にWireless Battery JPを自動起動する"

[Files]
Source: "{#Root}\WirelessBattery.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\third_party\headsetcontrol\headsetcontrol.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\LICENSE"; DestDir: "{app}"; DestName: "LICENSE.txt"; Flags: ignoreversion
Source: "{#Root}\installer\THIRD_PARTY_NOTICES.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#Root}\CHANGELOG-JP.md"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\Wireless Battery JP"; Filename: "{app}\WirelessBattery.exe"

[Run]
Filename: "{app}\WirelessBattery.exe"; Description: "Wireless Battery JPを起動する"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\WirelessBattery.exe"; Parameters: "--quit"; Flags: runhidden waituntilterminated; RunOnceId: "QuitApp"

[Code]
const
  RunKey = 'Software\Microsoft\Windows\CurrentVersion\Run';

procedure QuitRunningApp();
var
  Code: Integer;
begin
  if FileExists(ExpandConstant('{app}\WirelessBattery.exe')) then
    Exec(ExpandConstant('{app}\WirelessBattery.exe'), '--quit', '', SW_HIDE, ewWaitUntilTerminated, Code);
end;

function InstalledRunValue(): String;
begin
  Result := '"' + ExpandConstant('{app}\WirelessBattery.exe') + '"';
end;

{ Removes the startup entry only if it points at this installed copy, so a portable copy's
  "Start with Windows" setting is left alone. }
procedure RemoveOwnAutostart();
var
  Value: String;
begin
  if RegQueryStringValue(HKCU, RunKey, 'WirelessBatteryJP', Value) and (CompareText(Value, InstalledRunValue()) = 0) then
    RegDeleteValue(HKCU, RunKey, 'WirelessBatteryJP');
end;

{ True if this account can create the chosen folder (or write to it if it already exists).
  Without administrator rights, folders such as D:\Programs or Program Files are often read-only. }
function CanWriteTo(Dir: String): Boolean;
var
  Parent, Probe: String;
begin
  Dir := RemoveBackslashUnlessRoot(Dir);
  if DirExists(Dir) then
  begin
    Probe := AddBackslash(Dir) + '~wirelessbattery-write-test.tmp';
    Result := SaveStringToFile(Probe, '', False);
    DeleteFile(Probe);
    exit;
  end;
  { Find the nearest folder that exists and check that a new folder can be created in it. }
  Parent := Dir;
  while not DirExists(Parent) do
  begin
    if ExtractFileDir(Parent) = Parent then
    begin
      Result := False;  { the drive itself does not exist }
      exit;
    end;
    Parent := ExtractFileDir(Parent);
  end;
  Probe := AddBackslash(Parent) + '~wirelessbattery-write-test';
  Result := CreateDir(Probe);
  if Result then
    RemoveDir(Probe);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  { Not in silent installs: there the wizard would wait on a hidden page forever. }
  if (CurPageID = wpSelectDir) and not WizardSilent() and not CanWriteTo(WizardDirValue()) then
  begin
    if IsAdminInstallMode() then
      MsgBox('このフォルダーを作成または書き込みできません：' + #13#10 + WizardDirValue() + #13#10#13#10 +
        '別のフォルダーを選択してください。', mbError, MB_OK)
    else
      MsgBox('管理者権限なしでは、このフォルダーを作成または書き込みできません：' + #13#10 +
        WizardDirValue() + #13#10#13#10 +
        '既定のフォルダーなど書き込み可能な場所を選択するか、セットアップを閉じて管理者として再実行してください。', mbError, MB_OK);
    Result := False;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
    QuitRunningApp();  { upgrade: close the old version so its files can be replaced }
  if CurStep = ssPostInstall then
  begin
    { Same value the app's own "Start with Windows" menu item writes, so the two stay in sync. }
    if WizardIsTaskSelected('autostart') then
      RegWriteStringValue(HKCU, RunKey, 'WirelessBatteryJP', InstalledRunValue())
    else
      RemoveOwnAutostart();
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    RemoveOwnAutostart();
    RegDeleteKeyIncludingSubkeys(HKCU, 'Software\WirelessBatteryJP');
  end;
end;
