[Setup]
AppName=JT65-HF-comfort
AppVerName=JT65-HF-comfort
DefaultDirName={pf}\jt65hf-comfort
DefaultGroupName=JT65HF-Comfort
UninstallDisplayIcon={app}\jt65-hf-comfort.exe
Compression=lzma
SolidCompression=true
LicenseFile=license.txt
OutputBaseFilename=jt65-hf-comfort-setup
OutputDir=Z:\xfer\jt65-hf-comfort-dl4oce\setup
SetupIconFile=Z:\xfer\jt65-hf-comfort-dl4oce\jt65-hf-installer\jt65-hf.ico
AppCopyright=©2009...2011 J C Large W6CQZ
PrivilegesRequired=none
MinVersion=5.1.2600
VersionInfoVersion=4.0
VersionInfoCompany=W6CQZ
VersionInfoDescription=JT65A for HF
VersionInfoTextVersion=JT65-HF-Comfort
VersionInfoCopyright=(c)2009...2011 J C Large W6CQZ
VersionInfoProductName=JT65-HF-Comfort
VersionInfoProductVersion=4.0
SourceDir=Z:\xfer\jt65-hf-comfort-dl4oce\jt65-hf-installer

[InstallDelete]
Type: files; Name: {app}\gpl-2.0.txt
Type: files; Name: {app}\motd.txt
Type: files; Name: {app}\jl_libfftw3f.dll
Type: files; Name: {app}\jl-libportaudio-2.dll
Type: files; Name: {app}\jl-libsamplerate.dll
Type: files; Name: {app}\jt65.dll
Type: files; Name: {app}\jt65-hf-comfort.exe
Type: files; Name: {app}\libfftw3f-3.dll
Type: files; Name: {app}\PSKReporter.dll
Type: files; Name: {app}\HRDInterface0014.dll
Type: files; Name: {app}\HRDInterface0015.dll
Type: files; Name: {app}\pref.dat
Type: files; Name: {app}\KVASD_g95.exe
Type: files; Name: {app}\libmysql.dll

Type: files; Name: {app}\HRDInterface001.dll
Type: files; Name: {app}\jt65-hf.exe
Type: files; Name: {app}\libfftw3f.dll
Type: files; Name: {app}\jt65repair.exe

Type: filesandordirs; Name: {app}\hamlib
Type: filesandordirs; Name: {app}\optfft
Type: filesandordirs; Name: {localappdata}\JT65-HF-Comfort


[Files]
Source: jt65-hf-comfort.exe; DestDir: {app}
Source: KVASD_g95.EXE; DestDir: {app}
Source: jl_libfftw3f-3.dll; DestDir: {app}
Source: libfftw3f-3.dll; DestDir: {app}
Source: jt65.dll; DestDir: {app}
Source: libmysql.dll; DestDir: {app}
Source: jl-libportaudio-2.dll; DestDir: {app}
Source: jl-libsamplerate.dll; DestDir: {app}
Source: PSKReporter.dll; DestDir: {app}
Source: HRDInterface0014.dll; DestDir: {app}
Source: HRDInterface0015.dll; DestDir: {app}
Source: documentation\gpl-2.0.txt; DestDir: {app}\documentation
Source: motd.txt; DestDir: {app}
Source: documentation\jt65-hf-setup.pdf; DestDir: {app}\documentation
Source: documentation\jt65hf-109-addendum.pdf; DestDir: {app}\documentation
Source: documentation\JT65-HF-Comfort-3 Anwenderbeschreibung.pdf; DestDir: {app}\documentation
Source: documentation\History.txt; DestDir: {app}\documentation
Source: pref.dat; DestDir: {app}
Source: hamlib\*.*; DestDir: {app}\hamlib
Source: hamlib\rig_dde\*.*; DestDir: {app}\hamlib\rig_dde
Source: optFFT\*.*; DestDir: {app}\optFFT
;Source: placeholder; DestDir: {localappdata}\JT65-HF-Comfort-3.3

[Run]
Filename: {app}\optFFT\jt65-hf.exe; Flags: nowait; Description: Setup indicates it should update optimal FFT calculations.  This will take from 10 to 20+ minutes.  If you do not wish to do this uncheck the box to left of this text!

[Icons]
Name: {group}\JT65-HF-comfort; Filename: {app}\jt65-hf-comfort.exe
;Name: {group}\JT65-HF Configuration Repair; Filename: {app}\jt65repair.exe
Name: {group}\Uninstall JT65-HF; Filename: {uninstallexe}
Name: {group}\Documentation; Filename: {app}\jt65-hf-setup.pdf
Name: {group}\Documentation 1.0.9; Filename: {app}\jt65hf-109-addendum.pdf
Name: {group}\Documentation; Filename: {app}\jt65-hf-comfort-3 Anwenderbeschreibung.pdf
[Code]
function optFFTCheck(): Boolean;
Var
  fname : String;
Begin
  fname := ExpandConstant('{localappdata}')+'\JT65-HF-Comfort-3\wisdom2.dat';
  // The logic is somewhat reversed from what might seem correct
  // here.  I want to run optfft if the file DOES NOT exist thus
  // the seemingly backward return result.
  If FileExists(fname) Then result := False else result := True;
End;
