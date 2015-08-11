unit motd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics, Dialogs;

type

  { TForm9 }

  TForm9 = class(TForm)
    TIMemo1: TTIMemo;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    procedure load_motd();
  end;

var
  Form9: TForm9;

implementation

{$R *.lfm}

procedure TForm9.FormCreate(Sender: TObject);
begin

end;

procedure TForm9.load_motd();
var motd: TStringList;
  motds, index: Integer;
begin
  //Memo1.Clear;
  motd:= TStringList.Create;
  motd.LoadFromFile('motd.txt');
  //Memo1.Text:= '#:';//+motd[0];
  TIMemo1.Clear;
  //TIMemo1.Append('#:');
  motds:= StrToInt(motd[0]);
  index:= Random(motds)+1;
  //index:= 1;
  //TIMemo1.Append(inttostr(motds));
  //timemo1.Append(inttostr(index));
  TIMemo1.Append(motd[index*2-1]+chr(13));
  //TIMemo1.Append(motd[2]);
  TIMemo1.Text:= TIMemo1.Text + StringReplace(motd[index*2],'<crlf>',chr(13),[rfReplaceAll]);
  //TIMemo1.Append(StringReplace(motd[index*2],'<crlf>',chr(13),[rfReplaceAll]));
  motd.Free;
end;

end.

