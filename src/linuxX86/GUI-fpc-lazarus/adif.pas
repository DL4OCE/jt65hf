unit adif;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

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


implementation

function adifString(call, freq, grid, mode, rstrx, rsttx, timeon, timeoff, txpower, qdate, comment, mycall, mygrid: String): String;
var
   foo  : String;
   qrg  : Integer;
   sqrg : String;
   fqrg : Double;
Begin
     result := '';
     foo := '<CALL:' + IntToStr(Length(call)) + '>' + call;
     qrg := 0;
     sqrg := '';
     fqrg := StrToFloat(freq);
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
     if sqrg<>'' Then foo := foo + '<BAND:' + IntToStr(Length(sqrg)) + '>' + sqrg;
     If sqrg<>'' Then
     Begin
          fqrg := 0.0;
          if TryStrToFloat(freq,fqrg) Then
          Begin
               If fqrg > 450000 Then
               Begin
                    // Seems to be HZ
                    fqrg := fqrg/1000000;
                    freq := FloatToStr(fqrg);
               End;
               If fqrg < 1800 Then
               Begin
                    // Seems to be MHz, do nothing, I think.
               End;
               If (fqrg>1799) And (fqrg<450001) Then
               Begin
                    // Seems to be KHz
                    fqrg := fqrg/1000;
                    freq := FloatToStr(fqrg);
               End;
          End
          Else
          Begin
               fqrg := 0;
               freq :='0';
          End;
          if fqrg > 0 Then foo := foo + '<FREQ:' + IntToStr(Length(freq)) + '>' + freq;
     End;
     if (Length(grid)>3) And (Length(grid)<7) Then foo := foo + '<GRIDSQUARE:' + IntToStr(Length(grid)) + '>' + grid;
     foo := foo + '<MODE:' + IntToStr(Length(mode)) + '>' + mode;
     if Length(rstrx)>0 Then foo := foo + '<RST_RCVD:' + IntToStr(Length(rstrx)) + '>' + rstrx;
     if Length(rsttx)>0 Then foo := foo + '<RST_SENT:' + IntToStr(Length(rsttx)) + '>' + rsttx;
     foo := foo + '<QSO_DATE:' + IntToStr(Length(qdate)) + '>' + qdate;
     foo := foo + '<TIME_ON:' + IntToStr(Length(timeon)) + '>' + timeon;
     foo := foo + '<TIME_OFF:' + IntToStr(Length(timeoff)) + '>' + timeoff;
     if Length(txpower)>0 Then foo := foo + '<TX_PWR:' + IntToStr(Length(txpower)) + '>' + txpower;
     if Length(comment)>0 Then foo := foo + '<COMMENT:' + IntToStr(Length(comment)) + '>' + comment;
     if Length(mycall)>0 Then foo := foo + '<STATION_CALLSIGN:' + IntToStr(Length(mycall)) + '>' + mycall;
     if Length(mygrid)>0 Then foo := foo + '<MY_GRIDSQUARE:' + IntToStr(Length(mygrid)) + '>' + mygrid;
     foo := foo + '<eor>';
     result := foo;
End;
end.
