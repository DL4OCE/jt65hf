unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm8 }

  TForm8 = class(TForm)
   Button1: TButton;
   ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form8: TForm8; 

implementation

{ TForm8 }
procedure TForm8.Button1Click(Sender: TObject);
begin
     Form8.ListBox1.Clear;
end;

{$R *.lfm}

end.

