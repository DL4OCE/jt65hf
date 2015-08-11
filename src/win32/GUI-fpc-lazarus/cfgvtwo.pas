unit cfgvtwo;
//
// Copyright (c) 2008,2009 J C Large - W6CQZ
//
//
// JT65-HF is the legal property of its developer.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING. If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.
//
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, StdCtrls, StrUtils, globalData, CTypes, synaser, EditBtn, Spin,
  MaskEdit, catControl, diagout, valobject, types, odbcconn, db, mysql55conn, sqldb, libDL4OCE, verHolder;

Const
  myWordDelims = [' ',','];
  hrdDelim = [','];
  JT_DLL = 'jt65.dll';

type
  { TForm6 }
  TForm6 = class(TForm)
    btnClearLog, Button1, btnTestMySQL, buttonTestPTT, setHRDQRG, testHRDPTT: TButton;
    cbShowUsageAdvices: TCheckBox;
    cbShowWatchdogDiagout: TCheckBox;
    cbDecodeDividerCompact: TCheckBox;
    cbDecodeDivider: TCheckBox;
    GroupBox5: TGroupBox;
    cbCWID: TCheckBox;
    cbCWIDFT: TCheckBox;
    GroupBox4: TGroupBox;
    cbMultiAutoEnableHTX: TCheckBox;
    cbRestoreMulti: TCheckBox;
    cbDisableMultiQSO: TCheckBox;
    cbMultiAutoEnable: TCheckBox;
    GroupBox3: TGroupBox;
    cbAutoScrollRX: TCheckBox;
    cbSendStats: TCheckBox;
    GroupBox2: TGroupBox;
    rbKM: TRadioButton;
    rbMiles: TRadioButton;
    rbDecSepUS: TRadioButton;
    rbDecSepEU: TRadioButton;
    GroupBox1: TGroupBox;
    textlogerrror: TLabel;
    CheckNow: TButton;
    cbCheckForUpdates: TCheckBox;
    cbATQSY1, cbATQSY2, cbATQSY3, cbATQSY4, cbATQSY5, cbEnableQSY1, cbEnableQSY2, cbEnableQSY3, cbEnableQSY4,
      cbEnableQSY5, cbSaveCSV, cbSaveTxLog, cbToAtLog, cbBookmark, cbWipLg, cbWipTc, cbTXWatchDog,
      cbUseAltPTT, cbNwhmC, CheckBox1, CheckBox2, cbNotifyByUSB, cbLogHRD, chkEnableAutoSR, chkHRDPTT, chkNoOptFFT, chkTxDFVFO, chkUseCommander, chkUseHRD,
      chkUseOmni: TCheckBox;
    cbAudioIn, cbAudioOut, ComboBox1, ComboBox2, ComboBox3, ComboBox4, ComboBox5, ComboBox6, ComboBox7, ComboBox8, comboPrefix, comboSuffix: TComboBox;
    DirectoryEdit1: TDirectoryEdit;
    Edit1, MySQLpassword, Edit2, Edit3, Edit4, Edit5, Edit6, Edit7, Edit8, Edit9, MySQLhostname, MySQLusername, editPSKRAntenna, editPSKRCall, editUserDefinedPort1,
      edMyCall, edMyGrid, edQRGQSY1, edQRGQSY2, edQRGQSY3, edQRGQSY4, edQRGQSY5, edRXSRCor, edTXSRCor, edUserMsg11, edUserMsg10, edUserMsg12, edUserMsg13, edUserMsg14,
      edUserMsg15, edUserMsg17, edUserMsg16, edUserMsg18, edUserMsg19, edUserMsg20, edUserMsg4, edUserMsg5, edUserMsg6, edUserMsg7, edUserMsg8, edUserMsg9, edUserQRG1,
      edUserQRG10, edUserQRG2, edUserQRG3, edUserQRG4, edUserQRG5, edUserQRG6, edUserQRG7, edUserQRG8, edUserQRG9, hrdAddress, hrdPort, MySQLdatabase, rigQRG: TEdit;
    FileListbox1: TFileNameEdit;
    groupHRD: TGroupBox ;
    Label73, Label1, Label10, Label122, Label123, Label124, Label125, Label126, Label127, Label128, Label129, Label130, Label131, Label132, Label16,
      Label2, Label20, Label21, Label22, Label23, Label26, Label27, Label28, Label29, Label3, Label30, Label31, Label32, Label33, Label34, Label35, Label36, Label37,
      Label38, Label4, Label39, Label41, Label42, Label43, Label44, Label45, Label46, Label47, Label48, Label49, Label5, Label50, Label51, Label52, Label53,
      Label54, Label55, Label56, Label57, Label58, Label59, Label60, Label61, Label62, Label63, Label64, Label65, Label66, Label67, Label68, Label69, Label70, Label71,
      Label72, Label74, Label75, Label76, Label77, Label78, Label79, Label9: TLabel;
    lbDiagLog: TListBox;
    PageControl1: TPageControl;
    qsyHour1, qsyHour2, qsyHour3, qsyHour4, qsyHour5, qsyMinute1, qsyMinute2, qsyMinute3, qsyMinute4, qsyMinute5, SpinTXCount: TSpinEdit;
    RadioGroup1, RadioGroup2, OmniGroup: TRadioGroup;
    radioOmni1, radioOmni2, rbHRD4, rbHRD5: TRadioButton;
    TabSheet1, TabSheet2, TabSheet3, TabSheet4, TabSheet5, TabSheet6, TabSheet7: TTabSheet;
    ConnDB: TMySQL55Connection;
    procedure btnClearLogClick(Sender: TObject);
    procedure btnTestMySQLClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure buttonTestPTTClick(Sender: TObject);
    procedure cbAudioInChange(Sender: TObject);
    procedure cbAudioOutChange(Sender: TObject);
    procedure cbCWIDChange(Sender: TObject);
    procedure cbCWIDFTChange(Sender: TObject);
    procedure cbDecodeDividerCompactChange(Sender: TObject);
    procedure cbDisableMultiQSOChange(Sender: TObject);
    procedure cbLogHRDChange(Sender: TObject);
    procedure cbSendStatsChange(Sender: TObject);
    procedure cbShowWatchdogDiagoutChange(Sender: TObject);
    procedure cbWipLgChange(Sender: TObject);
    procedure cbWipTcChange(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckNowClick(Sender: TObject);
    procedure chkEnableAutoSRChange(Sender: TObject);
    procedure chkUseCommanderChange(Sender: TObject);
    procedure chkUseHRDChange(Sender: TObject);
    procedure chkUseOmniChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure ComboBox8Change(Sender: TObject);
    procedure comboPrefixChange(Sender: TObject);
    procedure edMyCallChange(Sender: TObject);
    procedure edMyCallKeyPress (Sender : TObject ; var Key : char );
    procedure edMyGridKeyPress (Sender : TObject ; var Key : char );
    procedure edUserMsg4KeyPress (Sender : TObject ; var Key : char );
    procedure edUserMsgChange(Sender: TObject);
    procedure edUserQRG13KeyPress (Sender : TObject ; var Key : char );
    procedure FileListbox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure hrdAddressChange(Sender: TObject);
    procedure hrdPortChange(Sender: TObject);
    procedure Label70Click(Sender: TObject);
    procedure ODBCConnection1AfterConnect(Sender: TObject);
    procedure ODBCConnection1Login(Sender: TObject; Username, Password: string);
    procedure rbDecSepEUChange(Sender: TObject);
    procedure rbDecSepEUClick(Sender: TObject);
    procedure rbDecSepUSChange(Sender: TObject);
    procedure rbDecSepUSClick(Sender: TObject);
    procedure setHRDQRGClick(Sender: TObject);
    procedure SpinTXCountChange(Sender: TObject);
    procedure SpinTXCountKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TabSheet7ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure testHRDPTTClick(Sender: TObject);
  private
    { private declarations }
  public
    FTransaction : TSQLTransaction;
    procedure ConnectMySQL;
  end;

var
  Form6: TForm6;
  glcqColor, glcallColor, glqsoColor, glqsobefColor, glqsocilColor, glclcfmcurrColor, glclcfmabColor, glbmbgrColor: TColor;
  cfpttSerial: TBlockSerial;
  glautoSR, glmustConfig, glrbcLogin, glrbcLogout, gld65AudioChange, glcallChange, gllogscanned, fileformatadi, fileformatmixw, emptyfile, mustsaveconfig: Boolean;
  glcatBy, glmyCall: String; // Can be hamlib, omnirig, hrd, commander or none.
  cfval: valobject.TValidator; // Class variable for validator object.  Needed for QRG conversions.

implementation

{ TForm6 }

function ptt(nport : Pointer; msg : Pointer; ntx : Pointer; iptt : Pointer) : CTypes.cint; cdecl; external JT_DLL name 'ptt_';

procedure raisePTT();
var
  np, ntx, iptt : CTypes.cint;
  msg           : CTypes.cschar;
  tmp, nport    : String;
Begin
  msg := 0;
  np := 0;
  ntx := 1;
  iptt := 0;
  tmp := '';
  nport := UpperCase(form6.editUserDefinedPort1.Text);
  if nport = 'None' Then nport := '';
  if nport = 'NONE' Then nport := '';
  if Length(nport) > 3 Then Begin
    if Length(nport) = 4 Then Begin
      // Length = 4 = COM#
      tmp := '';
      tmp := nport[4];
    End;
    if Length(nport) = 5 Then Begin
      // Length = 5 = COM##
      tmp := '';
      tmp := nport[4..5];
    End;
    If Length(nport) = 6 Then Begin
      // Length = 6 = COM###
      tmp := '';
      tmp := nport[4..6];
    End;
    np := StrToInt(tmp);
    if np > 0 Then ptt(@np, @msg, @ntx, @iptt);
  End Else Begin
    np := 0;
    if tryStrToInt(form6.editUserDefinedPort1.Text,np) Then Begin
      if np > 0 Then ptt(@np, @msg, @ntx, @iptt);
    End;
  End;
End;

procedure lowerPTT();
var
  np, ntx, iptt : CTypes.cint;
  msg           : CTypes.cschar;
  tmp, nport    : String;
Begin
  msg := 0;
  np := 0;
  ntx := 0;
  iptt := 0;
  tmp := '';
  nport := UpperCase(cfgvtwo.Form6.editUserDefinedPort1.Text);
  if nport = 'None' Then nport:= '';
  if nport = 'NONE' Then nport:= '';
  if Length(nport) > 3 Then Begin
    if Length(nport) = 4 Then Begin
      // Length = 4 = COM#
      tmp := '';
      tmp := nport[4];
    End;
    if Length(nport) = 5 Then Begin
      // Length = 5 = COM##
      tmp := '';
      tmp := nport[4..5];
    End;
    If Length(nport) = 6 Then Begin
      // Length = 6 = COM###
      tmp := '';
      tmp := nport[4..6];
    End;
    np := StrToInt(tmp);
    if np > 0 Then ptt(@np, @msg, @ntx, @iptt);
  End Else Begin
    np := 0;
    if tryStrToInt(cfgvtwo.Form6.editUserDefinedPort1.Text,np) Then Begin
      if np > 0 Then ptt(@np, @msg, @ntx, @iptt);
    End;
  End;
End;

procedure altRaisePTT();
var
  np        : Integer;
  pttOpened : Boolean;
  nport     : String;
Begin
  pttOpened := False;
  if not pttOpened Then Begin
    nport := '';
    nport := Form6.editUserDefinedPort1.Text;
    if nport = 'None' Then nport := '';
    if nport = 'NONE' Then nport := '';
    if Length(nport) > 3 Then Begin
      try
        cfpttSerial := TBlockSerial.Create;
        cfpttSerial.RaiseExcept := True;
        cfpttSerial.Connect(nport);
        cfpttSerial.Config(9600,8,'N',0,false,true);
        pttOpened := True;
      except
        //dlog.fileDebug('PTT Port [' + nport + '] failed to key up.');
      end;
    End Else Begin
      np := 0;
      if tryStrToInt(Form6.editUserDefinedPort1.Text,np) Then Begin
        Try
          cfpttSerial := TBlockSerial.Create;
          cfpttSerial.RaiseExcept := True;
          cfpttSerial.Connect('COM' + IntToStr(np));
          cfpttSerial.Config(9600,8,'N',0,false,true);
          pttOpened := True;
        Except
          //dlog.fileDebug('PTT Port [COM' + IntToStr(np) + '] failed to key up.');
        End;
      End Else pttOpened := False;
    End;
  End;
End;

procedure altLowerPTT();
Begin
  cfpttSerial.Free;
End;

procedure TForm6.Button1Click(Sender: TObject);
var
  logPath      : string;
  configError  : Boolean;
  lfile        : Textfile;
begin
  if rbDecSepUS.Checked then DecimalSeparator:= '.'
  else DecimalSeparator:= ',';
  textlogerrror.Caption:= '';
  configerror:=False;
  fileformatadi:=False;
  fileformatmixw:=False;
  logpath:=cfgvtwo.Form6.FileListbox1.Text;
  if logpath='' then configerror:=True;
  if AnsiEndsText('.adi',logpath) then begin
    fileformatadi:=True;
    fileformatmixw:=False;
    configerror:=False;
  end;
  if AnsiEndsText('.log',logpath) then begin
    fileformatmixw:=True;
    fileformatadi:=False;
    ConfigError:=False;
  end;
  if (not fileformatadi) and (not fileformatmixw) then begin
    configError:=True;
    textlogerrror.Caption:= 'File name does not end with *.adi or *.log !!';
    PageControl1.ActivePage:= TabSheet5;
  end;
  if (fileformatadi or fileformatmixw) and (not FileExists(logpath)) then begin
    gllogscanned:=False;
    AssignFile(lfile,logpath);
    rewrite(lfile);
    if fileformatadi then begin
      writeln(lfile,'JT65-HF Export');
      writeln(lfile,'<adif_ver:4>1.00');
      writeln(lfile,'<eoh>');
      emptyfile:=True;
      ////CheckBox1.Checked:=True;
      ////CheckBox2.Checked:=False;
      ////Decimalseparator:=',';
      globaldata.bigletter:=True;
    end;
    closeFile(lfile);
  end;
  if configError then glmustconfig:=True
  else begin
    textlogerrror.Caption:= '';
    glmustConfig := False;
    Close;
    gllogscanned:=False;
  end;
  mustsaveconfig:=True;
end;

procedure TForm6.buttonTestPTTClick(Sender: TObject);
begin
  if cbUseAltPTT.Checked Then altRaisePTT() else raisePTT();
  sleep(500);
  if cbUseAltPTT.Checked Then altLowerPTT() else lowerPTT();
end;

procedure TForm6.cbAudioInChange(Sender: TObject);
begin
  gld65AudioChange := True;
end;

procedure TForm6.cbAudioOutChange(Sender: TObject);
begin
  gld65AudioChange := True;
end;

procedure TForm6.cbCWIDChange(Sender: TObject);
begin
  if cbCWID.Checked Then cbCWIDFT.Checked:=False;
end;

procedure TForm6.cbCWIDFTChange(Sender: TObject);
begin
  if cbCWIDFT.Checked Then cbCWID.Checked:=False;
end;

procedure TForm6.cbDecodeDividerCompactChange(Sender: TObject);
begin

end;

procedure TForm6.cbDisableMultiQSOChange(Sender: TObject);
begin

end;

procedure TForm6.cbLogHRDChange(Sender: TObject);
begin
  MySQLhostname.Enabled:= cbLogHRD.Checked;
  MySQLdatabase.Enabled:= cbLogHRD.Checked;
  MySQLusername.Enabled:= cbLogHRD.Checked;
  MySQLpassword.Enabled:= cbLogHRD.Checked;
  btnTestMySQL.Enabled:= cbLogHRD.Checked;
end;

procedure TForm6.cbSendStatsChange(Sender: TObject);
begin
  if (Length(edMyCall.Text)>0) and (cbSendStats.Checked) then sendStats(cfgvtwo.Form6.edMyCall.Text, verHolder.verUpdCompare);
end;

procedure TForm6.cbShowWatchdogDiagoutChange(Sender: TObject);
begin
  SpinTXCountChange(Sender);
end;

procedure TForm6.ConnectMySQL;
begin
  ConnDB:= TMySQL55Connection.Create(nil);
  ConnDB.HostName:= MySQLhostname.Text;
  ConnDB.UserName:= MySQLusername.Text;
  ConnDB.Password:= MySQLpassword.Text;
  ConnDB.port:= 3306;
  ConnDB.DatabaseName:= MySQLdatabase.Text;
  try
    ConnDB.Connected:= true;
  except
    on E : EDatabaseError do
      ShowMessage('MySQL error:' + ' ' + E.ClassName + ': ' + E.Message);
    on E : Exception do
      ShowMessage('Error:' + ' ' + E.ClassName + ': ' + E.Message);
  end;
end;

procedure TForm6.cbWipLgChange(Sender: TObject);
begin
  if cbWipLg.checked then cbWipTc.checked:=False;
  cbNwhmC.Visible:=True;
end;
procedure TForm6.cbWipTcChange(Sender: TObject);
begin
  if cbWipTC.checked then cbWipLg.checked:=False;
  cbNwhmC.Visible:=False
end;

procedure TForm6.CheckBox1Change(Sender: TObject);
begin
 { if CheckBox1.Checked Then Begin
    globalData.decimalOverride1 := true;
    globalData.decimalOverride2 := false;
    CheckBox2.Checked := false;
  end else globalData.decimalOverride1 := false;      }
end;

procedure TForm6.CheckBox2Change(Sender: TObject);
begin
 { if CheckBox2.Checked Then Begin
    globalData.decimalOverride2 := true;
    globalData.decimalOverride1 := false;
    CheckBox1.Checked := false;
  end else globalData.decimalOverride2 := false; }
end;

procedure TForm6.CheckBox3Change(Sender: TObject);
begin
  //cbCheckForAlphaVersions.Enabled:= cbCheckForUpdates.Checked;
  CheckNow.Enabled:= cbCheckForUpdates.Checked;
end;

procedure TForm6.CheckNowClick(Sender: TObject);
begin
  if (cbCheckForUpdates.Checked) then checkForUpdate;
end;

procedure TForm6.chkEnableAutoSRChange(Sender: TObject);
begin
  if chkEnableAutoSR.Checked Then glautoSR := True else glautoSR := False;
end;

procedure TForm6.chkUseCommanderChange(Sender: TObject);
begin
  If chkUseCommander.Checked Then Begin
    chkUseHRD.Checked := False;
    chkUseOmni.Checked := False;
    glcatBy := 'commander';
  End Else Begin
    glcatBy := 'none';
    globalData.gqrg := 0.0;
    globalData.strqrg := '0';
  End;
end;

procedure TForm6.chkUseHRDChange(Sender: TObject);
begin
  If chkUseHRD.Checked Then Begin
    groupHRD.Caption := 'Waiting for data from HRD';
    groupHRD.Visible := True;
    chkUseOmni.Checked := False;
    chkUseCommander.Checked := False;
    glcatBy := 'hrd';
  End Else Begin
    groupHRD.Visible := False;
    glcatBy := 'none';
    globalData.gqrg := 0.0;
    globalData.strqrg := '0';
  End;
end;

procedure TForm6.chkUseOmniChange(Sender: TObject);
begin
  If chkUseOmni.Checked Then Begin
    chkUseHRD.Checked := False;
    chkUseCommander.Checked := False;
    glcatBy := 'omni';
  End Else Begin
    glcatBy := 'none';
    globalData.gqrg := 0.0;
    globalData.strqrg := '0';
  End;
end;

procedure TForm6.btnClearLogClick(Sender: TObject);
begin
  lbDiagLog.Clear;
end;

procedure TForm6.btnTestMySQLClick(Sender: TObject);
begin
  ConnectMySQL;
  if (ConnDB.Connected) then ShowMessage('Successfully connected ('+ConnDB.ServerInfo+')')
  else ShowMessage('Connection failed ('+ConnDB.ServerInfo+')');
  ConnDB.Destroy;
end;

procedure TForm6.edMyCallChange(Sender: TObject);
begin
  If (AnsiContainsText(Form6.edMyCall.Text,'/')) Or (AnsiContainsText(Form6.edMyCall.Text,'.')) Or
    (AnsiContainsText(Form6.edMyCall.Text,'-')) Or (AnsiContainsText(Form6.edMyCall.Text,'\')) Or
    (AnsiContainsText(Form6.edMyCall.Text,',')) Then Begin
    edMyCall.Clear;
    glmyCall := '';
    Label26.Font.Color := clRed;
    glCallChange := True;
  End Else Begin
    glmyCall := form6.edMyCall.Text;
    Label26.Font.Color := clBlack;
    glCallChange := True;
  End;
end;

procedure TForm6.edMyCallKeyPress(Sender : TObject; var Key : char);
Var
  i : Integer;
begin
  // Filtering input to signal report text box such that it only allows numerics and -
  i := ord(key);
  if not (i=8) then begin
    Key := upcase(key);
    if not cfval.asciiValidate(Key,'csign') then Key := #0;
  end;
end;

procedure TForm6.edMyGridKeyPress(Sender : TObject; var Key : char);
Var
  i : Integer;
begin
  // Filtering input to signal report text box such that it only allows numerics and -
  i := ord(key);
  if not (i=8) then begin
    Key := upcase(key);
    if not cfval.asciiValidate(Key,'gsign') then Key := #0;
  end;
end;

procedure TForm6.edUserMsg4KeyPress(Sender : TObject; var Key : char);
Var
  i : Integer;
begin
  // Filtering input to signal report text box such that it only allows numerics and -
  i := ord(key);
  if not (i=8) then begin
    Key := upcase(key);
    if not cfval.asciiValidate(Key,'free') then Key := #0;
  end;
end;

procedure TForm6.edUserMsgChange(Sender: TObject);
var
  foo : String;
  i   : Integer;
begin
  foo := TEdit(Sender).Text;
  // Replace any bad characters with space
  for i := 1 to Length(foo) do if not cfval.asciiValidate(Char(foo[i]),'free') then foo[i] := ' ';
  // Strip leading RRR, RO or 73
  if (Length(foo)>2) And (foo[1..3] = 'RRR') then begin
    foo[1] := ' ';
    foo[2] := ' ';
    foo[3] := ' ';
    foo := TrimLeft(TrimRight(Upcase(foo)));
  end;
  if (Length(foo)>1) And (foo[1..2] = 'RO')  then begin
    foo[1] := ' ';
    foo[2] := ' ';
    foo := TrimLeft(TrimRight(Upcase(foo)));
  end;
  if (Length(foo)>1) And (foo[1..2] = '73')  then begin
    foo[1] := ' ';
    foo[2] := ' ';
    foo := TrimLeft(TrimRight(Upcase(foo)));
  end;
  TEdit(Sender).Text := foo;
end;

procedure TForm6.edUserQRG13KeyPress(Sender : TObject; var Key : char);
Var
  i : Integer;
begin
  // Filtering input to signal report text box such that it only allows numerics and -
  i := ord(key);
  if not (i=8) then begin
    Key := upcase(key);
    if not cfval.asciiValidate(Key,'numeric') then Key := #0;
  end;
end;

procedure TForm6.FileListbox1Change(Sender: TObject);
begin
  textlogerrror.Caption:= '';
  if not (AnsiEndsText('.adi',FileListbox1.Text) or AnsiEndsText('.log',FileListbox1.Text)) then textlogerrror.Caption:= 'File name does not end with *.adi or *.log !!';
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  DirectoryEdit1.Directory := GetAppConfigDir(False);
  cbLogHRDChange(Sender);

end;

procedure TForm6.hrdAddressChange(Sender: TObject);
begin
  globalData.hrdcatControlcurrentRig.hrdAddress := cfgvtwo.Form6.hrdAddress.Text;
end;

procedure TForm6.hrdPortChange(Sender: TObject);
Var
  tstint : Integer;
begin
  tstint := 0;
  If TryStrToInt(hrdPort.Text,tstint) Then globalData.hrdcatControlcurrentRig.hrdPort := tstint
  else globalData.hrdcatControlcurrentRig.hrdPort := 7809;
end;

procedure TForm6.Label70Click(Sender: TObject);
begin

end;

procedure TForm6.ODBCConnection1AfterConnect(Sender: TObject);
begin
  ShowMessage('Connected.');
end;

procedure TForm6.ODBCConnection1Login(Sender: TObject; Username, Password: string);
begin
  ShowMessage('Logged on.');
end;

procedure TForm6.rbDecSepEUChange(Sender: TObject);
begin

end;

procedure TForm6.rbDecSepEUClick(Sender: TObject);
begin
  //  if rbDecSepEU.Checked Then Begin
    globalData.decimalOverride1 := true;
    globalData.decimalOverride2 := false;
  //end else globalData.decimalOverride1 := false;
end;

procedure TForm6.rbDecSepUSChange(Sender: TObject);
begin

end;

procedure TForm6.rbDecSepUSClick(Sender: TObject);
begin
  globalData.decimalOverride1 := false;
  globalData.decimalOverride2 := true;
end;

procedure TForm6.setHRDQRGClick(Sender: TObject);
Begin
  if rbHRD4.Checked Then globalData.hrdVersion :=4;
  if rbHRD5.Checked Then globalData.hrdVersion :=5;
  catControl.hrdrigCAPS();
  if globalData.hrdcatControlcurrentRig.hrdAlive then begin
    // Need to send a set QRG message
    catControl.writeHRD('[' + globalData.hrdcatControlcurrentRig.radioContext + '] set frequency-hz ' + Edit4.Text);
  end;
end;

procedure TForm6.SpinTXCountChange(Sender: TObject);
begin
  cbShowWatchdogDiagout.Caption:= 'Show diagnosis output after ' + SpinTXCount.Text + ' times.';
end;

procedure TForm6.SpinTXCountKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     {TODO Validate as numeric only}
end;

procedure TForm6.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm6.TabSheet7ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm6.testHRDPTTClick(Sender: TObject);
begin
  if rbHRD4.Checked Then globalData.hrdVersion :=4;
  if rbHRD5.Checked Then globalData.hrdVersion :=5;
  catControl.hrdrigCAPS();
  if globalData.hrdcatControlcurrentRig.hrdAlive Then Begin
    // Need to execute an HRD PTT sequence.
    // [c] set button-select XXX 0|1
    catControl.writeHRD('[' + globalData.hrdcatControlcurrentRig.radioContext + '] set button-select ' + globalData.hrdcatControlcurrentRig.txControl + ' 1');
    sleep(500);
    catControl.writeHRD('[' + globalData.hrdcatControlcurrentRig.radioContext + '] set button-select ' + globalData.hrdcatControlcurrentRig.txControl + ' 0');
  end;
end;

procedure TForm6.ComboBox1Change(Sender: TObject);
begin
  Case ComboBox1.ItemIndex of
    0  : Edit1.Color := clGreen;
    1  : Edit1.Color := clOlive;
    2  : Edit1.Color := clSkyBlue;
    3  : Edit1.Color := clPurple;
    4  : Edit1.Color := clTeal;
    5  : Edit1.Color := clGray;
    6  : Edit1.Color := clSilver;
    7  : Edit1.Color := clRed;
    8  : Edit1.Color := clLime;
    9  : Edit1.Color := clYellow;
    10 : Edit1.Color := clMoneyGreen;
    11 : Edit1.Color := clFuchsia;
    12 : Edit1.Color := clAqua;
    13 : Edit1.Color := clCream;
    14 : Edit1.Color := clMedGray;
    15 : Edit1.Color := clWhite;
  End;
  Case ComboBox1.ItemIndex of
    0  : ComboBox1.Color := clGreen;
    1  : ComboBox1.Color := clOlive;
    2  : ComboBox1.Color := clSkyBlue;
    3  : ComboBox1.Color := clPurple;
    4  : ComboBox1.Color := clTeal;
    5  : ComboBox1.Color := clGray;
    6  : ComboBox1.Color := clSilver;
    7  : ComboBox1.Color := clRed;
    8  : ComboBox1.Color := clLime;
    9  : ComboBox1.Color := clYellow;
    10 : ComboBox1.Color := clMoneyGreen;
    11 : ComboBox1.Color := clFuchsia;
    12 : ComboBox1.Color := clAqua;
    13 : ComboBox1.Color := clCream;
    14 : ComboBox1.Color := clMedGray;
    15 : ComboBox1.Color := clWhite;
  End;
  Case ComboBox1.ItemIndex of
    0  : glcqColor := clGreen;
    1  : glcqColor := clOlive;
    2  : glcqColor := clSkyBlue;
    3  : glcqColor := clPurple;
    4  : glcqColor := clTeal;
    5  : glcqColor := clGray;
    6  : glcqColor := clSilver;
    7  : glcqColor := clRed;
    8  : glcqColor := clLime;
    9  : glcqColor := clYellow;
    10 : glcqColor := clMoneyGreen;
    11 : glcqColor := clFuchsia;
    12 : glcqColor := clAqua;
    13 : glcqColor := clCream;
    14 : glcqColor := clMedGray;
    15 : glcqColor := clWhite;
  End;
end;

procedure TForm6.ComboBox2Change(Sender: TObject);
begin
  Case ComboBox2.ItemIndex of
    0  : Edit2.Color := clGreen;
    1  : Edit2.Color := clOlive;
    2  : Edit2.Color := clSkyBlue;
    3  : Edit2.Color := clPurple;
    4  : Edit2.Color := clTeal;
    5  : Edit2.Color := clGray;
    6  : Edit2.Color := clSilver;
    7  : Edit2.Color := clRed;
    8  : Edit2.Color := clLime;
    9  : Edit2.Color := clYellow;
    10 : Edit2.Color := clMoneyGreen;
    11 : Edit2.Color := clFuchsia;
    12 : Edit2.Color := clAqua;
    13 : Edit2.Color := clCream;
    14 : Edit2.Color := clMedGray;
    15 : Edit2.Color := clWhite;
  End;
  Case ComboBox2.ItemIndex of
    0  : ComboBox2.Color := clGreen;
    1  : ComboBox2.Color := clOlive;
    2  : ComboBox2.Color := clSkyBlue;
    3  : ComboBox2.Color := clPurple;
    4  : ComboBox2.Color := clTeal;
    5  : ComboBox2.Color := clGray;
    6  : ComboBox2.Color := clSilver;
    7  : ComboBox2.Color := clRed;
    8  : ComboBox2.Color := clLime;
    9  : ComboBox2.Color := clYellow;
    10 : ComboBox2.Color := clMoneyGreen;
    11 : ComboBox2.Color := clFuchsia;
    12 : ComboBox2.Color := clAqua;
    13 : ComboBox2.Color := clCream;
    14 : ComboBox2.Color := clMedGray;
    15 : ComboBox2.Color := clWhite;
  End;
  Case ComboBox2.ItemIndex of
    0  : glcallColor := clGreen;
    1  : glcallColor := clOlive;
    2  : glcallColor := clSkyBlue;
    3  : glcallColor := clPurple;
    4  : glcallColor := clTeal;
    5  : glcallColor := clGray;
    6  : glcallColor := clSilver;
    7  : glcallColor := clRed;
    8  : glcallColor := clLime;
    9  : glcallColor := clYellow;
    10 : glcallColor := clMoneyGreen;
    11 : glcallColor := clFuchsia;
    12 : glcallColor := clAqua;
    13 : glcallColor := clCream;
    14 : glcallColor := clMedGray;
    15 : glcallColor := clWhite;
  End;
end;

procedure TForm6.ComboBox3Change(Sender: TObject);
begin
  Case ComboBox3.ItemIndex of
    0  : Edit3.Color := clGreen;
    1  : Edit3.Color := clOlive;
    2  : Edit3.Color := clSkyBlue;
    3  : Edit3.Color := clPurple;
    4  : Edit3.Color := clTeal;
    5  : Edit3.Color := clGray;
    6  : Edit3.Color := clSilver;
    7  : Edit3.Color := clRed;
    8  : Edit3.Color := clLime;
    9  : Edit3.Color := clYellow;
    10 : Edit3.Color := clMoneyGreen;
    11 : Edit3.Color := clFuchsia;
    12 : Edit3.Color := clAqua;
    13 : Edit3.Color := clCream;
    14 : Edit3.Color := clMedGray;
    15 : Edit3.Color := clWhite;
  End;
  Case ComboBox3.ItemIndex of
    0  : ComboBox3.Color := clGreen;
    1  : ComboBox3.Color := clOlive;
    2  : ComboBox3.Color := clSkyBlue;
    3  : ComboBox3.Color := clPurple;
    4  : ComboBox3.Color := clTeal;
    5  : ComboBox3.Color := clGray;
    6  : ComboBox3.Color := clSilver;
    7  : ComboBox3.Color := clRed;
    8  : ComboBox3.Color := clLime;
    9  : ComboBox3.Color := clYellow;
    10 : ComboBox3.Color := clMoneyGreen;
    11 : ComboBox3.Color := clFuchsia;
    12 : ComboBox3.Color := clAqua;
    13 : ComboBox3.Color := clCream;
    14 : ComboBox3.Color := clMedGray;
    15 : ComboBox3.Color := clWhite;
  End;
  Case ComboBox3.ItemIndex of
    0  : glqsoColor := clGreen;
    1  : glqsoColor := clOlive;
    2  : glqsoColor := clSkyBlue;
    3  : glqsoColor := clPurple;
    4  : glqsoColor := clTeal;
    5  : glqsoColor := clGray;
    6  : glqsoColor := clSilver;
    7  : glqsoColor := clRed;
    8  : glqsoColor := clLime;
    9  : glqsoColor := clYellow;
    10 : glqsoColor := clMoneyGreen;
    11 : glqsoColor := clFuchsia;
    12 : glqsoColor := clAqua;
    13 : glqsoColor := clCream;
    14 : glqsoColor := clMedGray;
    15 : glqsoColor := clWhite;
  End;
end;

procedure TForm6.ComboBox4Change(Sender: TObject);
begin
  Case ComboBox4.ItemIndex of
    0  : Edit5.Color := clGreen;
    1  : Edit5.Color := clOlive;
    2  : Edit5.Color := clSkyBlue;
    3  : Edit5.Color := clPurple;
    4  : Edit5.Color := clTeal;
    5  : Edit5.Color := clGray;
    6  : Edit5.Color := clSilver;
    7  : Edit5.Color := clRed;
    8  : Edit5.Color := clLime;
    9  : Edit5.Color := clYellow;
    10 : Edit5.Color := clMoneyGreen;
    11 : Edit5.Color := clFuchsia;
    12 : Edit5.Color := clAqua;
    13 : Edit5.Color := clCream;
    14 : Edit5.Color := clMedGray;
    15 : Edit5.Color := clWhite;
  End;
  Case ComboBox4.ItemIndex of
    0  : ComboBox4.Color := clGreen;
    1  : ComboBox4.Color := clOlive;
    2  : ComboBox4.Color := clSkyBlue;
    3  : ComboBox4.Color := clPurple;
    4  : ComboBox4.Color := clTeal;
    5  : ComboBox4.Color := clGray;
    6  : ComboBox4.Color := clSilver;
    7  : ComboBox4.Color := clRed;
    8  : ComboBox4.Color := clLime;
    9  : ComboBox4.Color := clYellow;
    10 : ComboBox4.Color := clMoneyGreen;
    11 : ComboBox4.Color := clFuchsia;
    12 : ComboBox4.Color := clAqua;
    13 : ComboBox4.Color := clCream;
    14 : ComboBox4.Color := clMedGray;
    15 : ComboBox4.Color := clWhite;
  End;
  Case ComboBox4.ItemIndex of
    0  : glqsobefColor := clGreen;
    1  : glqsobefColor := clOlive;
    2  : glqsobefColor := clSkyBlue;
    3  : glqsobefColor := clPurple;
    4  : glqsobefColor := clTeal;
    5  : glqsobefColor := clGray;
    6  : glqsobefColor := clSilver;
    7  : glqsobefColor := clRed;
    8  : glqsobefColor := clLime;
    9  : glqsobefColor := clYellow;
    10 : glqsobefColor := clMoneyGreen;
    11 : glqsobefColor := clFuchsia;
    12 : glqsobefColor := clAqua;
    13 : glqsobefColor := clCream;
    14 : glqsobefColor := clMedGray;
    15 : glqsobefColor := clWhite;
  End;
end;

procedure TForm6.ComboBox5Change(Sender: TObject);
begin
  Case ComboBox5.ItemIndex of
    0  : Edit6.Color := clGreen;
    1  : Edit6.Color := clOlive;
    2  : Edit6.Color := clSkyBlue;
    3  : Edit6.Color := clPurple;
    4  : Edit6.Color := clTeal;
    5  : Edit6.Color := clGray;
    6  : Edit6.Color := clSilver;
    7  : Edit6.Color := clRed;
    8  : Edit6.Color := clLime;
    9  : Edit6.Color := clYellow;
    10 : Edit6.Color := clMoneyGreen;
    11 : Edit6.Color := clFuchsia;
    12 : Edit6.Color := clAqua;
    13 : Edit6.Color := clCream;
    14 : Edit6.Color := clMedGray;
    15 : Edit6.Color := clWhite;
  End;
  Case ComboBox5.ItemIndex of
    0  : ComboBox5.Color := clGreen;
    1  : ComboBox5.Color := clOlive;
    2  : ComboBox5.Color := clSkyBlue;
    3  : ComboBox5.Color := clPurple;
    4  : ComboBox5.Color := clTeal;
    5  : ComboBox5.Color := clGray;
    6  : ComboBox5.Color := clSilver;
    7  : ComboBox5.Color := clRed;
    8  : ComboBox5.Color := clLime;
    9  : ComboBox5.Color := clYellow;
    10 : ComboBox5.Color := clMoneyGreen;
    11 : ComboBox5.Color := clFuchsia;
    12 : ComboBox5.Color := clAqua;
    13 : ComboBox5.Color := clCream;
    14 : ComboBox5.Color := clMedGray;
    15 : ComboBox5.Color := clWhite;
  End;
  Case ComboBox5.ItemIndex of
    0  : glqsocilColor := clGreen;
    1  : glqsocilColor := clOlive;
    2  : glqsocilColor := clSkyBlue;
    3  : glqsocilColor := clPurple;
    4  : glqsocilColor := clTeal;
    5  : glqsocilColor := clGray;
    6  : glqsocilColor := clSilver;
    7  : glqsocilColor := clRed;
    8  : glqsocilColor := clLime;
    9  : glqsocilColor := clYellow;
    10 : glqsocilColor := clMoneyGreen;
    11 : glqsocilColor := clFuchsia;
    12 : glqsocilColor := clAqua;
    13 : glqsocilColor := clCream;
    14 : glqsocilColor := clMedGray;
    15 : glqsocilColor := clWhite;
  End;
end;

procedure TForm6.ComboBox6Change(Sender: TObject);
begin
  Case ComboBox6.ItemIndex of
    0  : Edit7.Color := clGreen;
    1  : Edit7.Color := clOlive;
    2  : Edit7.Color := clSkyBlue;
    3  : Edit7.Color := clPurple;
    4  : Edit7.Color := clTeal;
    5  : Edit7.Color := clGray;
    6  : Edit7.Color := clSilver;
    7  : Edit7.Color := clRed;
    8  : Edit7.Color := clLime;
    9  : Edit7.Color := clYellow;
    10 : Edit7.Color := clMoneyGreen;
    11 : Edit7.Color := clFuchsia;
    12 : Edit7.Color := clAqua;
    13 : Edit7.Color := clCream;
    14 : Edit7.Color := clMedGray;
    15 : Edit7.Color := clWhite;
  End;
  Case ComboBox6.ItemIndex of
    0  : ComboBox6.Color := clGreen;
    1  : ComboBox6.Color := clOlive;
    2  : ComboBox6.Color := clSkyBlue;
    3  : ComboBox6.Color := clPurple;
    4  : ComboBox6.Color := clTeal;
    5  : ComboBox6.Color := clGray;
    6  : ComboBox6.Color := clSilver;
    7  : ComboBox6.Color := clRed;
    8  : ComboBox6.Color := clLime;
    9  : ComboBox6.Color := clYellow;
    10 : ComboBox6.Color := clMoneyGreen;
    11 : ComboBox6.Color := clFuchsia;
    12 : ComboBox6.Color := clAqua;
    13 : ComboBox6.Color := clCream;
    14 : ComboBox6.Color := clMedGray;
    15 : ComboBox6.Color := clWhite;
  End;
  Case ComboBox6.ItemIndex of
    0  : glclcfmcurrColor := clGreen;
    1  : glclcfmcurrColor := clOlive;
    2  : glclcfmcurrColor := clSkyBlue;
    3  : glclcfmcurrColor := clPurple;
    4  : glclcfmcurrColor := clTeal;
    5  : glclcfmcurrColor := clGray;
    6  : glclcfmcurrColor := clSilver;
    7  : glclcfmcurrColor := clRed;
    8  : glclcfmcurrColor := clLime;
    9  : glclcfmcurrColor := clYellow;
    10 : glclcfmcurrColor := clMoneyGreen;
    11 : glclcfmcurrColor := clFuchsia;
    12 : glclcfmcurrColor := clAqua;
    13 : glclcfmcurrColor := clCream;
    14 : glclcfmcurrColor := clMedGray;
    15 : glclcfmcurrColor := clWhite;
  End;
end;
 procedure TForm6.ComboBox7Change(Sender: TObject);
 begin
  Case ComboBox7.ItemIndex of
     0  : Edit8.Color := clGreen;
     1  : Edit8.Color := clOlive;
     2  : Edit8.Color := clSkyBlue;
     3  : Edit8.Color := clPurple;
     4  : Edit8.Color := clTeal;
     5  : Edit8.Color := clGray;
     6  : Edit8.Color := clSilver;
     7  : Edit8.Color := clRed;
     8  : Edit8.Color := clLime;
     9  : Edit8.Color := clYellow;
     10 : Edit8.Color := clMoneyGreen;
     11 : Edit8.Color := clFuchsia;
     12 : Edit8.Color := clAqua;
     13 : Edit8.Color := clCream;
     14 : Edit8.Color := clMedGray;
     15 : Edit8.Color := clWhite;
  End;
  Case ComboBox7.ItemIndex of
     0  : Combobox7.Color := clGreen;
     1  : Combobox7.Color := clOlive;
     2  : Combobox7.Color := clSkyBlue;
     3  : Combobox7.Color := clPurple;
     4  : Combobox7.Color := clTeal;
     5  : Combobox7.Color := clGray;
     6  : Combobox7.Color := clSilver;
     7  : Combobox7.Color := clRed;
     8  : Combobox7.Color := clLime;
     9  : Combobox7.Color := clYellow;
     10 : Combobox7.Color := clMoneyGreen;
     11 : Combobox7.Color := clFuchsia;
     12 : Combobox7.Color := clAqua;
     13 : Combobox7.Color := clCream;
     14 : Combobox7.Color := clMedGray;
     15 : Combobox7.Color := clWhite;
  End;
  Case ComboBox7.ItemIndex of
     0  : glclcfmabColor := clGreen;
     1  : glclcfmabColor := clOlive;
     2  : glclcfmabColor := clSkyBlue;
     3  : glclcfmabColor := clPurple;
     4  : glclcfmabColor := clTeal;
     5  : glclcfmabColor := clGray;
     6  : glclcfmabColor := clSilver;
     7  : glclcfmabColor := clRed;
     8  : glclcfmabColor := clLime;
     9  : glclcfmabColor := clYellow;
     10 : glclcfmabColor := clMoneyGreen;
     11 : glclcfmabColor := clFuchsia;
     12 : glclcfmabColor := clAqua;
     13 : glclcfmabColor := clCream;
     14 : glclcfmabColor := clMedGray;
     15 : glclcfmabColor := clWhite;
  End;
end;

 procedure TForm6.ComboBox8Change(Sender: TObject);
 begin
  Case ComboBox8.ItemIndex of
    0  : Edit9.Color := clGreen;
    1  : Edit9.Color := clOlive;
    2  : Edit9.Color := clSkyBlue;
    3  : Edit9.Color := clPurple;
    4  : Edit9.Color := clTeal;
    5  : Edit9.Color := clGray;
    6  : Edit9.Color := clSilver;
    7  : Edit9.Color := clRed;
    8  : Edit9.Color := clLime;
    9  : Edit9.Color := clYellow;
    10 : Edit9.Color := clMoneyGreen;
    11 : Edit9.Color := clFuchsia;
    12 : Edit9.Color := clAqua;
    13 : Edit9.Color := clCream;
    14 : Edit9.Color := clMedGray;
    15 : Edit9.Color := clWhite;
  End;
  Case ComboBox8.ItemIndex of
    0  : Combobox8.Color := clGreen;
    1  : Combobox8.Color := clOlive;
    2  : Combobox8.Color := clSkyBlue;
    3  : Combobox8.Color := clPurple;
    4  : Combobox8.Color := clTeal;
    5  : Combobox8.Color := clGray;
    6  : Combobox8.Color := clSilver;
    7  : Combobox8.Color := clRed;
    8  : Combobox8.Color := clLime;
    9  : Combobox8.Color := clYellow;
    10 : Combobox8.Color := clMoneyGreen;
    11 : Combobox8.Color := clFuchsia;
    12 : Combobox8.Color := clAqua;
    13 : Combobox8.Color := clCream;
    14 : Combobox8.Color := clMedGray;
    15 : Combobox8.Color := clWhite;
  End;
  Case ComboBox8.ItemIndex of
    0  : glbmbgrColor := clGreen;
    1  : glbmbgrColor := clOlive;
    2  : glbmbgrColor := clSkyBlue;
    3  : glbmbgrColor := clPurple;
    4  : glbmbgrColor := clTeal;
    5  : glbmbgrColor := clGray;
    6  : glbmbgrColor := clSilver;
    7  : glbmbgrColor := clRed;
    8  : glbmbgrColor := clLime;
    9  : glbmbgrColor := clYellow;
    10 : glbmbgrColor := clMoneyGreen;
    11 : glbmbgrColor := clFuchsia;
    12 : glbmbgrColor := clAqua;
    13 : glbmbgrColor := clCream;
    14 : glbmbgrColor := clMedGray;
    15 : glbmbgrColor := clWhite;
  End;
 end;

procedure TForm6.comboPrefixChange(Sender: TObject);
begin
  glCallChange:= True;
end;


initialization
  {$I cfgvtwo.lrs}
  cfval         := valobject.TValidator.create(); // This creates a access point to validation routines needed for new RB code
end.

