unit log;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls, logformat, cfgvtwo, EditBtn, FileUtil, logscan, sqldb;

type

  { TForm2 }

  TForm2 = class(TForm)
    btnLogQSO, Button1: TButton;
    CheckBox1: TCheckBox;
    edLogComment, edLogSTime, edLogDate, edLogETime, edLogCall, edLogSReport, edLogRReport, edLogPower, edLogFrequency, edLogGrid: TEdit;
    Label1, Label10, Label11, Label12, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9: TLabel;
    procedure btnLogQSOClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form2: TForm2;
  logmycall, logmygrid : String;

implementation

{ TForm2 }
procedure TForm2.btnLogQSOClick(Sender: TObject);
Var
  foo, fname, strSQL, sqrg, strSep, strDate, strTime, strtmp: String;
  lfile: TextFile;
  qrg, tmpint: Integer;
  tmpflt: Double;
begin
  //ShowMessage(edLogFrequency.Text);
  //tmpint:= Round(StrToFloat(edLogFrequency.Text));
  //strtmp:= IntToStr(tmpint);
  //strtmp:= StringReplace(strtmp,',','',[rfReplaceAll]);
  //strtmp:= StringReplace(strtmp,'.','',[rfReplaceAll]);
  //strtmp:=
  //     ShowMessage(strtmp);
  //qrg:= StrToInt(strtmp); //StrToInt(edLogFrequency.Text);
  //qrg:= StrToInt(edLogFrequency.Text);
  //ShowMessage(inttostr(qrg));

  strSep:= #39;// String(chr(39));
{  Case qrg of
    1800..2000         : sqrg := '160m';
    3500..4000         : sqrg := '80m';
    7000..7300         : sqrg := '40m';
    10100..10150       : sqrg := '30m';
    14000..14350       : sqrg := '20m';
    18068..18168       : sqrg := '17m';
    21000..21450       : sqrg := '15m';
    24890..24990       : sqrg := '12m';
    28000..29700       : sqrg := '10m';
    50000..54000       : sqrg := '6m';
    144000..148000     : sqrg := '2m';
    222000..225000     : sqrg := '1.25m';
    420000..450000     : sqrg := '70cm';
  End; }
  // Need to build the log entry and add it to log file.
  if cfgvtwo.fileformatadi then begin
    foo := '';
    //foo := logformat.adifString(edLogCall.Text,StringReplace(edLogFrequency.Text,',','.',[rfReplaceAll]),edLogGrid.Text,logformat.JT65A, edLogRReport.Text,edLogSReport.Text,

    foo := logformat.adifString(edLogCall.Text,edLogFrequency.Text,edLogGrid.Text,logformat.JT65A, edLogRReport.Text,edLogSReport.Text,
      edLogSTime.Text, edLogETime.Text,edLogPower.Text,edLogDate.Text,edLogComment.Text, logmycall, logmygrid);
  end;
  if cfgvtwo.fileformatmixw then begin
    foo := '';
    foo := logformat.mixwString(edLogCall.Text,StringReplace(edLogFrequency.Text,',','.',[rfReplaceAll]),edLogGrid.Text,logformat.JT65A, edLogRReport.Text,edLogSReport.Text,
      edLogSTime.Text, edLogETime.Text,edLogPower.Text,edLogDate.Text,edLogComment.Text, logmycall, logmygrid);
  end;
  fname := cfgvtwo.Form6.FileListbox1.Text;
  AssignFile(lfile, fname);
  append(lfile);
  writeln(lfile,foo);
  closeFile(lfile);
  cfgvtwo.emptyfile:= false;

  // MySQL 5.5 HRD 5.0
  if (cfgvtwo.Form6.cbLogHRD.Checked) then begin
    cfgvtwo.Form6.ConnectMySQL;
    //tmpint:= Round(StrToFloat(edLogFrequency.Text));
    //strtmp:= IntToStr(tmpint);
    strtmp:= StringReplace(edLogFrequency.Text,',','',[rfReplaceAll]); // convert MHz to kHz
    strtmp:= StringReplace(strtmp,'.','',[rfReplaceAll]);              // no matter if separator is . or , (simply eliminate both)
    //strtmp:=
    //     ShowMessage(strtmp);
    //qrg:= StrToInt(strtmp); //StrToInt(edLogFrequency.Text);
    //qrg:= StrToInt(edLogFrequency.Text);
    strSQL:= 'INSERT INTO TABLE_HRD_CONTACTS_V01 (COL_CALL, COL_FREQ, COL_GRIDSQUARE, COL_BAND, COL_MODE, COL_RST_RCVD, COL_RST_SENT, COL_SRX_STRING, COL_STX_STRING, COL_TIME_ON, ';
    strSQL:= strSQL + 'COL_TIME_OFF, COL_TX_PWR, COL_COMMENT, COL_OPERATOR, COL_MY_GRIDSQUARE, COL_QSL_RCVD, COL_QSL_SENT, COL_QSO_COMPLETE, COL_STATION_CALLSIGN) VALUES (';
    strSQL:= strSQL + strSep + UpperCase(edLogCall.Text) + strSep + ',';
    strtmp:= IntToStr(StrToInt(strtmp)*1000);  // convert kHz to Hz
    //strtmp:= StringReplace(strtmp,',','',[rfReplaceAll]);
    //strtmp:= StringReplace(strtmp,'.','',[rfReplaceAll]);
    strSQL:= strSQL + strtmp + ',' + strSep + UpperCase(edLogGrid.Text) + strSep + ',' + strSep + sqrg + strSep + ',' + strSep + 'JT65A' + strSep + ',' + strSep + '59' + strSep + ',';
    strSQL:= strSQL + strSep + '59' + strSep + ',' + strSep + edLogRReport.Text + strSep + ',' + strSep + edLogSReport.Text + strSep + ',';
    strDate:= Copy(edLogDate.Text, 1, 4) + '-' + Copy(edLogDate.Text, 5, 2) + '-' + Copy(edLogDate.Text, 7, 2);
    strTime:= Copy(edLogSTime.Text, 1, 2) + ':' + Copy(edLogSTime.Text, 3, 2);
    strSQL:= strSQL + strSep + strDate + ' ' + strTime + strSep + ',';
    strTime:= Copy(edLogETime.Text, 1, 2) + ':' + Copy(edLogETime.Text, 3, 2);
    strSQL:= strSQL + strSep + strDate + ' ' + strTime + strSep + ',' + edLogPower.Text + ',' + strSep + edLogComment.Text + strSep + ',' + strSep + logmycall + strSep + ',';
    strSQL:= strSQL + strSep + logmygrid + strSep + ',' + strSep + 'N' + strSep + ',' + strSep + 'N' + strSep + ',' + strSep + 'Y' + strSep + ',' + strSep + logmycall + strSep + ');';
    cfgvtwo.Form6.FTransaction:= tsqltransaction.create(nil);
    cfgvtwo.Form6.FTransaction.DataBase:= cfgvtwo.Form6.ConnDB;
    cfgvtwo.Form6.Ftransaction.StartTransaction;
    cfgvtwo.Form6.lbDiagLog.Items.Insert(0,strSQL);
    cfgvtwo.Form6.ConnDB.ExecuteDirect(strSQL);
    cfgvtwo.Form6.Ftransaction.Commit;
    cfgvtwo.Form6.ConnDB.Destroy;
  end;
  close;
  logscan.logscanned:=False;
end;


procedure TForm2.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  KeyPreview:= true;
end;

procedure TForm2.FormKeyPress(Sender: TObject; var Key: char);
begin
  if (key=chr(27)) then Button1Click(Self);
end;


initialization
  {$I log.lrs}

end.

