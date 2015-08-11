unit log;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, adif, EditBtn, FileUtil, CTypes, DateUtils;

Const
     XLOG = 'jt65XLog';
type

  { TForm2 }

  TForm2 = class(TForm)
    btnLogQSO: TButton;
    Button1: TButton;
    cbXLog: TCheckBox;
    DirectoryEdit1: TDirectoryEdit;
    edLogComment: TEdit;
    edLogSTime: TEdit;
    edLogDate: TEdit;
    edLogETime: TEdit;
    edLogCall: TEdit;
    edLogSReport: TEdit;
    edLogRReport: TEdit;
    edLogPower: TEdit;
    edLogFrequency: TEdit;
    edLogGrid: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btnLogQSOClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

  function  doXLog(entry : PChar) : CTypes.cint; cdecl; external XLOG name 'addEntry';

var
  Form2: TForm2;
  logmycall, logmygrid : String;

implementation

{ TForm2 }
procedure TForm2.btnLogQSOClick(Sender: TObject);
Var
   foo, fname   : String;
   lfile        : TextFile;
   xlog         : PChar;
   xdate        : TDateTime;
   xres         : CTypes.cint;
begin
     // Need to build the log entry and add it to log file.
     foo := '';
     foo := adif.adifString(edLogCall.Text,edLogFrequency.Text,edLogGrid.Text,adif.JT65A,
                            edLogRReport.Text,edLogSReport.Text,edLogSTime.Text,
                            edLogETime.Text,edLogPower.Text,edLogDate.Text,edLogComment.Text,
                            logmycall, logmygrid);
     fname := TrimFilename(Form2.DirectoryEdit1.Directory + PathDelim + 'jt65hf_log.adi');
     AssignFile(lfile, fname);
     If FileExists(fname) Then
     Begin
          append(lfile);
     end
     else
     Begin
          rewrite(lfile);
          writeln(lfile,'JT65-HF ADIF Export');
          //writeln(lfile,'<adif_ver:4>2.26');
          writeln(lfile,'<eoh>');
     end;
     writeln(lfile,foo);
     closeFile(lfile);

     if Form2.cbXLog.Checked Then
     Begin
          // Rather than try to use FPC IPC support I'm going to use an external library
          // compiled in C.  Easier, faster less stress.
          // Create the string for XLog
          //                 	 program:sendtoxlog\1
          //                     version:1\1
          //                     date:30 Dec 2001\1
          //                     time:2214\1
          //                     endtime:2220\1
          //                     call:pg4i\1
          //                     mhz:14\1
          //                     mode:cw\1
          //                     tx:579\1
          //                     rx:569\1
          //                     name:joop\1
          //                     qth:houten\1
          //                     power:100W\1
          //                     locator:JO22OB\1
          //                     free1:testfree1\1
          //                     free2:testfree2\1
          //                     notes:this is DEMO2

          if length(Form2.edLogCall.Text)>2 Then
          Begin
               foo := 'program:jt65-hf' + chr(1) + 'version:1090' + chr(1) + 'mode:JT65' + chr(1) + 'call:' + upcase(edLogCall.Text) + chr(1);
               if (length(edLogGrid.Text)=4) or (length(edLogGrid.Text)=6) then foo := foo + 'locator:' + upcase(edLogGrid.Text) + chr(1);
               if (length(edLogDate.Text)=8) then
               begin
                    // Format date to XLog requirement of DD Mon YYYY
                    Try
                       xdate := ScanDateTime('yyyymmddhhnn',edLogDate.Text+'0000');
                       foo := foo + 'date:' + FormatDateTime('dd mmm yyyy',xdate) + chr(1);
                    except
                      // Nada
                    end;
               end;
               if (length(edLogSTime.Text)=4) then foo := foo + 'time:' + edLogSTime.Text + chr(1);
               if (length(edLogETime.Text)=4) then foo := foo + 'endtime:' + edLogETime.Text + chr(1);
               if (length(edLogSReport.Text)>1) then foo := foo + 'tx:' + edLogSReport.Text + chr(1);
               if (Length(edLogRReport.Text)>1) then foo := foo + 'rx:' + edLogRReport.Text + chr(1);
               if (Length(edLogPower.Text)>0) then foo := foo + 'power:' + edLogPower.Text + chr(1);
               if (Length(edLogFrequency.Text)>1) then foo := foo + 'mhz:' + edLogFrequency.Text + chr(1);
               if (Length(edLogComment.Text)>1) then foo := foo + 'notes:' + edLogComment.Text;
          end;
          if length(foo)>1024 then foo := foo[1..1024];
          xlog := StrAlloc(Length(foo)+1);
          StrPCopy(xlog, foo);
          xres := -99;
          xres := doXLog(xlog);
          if xres > -1 Then label13.Caption:='Logged to XLog.' else label13.Caption:='Failed, but saved to ADIF text file.';
          xlog := StrAlloc(0);
     end;
     for xres := 0 to 10 do
     begin
          sleep(100);
          application.ProcessMessages;
     end;
     Form2.visible := False;
end;


procedure TForm2.Button1Click(Sender: TObject);
begin
     Form2.visible := False;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
     Form2.DirectoryEdit1.Directory := GetAppConfigDir(False);
end;

initialization
  {$I log.lrs}

end.
