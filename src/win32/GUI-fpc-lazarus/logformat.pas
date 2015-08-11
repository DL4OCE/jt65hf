unit logformat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, globaldata, cfgvtwo, logscan, Dialogs;

const JT65A = 'JT65';
const JT65B = 'JT65';
const JT65C = 'JT65';
const JT2   = 'JT65';
const JT4A  = 'JT65';
const JT4B  = 'JT65';

type
  log = record
    call    : String;
    band    : String;
    freq    : String;
    grid    : String;
    mode    : String;
    rstrx   : String;
    rsttx   : String;
    timeon  : String;
    timeoff : String;
    tx_pwr  : String;
  end;

function adifString(call, freq, grid, mode, rstrx, rsttx, timeon, timeoff, txpower, qdate, comment, mycall, mygrid: String): String;
function mixwString(call, freq, grid, mode, rstrx, rsttx, timeon, timeoff, txpower, qdate, comment, mycall, mygrid: String): String;
function ADIFenc(TagName, TagContent: String; flagCapital: Boolean): String;


implementation

function ADIFenc(TagName, TagContent: String; flagCapital: Boolean): String;
var tmpStr: String;
begin
    tmpStr:= '<' + TagName + ':';
    if flagCapital then tmpStr:= UpperCase(tmpStr);
    Result:= tmpStr + IntToStr(Length(TagContent)) +  '>' + TagContent;
end;


function adifString(call, freq, grid, mode, rstrx, rsttx, timeon, timeoff, txpower, qdate, comment, mycall, mygrid: String): String;
var
   foo, sqrg, freqlocal: String;
   qrg, pointpos: Integer;
   fqrg : Double;
Begin
  cfgvtwo.Form6.lbDiagLog.Items.Add('********'+freq);
  result := '';
  if logscan.bigletter or globaldata.bigletter then foo:= ADIFenc('call', call, logscan.bigletter);
  //foo := '<CALL:' + IntToStr(Length(call)) + '>' + call;
  if logscan.smallletter then foo:= ADIFenc('call', call, false);
  //foo := '<call:' + IntToStr(Length(call)) + '>' + call;
  qrg := 0;
  sqrg := '';
  {if (cfgvtwo.Form6.CheckBox1.Checked) then begin  // 1.000 thousand,   5,3 decimal
    freq:= StringReplace(freq,'.',',',[rfReplaceAll]);
  end;
  if (cfgvtwo.Form6.CheckBox2.Checked) then begin  // 1,000 thousand,   5.3 decimal
    freq:= StringReplace(freq,',','.',[rfReplaceAll]);
  end;
  if not ((cfgvtwo.Form6.CheckBox1.Checked) or (cfgvtwo.Form6.CheckBox2.Checked)) then begin

    //freq:= StringReplace(freq,',','.',[rfReplaceAll]);

    //freq:= IntToStr(Round(StrToInt(
    //freq:= StringReplace(freq,',','.',[rfReplaceAll]);
  end;
  }
  if (cfgvtwo.Form6.rbDecSepEU.Checked) then freq:= StringReplace(freq,'.',',',[rfReplaceAll]) // 1.000 thousand,   5,3 decimal
  else freq:= StringReplace(freq,',','.',[rfReplaceAll]);                                   // 1,000 thousand,   5.3 decimal
  fqrg := StrToFloat(freq);
  cfgvtwo.Form6.lbDiagLog.Items.Add(freq);

  //fqrg := StrToFloat(StringReplace(freq,',','.',[rfReplaceAll]));
  fqrg := fqrg * 1000;
  qrg := Round(fqrg);
  Case qrg of
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
  End;
  cfgvtwo.Form6.lbDiagLog.Items.Add(sqrg);
  if (logscan.bigletter  or cfgvtwo.emptyfile) and (sqrg<>'') then foo:= foo + ADIFenc('band', sqrg, logscan.bigletter);
  //foo := foo + '<BAND:' + IntToStr(Length(sqrg)) + '>' + sqrg;
  if logscan.smallletter and (sqrg<>'') Then foo:= foo + ADIFenc('band', sqrg, false);
  //foo := foo + '<band:' + IntToStr(Length(sqrg)) + '>' + sqrg;
  //if (sqrg<>'') Then  foo := foo + '<band:' + IntToStr(Length(sqrg)) + '>' + sqrg;
  If (sqrg<>'') Then Begin
    fqrg := 0.0;
    if TryStrToFloat(freq, fqrg) Then Begin
      cfgvtwo.Form6.lbDiagLog.Items.Add('TryStrToFloat1(freq,fqrg): foo='+foo);
      If fqrg > 450000 Then Begin
        // Seems to be HZ
        cfgvtwo.Form6.lbDiagLog.Items.Add('Seems to be Hz');
        fqrg := fqrg/1000000;
        freq := FloatToStr(fqrg);
      End;
      If fqrg < 1800 Then Begin
        // Seems to be MHz, do nothing, I think.
        cfgvtwo.Form6.lbDiagLog.Items.Add('Seems to be MHz');
      End;
      If (fqrg>1799) And (fqrg<450001) Then Begin
        // Seems to be KHz
        cfgvtwo.Form6.lbDiagLog.Items.Add('Seems to be kHz');
        fqrg := fqrg/1000;
        freq := FloatToStr(fqrg);
      End;
      cfgvtwo.Form6.lbDiagLog.Items.Add('TryStrToFloat2(freq,fqrg): foo='+foo);
      cfgvtwo.Form6.lbDiagLog.Items.Add('TryStrToFloat3(freq,fqrg): freq='+freq);
    End Else Begin
      fqrg := 0;
      freq :='0';
    End;
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    *** Does this stuff do anything in any case? ***
   { if logscan.freqcomma and cfgvtwo.fileformatadi then begin
      cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.freqcomma');
      freqlocal:=freq;
      pointpos:=POS(',',freqlocal);
      //DecimalSeparator:=',';
      freqlocal[pointpos]:=',';
      freq:=freqlocal;
      cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.freqcomma: freq='+freq+', freqlocal='+freqlocal);
    end;
    if logscan.freqpoint and cfgvtwo.fileformatadi then begin
      cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.freqpoint');
      freqlocal:=freq;
      pointpos:=POS('.',freqlocal);
      //DecimalSeparator:='.';
      freqlocal[pointpos]:='.';
      freq:=freqlocal;
      cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.freqpoint: freq='+freq+', freqlocal='+freqlocal);
    end;  }

    if (not logscan.freqcomma or logscan.freqpoint) then cfgvtwo.Form6.lbDiagLog.Items.Add('Neither dot nor comma');
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if logscan.freqcomma then freq:= StringReplace(freq,'.',',',[rfReplaceAll]);
    if logscan.freqpoint then freq:= StringReplace(freq,',','.',[rfReplaceAll]);
    cfgvtwo.Form6.lbDiagLog.Items.Add(freq);
    // FREQ
    if (logscan.bigletter or cfgvtwo.emptyfile) and (fqrg > 0)  Then foo:= foo + ADIFenc('freq', freq, logscan.bigletter);
    //foo := foo + '<FREQ:' + IntToStr(Length(freq)) + '>' + freq;
    if logscan.smallletter and (fqrg > 0) Then foo:= foo + ADIFenc('freq', freq, false);
    cfgvtwo.Form6.lbDiagLog.Items.Add(foo);
    //foo := foo + '<freq:' + IntToStr(Length(freq)) + '>' + freq;
    //if (fqrg > 0)  Then foo := foo + '<FREQ:' + IntToStr(Length(freq)) + '>' + freq;
  End;
  if logscan.bigletter then cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.bigletter=yes')
  else cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.bigletter=no');
  if cfgvtwo.emptyfile then cfgvtwo.Form6.lbDiagLog.Items.Add('cfgvtwo.emptyfile=yes')
  else cfgvtwo.Form6.lbDiagLog.Items.Add('cfgvtwo.emptyfile=no');
  if logscan.smallletter then cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.smallletter=yes')
  else cfgvtwo.Form6.lbDiagLog.Items.Add('logscan.smallletter=no');

  if (logscan.bigletter or cfgvtwo.emptyfile) and (Length(grid)>3) And (Length(grid)<7) Then foo:= foo + ADIFenc('gridsquare',grid, logscan.bigletter);
  //foo := foo + '<GRIDSQUARE:' + IntToStr(Length(grid)) + '>' + grid;
  if logscan.smallletter and (Length(grid)>3) And (Length(grid)<7) Then foo:= foo + ADIFenc('gridsquare',grid, false);
  //foo := foo + '<gridsquare:' + IntToStr(Length(grid)) + '>' + grid;

  if (logscan.bigletter or cfgvtwo.emptyfile) then foo := foo + '<MODE:' + IntToStr(Length(mode)) + '>' + mode;
  if logscan.smallletter then foo := foo + '<mode:' + IntToStr(Length(mode)) + '>' + mode;


  if (logscan.bigletter or cfgvtwo.emptyfile) and (Length(rstrx)>0) Then foo := foo + '<RST_RCVD:' + IntToStr(Length(rstrx)) + '>' + rstrx;
  if logscan.smallletter and (Length(rstrx)>0) Then foo := foo + '<rst_rcvd:' + IntToStr(Length(rstrx)) + '>' + rstrx;

  if (logscan.bigletter or cfgvtwo.emptyfile) and (Length(rsttx)>0) Then foo := foo + '<RST_SENT:' + IntToStr(Length(rsttx)) + '>' + rsttx;
  if logscan.smallletter and (Length(rsttx)>0) Then foo := foo + '<rst_sent:' + IntToStr(Length(rsttx)) + '>' + rsttx;

  if (logscan.bigletter or cfgvtwo.emptyfile) then foo := foo + '<QSO_DATE:' + IntToStr(Length(qdate)) + '>' + qdate;
  if logscan.smallletter then foo := foo + '<qso_date:' + IntToStr(Length(qdate)) + '>' + qdate;

  if (logscan.bigletter or cfgvtwo.emptyfile) then foo := foo + '<TIME_ON:' + IntToStr(Length(timeon)) + '>' + timeon;
  if logscan.smallletter then foo := foo + '<time_on:' + IntToStr(Length(timeon)) + '>' + timeon;

  if (logscan.bigletter or cfgvtwo.emptyfile) then foo := foo + '<TIME_OFF:' + IntToStr(Length(timeoff)) + '>' + timeoff;
  if logscan.smallletter then foo := foo + '<time_off:' + IntToStr(Length(timeoff)) + '>' + timeoff;

  if (logscan.bigletter or cfgvtwo.emptyfile) and (Length(txpower)>0) Then foo := foo + '<TX_PWR:' + IntToStr(Length(txpower)) + '>' + txpower;
  if logscan.smallletter and (Length(txpower)>0) Then foo := foo + '<tx_pwr:' + IntToStr(Length(txpower)) + '>' + txpower;

  if (logscan.bigletter or cfgvtwo.emptyfile) and (Length(comment)>0) Then foo := foo + '<COMMENT:' + IntToStr(Length(comment)) + '>' + comment;
  if logscan.smallletter and (Length(comment)>0) Then foo := foo + '<comment:' + IntToStr(Length(comment)) + '>' + comment;

  if (logscan.bigletter or cfgvtwo.emptyfile) and (Length(mycall)>0) Then foo := foo + '<STATION_CALLSIGN:' + IntToStr(Length(mycall)) + '>' + mycall;
  if logscan.smallletter and (Length(mycall)>0) Then foo := foo + '<station_callsign:' + IntToStr(Length(mycall)) + '>' + mycall;

  if (logscan.bigletter or cfgvtwo.emptyfile) and  (Length(mygrid)>0) Then foo := foo + '<MY_GRIDSQUARE:' + IntToStr(Length(mygrid)) + '>' + mygrid;
  if logscan.smallletter and  (Length(mygrid)>0) Then foo := foo + '<my_gridsquare:' + IntToStr(Length(mygrid)) + '>' + mygrid;
  cfgvtwo.Form6.lbDiagLog.Items.Add('End of function: foo='+foo);
  foo := foo + '<eor>';
  //cfgvtwo.emptyfile:=False;
  result := foo;
End;

function mixwString(call, freq, grid, mode, rstrx, rsttx, timeon, timeoff, txpower, qdate, comment, mycall, mygrid: String): String;
var
   foo: String;
   tnint, tfint: Integer;
Begin
  result := '';
  foo := myCall + ';' + call + ';'+ qdate+timeon + '00;';
  tnint:= StrToInt(timeon);
  tfint:= StrToInt(timeoff);
  tfint:= (tfint - tnint)*60;
  timeoff:= IntToStr(tfint);
  foo :=  foo + timeoff + ';;;';
  if txpower <> '' then begin comment := comment + 'TX_PWR:'+ txpower + 'W';
    freq:= InttoStr(globaldata.iqrg);
    foo:= foo + freq + ';' + '0' + ';;' + JT65A +';'+rsttx + ';' +rstrx + ';;;;;'+ comment +';;;;;' + grid + ';;;;;' ;
    result := foo;
  end;
end;

end.

