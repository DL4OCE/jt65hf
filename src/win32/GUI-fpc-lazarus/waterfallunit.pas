unit waterfallunit;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, waterfall, ExtCtrls, Spin, ComCtrls, valobject, cfgvtwo, globaldata;

type

  { Twaterfallform }

  Twaterfallform = class(TForm)
    btnZeroRX: TButton;
    btnZeroTX: TButton;
    cbSmooth: TCheckBox;
    cbSpecPal: TComboBox;
    chkAutoTxDF: TCheckBox;
    Label14: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    Label5: TLabel;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    spinDecoderCF: TSpinEdit;
    SpinEdit1: TSpinEdit;
    spinGain: TSpinEdit;
    spinTXCF: TSpinEdit;
    tbBright: TTrackBar;
    tbContrast: TTrackBar;
    Waterfall: TWaterfallControl;
    procedure btnZeroRXClick(Sender: TObject);
    procedure btnZeroTXClick(Sender: TObject);
    procedure cbSpecPalChange(Sender: TObject);
    procedure chkAutoTxDFChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Label17DblClick(Sender: TObject);
    procedure Label22Click(Sender: TObject);
    procedure Label31Click(Sender: TObject);
    procedure spinDecoderCFChange(Sender: TObject);
    procedure spinDecoderCFKeyPress(Sender: TObject; var Key: char);
    procedure SpinEdit1Change(Sender: TObject);
    procedure spinGainChange(Sender: TObject);
    procedure spinTXCFChange(Sender: TObject);
    procedure spinTXCFKeyPress(Sender: TObject; var Key: char);
    procedure tbBrightChange(Sender: TObject);
    //procedure waterfallMouseDownProxy();
    procedure WaterfallMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    { private declarations }
  public

    //mval                       : valobject.TValidator; // Class variable for validator object.  Needed for QRG conversions.

  end;

var
  waterfallform: Twaterfallform;

implementation

{$R *.lfm}

{ Twaterfallform }



procedure Twaterfallform.FormCreate(Sender: TObject);
begin
  Waterfall := TWaterfallControl.Create(Self);
  with Waterfall do begin
    Height := 163;
    Width := 750;
    Top := 25;
    Left := 0;
    Parent := Self;
    OnMouseDown := waterfallMouseDown;//(Self,  Mouse.CursorPos.x, Mouse.CursorPos.y);
    //(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer)
    DoubleBuffered := True;
    cfgError := True;
  end;
end;

procedure Twaterfallform.FormResize(Sender: TObject);
begin
  Width := 750;
  Waterfall.Height := Height - 73;
end;

procedure Twaterfallform.Label17DblClick(Sender: TObject);
begin
  tbBright.Position := 0;
end;

procedure Twaterfallform.Label22Click(Sender: TObject);
begin
  tbContrast.Position := 0;
end;

procedure Twaterfallform.Label31Click(Sender: TObject);
begin
  spinGain.Value := 0;
end;

procedure Twaterfallform.spinDecoderCFChange(Sender: TObject);
begin
  if spinDecoderCF.Value < -1000 then
    spinDecoderCF.Value := -1000;
  if spinDecoderCF.Value > 1000 then
    spinDecoderCF.Value := 1000;
  if chkAutoTxDF.Checked then
    spinTXCF.Value := spinDecoderCF.Value;
end;

procedure Twaterfallform.spinDecoderCFKeyPress(Sender: TObject; var Key: char);
var
  i: integer;
begin
  // Filtering input to signal report text box such that it only allows numerics and -
  i := Ord(key);
  if not (i = 8) then
  begin
    Key := upcase(key);
    //if not mval.asciiValidate(Key,'sig') then Key := #0;
  end;
end;

procedure Twaterfallform.SpinEdit1Change(Sender: TObject);
begin
  if spinEdit1.Value > 5 then
    spinEdit1.Value := 5;
  if spinEdit1.Value < -1 then
    spinEdit1.Value := -1;
  //spectrum.specSpeed2 := SpinEdit1.Value;
  // Handle spectrum being off (speed = -1)
  mustsaveconfig := True;
end;

procedure Twaterfallform.spinGainChange(Sender: TObject);
begin
  if spinGain.Value > 6 then
    spinGain.Value := 6;
  if spinGain.Value < -6 then
    spinGain.Value := -6;
  mustsaveconfig := True;
end;

procedure Twaterfallform.chkAutoTxDFChange(Sender: TObject);
begin
  if chkAutoTxDF.Checked then
    spinTXCF.Value := spinDecoderCF.Value;
end;

procedure Twaterfallform.btnZeroTXClick(Sender: TObject);
begin
  spinTXCF.Value := 0;
  if chkAutoTxDF.Checked then
    spinDecoderCF.Value := 0;
end;

procedure Twaterfallform.cbSpecPalChange(Sender: TObject);
begin
  mustsaveconfig := True;
end;

procedure Twaterfallform.btnZeroRXClick(Sender: TObject);
begin
  spinDecoderCF.Value := 0;
  if chkAutoTxDF.Checked then
    spinTXCF.Value := 0;
end;

procedure Twaterfallform.spinTXCFChange(Sender: TObject);
begin
  if spinTXCF.Value < -1000 then
    spinTXCF.Value := -1000;
  if spinTXCF.Value > 1000 then
    spinTXCF.Value := 1000;
  if chkAutoTxDF.Checked then
    spinDecoderCF.Value := spinTXCF.Value;
end;

procedure Twaterfallform.spinTXCFKeyPress(Sender: TObject; var Key: char);
var
  i: integer;
begin
  // Filtering input to signal report text box such that it only allows numerics and -
  i := Ord(key);
  if not (i = 8) then
  begin
    Key := upcase(key);
    //if not mval.asciiValidate(Key,'sig') then Key := #0;
  end;
end;

procedure Twaterfallform.tbBrightChange(Sender: TObject);
begin
  mustsaveconfig:= true;
end;

{procedure Twaterfallform.waterfallMouseDownProxy();
begin
  //WaterfallMouseDown(Self, );

end;
 }
procedure Twaterfallform.WaterfallMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  df: single;
begin
  if x = 0 then
    df := -1019;
  if x > 0 then
    df := X * 2.7027;
  df := -1018.9189 + df;
  if Button = mbLeft then
  begin
    spinTXCF.Value := round(df);
    if chkAutoTxDF.Checked then
      spinDecoderCF.Value := spinTXCF.Value;
  end;
  if Button = mbRight then
  begin
    spinDecoderCF.Value := round(df);
    if chkAutoTxDF.Checked then
      spinTXCF.Value := spinDecoderCF.Value;
  end;
end;

end.


