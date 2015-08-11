unit logscan;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Crt, strutils, cfgvtwo, globalData, rawdec, dateUtils, FileUtil, someprogressunit;
type
  Jt65qso = record
  {In diesen Record werden aus dem Logfile alle JT65-QSO's eingelesen, wobei die Log-QRG-Angabe das jeweilige Bandflag setzt }
    call  : String;
    m160w: boolean;  //Flag, ob auf diesen Band schon gearbeitet
    m80w:  boolean;
    m40w:  boolean;
    m30w:  boolean;
    m20w:  boolean;
    m17w:  boolean;
    m15w:  boolean;
    m12w:  boolean;
    m10w:  boolean;
    m160c: boolean; //Flag, ob auf diesem Band schon bestätigt,wird in
    m80c:  boolean; //Record eingelesen, aber noch nicht ausgewertet
    m40c:  boolean;
    m30c:  boolean;
    m20c:  boolean;
    m17c:  boolean;
    m15c:  boolean;
    m12c:  boolean;
    m10c:  boolean;
  end;

  MasterPrefix = record
    {Masterprefixindexe gibt es soviel wie Zeilen in der Prefixdatei. Index 0 wird nicht verwendet. Beginn ab Index 1, damit Index und Zeilennummer in der Prefixdatei uebereinstimmen }
    ctry: string;   //Ländername
    pref: string;   //Masterprefix
    m160w: boolean;  //Flag, ob auf diesen Band schon gearbeitet
    m80w:  boolean;
    m40w:  boolean;
    m30w:  boolean;
    m20w:  boolean;
    m17w:  boolean;
    m15w:  boolean;
    m12w:  boolean;
    m10w:  boolean;
    m160c: boolean; //Flag, ob dieses Band bestaetigt
    m80c:  boolean;
    m40c:  boolean;
    m30c:  boolean;
    m20c:  boolean;
    m17c:  boolean;
    m15c:  boolean;
    m12c:  boolean;
    m10c:  boolean;
  end;

   {Subprefixindexe gibt es 1-34 ( Ziffern 1-9 und Buchstaben A-Z (ohne Q)}
   SubPrefix = record
     pref: string;
   end;

var
  jtqso       : array of Jt65qso;
  mPref       : array of MasterPrefix;
  sPref       : array [1..34] of SubPrefix;
  mPrefIdx    : Integer;      //Masterprefixindex == Land
  prefpath    : String;   //Pfad+Filename Prefixfile
  cil         : Boolean;      //Call in Log -> Meldung an 'maincode'
  qsobev      : Boolean;      //Qso before  -> Meldung an 'maincode'
  cnil        : Boolean;      //Call not in Log -> Meldung an maincode, dort auskommentiert
  lsfoo       : String;       //komplette Zeile aus RX-Fenster, von 'maincode' geliefert
  logscanned  : Boolean;      // True, wenn Log schon gescanned, wird von 'log' zurueckgesetzt
  Zjt65line   : integer;      //Anzahl der Zeilen mit JT65-QSO's
  ZprefLine   : integer;      //Zeilenanzahl des Prefixfiles
  idx         : Integer;      //Index des Subprefix ,wird von alphabet() gebildet ::alphabet(),scanprfix(),
  ctywkd      : Boolean;      //contryworked  -> frequenzabhängig
  ctycfm      : Boolean;      //countryconfirmed -> frequenzabhängig
  ctyab       : Boolean;      //countryanotherband -> frequenzunabhängig
  ctyabc      : Boolean;      //countryanotherbandconfirmed -> frequenzunabhängig
  callcfmcurr : Boolean;      //callconfirmedcurrentband -> frequenzabhängig
  callcfmab   : Boolean;      //callconfirmedanotherband -> frquenzunabhängig
  flSubPref   : String;       //firtsletter == erster Buchstabe des Subprefix
  callfromlog : String;       //Rufzeichen im Logfile -> MixW+Adif
  callfromjt  : String;       // Call aus 'foo' extrahiert
  freqcomma   : Boolean;
  freqpoint   : Boolean;
  bigletter   : Boolean;
  smallletter : Boolean;

procedure alphabet();
procedure scanprefix();
procedure searchSubPref();
procedure callinrecord();
procedure callfromrecord();
procedure searchCallPref();
procedure clearrecord();

implementation

procedure alphabet();
{Ordnet einen Buchstaben/Zahl aus dem Alphabez einem Index zu}
begin
  case flSubPref[1] of
    '1': idx := 1;
    '2': idx := 2;
    '3': idx := 3;
    '4': idx := 4;
    '5': idx := 5;
    '6': idx := 6;
    '7': idx := 7;
    '8': idx := 8;
    '9': idx := 9;
    'A': idx := 10;
    'B': idx := 11;
    'C': idx := 12;
    'D': idx := 13;
    'E': idx := 14;
    'F': idx := 15;
    'G': idx := 16;
    'H': idx := 17;
    'I': idx := 18;
    'J': idx := 19;
    'K': idx := 20;
    'L': idx := 21;
    'M': idx := 22;
    'N': idx := 23;
    'O': idx := 24;
    'P': idx := 25;
    'R': idx := 26;
    'S': idx := 27;
    'T': idx := 28;
    'U': idx := 29;
    'V': idx := 30;
    'W': idx := 31;
    'X': idx := 32;
    'Y': idx := 33;
    'Z': idx := 34;
  end;
end;

 procedure scanPrefix();
{ TODO : Zuerst wird die Zeilenanzahl des Prefixfiles ermittelt, damit wird die Laenge des Arrays 'mPref' gesetzt. Diese Laenge ist 1 laenger als die Zeilenanzahl des Prefixfiles,
da ein Array mit dem Index 0 anfaengt.
Damit im Programmablauf der Index des Arrays mit der Zeilennummer im Prefixfile uebereinstimmt, wird der Index 0 im Array nicht benutzt. }

{Der Prefixfile wird folgendermassen eingelesen:
Der Zeilenzaehler linecount indexiert den Masterprefixrecord.
Es gibt also soviel Masterprefixindexe wie Zeilenzahlen im Prefixfile.
Der 1. Eintrag ist der Landesname, der 2. der Masterprefix.
Diese 2 Eintrage werden in den Masterprefixrecord geschrieben.
Ab dem 3.Eintrag wird in den Subprefixrecord geschrieben.
Hier gibt es nur 34 Indexe, resultierend aus den Ziffern 1-9 und den Buchstaben
A-Z (ohne Q).Dieser Index wird von aus dem ersten Zeichen des Prefixes mit der
procedure alphabet() gebildet.
Der Subprefixrecord enthaelt z.B. im Index '13' alle Subprefixe, die mit 'D' anfangen.
Zugleich wird beim Eintrag in den Record die Zeilenzahl des Prefixfiles mit
eingetragen, so das ein Eintrag so aussieht ...:DA 95:DU 96:..
Da die Zeilenzahl des Prefixfiles zugleich der Index des Masterprefixrecords ist,
laesst sich zu jedem SubPrefix der Masterprefixrecord zuordnen}
var
  subPref    : string;
  prefLine   : string;   //Zeile des Prefixfiles
  wordct     : integer;  //Wordcounter , Wordzähler
  preffile   : Textfile;
  lineCount  : integer;  //Zeilenzaehler beim File scannen
begin
  prefpath:= TrimFileName(GetCurrentDir + PathDelim + 'pref.dat');
  AssignFile(prefFile, prefPath);
  Reset(prefFile);
  ZprefLine := 0;
  repeat
    ReadLn(prefFile, prefLine);
    ZprefLine := ZprefLine + 1;//Zeilenzahl hochzaehlen
  until EOF(prefFile);
  SetLength(mPref,ZprefLine+1);
  Reset(prefFile);
  lineCount := 1; //Start ab Zeile 1 == Index 1
  repeat
    ReadLn(prefFile, prefLine);
    mPref[lineCount].ctry := TrimRight(ExtractWord(1, prefLine, [':']));
    mPref[lineCount].pref := TrimLeft(ExtractWord(2, prefLine, [':']));
    mPref[lineCount].pref := TrimRight(mPref[lineCount].pref);
    for wordct := 3 to (wordcount(prefLine, [':']) - 1) do begin
      subPref := TrimLeft(ExtractWord(wordct, prefLine, [':']));
      subPref := TrimRight(subPref);
      flSubPref:=subPref[1];
      alphabet();
      sPref[idx].pref := sPref[idx].pref + ':'+subPref + ' ' + IntToStr(lineCount) + ':';
    end;
    lineCount := linecount + 1;
  until lineCount = (ZprefLine+1);
  closeFile(prefFile);
end;

procedure searchSubPref();
 {aus Call (callfromlog) Prefix extrahieren ,im Subprefixrecord suchen
 und aus diesem Eintrag Masterprefixindex auslesen+bilden}
var
  posPartCls : Integer; //Position des Teiles (part)des Callsign
  posDblPoint: Integer; //Position des naechsten Doppelpunkts nach POS
  posSpace   : Integer; //Position des nächsten Leerzeichens nach POS
  cntsPref   : String;  //Inhalt(content) des Subprefixstrings
  lenCls     : Integer; //Anzahl der Zeichen des Callsign
  mPrefIdxStr: String;  //Index des Masterprefix im Stringformat
  proxyCall  : String;  //Ersatzstring fuer Callsign,kann von den Proceduren ueberschrieben werden
  dpPrCall   : String;  //Doppelpunkt plus Proxycall
  z1         : Integer; //Zaehlvariable;
begin
  proxycall:=callfromlog;
  flSubPref:=proxycall[1];
  alphabet();
  cntsPref:=sPref[idx].pref;
  lenCls:=length(proxycall);
  For z1:=lenCls downto 1 do begin
    proxycall:=proxycall[1..z1];
    proxycall:=proxycall+' ';
    dpPrCall:=':'+proxycall;
    posPartCls:=Pos(dpPrCall,cntsPref);
    mPrefIdx:=0;
    if posPartCls>0 then begin
      posDblPoint:=PosEx(':',cntsPref,(posPartCls+1));//Postion des nächsten ':' nach POS
      posSpace:=PosEX(' ',cntsPref,(posPartCls+1));   //Postion des nächsten ' ' nach POS
      mPrefIdxStr:= sPref[idx].pref[posSpace..(posDblPoint-1)];
      mPrefIdxStr:= TrimLeft(mPrefIdxStr);
      mPrefIdxStr:= TrimRight(mPrefIdxStr);
      mPrefIdx:= StrToInt(mPrefIdxStr);
      if posPartCls>0 then break;
    end;
  end;
end;

procedure callinrecord();
{Prozedur sucht im gesamten Logifle (jenachdem ob ADIF oder MixW2-Format nach
 JT65-QSO's und schreibt diese in den jt65qso-Record. Zugleich wird die QRG aus
 dem Log mit gespeichert und ob das QSO schon bestaetigt ist }
label
  badrecorda, badrecordm,nologfile;
var
  logpath       : String;  //kompletter Logpfad aus cfgvtwo -> MixW+Adif
  logname       : Textfile;//Typ und Name des Logfiles -> MixW+Adif
  logLine       : String;  //Zeile des Logfiles -> MixW+Adif
  logqrg        : String;  //Frequenz im Logfile -> Mixw+Adif
  logMode       : String;  //Vergleich, ob Betriebsart JT65 -> MixW
  logmodepos    : Integer; //Abfrage, ob 'JT65' in Logzeile vorkommt -> Adif
  logfreqlength : String;  //String, wieviel Zeichen die Frequenzangabe lang ist -> Adif
  logfreqend    : Integer; //Ziffernangabe,wie lang der Frequenzeintrag ist -> Adif
  logfreqpoint  : Integer; //Position des Punktes in logqrg -> Adif
  logfreqbefore : String;  //Vorkommateil von logqrg -> Adif
  callfromloglength : String; //Rufzeichenlaenge Adif
  callfromlogpos     :Integer; //Position von 'Call:' in der Logzeile
  logfreqPos    : Integer; //Position von 'FREQ' in der Logzeile -> Adif
  logqslrpos    : integer; //Position von 'QSL_RCVD' in der Logzeile -> Adif
  qsocfm        : String;  // QSO bestaetigt -> MixW+Adif
  lenlogqrg     : Integer; //Vorkommateil des Frequenzeintrages -> MixW
  scanline      : Integer; //Zeilenzaehler fuers Logscannen  -> MixW+Adif
  Z1            : Integer; //Zaehlvariable
  foo           : String;  //temporaerer String, um Logrecords einzulesen
  callok        : Integer;
begin
  // Vorbedingungen und Default-Werte fuer Logscanroutine
  scanline:=0;
  lenlogqrg:=0;
  z1:=0;
  logmodepos:=0;
  logfreqend:=0;
  logfreqpoint:=0;
  callfromlogpos:=0;
  logfreqpos:=0;
  logqslrpos:=0;
  lenlogqrg:=0;
  callok:=0;
  logpath:= Form6.FileListbox1.Text;
  //cfgvtwo.Form6.CheckBox2.Checked:=False;
  //cfgvtwo.Form6.CheckBox1.Checked:=False;
  freqpoint:=False;
  freqcomma:=False;
  if (not FileExists(logpath)) then begin
    cfgvtwo.glmustConfig:=True;
    cfgvtwo.Form6.PageControl1.ActivePage := cfgvtwo.Form6.TabSheet5;
    cfgvtwo.Form6.ShowModal;
    //cfgvtwo.Form6.BringToFront;
    goto nologfile;
  end;
  //~~~~~~~~~~~~   L O G S C A N  F U E R  M I X W  Version 3.04~~~~~~~~~~~~~~~~
  //~~~Routine fuer MixW, um Call/Frequenz aus dem Log in den Record zu schreiben
  if cfgvtwo.fileformatmixw then begin
    freqpoint:=False;
    freqcomma:=False;
    ////cfgvtwo.Form6.CheckBox1.Checked:=False;
    ////cfgvtwo.Form6.CheckBox2.Checked:=False;
    Zjt65line:=0;
    scanline:=0;
    AssignFile(logName, logPath);
    Reset(logName);
    //Ermittlung, wieviele Logzeilen JT65-QSO's enthalten + Setzen der jtqso-Recordlänge
    repeat
      Readln(logName,logLine);
      logmode:=ExtractDelimited(10,logline,[';']);
      if logmode='JT65' then Zjt65line:=Zjt65line+1;
    until EOF(logname);
    SetLength(jtqso,Zjt65line);
    Reset(logname);
    scanline:=0;
    //Schreiben von callfromlog und Frequenz in den Record
    repeat
      Readln(logName,logLine);
      logmode:=ExtractDelimited(10,logline,[';']);
      if logmode='JT65' then begin
        callfromlog:=ExtractDelimited(2,logline,[';']);
        callok:=length(callfromlog);
        if callok<3 then goto badrecordm;
        logQrg:=ExtractDelimited(7,logline,[';']);
        lenLogQrg:=length(logQrg);
        lenLogQrg:=lenLogQrg-6;
        jtqso[scanline].call:=callfromlog;
        searchsubpref();
        {160m}
        if logQrg[1..lenLogQrg]='1' then begin
          jtqso[scanline].m160w:=true;
          mpref[mprefidx].m160w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m160c:=true;
            mpref[mprefidx].m160c:=true;
          end;
        end;
        {80m}
        if logQrg[1..lenLogQrg]='3' then begin
          jtqso[scanline].m80w:=true;
          mpref[mprefidx].m80w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m80c:=true;
            mpref[mprefidx].m80c:=true;
          end;
        end;
        {40m}
        if logQrg[1..lenLogQrg]='7' then begin
          jtqso[scanline].m40w:=true;
          mpref[mprefidx].m40w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m40c:=true;
            mpref[mprefidx].m40c:=true;
          end;
        end;
        {30m}
        if logQrg[1..lenLogQrg]='10' then begin
          jtqso[scanline].m30w:=true;
          mpref[mprefidx].m30w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m30c:=true;
            mpref[mprefidx].m30c:=true;
          end;
        end;
        {20m}
        if logQrg[1..lenLogQrg]='14' then begin
          jtqso[scanline].m20w:=true;
          mpref[mprefidx].m20w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m20c:=true;
            mpref[mprefidx].m20c:=true;
          end;
        end;
        {17m}
        if logQrg[1..lenLogQrg]='18' then begin
          jtqso[scanline].m17w:=true;
          mpref[mprefidx].m17w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m17c:=true;
            mpref[mprefidx].m17c:=true;
          end;
        end;
        {15m}
        if logQrg[1..lenLogQrg]='21' then begin
          jtqso[scanline].m15w:=true;
          mpref[mprefidx].m15w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m15c:=true;
            mpref[mprefidx].m15c:=true;
          end;
        end;
        {12m}
        if logQrg[1..lenLogQrg]='24' then begin
          jtqso[scanline].m12w:=true;
          mpref[mprefidx].m12w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m12c:=true;
            mpref[mprefidx].m12c:=true;
          end;
        end;
        {10m}
        if logQrg[1..lenLogQrg]='28' then begin
          jtqso[scanline].m10w:=true;
          mpref[mprefidx].m10w:=true;
          qsocfm:=ExtractDelimited(6,logline,[';']);
          if not (qsocfm='') then begin
            jtqso[scanline].m10c:=true;
            mpref[mprefidx].m10c:=true;
          end;
        end;
        scanline:=scanline+1;
        badrecordm:
      end;
    until (scanline=Zjt65line) or EOF(Logname);
    closefile(Logname);
    logscanned:=True;
  end;
  //         ~~~L O G S C A N  F U E R  A D I F  ~~~~~~~~~~~~~~~~
  //if cfgvtwo.Form6.cbLogAdif.Checked then
  if cfgvtwo.fileformatadi then begin
    logline:='';
    Assignfile(logname,logpath);
    reset(logname);
    foo:='';
    repeat
      readln(logname,logline);
      foo:=foo+ logline;
    until AnsiEndsText('<eor>',foo) or (EOF(logname));
    if AnsiContainsStr(foo,'<call:') then begin
      smallletter:=True;
      bigletter:=False;
    end;
    if AnsiContainsStr(foo,'<CALL') or (cfgvtwo.emptyfile) then begin
      bigletter:=True;
      smallletter:=False;
    end;

    // EXPERIMENTAL
    if not (AnsiContainsStr(foo,'<CALL') or AnsiContainsStr(foo,'<call:') or cfgvtwo.emptyfile) then smallletter:= true;
    // Leseschleife des Haeders, foo wird am Ende gelöscht
    // wird nur genommen,damit interner Lesezeiger am Ende des Headers steht
    Reset(logName);
    freqcomma:=False;
    freqpoint:=False;
    //auessere Leseschleife der Logdatei,Ende mit EOF
    Repeat
      foo:='';
      //innere Leseschleife des Logrecords, Ende mit <eor>
      Repeat
        ReadLn(LogName,logline);
        foo:= foo+ logline;
      until AnsiEndsText('<eor>',foo) or EOF(logname);
      //Wenn im Logrecord als Betriebsart 'JT65' steht:
      if AnsiContainsStr(foo,'65A') or AnsiContainsStr(foo,'JT65') or AnsiContainsStr(foo,'JT65A') then begin
        if bigletter then callfromlogpos:= POS('<CALL:',foo);     //Ermittlung der 1. Position von 'Call:'
        if smallletter then callfromlogpos:= POS('<call:',foo); //Ermittlung der 1. Position von 'Call:'
        if callfromlogpos=0 then goto badrecorda;
        callfromloglength:=foo[callfromlogpos+6];                //Ermittlung der Calllaenge
        callok:=StrToInt(callfromloglength);
        if callok<3 then goto badrecorda;                         //Ein Call mit kleiner als 3 Zeichen gibt es nicht,Sprung ans Routinenende
        callfromlog:=foo[(callfromlogpos+8)..(callfromlogpos+7+StrtoInt(callfromloglength))];//Errechnung Call aus Position und Laenge
        setlength(jtqso,scanline+1);
        jtqso[scanline].call:=callfromlog;
        searchSubPref();
        logfreqpos:=0;
        logqslrpos:=0;
        if AnsiContainsStr(foo,'<FREQ:') and bigletter then logfreqPos:= POS('<FREQ:',foo);
        if AnsiContainsStr(foo,'<freq:') and smallletter then logfreqPos:= POS('<freq:',foo);
        {if logfreqPos=0 then goto badrecorda;}
        if bigletter and AnsiContainsStr(foo,'<QSL_RCVD:1>') then logqslrPos:= POS('<QSL_RCVD:1>',foo);
        if smallletter and AnsiContainsStr(foo,'<qsl_rcvd:1>') then logqslrPos:= POS('<qsl_rcvd:1>',foo);
        if AnsiContainsText(foo,'<freq:') then begin
          logfreqlength:=foo[(logfreqPos+6)..(logfreqPos+6)];
          logfreqend:=StrToInt(logfreqlength);
          logqrg:=foo[(logfreqPos+8)..(logfreqPos+7+logfreqend)];
          if AnsiContainsStr(logqrg,'.') then begin
            freqpoint:=True;
            freqcomma:=False;
            ////cfgvtwo.Form6.CheckBox2.Checked:=True;
            ////cfgvtwo.Form6.CheckBox1.Checked:=False;
            ////Decimalseparator:='.';
          end;
          if  AnsiContainsStr(logqrg,',') then begin
            freqpoint:=False;
            freqcomma:=True;
            ////cfgvtwo.Form6.CheckBox1.Checked:=True;
            ////cfgvtwo.Form6.CheckBox2.Checked:=False;
            ////Decimalseparator:=',';
          end;
          if freqpoint then logfreqpoint:=pos('.',logqrg);
          if freqcomma then logfreqpoint:=pos(',',logqrg);
          logfreqbefore:=logqrg[1..logfreqpoint-1];
        end;
        {160m}
        if (logfreqbefore ='1') or AnsiContainsText(foo,'<Band:4>160M') then begin
          jtqso[scanline].m160w:=true;
          mpref[mprefidx].m160w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') then begin
            jtqso[scanline].m160c:=true;
            mpref[mprefidx].m160c:=true;
          end;
        end;
        {80m}
        if (logfreqbefore ='3') or AnsiContainsText(foo,'<Band:3>80M') then begin
          jtqso[scanline].m80w:=true;
          mpref[mprefidx].m80w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m80c:=true;
            mpref[mprefidx].m80c:=true;
          end;
        end;
        {40m}
        if (logfreqbefore ='7') or AnsiContainsText(foo,'<Band:3>40M') then begin
          jtqso[scanline].m40w:=true;
          mpref[mprefidx].m40w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m40c:=true;
            mpref[mprefidx].m40c:=true;
          end;
        end;
        {30m}
        if (logfreqbefore ='10')  or AnsiContainsText(foo,'<Band:3>30M') then begin
          jtqso[scanline].m30w:=true;
          mpref[mprefidx].m30w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m30c:=true;
            mpref[mprefidx].m30c:=true;
          end;
        end;
        {20m}
        if (logfreqbefore ='14') or AnsiContainsText(foo,'<Band:3>20M') then begin
          jtqso[scanline].m20w:=true;
          mpref[mprefidx].m20w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m20c:=true;
            mpref[mprefidx].m20c:=true;
          end;
        end;
        {17m}
        if (logfreqbefore ='18') or AnsiContainsText(foo,'<Band:3>17M') then begin
          jtqso[scanline].m17w:=true;
          mpref[mprefidx].m17w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m17c:=true;
            mpref[mprefidx].m17c:=true;
          end;
        end;
        {15m}
        if (logfreqbefore ='21') or AnsiContainsText(foo,'<Band:3>15M') then begin
          jtqso[scanline].m15w:=true;
          mpref[mprefidx].m15w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m15c:=true;
            mpref[mprefidx].m15c:=true;
          end;
        end;
        {12m}
        if (logfreqbefore ='24') or AnsiContainsText(foo,'<Band:3>12M') then begin
          jtqso[scanline].m12w:=true;
          mpref[mprefidx].m12w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m12c:=true;
            mpref[mprefidx].m12c:=true;
          end;
        end;
        {10m}
        if (logfreqbefore ='28') or AnsiContainsText(foo,'<Band:3>10M') then begin
          jtqso[scanline].m10w:=true;
          mpref[mprefidx].m10w:=true;
          qsocfm:=foo[(logqslrpos+12)..(logqslrpos+12)];
          if (qsocfm='Y') and AnsiContainsText(foo,'<qsl_rcvd') then begin
            jtqso[scanline].m10c:=true;
            mpref[mprefidx].m10c:=true;
          end;
        end;
        scanline:=scanline+1;
        Zjt65line:=scanline;
      end;
      badrecorda:
    until EOF(logname);
    closefile(logname);
    logscanned:=True;
  end;
  nologfile:
end;

procedure callfromrecord();
var
callrecord  :   String; // Call aus dem Record
freqfromjt  :   Real;   // Frequenz von JT65
freqcompare :   Integer; //ganzzahliger (abgeschnittener) Anteil von freqfromjt
wcount      :   Integer; //Anzahl der Woerter in RX-Textzeile
z1          :   Integer; //Zaehlvariable
begin
  cil:=False;
  qsobev:=False;
  cnil:=True;
  callcfmcurr:=False;
  callcfmab:=False;
  //begin
  for z1:=0 to Zjt65line-1 do begin
    callrecord:=jtqso[Z1].call;
    if callfromjt=callrecord then begin
      freqfromjt:= globaldata.iqrg / 1000000;
      cil:=True;
      freqcompare:= trunc(freqfromjt);
      // Vergleich ob auf 160m gearbeitet + bestaetigt
      if (freqcompare=1) then begin
        if (jtqso[Z1].m160w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m160c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 80m gearbeitet + bestaetigt
      if (freqcompare=3) then begin
        if (jtqso[Z1].m80w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m80c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 40m gearbeitet + bestaetigt
      if (freqcompare=7) then begin
        if (jtqso[Z1].m40w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m40c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 30m gearbeitet + bestaetigt
      if (freqcompare=10) then begin
        if (jtqso[Z1].m30w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m30c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 20m gearbeitet + bestaetigt
      if (freqcompare=14) then begin
        if (jtqso[Z1].m20w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m20c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 17m gearbeitet + bestaetigt
      if (freqcompare=18) then begin
        if (jtqso[Z1].m17w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m17c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 15m gearbeitet + bestaetigt
      if (freqcompare=21) then begin
        if (jtqso[Z1].m15w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m15c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 12m gearbeitet + bestaetigt
      if (freqcompare=24) then begin
        if (jtqso[Z1].m12w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m12c=true) then callcfmcurr:=True;
      end;
      // Vergleich ob auf 10m gearbeitet + bestaetigt
      if (freqcompare=28) then begin
        if (jtqso[Z1].m10w=true) then begin
          qsobev:=true;
          cil:=false;
        end;
        if (jtqso[Z1].m10c=true) then callcfmcurr:=True;
      end;
      if (not callcfmcurr) then begin
        if (jtqso[Z1].m160c=true) then callcfmab:=True;
        if (jtqso[Z1].m80c=true) then callcfmab:=True;
        if (jtqso[Z1].m40c=true) then callcfmab:=True;
        if (jtqso[Z1].m30c=true) then callcfmab:=True;
        if (jtqso[Z1].m20c=true) then callcfmab:=True;
        if (jtqso[Z1].m17c=true) then callcfmab:=True;
        if (jtqso[Z1].m15c=true) then callcfmab:=True;
        if (jtqso[Z1].m12c=true) then callcfmab:=True;
        if (jtqso[Z1].m10c=true) then callcfmab:=True;
      end;
    end;
  end;
     //end;
  if cil=True or qsobev=True then cnil:=False;
end;

procedure searchCallPref();
{Prozedur sucht Call und den zugehörigen Prefix in den jeweiligen Records und
bildet so ctywkd+ ctycfm }
var
freqfromjt  :   Real;   // Frequenz von JT65
freqcompare: Integer;
begin
  callfromlog:=callfromjt;
  searchsubpref();
  freqfromjt:= globaldata.iqrg / 1000000;
  freqcompare:= trunc(freqfromjt);
  ctywkd:=False;
  ctycfm:=False;
  ctyab:=False;
  ctyabc:=False;
  {160m}
  if freqcompare=1 then begin
    if mpref[MprefIdx].m160w then ctywkd:=True;
    if mpref[MprefIdx].m160C then ctycfm:=True;
  end;
  {80m}
  if freqcompare=3 then begin
    if mpref[MprefIdx].m80w then ctywkd:=True;
    if mpref[MprefIdx].m80C then ctycfm:=True;
  end;
  {40m}
  if freqcompare=7 then begin
    if mpref[MprefIdx].m40w then ctywkd:=True;
    if mpref[MprefIdx].m40C then ctycfm:=True;
   end;
  {30m}
  if freqcompare=10 then begin
    if mpref[MprefIdx].m30w then ctywkd:=True;
    if mpref[MprefIdx].m30C then ctycfm:=True;
  end;
  {20m}
  if freqcompare=14 then begin
    if mpref[MprefIdx].m20w then ctywkd:=True;
    if mpref[MprefIdx].m20C then ctycfm:=True;
  end;
  {17m}
  if freqcompare=18 then begin
    if mpref[MprefIdx].m17w then ctywkd:=True;
    if mpref[MprefIdx].m17C then ctycfm:=True;
  end;
  {15m}
  if freqcompare=21 then begin
    if mpref[MprefIdx].m15w then ctywkd:=True;
    if mpref[MprefIdx].m15C then ctycfm:=True;
  end;
  {12m}
  if freqcompare=24 then begin
    if mpref[MprefIdx].m12w then ctywkd:=True;
    if mpref[MprefIdx].m12C then ctycfm:=True;
  end;
  {10m}
  if freqcompare=28 then begin
    if mpref[MprefIdx].m10w then ctywkd:=True;
    if mpref[MprefIdx].m10C then ctycfm:=True;
  end;
  if (not ctywkd) then  //wenn nicht auf akt. Band gearbeitet, dann Abfrage andere Bänder
    begin
    if mpref[MprefIdx].m160w then ctyab:=True;
    if mpref[MprefIdx].m80w then ctyab:=True;
    if mpref[MprefIdx].m40w then ctyab:=True;
    if mpref[MprefIdx].m30w then ctyab:=True;
    if mpref[MprefIdx].m20w then ctyab:=True;
    if mpref[MprefIdx].m17w then ctyab:=True;
    if mpref[MprefIdx].m15w then ctyab:=True;
    if mpref[MprefIdx].m12w then ctyab:=True;
    if mpref[MprefIdx].m10w then ctyab:=True;
  end;
  if (not ctycfm) then  //wenn nicht auf akt. Band bestätigt, dann Abfrage andere Bänder
    begin
    if mpref[MprefIdx].m160C then ctyabc:=True;
    if mpref[MprefIdx].m80C then ctyabc:=True;
    if mpref[MprefIdx].m40C then ctyabc:=True;
    if mpref[MprefIdx].m30C then ctyabc:=True;
    if mpref[MprefIdx].m20C then ctyabc:=True;
    if mpref[MprefIdx].m17C then ctyabc:=True;
    if mpref[MprefIdx].m15C then ctyabc:=True;
    if mpref[MprefIdx].m12C then ctyabc:=True;
    if mpref[MprefIdx].m10C then ctyabc:=True;
  end;
end;

procedure clearrecord();
{wird beim Logwechsel benoetigt, um die Masterprefixe zu löschen und beim
Scannen des neuen Logs mit einen leeren Masterprefix anzufangen}
var
  z1 :      Integer;
begin
  for z1:=0 to Zprefline do begin
    mpref[z1].m160w:=False;
    mpref[z1].m160c:=False;
    mpref[z1].m80w:=False;
    mpref[z1].m80c:=False;
    mpref[z1].m40w:=False;
    mpref[z1].m40c:=False;
    mpref[z1].m30w:=False;
    mpref[z1].m30c:=False;
    mpref[z1].m20w:=False;
    mpref[z1].m20c:=False;
    mpref[z1].m17w:=False;
    mpref[z1].m17c:=False;
    mpref[z1].m15w:=False;
    mpref[z1].m15c:=False;
    mpref[z1].m12w:=False;
    mpref[z1].m12c:=False;
    mpref[z1].m10w:=False;
    mpref[z1].m10c:=False;
  end;
end;

end.

