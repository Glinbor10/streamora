#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef Tag
  #define Tag "v0.0.0"
#endif

[Setup]
AppName=Streamore
AppVersion={#AppVersion}
DefaultDirName={autopf}\Streamore
DefaultGroupName=Streamore
OutputDir=..
OutputBaseFilename=streamore-windows-{#Tag}-setup
SetupIconFile=..\windows\runner\resources\app_icon.ico
Compression=lzma2
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64compatible

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{group}\Streamore"; Filename: "{app}\streamora.exe"
Name: "{autodesktop}\Streamore"; Filename: "{app}\streamora.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a desktop icon"

[Run]
Filename: "{app}\streamora.exe"; Description: "Launch Streamore"; Flags: nowait postinstall skipifsilent
