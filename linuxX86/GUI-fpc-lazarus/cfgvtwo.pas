unit cfgvtwo;
//
// Copyright (c) 2008,2009, 2010, 2011 J C Large - W6CQZ
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
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, StrUtils, globalData, synaser, EditBtn,
  valobject;

Const
    myWordDelims = [' ',','];
    hrdDelim = [','];

type

  { TForm6 }

  TForm6 = class(TForm)
    Button1 : TButton ;
    buttonTestPTT : TButton ;
    cbCWID : TCheckBox ;
    cbDisableMultiQSO : TCheckBox ;
    cbMultiAutoEnable : TCheckBox ;
    cbRestoreMulti : TCheckBox ;
    cbSaveCSV : TCheckBox ;
    cbTXWatchDog : TCheckBox ;
    ComboBox1 : TComboBox ;
    ComboBox2 : TComboBox ;
    ComboBox3 : TComboBox ;
    comboPrefix : TComboBox ;
    comboSuffix : TComboBox ;
    DirectoryEdit1 : TDirectoryEdit ;
    Edit1 : TEdit ;
    Edit2 : TEdit ;
    Edit3 : TEdit ;
    editPSKRAntenna : TEdit ;
    editPSKRCall : TEdit ;
    editUserDefinedPort1 : TEdit ;
    edMyCall : TEdit ;
    edMyGrid : TEdit ;
    edUserMsg10 : TEdit ;
    edUserMsg11 : TEdit ;
    edUserMsg12 : TEdit ;
    edUserMsg13 : TEdit ;
    edUserMsg14 : TEdit ;
    edUserMsg15 : TEdit ;
    edUserMsg16 : TEdit ;
    edUserMsg17 : TEdit ;
    edUserMsg18 : TEdit ;
    edUserMsg19 : TEdit ;
    edUserMsg20 : TEdit ;
    edUserMsg4 : TEdit ;
    edUserMsg5 : TEdit ;
    edUserMsg6 : TEdit ;
    edUserMsg7 : TEdit ;
    edUserMsg8 : TEdit ;
    edUserMsg9 : TEdit ;
    edUserQRG1 : TEdit ;
    edUserQRG10 : TEdit ;
    edUserQRG11 : TEdit ;
    edUserQRG12 : TEdit ;
    edUserQRG13 : TEdit ;
    edUserQRG2 : TEdit ;
    edUserQRG3 : TEdit ;
    edUserQRG4 : TEdit ;
    edUserQRG5 : TEdit ;
    edUserQRG6 : TEdit ;
    edUserQRG7 : TEdit ;
    edUserQRG8 : TEdit ;
    edUserQRG9 : TEdit ;
    Label10 : TLabel ;
    Label122 : TLabel ;
    Label123 : TLabel ;
    Label124 : TLabel ;
    Label125 : TLabel ;
    Label126 : TLabel ;
    Label127 : TLabel ;
    Label128 : TLabel ;
    Label129 : TLabel ;
    Label130 : TLabel ;
    Label131 : TLabel ;
    Label132 : TLabel ;
    Label2 : TLabel ;
    Label20 : TLabel ;
    Label26 : TLabel ;
    Label27 : TLabel ;
    Label28 : TLabel ;
    Label29 : TLabel ;
    Label3 : TLabel ;
    Label30 : TLabel ;
    Label33 : TLabel ;
    Label34 : TLabel ;
    Label35 : TLabel ;
    Label36 : TLabel ;
    Label37 : TLabel ;
    Label39 : TLabel ;
    Label41 : TLabel ;
    Label42 : TLabel ;
    Label43 : TLabel ;
    Label44 : TLabel ;
    Label45 : TLabel ;
    Label46 : TLabel ;
    Label47 : TLabel ;
    Label48 : TLabel ;
    Label49 : TLabel ;
    Label50 : TLabel ;
    Label51 : TLabel ;
    Label52 : TLabel ;
    Label55 : TLabel ;
    Label56 : TLabel ;
    Label57 : TLabel ;
    Label58 : TLabel ;
    Label59 : TLabel ;
    Label60 : TLabel ;
    Label61 : TLabel ;
    Label62 : TLabel ;
    Label63 : TLabel ;
    Label64 : TLabel ;
    Label70 : TLabel ;
    Label71 : TLabel ;
    Label72 : TLabel ;
    Label74 : TLabel ;
    Label75 : TLabel ;
    Label76 : TLabel ;
    Label77 : TLabel ;
    Label78 : TLabel ;
    Label9 : TLabel ;
    PageControl1 : TPageControl ;
    rigQRG : TEdit ;
    TabSheet1 : TTabSheet ;
    TabSheet2 : TTabSheet ;
    TabSheet3 : TTabSheet ;
    TabSheet4 : TTabSheet ;
    TabSheet6 : TTabSheet ;
    procedure Button1Click(Sender: TObject);
    procedure buttonTestPTTClick(Sender: TObject);
    procedure cbAudioInChange(Sender: TObject);
    procedure cbAudioOutChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure comboPrefixChange(Sender: TObject);
    procedure edMyCallChange(Sender: TObject);
    procedure edMyCallKeyPress (Sender : TObject ; var Key : char );
    procedure edMyGridKeyPress (Sender : TObject ; var Key : char );
    procedure edUserMsg4KeyPress (Sender : TObject ; var Key : char );
    procedure edUserMsgChange(Sender: TObject);
    procedure edUserQRG13KeyPress (Sender : TObject ; var Key : char );
    procedure FormCreate(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form6            : TForm6;
  glcqColor        : TColor;
  glcallColor      : TColor;
  glqsoColor       : TColor;
  cfpttSerial      : TBlockSerial;
  glautoSR         : Boolean;
  glmyCall         : String;
  glmustConfig     : Boolean;
  glcatBy          : String; // Can be hamlib, omnirig, hrd, commander or none.
  glrbcLogin       : Boolean;
  glrbcLogout      : Boolean;
  gld65AudioChange : Boolean;
  glcallChange     : Boolean;
  cfval            : valobject.TValidator; // Class variable for validator object.  Needed for QRG conversions.
implementation

{ TForm6 }

procedure altRaisePTT();
var
   np        : Integer;
   pttOpened : Boolean;
   nport     : String;
Begin
     pttOpened := False;
     if not pttOpened Then
     Begin
          nport := '';
          nport := Form6.editUserDefinedPort1.Text;
          if nport = 'None' Then nport := '';
          if nport = 'NONE' Then nport := '';
          if Length(nport) > 3 Then
          Begin
               try
                  cfpttSerial := TBlockSerial.Create;
                  cfpttSerial.RaiseExcept := True;
                  cfpttSerial.Connect(nport);
                  cfpttSerial.Config(9600,8,'N',0,false,true);
                  pttOpened := True;
               except
               end;
          End
          Else
          Begin
               np := 0;
               if tryStrToInt(Form6.editUserDefinedPort1.Text,np) Then
               Begin
                    Try
                       cfpttSerial := TBlockSerial.Create;
                       cfpttSerial.RaiseExcept := True;
                       cfpttSerial.Connect('COM' + IntToStr(np));
                       cfpttSerial.Config(9600,8,'N',0,false,true);
                       pttOpened := True;
                    Except
                    End;
               End
               Else
               Begin
                    pttOpened := False;
               End;
          End;
     End;
End;

procedure altLowerPTT();
Begin
     cfpttSerial.Free;
End;

procedure TForm6.Button1Click(Sender: TObject);
begin
     glmustConfig := False;
     self.Hide;
end;

procedure TForm6.buttonTestPTTClick(Sender: TObject);
begin
     altRaisePTT();
     sleep(500);
     altLowerPTT();
end;

procedure TForm6.cbAudioInChange(Sender: TObject);
begin
     gld65AudioChange := True;
end;

procedure TForm6.cbAudioOutChange(Sender: TObject);
begin
     gld65AudioChange := True;
end;

procedure TForm6.edMyCallChange(Sender: TObject);
begin
     If (AnsiContainsText(Form6.edMyCall.Text,'/')) Or (AnsiContainsText(Form6.edMyCall.Text,'.')) Or
     (AnsiContainsText(Form6.edMyCall.Text,'-')) Or (AnsiContainsText(Form6.edMyCall.Text,'\')) Or
     (AnsiContainsText(Form6.edMyCall.Text,',')) Then
     Begin
          form6.edMyCall.Clear;
          glmyCall := '';
          form6.Label26.Font.Color := clRed;
          glCallChange := True;
     End
     Else
     Begin
          glmyCall := form6.edMyCall.Text;
          form6.Label26.Font.Color := clBlack;
          glCallChange := True;
     End;
end;

procedure TForm6.edMyCallKeyPress(Sender : TObject; var Key : char);
Var
   i : Integer;
begin
     // Filtering input to signal report text box such that it only allows numerics and -
     i := ord(key);
     if not (i=8) then
     begin
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
     if not (i=8) then
     begin
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
     if not (i=8) then
     begin
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
     if (Length(foo)>2) And (foo[1..3] = 'RRR') then
     begin
          foo[1] := ' ';
          foo[2] := ' ';
          foo[3] := ' ';
          foo := TrimLeft(TrimRight(Upcase(foo)));
     end;
     if (Length(foo)>1) And (foo[1..2] = 'RO')  then
     begin
          foo[1] := ' ';
          foo[2] := ' ';
          foo := TrimLeft(TrimRight(Upcase(foo)));
     end;
     if (Length(foo)>1) And (foo[1..2] = '73')  then
     begin
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
     if not (i=8) then
     begin
        Key := upcase(key);
        if not cfval.asciiValidate(Key,'numeric') then Key := #0;
     end;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
     Form6.DirectoryEdit1.Directory := GetAppConfigDir(False);
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

procedure TForm6.comboPrefixChange(Sender: TObject);
begin
     glCallChange := True;
end;

initialization
  {$I cfgvtwo.lrs}
  glcqColor     := clLime;
  glcallColor   := clRed;
  glqsoColor    := clSilver;
  cfval           := valobject.TValidator.create(); // This creates a access point to validation routines needed for new RB code
end.
