unit unused;
{enthaelt geparkte oder veraltete, nicht mehr benoetigte Programmteile,
Unit ist nicht lauffaehig !!}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;




procedure rightcall();
procedure logtest();
procedure buttonTestClick(Sender: TObject);
procedure logsearch();
var
//Variablen Programmtest Start
//st                 : SystemTime;
//sekunde            : Integer;


implementation
//############################################################################
procedure rightcall();
{Wenn im RX-Fenster eine neue Minute erscheint, wird aus dem Listeneintrag
 Form1.ListBox1.Items[Index]  die Minute extrahiert. Wenn die Systemzeit gleich
 der Minute im Listeneintrag ist, wir das rechte Call extrahiert}

  begin
      lstime := ExtractWord(1,lsfoo,[' ']);
      lstime := lstime[4..5];
      lsMinuteSyst := IntToStr(lsUtcMinute);
      lminute := Length(lsMinuteSyst);
      if lminute < 2 then
         begin
              lsMinuteSyst := '0' + lsMinuteSyst;
         end;
       if lstime = lsMinuteSyst then
         begin
         lsCallRight := ExtractWord(8,lsfoo,[' ']);
         //testges := lstime + '  ' + lsCallRight  + '  '+lsMinuteSyst+ '  ' +'Index: '+ lsIndex;
         //Form7.ListBox1.Items.Add(testges);
         //end;
         logtest();
         end;

  end;
//##############################################################################

procedure logtest();
Var
    lsLog     :     TextFile;
    lsLine    :     String;
    lsPath    :     String;
    lsPoint   :     Integer;
    lsCallPos :     Integer;
    lsMod     :     Integer;
    lsLogQrg  :     String;  //QRG from Log
    lsCall    :     String;  //Call from JT65
    logCall   :     String;  //Call aus Logzeile
    lsQrg     :     String;  //QRG from JT65
    lsfQrg    :     Double;
    lsLineLength:   Integer;
    lshelpvar1:     Integer;
    lshelpvar2:     Integer;
    lsSemikolon:    Integer;
    lsQrgBegin:     Integer;
    lsQrgEnd:       Integer;
    wcount:         Integer;
{
lsLog    : Name des Logfiles
lsPath   : Pfad des Logfiles
lsLine   : Zeile des Logfiles
lsCallPos: Position des gesuchten Calls in der Logzeile, wenn<>0 dann vorhanden
lsMod    : Position von 'JT65' in der Logzeile, wenn <>0, dann war QSO in JT65
lsLogQrg : QrG aus Log
lsQRG    : QRG aus JT65
lsfQrg   : Frequenz aus JT65 als String, aus Gleitkommazahl gewonnen
lsLineLength: Zeilenlänge der Logzeile
lshelpvar1: Hilfsvariable für Schleifenzähler
lshelpvar2: Speichervariable für Positionen des Semikolons
}
  begin
     //lsPath := TrimFileName(Form2.DirectoryEdit1.Directory + PathDelim + 'jt65hf_log.adi');
     lsPath:= Form6.FileListbox1.Text;
     AssignFile(lsLog, lsPath);
     Reset(lsLog);
     wcount := WordCount(lsfoo,[' ']);
     if wcount>7 then lsCallRight := ExtractWord(8,lsfoo,[' ']);
     lsCall:= lsCallRight;
     lsfQrg:= globaldata.iqrg / 1000000;
     lsQrg:= FloatToStr(lsfQrg);
     //Form1.edHisCall.Color:= clWhite;
     cil:= False;
     qsobev:=False;
     cnil:= True;

     // Routine fuer AdifFormat
     if cfgvtwo.Form6.cbLogAdif.Checked then
     begin
          Repeat
           ReadLn (lsLog,lsLine);
           lsMod:=POS('JT65',lsLine);
           if lsmod <> 0 then
              begin
                   logCall:=ExtractWord(2,lsline,[';']);
                   if lscall=logCall then
                 //lsCallPos:= POS(lsCall,lsLine);
                 //if lsCallPos <> 0 then
                     begin
                          cil:=True;
                          cnil:=False;
                          //Form1.edHisCall.Color:= cfgvtwo.glqsocilColor;
                          //if cfgvtwo.Form6.cbTxEnableCil.Checked then
                          //begin
                          //     Form1.chkEnTx.Checked:= False;
                          //end;
                          //lspoint:= POS('.',lsline);
                          if lspoint <> 0 then
                          begin
                               lsLogQrg:= lsline[(lspoint-2)..lspoint];
                                  if (lsLogQrg[1])= '>' then
                                  begin
                                  lsLogQrg:=lsLogQrg[2..3];
                                  end;
                                  if POS('.',lsQRG)= 2 then lsQRG:=lsQRG[1..2] else lsQRG:= lsQRG[1..3];
                                  if lsLogQrg = lsQRG then
                                  begin
                                       qsobev:=True;
                                       cnil:=False;
                                       //Form1.edHisCall.Color:= cfgvtwo.glqsobefColor;
                                       //if cfgvtwo.Form6.cbTxEnableBef.Checked then
                                       //begin
                                       //     Form1.chkEnTx.Checked:= False;
                                       //end;
                                  end;
                          end;
                     end;
              end;
         //until (Form1.edHisCall.Color = cfgvtwo.glqsobefColor) or (EOF(lsLog));
           until (qsobev=True) or (EOF(lsLog));
     end;

     // Routine for MixW2.log-Format
     if cfgvtwo.Form6.cbLogMixW.Checked then
      begin
           Repeat
            ReadLn (lsLog,lsLine);
            lsMod:=POS('JT65',lsLine);
            if lsmod <> 0 then
               begin
                  logCall:=ExtractWord(2,lsline,[';']);
                  if lscall=logCall then
                  //lsCallPos:= POS(lsCall,lsLine);
                  //if lsCallPos <> 0 then
                      begin
                           cil:=True;
                           cnil:=False;
                           //Form1.edHisCall.Color:= cfgvtwo.glqsocilColor;
                           //if cfgvtwo.Form6.cbTxEnableCil.Checked then
                           //begin
                           //     Form1.chkEnTx.Checked:= False;
                           //end;
                           lsLineLength:= length(lsline);
                           lshelpvar2:= 1;
                           lsSemikolon:= 1;
                           For lshelpvar1:=1 to 7 do
                           Begin
                                lsSemikolon:= Pos(';',lsline[(lshelpvar2+1)..(lsLineLength)]);
                                lshelpvar2:= lsSemikolon + lshelpvar2;
                                if lshelpvar1 = 6 Then lsqrgBegin:= lshelpvar2;
                                if lshelpvar1 = 7 Then lsqrgEnd:= lshelpvar2;
                           end;
                           if POS('.',lsQRG)= 2 then lsQRG:=lsQRG[1] else lsQRG:= lsQRG[1..2];
//                         testvar3:= lsline[(lsqrgBegin+1)..(lsqrgEnd -7)];
                           if lsQrg = lsline[(lsqrgBegin+1)..(lsqrgEnd -7)] then
                           begin
                                qsobev:=True;
                                cnil:=False
                                //Form1.edHisCall.Color:= cfgvtwo.glqsobefColor;
                                //if cfgvtwo.Form6.cbTxEnableBef.Checked then
                                //begin
                                //     Form1.chkEnTx.Checked:= False;
                                //end;
                           end;
                      end;
               end;
               //until (Form1.edHisCall.Color = cfgvtwo.glqsobefColor) or (EOF(lsLog));
               until (qsobev=True) or (EOF(lsLog));
       end;
     closeFile(lsLog);
     testvar1:=testvar1+1;
  end;
//################################################################################
procedure TForm1.buttonTestClick(Sender: TObject);
begin
     dxcc.Form7.Visible := True;
     dxcc.Form7.Show;
     dxcc.Form7.BringToFront;

end;
//##############################################################################


procedure TForm1.logsearch();

Var
    lsLog     :     TextFile;
    lsLine    :     String;
    lsPath    :     String;
    lsPoint   :     Integer;
    lsCallPos :     Integer;
    lsMod     :     Integer;
    lsLogQrg  :     String;  //QRG from Log
    lsCall    :     String;  //Call from JT65
    lsQrg     :     String;  //QRG from JT65
    lsfQrg    :     Double;
    lsLineLength:   Integer;
    lshelpvar1:     Integer;
    lshelpvar2:     Integer;
    lsSemikolon:    Integer;
    lsQrgBegin:     Integer;
    lsQrgEnd:       Integer;
{
lsLog    : Name des Logfiles
lsPath   : Pfad des Logfiles
lsLine   : Zeile des Logfiles
lsCallPos: Position des gesuchten Calls in der Logzeile, wenn<>0 dann vorhanden
lsMod    : Position von 'JT65' in der Logzeile, wenn <>0, dann war QSO in JT65
lsLogQrg : QrG aus Log
lsQRG    : QRG aus JT65
lsfQrg   : Frequenz aus JT65 als String, aus Gleitkommazahl gewonnen
lsLineLength: Zeilenlänge der Logzeile
lshelpvar1: Hilfsvariable für Schleifenzähler
lshelpvar2: Speichervariable für Positionen des Semikolons
}
  begin
     //lsPath := TrimFileName(Form2.DirectoryEdit1.Directory + PathDelim + 'jt65hf_log.adi');
     lsPath:= Form6.FileListbox1.Text;
     AssignFile(lsLog, lsPath);
     Reset(lsLog);
     lsCall:= Form1.edHisCall.Text;
     lsfQrg:= globaldata.iqrg / 1000000;
     lsQrg:= FloatToStr(lsfQrg);
     Form1.edHisCall.Color:= clWhite;

     // Routine fuer AdifFormat
     if cfgvtwo.Form6.cbLogAdif.Checked then
     begin
          Repeat
           ReadLn (lsLog,lsLine);
           lsMod:=POS('JT65',lsLine);
           if lsmod <> 0 then
              begin
                 lsCallPos:= POS(lsCall,lsLine);
                 if lsCallPos <> 0 then
                     begin
                          Form1.edHisCall.Color:= cfgvtwo.glqsocilColor;
                          if cfgvtwo.Form6.cbTxEnableCil.Checked then
                          begin
                               Form1.chkEnTx.Checked:= False;
                          end;
                          lspoint:= POS('.',lsline);
                          if lspoint <> 0 then
                          begin
                               lsLogQrg:= lsline[(lspoint-2)..lspoint];
                                  if (lsLogQrg[1])= '>' then
                                  begin
                                  lsLogQrg:=lsLogQrg[2..3];
                                  end;
                                  if POS('.',lsQRG)= 2 then lsQRG:=lsQRG[1..2] else lsQRG:= lsQRG[1..3];
                                  if lsLogQrg = lsQRG then
                                  begin
                                       Form1.edHisCall.Color:= cfgvtwo.glqsobefColor;
                                       if cfgvtwo.Form6.cbTxEnableBef.Checked then
                                       begin
                                            Form1.chkEnTx.Checked:= False;
                                       end;
                                  end;
                          end;
                     end;
              end;
         until (Form1.edHisCall.Color = cfgvtwo.glqsobefColor) or (EOF(lsLog));
     end;
 Routine for MixW2.log-Format
     if cfgvtwo.Form6.cbLogMixW.Checked then
      begin
           Repeat
            ReadLn (lsLog,lsLine);
            lsMod:=POS('JT65',lsLine);
            if lsmod <> 0 then
               begin
                  lsCallPos:= POS(lsCall,lsLine);
                  if lsCallPos <> 0 then
                      begin
                           Form1.edHisCall.Color:= cfgvtwo.glqsocilColor;
                           if cfgvtwo.Form6.cbTxEnableCil.Checked then
                           begin
                                Form1.chkEnTx.Checked:= False;
                           end;
                           lsLineLength:= length(lsline);
                           lshelpvar2:= 1;
                           lsSemikolon:= 1;
                           For lshelpvar1:=1 to 7 do
                           Begin
                                lsSemikolon:= Pos(';',lsline[(lshelpvar2+1)..(lsLineLength)]);
                                lshelpvar2:= lsSemikolon + lshelpvar2;
                                if lshelpvar1 = 6 Then lsqrgBegin:= lshelpvar2;
                                if lshelpvar1 = 7 Then lsqrgEnd:= lshelpvar2;
                           end;
                           if POS('.',lsQRG)= 2 then lsQRG:=lsQRG[1] else lsQRG:= lsQRG[1..2];
//                         testvar3:= lsline[(lsqrgBegin+1)..(lsqrgEnd -7)];
                           if lsQrg = lsline[(lsqrgBegin+1)..(lsqrgEnd -7)] then
                           begin
                                Form1.edHisCall.Color:= cfgvtwo.glqsobefColor;
                                if cfgvtwo.Form6.cbTxEnableBef.Checked then
                                begin
                                     Form1.chkEnTx.Checked:= False;
                                end;
                           end;
                      end;
               end;
               until (Form1.edHisCall.Color = cfgvtwo.glqsobefColor) or (EOF(lsLog));
       end;
     closeFile(lsLog);
  end;
//##############################################################################
// aus 'maincode' entfernte Programmschnipsel, evt. fuer Comfort-3-Version hilfreich
// um 'dxcc'-Unit wieder einzurichten
Programmtest Start
st := utcTime();
//dxcc.dxUtcMinute := st.Minute;
//sekunde:= st.Second;
//logscan.lsUtcMinute := st.Minute  ;
//if sekunde>58 then logscan.testvar1:=0;
//logscan.lsIndex := Index;
//logscan.logtest();
//dxcc.dxDurchlauf:=logscan.testvar1;
//dxcc.dxfoo := foo;
//dxcc.dxIndex := Index;
//dxcc.Form7.viewdxcc();
//logscan.rightcall();
//Programmtest Ende
//if logscan.cnil=True then mycolor:=clBlack;

// aus 'logscan' entfernte, fuer Testzwecke benutzte Programmteile
//freqtorawdec:   String;
//freqtorawdec:=FloatToStr(freqcompare);
//rawdec.Form5.ListBox1.Items.Add(freqtorawdec);
//rawdec.Form5.ListBox1.Items.Add('Call 1,8 before')
//rawdec.Form5.ListBox1.Items.Add('Call 3,5 before')
//rawdec.Form5.ListBox1.Items.Add('Call 7  before')
//rawdec.Form5.ListBox1.Items.Add('Call 10  before')
//rawdec.Form5.ListBox1.Items.Add('Call 14  before')
//rawdec.Form5.ListBox1.Items.Add('Call 18  before')
//rawdec.Form5.ListBox1.Items.Add('Call 21  before')
//rawdec.Form5.ListBox1.Items.Add('Call 24  before')
//rawdec.Form5.ListBox1.Items.Add('Call 28  before')
//if qsobev=true then rawdec.Form5.ListBox1.Items.Add('QSO before') else ;

//''' CALLINRECORD-PROCEDURE AUS DER COMFORT-VERSION-3.02
{    ~~~~~~~~  Routine fuer ADIF ~~~~~~~~~~~~~~~~~}
     if cfgvtwo.Form6.cbLogAdif.Checked then
        begin
        Zjt65line:=0;
        AssignFile(logName, logPath);
        Reset(logName);
          repeat
           Readln(logName,logLine);
           logmodePos:= POS('JT65',logLine);
           if logmodePos >0 then
                 begin
                  Zjt65line:=Zjt65line+1;
                  Z1:=Zjt65line
                 end;
          until EOF(logname);
          SetLength(jtqso,Zjt65line);

         scanline:=0;
         Reset(logName);
         freqcomma:=False;
         freqpoint:=False;
          repeat
            ReadLn(logName,logLine);
               logmodePos:= POS('JT65',logLine);
               if logmodePos >0 then
                  begin
                  callfromlogpos:= POS('CALL:',logline);//Ermittlung der 1. Position von 'Call:'
                  if callfromlogpos >0 then
                     begin
                       callfromloglength:=logline[callfromlogpos+5];//Ermittlung der Calllaenge
                       callfromlog:=logline[(callfromlogpos+7)..(callfromlogpos+6+StrtoInt(callfromloglength))];//Errechnung Call aus Position und Laenge
                       if callfromlog='' then goto badCall;
                       jtqso[scanline].call:=callfromlog;
                       searchSubPref();
                       logfreqPos:= POS('FREQ:',logline);
                       logqslrPos:= POS('QSL_RCVD',logline);
                       if logfreqPos>0 then
                          begin
                            logfreqlength:=(logline[(logfreqPos+5)..(logfreqPos+5)]);
                            logfreqend:=StrToInt(logfreqlength);
                            logqrg:=logline[(logfreqPos+7)..(logfreqPos+6+logfreqend)];

                            logfreqpoint:=pos('.',logqrg);
                            if logfreqpoint >0 then
                               begin
                                  if (not freqpoint) then
                                  begin
                                   freqpoint:=True;
                                   freqcomma:=False;
                                   cfgvtwo.Form6.CheckBox2.Checked:=True;
                                   cfgvtwo.Form6.CheckBox1.Checked:=False;
                                   Decimalseparator:='.';
                                   end;
                                  logfreqbefore:=logqrg[1..logfreqpoint-1];
                               end;

                            logfreqpoint:=pos(',',logqrg);
                            if logfreqpoint >0 then
                            begin
                                  if (not freqcomma) then
                                  begin
                                   freqcomma:=True;
                                   freqpoint:=False;
                                   cfgvtwo.Form6.CheckBox1.Checked:=True;
                                   cfgvtwo.Form6.CheckBox2.Checked:=False;
                                   Decimalseparator:=',';
                                  end;
                                  logfreqbefore:=logqrg[1..logfreqpoint-1];
                            end;

                            {160m}
                           if logfreqbefore ='1' then
                              begin
                               jtqso[scanline].m160w:=true;
                               mpref[mprefidx].m160w:=true;
                               qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                               if (qsocfm='Y') then
                                  begin
                                    jtqso[scanline].m160c:=true;
                                    mpref[mprefidx].m160c:=true;
                                  end;
                              end;
                           {80m}
                           if logfreqbefore ='3' then
                              begin
                                jtqso[scanline].m80w:=true;
                                mpref[mprefidx].m80w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m80c:=true;
                                     mpref[mprefidx].m80c:=true;
                                   end;
                              end;
                           {40m}
                           if logfreqbefore ='7' then
                              begin
                                jtqso[scanline].m40w:=true;
                                mpref[mprefidx].m40w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m40c:=true;
                                     mpref[mprefidx].m40c:=true;
                                   end;
                              end;
                           {30m}
                           if logfreqbefore ='10' then
                              begin
                                jtqso[scanline].m30w:=true;
                                mpref[mprefidx].m30w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m30c:=true;
                                     mpref[mprefidx].m30c:=true;
                                   end;
                              end;
                           {20m}
                           if logfreqbefore ='14' then
                              begin
                                jtqso[scanline].m20w:=true;
                                mpref[mprefidx].m20w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m20c:=true;
                                     mpref[mprefidx].m20c:=true;
                                   end;
                              end;
                           {17m}
                           if logfreqbefore ='18' then
                              begin
                                jtqso[scanline].m17w:=true;
                                mpref[mprefidx].m17w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m17c:=true;
                                     mpref[mprefidx].m17c:=true;
                                   end;
                              end;
                           {15m}
                           if logfreqbefore ='21' then
                              begin
                                jtqso[scanline].m15w:=true;
                                mpref[mprefidx].m15w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m15c:=true;
                                     mpref[mprefidx].m15c:=true;
                                   end;
                              end;
                           {12m}
                           if logfreqbefore ='24' then
                              begin
                                jtqso[scanline].m12w:=true;
                                mpref[mprefidx].m12w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m12c:=true;
                                     mpref[mprefidx].m12c:=true;
                                   end;
                              end;
                           {10m}
                           if logfreqbefore ='28' then
                              begin
                                jtqso[scanline].m10w:=true;
                                mpref[mprefidx].m10w:=true;
                                qsocfm:=logline[(logqslrpos+11)..(logqslrpos+11)];
                                if (qsocfm='Y') then
                                   begin
                                     jtqso[scanline].m10c:=true;
                                     mpref[mprefidx].m10c:=true;
                                   end;
                              end;
                          scanline:=scanline+1;
                       end;
                     end;
                  badCall:
                 end;
             until (scanline=Zjt65line) or EOF(logname);
          closefile(logname);
          logscanned:=True;
          end;
end;
////''' CALLINRECORD-PROCEDURE AUS DER COMFORT-VERSION-3.02
{    ~~~~~~~~  Routine fuer MixW ~~~~~~~~~~~~~~~~~}
//Ermittlung, wieviele Logzeilen JT65-QSO's enthalten + Setzen der jtqso-Recordlänge
          repeat
           Readln(logname,foo);
           if AnsiContainsStr(foo,'JT65') then Zjt65line:=Zjt65line+1;
          until EOF(logname);
          Reset(logname);
          SetLength(jtqso,Zjt65line);
//Schreiben von callfromlog und Frequenz in den Record
            scanline:=0;
            lenlogqrg:=0;
            //cfgvtwo.Form6.CheckBox2.Checked:=true;
            //cfgvtwo.Form6.CheckBox1.Checked:=False;
            //Reset(logname);
              repeat
               Readln(logname,foo);
                 {if AnsiContainsStr(foo,'JT65') then
                   begin
                     callfromlog:=ExtractDelimited(2,foo,[';']);
                     //qsocfm:=ExtractDelimited(6,logline,[';']);
                     logQrg:=ExtractDelimited(7,foo,[';']);
                     lenLogQrg:=length(logQrg);
                     lenLogQrg:=lenLogQrg-6;
                     jtqso[scanline].call:=callfromlog;
                     searchsubpref();
                     {160m}
                     if logQrg[1..lenLogQrg]='1' then
                       begin
                         jtqso[scanline].m160w:=true;
                         mpref[mprefidx].m160w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m160c:=true;
                              mpref[mprefidx].m160c:=true;
                            end;
                       end;
                     {80m}
                     if logQrg[1..lenLogQrg]='3' then
                       begin
                         jtqso[scanline].m80w:=true;
                         mpref[mprefidx].m80w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m80c:=true;
                              mpref[mprefidx].m80c:=true;
                            end;
                       end;
                     {40m}
                     if logQrg[1..lenLogQrg]='7' then
                       begin
                         jtqso[scanline].m40w:=true;
                         mpref[mprefidx].m40w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m40c:=true;
                              mpref[mprefidx].m40c:=true;
                            end;
                       end;
                     {30m}
                     if logQrg[1..lenLogQrg]='10' then
                       begin
                         jtqso[scanline].m30w:=true;
                         mpref[mprefidx].m30w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m30c:=true;
                              mpref[mprefidx].m30c:=true;
                            end;
                       end;
                     {20m}
                     if logQrg[1..lenLogQrg]='14' then
                       begin
                         jtqso[scanline].m20w:=true;
                         mpref[mprefidx].m20w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m20c:=true;
                              mpref[mprefidx].m20c:=true;
                            end;
                       end;
                     {17m}
                     if logQrg[1..lenLogQrg]='18' then
                       begin
                         jtqso[scanline].m17w:=true;
                         mpref[mprefidx].m17w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                            jtqso[scanline].m17c:=true;
                            mpref[mprefidx].m17c:=true;
                            end;
                       end;
                     {15m}
                    if logQrg[1..lenLogQrg]='21' then
                       begin
                         jtqso[scanline].m15w:=true;
                         mpref[mprefidx].m15w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m15c:=true;
                              mpref[mprefidx].m15c:=true;
                            end;
                       end;
                    {12m}
                    if logQrg[1..lenLogQrg]='24' then
                       begin
                         jtqso[scanline].m12w:=true;
                         mpref[mprefidx].m12w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m12c:=true;
                              mpref[mprefidx].m12c:=true;
                            end;
                       end;
                    {10m}
                    if logQrg[1..lenLogQrg]='28' then
                       begin
                         jtqso[scanline].m10w:=true;
                         mpref[mprefidx].m10w:=true;
                         qsocfm:=ExtractDelimited(6,foo,[';']);
                         if not (qsocfm='') then
                            begin
                              jtqso[scanline].m10c:=true;
                              mpref[mprefidx].m10c:=true;
                            end;
                       end;


end.
// aus ubekannten Gründen nicht funktionierende Logscanroutine fuer Mixw
   if cfgvtwo.fileformatmixw then
     begin
        AssignFile(logName,logPath);
        Reset(logName);
        bigletter:=True;
        callfromlog:='';

        repeat
         Readln(logname,foo);
         Z1:=Z1+1;
         if AnsiContainsStr(foo,';JT65;') then
           begin
           callfromlog:=ExtractDelimited(2,foo,[';']);
           callok:=length(callfromlog);
           if callok<3 then goto badrecordm;  //wenn Calllaenge <3 Sprung ans Ende
           logQrg:=ExtractDelimited(7,foo,[';']);
           lenLogQrg:=length(logQrg);
           lenLogQrg:=lenLogQrg-6;
           logfreqlength:=(logqrg[1..lenLogQrg]);
           if StrToInt(logfreqlength)=0 then break;//goto badrecorda; //wenn keine QRG im Log Sprung ans Ende
           setlength(jtqso,scanline+1);
           jtqso[scanline].call:=callfromlog;
           searchSubPref();

           {160m}
           if logQrg[1..lenLogQrg]='1' then
               begin
               jtqso[scanline].m160w:=true;
               mpref[mprefidx].m160w:=true;
               qsocfm:=ExtractDelimited(6,foo,[';']);
               if not (qsocfm='') then
               begin
               jtqso[scanline].m160c:=true;
               mpref[mprefidx].m160c:=true;
               end;
               end;
           {80m}
           if logfreqbefore ='3' then
              begin
                jtqso[scanline].m80w:=true;
                mpref[mprefidx].m80w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m80c:=true;
                     mpref[mprefidx].m80c:=true;
                   end;
              end;
           {40m}
           if logfreqbefore ='7' then
              begin
                jtqso[scanline].m40w:=true;
                mpref[mprefidx].m40w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m40c:=true;
                     mpref[mprefidx].m40c:=true;
                   end;
              end;
           {30m}
           if logfreqbefore ='10' then
              begin
                jtqso[scanline].m30w:=true;
                mpref[mprefidx].m30w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m30c:=true;
                     mpref[mprefidx].m30c:=true;
                   end;
              end;
           {20m}
           if logfreqbefore ='14' then
              begin
                jtqso[scanline].m20w:=true;
                mpref[mprefidx].m20w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m20c:=true;
                     mpref[mprefidx].m20c:=true;
                   end;
              end;
           {17m}
           if logfreqbefore ='18' then
              begin
                jtqso[scanline].m17w:=true;
                mpref[mprefidx].m17w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
              if not (qsocfm='') then
                   begin
                     jtqso[scanline].m17c:=true;
                     mpref[mprefidx].m17c:=true;
                   end;
              end;
           {15m}
           if logfreqbefore ='21' then
              begin
                jtqso[scanline].m15w:=true;
                mpref[mprefidx].m15w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m15c:=true;
                     mpref[mprefidx].m15c:=true;
                   end;
              end;
           {12m}
           if logfreqbefore ='24' then
              begin
                jtqso[scanline].m12w:=true;
                mpref[mprefidx].m12w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m12c:=true;
                     mpref[mprefidx].m12c:=true;
                   end;
              end;
           {10m}
           if logfreqbefore ='28' then
              begin
                jtqso[scanline].m10w:=true;
                mpref[mprefidx].m10w:=true;
                qsocfm:=ExtractDelimited(6,foo,[';']);
                if not (qsocfm='') then
                   begin
                     jtqso[scanline].m10c:=true;
                     mpref[mprefidx].m10c:=true;
                   end;
              end;
           scanline:=scanline+1;
           Zjt65line:=scanline;
           end;
           badrecordm:
           until EOF(Logname);
           closefile(Logname);
           logscanned:=True;
end;

