unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, GifAnim, ColorProgress;

type

  { TForm1 }

  TForm1 = class(TForm)
    ColorProgress1: TColorProgress;
    ColorProgress2: TColorProgress;
    ColorProgress3: TColorProgress;
    ColorProgress4: TColorProgress;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if ColorProgress1.Progress = ColorProgress1.MaxValue then
    ColorProgress1.Progress:= ColorProgress1.MinValue;
  ColorProgress1.Progress:= ColorProgress1.Progress+1;
  ColorProgress2.Progress:= ColorProgress1.Progress;
  ColorProgress3.Progress:= ColorProgress1.Progress;
  ColorProgress4.Progress:= ColorProgress1.Progress;
end;

initialization
  {$I unit1.lrs}

end.

