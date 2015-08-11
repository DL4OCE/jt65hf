unit statistic;

{$mode objfpc}{$H+}

interface

uses
  //Classes, SysUtils,Forms, Controls,Graphics, Dialogs;
Classes, SysUtils, LResources, FileUtil, Forms, Controls, Graphics, Dialogs,
  extCtrls, StdCtrls, {StrUtils,}logscan;
type
  { TForm7 }
  TForm7 = class(TForm)
   ListBox1: TListBox;
   ListBox2: TListBox;

   procedure Button1Click(Sender: TObject);
   procedure FormCreate(Sender: TObject);
   procedure FormResize(Sender: TObject);


end;


var
  Form7        : TForm7;

procedure viewHeader();
procedure viewstatistic();

implementation

{ TForm7 }
procedure TForm7.Button1Click(Sender: TObject);
begin
     Form7.ListBox1.Clear;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin

end;

procedure TForm7.FormResize(Sender: TObject);
begin
  ListBox1.Width:= Width;
  ListBox2.Width:= Width;
  ListBox1.Height:= Height-27;
end;


procedure viewHeader();

begin
 Form7.ListBox1.Clear;
 Form7.ListBox2.Clear;
 Form7.ListBox2.Items.Add('Prefix      160M  80M  40M  30M  20M  17M  15M  12M  10M   Country');
end;

procedure viewstatistic();
var
foo          : String;
foo160,foo80 : String;
foo40,foo30  : String;
foo20,foo17  : String;
foo15,foo12  : String;
foo10        : String;
z1           : Integer; //Zeilenzähler Prefixfile
z2           : Integer;
ctrylength   : Integer;

begin
 SetLength(foo160,3);
 SetLength(foo80,3);
 SetLength(foo30,3);
 SetLength(foo30,3);
 SetLength(foo20,3);
 SetLength(foo17,3);
 SetLength(foo15,3);
 SetLength(foo12,3);
 SetLength(foo10,3);

   For z1:=1 to logscan.ZprefLine do
   begin
      foo160:='   ';
      foo80:='   ';
      foo40:='   ';
      foo30:='   ';
      foo20:='   ';
      foo17:='   ';
      foo15:='   ';
      foo12:='   ';
      foo10:='   ';
     //foo:=logscan.mPref[z1].ctry;
     foo:=logscan.mPref[z1].pref;
     ctrylength:=length(foo);
     if logscan.mPref[z1].m160w then foo160:='160W';
     if logscan.mPref[z1].m80w then foo80:='80W';
     if logscan.mPref[z1].m40w then foo40:='40W';
     if logscan.mPref[z1].m30w then foo30:='30W';
     if logscan.mPref[z1].m20w then foo20:='20W';
     if logscan.mPref[z1].m17w then foo17:='17W';
     if logscan.mPref[z1].m15w then foo15:='15W';
     if logscan.mPref[z1].m12w then foo12:='12W';
     if logscan.mPref[z1].m10w then foo10:='10W';
     if logscan.mPref[z1].m160c then foo160:='160C';
     if logscan.mPref[z1].m80c then foo80:='80C';
     if logscan.mPref[z1].m40c then foo40:='40C';
     if logscan.mPref[z1].m30c then foo30:='30C';
     if logscan.mPref[z1].m20c then foo20:='20C';
     if logscan.mPref[z1].m17c then foo17:='17C';
     if logscan.mPref[z1].m15c then foo15:='15C';
     if logscan.mPref[z1].m12c then foo12:='12C';
     if logscan.mPref[z1].m10c then foo10:='10C';
     begin
         For z2:=12 downto ctrylength do
         begin
            foo:=foo+' ';
         end;
         foo:=foo+foo160+'  '+foo80+'  '+foo40+'  '+foo30+'  '+foo20+'  '+foo17+'  '+foo15+'  '+foo12+'  '+foo10;
     end;
     foo:=foo+'   '+logscan.mPref[z1].ctry;
     //Form7.ListBox1.Items.Add('--------------------------------------------------------------------------------');
     Form7.   ListBox1.Items.Add(foo);
     Form7.ListBox1.Items.Add('--------------------------------------------------------------------------------');
   end;
end;

{$R *.lfm}
end.

