unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TForm4 }

  TForm4 = class(TForm)
    Memo1: TMemo;
    procedure FormResize(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form4: TForm4; 

implementation

{ TForm4 }

procedure TForm4.Memo1Change(Sender: TObject);
begin

end;

procedure TForm4.FormResize(Sender: TObject);
begin
  memo1.Width:= Form4.Width - 2;
  memo1.Height:= form4.Height - 2;
end;

initialization
  {$I about.lrs}

end.

