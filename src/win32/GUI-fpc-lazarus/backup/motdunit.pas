unit  Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type
  TForm9 = class(TForm)
  private
    { private declarations }
  public
    procedure load_motd();
  end;

var
  Form9: TForm9;

implementation

{$R *.lfm}

procedure TForm9.load_motd();
var motd: TStringList;
begin
  //Memo1.Clear;
  motd:= TStringList.Create;
  motd.LoadFromFile('motd.txt');
  //Memo1.Text:= '#:';//+motd[0];

  //Memo1.Lines.Add(motd[0]);
  motd.Free;
end;

end.

