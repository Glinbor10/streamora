#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef Tag
  #define Tag "v0.0.0"
#endif

[Setup]
AppName=streamora
AppVersion={#AppVersion}
DefaultDirName={autopf}\streamora
DefaultGroupName=streamora
OutputDir=..
OutputBaseFilename=streamora-windows-{#Tag}-setup
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\streamora"; Filename: "{app}\streamora.exe"
Name: "{autodesktop}\streamora"; Filename: "{app}\streamora.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop icon"

[Run]
Filename: "{app}\streamora.exe"; Description: "Launch streamora"; Flags: nowait postinstall skipifsilent
