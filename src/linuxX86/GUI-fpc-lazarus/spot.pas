//
// Copyright (c) 2008...2011 J C Large - W6CQZ
//
//
// JT65-HF is the legal property of its developer.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; see the file COPYING. If not, write to
// the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
// Boston, MA 02110-1301, USA.
//
unit spot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, httpsend, synacode, valobject, StrUtils, CTypes,
  {$IFDEF WIN32}windows,{$ENDIF}{$IFDEF LINUX}unix,{$ENDIF}
  {$IFDEF DARWIN}unix,{$ENDIF} DateUtils;

Type
    spotRecord = record
      qrg      : Integer;
      date     : String;
      time     : String;
      sync     : Integer;
      db       : Integer;
      dt       : Double;
      df       : Integer;
      decoder  : String;
      exchange : String;
      mode     : String;
      rbsent   : Boolean;
      pskrsent : Boolean;
      dbfsent  : Boolean;
    end;

    spotsArray = Array of spotRecord;

    spotDBRec  = record
      callsign : Array[0..16] of Char;
      grid1    : Array[0..6] of Char;
      grid2    : Array[0..6] of Char;
      grid3    : Array[0..6] of Char;
      grid4    : Array[0..6] of Char;
      count    : CTypes.cuint32;
      first    : TDateTime;
      last     : TDateTime;
      b160     : Boolean;
      b80      : Boolean;
      b40      : Boolean;
      b30      : Boolean;
      b20      : Boolean;
      b17      : Boolean;
      b15      : Boolean;
      b12      : Boolean;
      b10      : Boolean;
      b6       : Boolean;
      b2       : Boolean;
      wb160    : Boolean;
      wb80     : Boolean;
      wb40     : Boolean;
      wb30     : Boolean;
      wb20     : Boolean;
      wb17     : Boolean;
      wb15     : Boolean;
      wb12     : Boolean;
      wb10     : Boolean;
      wb6      : Boolean;
      wb2      : Boolean;
    end;

    spotDB     = File Of spotDBRec;

    spotDBIdx  = Record
      id       : CTypes.cuint32;
      callsign : Array[0..16] of Char;
    end;

    spotIDX    = File of spotDBIdx;

    // Encapsulates all the possible spotting methods to a single unified interface.
    // Handles (for now) RB and PSKR spotting.
    TSpot = Class
       private
              // Control values
              prMyCall      : String;
              prMyGrid      : String;
              prMyQRG       : Integer;
              prUseRB       : Boolean;
              prUsePSKR     : Boolean;
              prUseDBF      : Boolean;
              prRBOn        : Boolean;
              prRBError     : String;
              prPSKROn      : Boolean;
              prBusy        : Boolean;
              prVersion     : String;
              prSpots       : spotsArray;
              prVal         : valobject.TValidator;
              prRBCount     : CTypes.cuint64;
              prRBFail      : CTypes.cuint64;
              prRBDiscard   : CTypes.cuint64;
              prPRCount     : CTypes.cuint64;
              prDBFCount    : CTypes.cuint64;
              prDBFUCount   : CTypes.cuint64;
              prDBLock      : Boolean;
              //pskrStats     : PSKReporter.REPORTER_STATISTICS;
              //pskrstat      : DWORD;
              prInfo        : String;
              prLogDir      : String;
              prErrDir      : String;
              prhttp        : THTTPSend;
              rbResult      : TStringList;
              // Private functions to format data for PSK Reporter
              function BuildRemoteString (call, mode, freq, date, time : String) : WideString;
              function BuildRemoteStringGrid (call, mode, freq, grid, date, time : String) : WideString;
              function BuildLocalString (station_callsign, my_gridsquare, programid, programversion, my_antenna : String) : WideString;
              // Private function to parse exchange text for RB/PSKR
              function parseExchange(const exchange : String; var callheard : String; var gridheard : String) : Boolean;
              // Private functions for internal DB handling
              function  utcTime: TSystemTime;

       public
             Constructor create;
             Destructor  endspots;
             function    addSpot(const spot : spotRecord) : Boolean;
             function    loginRB    : Boolean;
             function    loginPSKR  : Boolean;
             function    logoutRB   : Boolean;
             function    logoutPSKR : Boolean;
             function    pushSpots  : Boolean;
             function    RBCountS   : String;
             function    RBFailS    : String;
             function    RBDiscardS : String;
             function    PRcountS   : String;
             function    DBFcountS  : String;
             function    DBFUcountS : String;

             property myCall    : String
                read  prMyCall
                write prMyCall;
             property myGrid    : String
                read  prMyGrid
                write prMyGrid;
             property myQRG     : Integer
                read  prMyQRG
                write prMyQRG;
             property useRB     : Boolean
                read  prUseRB
                write prUseRB;
             property usePSKR   : Boolean
                read  prUsePSKR
                write prUsePSKR;
             property useDBF    : Boolean
                read  prUseDBF
                write prUseDBF;
             property rbOn      : Boolean
                read  prRBOn;
             property pskrOn    : Boolean
                read  prPSKROn;
             property busy      : Boolean
                read  prBusy;
             property rbError   : String
                read  prRBError;
             property version   : String
                read  prVersion
                write prVersion;
             property rbCount   : String
                read  RBCountS;
             property rbDiscard : String
                read  rbDiscardS;
             property rbFail    : String
                read  RBFailS;
             property pskrCount : String
                read  PRCountS;
             property dbfCount  : String
                read  DBFCountS;
             property dbfUCount : String
                read  DBFUCountS;
             property rbInfo    : String
                read  prInfo
                write prInfo;
             property rbVersion : String
                read  prVersion
                write prVersion;
             //property pskrCallsSent : Word
                //read  pskrStats.callsigns_sent;
             //property pskrCallsBuff : Word
                //read  pskrStats.callsigns_discarded;  // I know this looks WRONG but, so far, it's not.  See notes in constructor code.
             //property pskrCallsDisc : Word
                //read  pskrStats.next_send_time;
             //property pskrConnected : LongBool
                //read  pskrStats.connected;
             property logDir : String
                read  prLogDir
                write prLogDir;
             property errDir : String
                read  prErrDir
                write prErrDir;
       end;

implementation

    function TSpot.utcTime: TSystemTime;
       {$IFDEF LINUX}
       var
          TV: TimeVal;
          TD: TDateTime;
       begin
            result.Day := 0;
            fpgettimeofday(@TV, nil);
            TD := UnixDateDelta + (TV.tv_sec + TV.tv_usec / 1000000) / 86400;
            DateTimeToSystemTime(TD,result);
       {$ENDIF}
       {$IFDEF DARWIN}
       var
          TV: TimeVal;
          TD: TDateTime;
       begin
            result.Day := 0;
            fpgettimeofday(@TV, nil);
            TD := UnixDateDelta + (TV.tv_sec + TV.tv_usec / 1000000) / 86400;
            DateTimeToSystemTime(TD,result);
       {$ENDIF}
       {$IFDEF WIN32}
       Begin
            result.Day := 0;
            GetSystemTime(result);
       {$ENDIF}
    end;

    constructor TSpot.Create;
    var
       i : Integer;
    Begin
         // Setup validation utility object
         prVal     := valobject.TValidator.create();
         // Setup http object for RB use
         prhttp         := THTTPSend.Create;
         prMyCall    := '';
         prMyGrid    := '';
         prMyQRG     := 0;
         prUseRB     := false;
         prUsePSKR   := False;
         prUseDBF    := False;
         prRBOn      := False;
         prRBError   := '';
         prPSKROn    := False;
         // Linux versions report RB Version as even integer for last digit -- Windows is odd :)
         prVersion   := '2002';
         prRBCount   := 0;
         prPRCount   := 0;
         prRBFail    := 0;
         prDBFCount  := 0;
         prDBFUCount := 0;
         prRBDiscard := 0;
         prDBLock    := False;
         prInfo      := '';
         prLogDir    := '';
         prErrDir    := '';
         setlength(prSpots,8192);
         for i := 0 to 8191 do
         begin
              prspots[i].qrg      := 0;
              prspots[i].date     := '';
              prspots[i].time     := '';
              prspots[i].sync     := 0;
              prspots[i].db       := 0;
              prspots[i].dt       := 0.0;
              prspots[i].df       := 0;
              prspots[i].decoder  := '';
              prspots[i].exchange := '';
              prspots[i].mode     := '65A';
              prspots[i].rbsent   := true;
              prspots[i].pskrsent := true;
              prspots[i].dbfsent  := true;
         end;
         rbResult := TStringList.Create;
         rbResult.Clear;
    End;

    Destructor TSpot.endspots;
    Begin
         prHTTP.Free;                       // Release HTTP object
         setlength(prSpots,0);              // Free spots array
    end;

    //function  TSpot.pskrTickle : DWORD;
    //begin
         //If pskrstat = 0 Then
         //Begin
              //PSKReporter.ReporterGetStatistics(pskrStats,sizeof(pskrStats));
              //result := PSKReporter.ReporterTickle;
         //end;
    //end;

    function  TSpot.RBcountS : String;
    begin
         result := IntToStr(prRBCount);
    end;

    function  TSpot.RBDiscardS : String;
    begin
         result := IntToStr(prRBDiscard);
    end;

    function  TSpot.RBFailS : String;
    begin
         result := IntToStr(prRBFail);
    end;

    function  TSpot.PRcountS : String;
    begin
         result := IntToStr(prPRCount);
    end;

    function  TSpot.DBFcountS  : String;
    begin
         result := IntToStr(prDBFCount);
    end;

    function  TSpot.DBFUcountS  : String;
    begin
         result := IntToStr(prDBFUCount);
    end;

    function  TSpot.addSpot(const spot : spotRecord) : Boolean;
    var
       i         : Integer;
       inserted  : Boolean;
    begin
         inserted := false;
         for i := 0 to 8191 do
         begin
              if prSpots[i].rbsent and prSpots[i].pskrsent and prSpots[i].dbfsent then
              begin
                   // Found a spot to insert a new report
                   prspots[i].qrg      := spot.qrg;
                   prspots[i].date     := spot.date;
                   prspots[i].time     := spot.time;
                   prspots[i].sync     := spot.sync;
                   prspots[i].db       := spot.db;
                   prspots[i].dt       := spot.dt;
                   prspots[i].df       := spot.df;
                   prspots[i].decoder  := spot.decoder;
                   prspots[i].exchange := spot.exchange;
                   prspots[i].mode     := '65A';
                   prspots[i].rbsent   := false;
                   prspots[i].pskrsent := false;
                   prspots[i].dbfsent  := false;
                   inserted := true;
                   break;
              end;
         end;
         result := inserted;
    end;

    function TSpot.loginRB : Boolean;
    var
       url      : String;
    Begin
         prRBError    := '';
         prBusy       := True;
         url          := 'http://jt65.w6cqz.org/rb.php?func=LI&callsign=' + prMyCall + '&grid=' + prMyGrid + '&qrg=' + IntToStr(prMyQRG) + '&rbversion=' + prVersion;
         prhttp.Clear;
         prhttp.Timeout := 10000;  // 10K ms = 10 s
         prhttp.Headers.Add('Accept: text/html');
         rbResult.Clear;
         Try
            // This logs in to the RB System using parameters set in the object class
            if not prHTTP.HTTPMethod('GET', url) Then
            begin
                 prRBOn := False;
                 result := False;
            end
            else
            begin
                 rbResult.LoadFromStream(prHTTP.Document);
                 // Messages RB login can return:
                 // QSL - All good, logged in.
                 // NO - Indicates login failed but not due to bad RB data, so it's safe to try again. (Probably RB Server busy)
                 // BAD QRG - Fix the RB's QRG error before trying again.
                 // BAD GRID - Invalid Grid value, fix before trying again.
                 // BAD CALL - RB Call too short/long, fix before trying again.
                 // BAD MODE - RB Mode not 65A or 4B, fix before trying again.
                 prRBOn := False;
                 If TrimLeft(TrimRight(rbResult.Text)) = 'QSL'      Then prRBOn := true;
                 //If TrimLeft(TrimRight(rbResult.Text)) = 'BAD QRG'  Then prRBOn := false;
                 //If TrimLeft(TrimRight(rbResult.Text)) = 'BAD GRID' Then prRBOn := false;
                 //If TrimLeft(TrimRight(rbResult.Text)) = 'BAD CALL' Then prRBOn := false;
                 //If TrimLeft(TrimRight(rbResult.Text)) = 'BAD MODE' Then prRBOn := false;
                 //If TrimLeft(TrimRight(rbResult.Text)) = 'NO'       Then prRBOn := false;
                 prRBError := TrimLeft(TrimRight(rbresult.Text));
            end;
         Except
            prRBError := 'EXCEPTION';
            prRBOn    := False;
         End;
         prBusy := False;
         prBusy := False;
         result := prRBOn;
    end;

    function TSpot.logoutRB : Boolean;
    var
       url      : String;
       band     : String;
       go       : Boolean;
    Begin
         prBusy       := True;
         band := '';
         if prVal.evalIQRG(prMyQRG,'LAX',band) then go := true else go := false;
         if go then
         begin
              rbResult.Clear;
              prRBError    := '';
              url          := 'http://jt65.w6cqz.org/rb.php?func=LO&callsign=' + prMyCall + '&grid=' + prMyGrid + '&qrg=' + IntToStr(prMyQRG) + '&rbversion=' + prVersion;
              prhttp.Clear;
              prhttp.Timeout := 10000;  // 10K ms = 10 s
              prhttp.Headers.Add('Accept: text/html');
              Try
                 // This logs out the RB using parameters set in the object class
                 if not prHTTP.HTTPMethod('GET', url) Then
                 begin
                      prRBOn := False;
                      result := False;
                 end
                 else
                 begin
                      rbResult.LoadFromStream(prHTTP.Document);
                      // Messages RB login can return:
                      // QSL - All good, logged out.
                      // NO - Indicates logout failed. (Probably RB Server busy)
                      If TrimLeft(TrimRight(rbResult.Text[1..3])) = 'QSL' Then prRBOn := false;
                      If TrimLeft(TrimRight(rbResult.Text[1..2])) = 'NO'  Then prRBOn := true;
                      prRBError := TrimLeft(TrimRight(rbresult.Text));
                 end;
              Except
                 prRBError := 'EXCEPTION';
                 prRBOn    := True;
              End;
              if prRBOn then result := false else result := true;
         end
         else
         begin
              prRBError := 'QRG';
              prRBOn    := false;
              result    := false;
         end;
         result := true;
         prBusy := False;
    end;

    function TSpot.loginPSKR : Boolean;
    Begin
         //pskrstat := PSKReporter.ReporterInitialize('report.pskreporter.info','4739');
         //if pskrstat = 0 then
         //begin
              //result := True;
              //prPSKROn := True;
         //end
         //else
         //begin
              result := False;
              prPSKROn := False;
         //end;
    End;

    function TSpot.logoutPSKR : Boolean;
    Begin
         //PSKReporter.ReporterUninitialize;
         //pskrStat := 1;
         result := False;
         prPSKROn := False;
    end;

    function TSpot.pushSpots : Boolean;
    var
       url       : String;
       i         : Integer;
       resolved  : Boolean;
       callheard : String;
       gridheard : String;
       band      : String;
    Begin
         prRBError := '';
         band      := '';
         prBusy    := True;
         // This function handles sending spots to RB Network, PSK Reporter or Internal Database
         if prUseRB then
         begin
              // Do RB work
              for i := 0 to 8191 do
              begin
                   if not prSpots[i].rbsent then
                   begin
                        // OK.  Found an entry not marked as sent.  Is it something to send or not?
                        rbResult.Clear;
                        url       := '';
                        resolved  := false;
                        callheard := '';
                        gridheard := '';
                        if parseExchange(prSpots[i].exchange, callheard, gridheard) and prVal.evalIQRG(prSpots[i].qrg,'LAX',band) then
                        begin
                             prhttp.Clear;
                             prhttp.Timeout := 10000;  // 10K ms = 10 s
                             prhttp.Headers.Add('Accept: text/html');
                             url := synacode.EncodeURL('http://jt65.w6cqz.org/rb.php?func=RR&callsign=' + prMyCall + '&grid=' + prMyGrid + '&qrg=' + IntToStr(prSpots[i].qrg) + '&rxdate=' + prSpots[i].date + '&callheard=' + callheard + '&gridheard=' + gridheard + '&siglevel=' + IntToStr(prSpots[i].db) + '&deltaf=' + IntToStr(prSpots[i].df) + '&deltat=' + floatToStrF(prSpots[i].dt,ffFixed,0,1) + '&decoder=' + prSpots[i].decoder + '&mode=' + prSpots[i].mode + '&exchange=' + prSpots[i].exchange + '&rbversion=' + prVersion);
                             Try
                                if prHTTP.HTTPMethod('GET', url) Then
                                begin
                                     rbResult.LoadFromStream(prHTTP.Document);
                                     // Messages RB login can return:
                                     // QSL - All good, spot saved.
                                     // NO - Indicates spot failed and safe to retry. (Probably RB Server busy)
                                     // ERR - Indicates RB Server has an issue with the data and not allowed to retry.
                                     // QRG - Indicates RB Server will no accept the current QRG
                                     If Length(rbResult.Text) > 1 then
                                     begin
                                          If TrimLeft(TrimRight(rbResult.Text)) = 'QSL' Then resolved := true;
                                          If TrimLeft(TrimRight(rbResult.Text)) = 'QRG' Then resolved := false;
                                          If TrimLeft(TrimRight(rbResult.Text)) = 'NO'  Then resolved := false;
                                          If TrimLeft(TrimRight(rbResult.Text)) = 'ERR' Then resolved := false;
                                     end
                                     else
                                     begin
                                          // Unexpected return value from URL call
                                     end;
                                end
                                else
                                begin
                                     resolved := False;
                                end;
                             Except
                                resolved := false;
                             End;
                             // Wrap up by checking for status of spot and clearing its place in the list as appropriate.
                             if resolved then
                             begin
                                  prSpots[i].rbsent := true;
                                  inc(prRBCount);
                             end
                             else
                             begin
                                  { TODO [1.0.9] Pass back error to main code so user can be notified of problem }
                                  { TODO [1.0.9] This is a hard fail.. even in the case where a retry is warranted the spot is discarded. }
                                  //if length(foo) < 2 then foo := 'EXC';
                                  //prSpots[i].rbsent:= true;
                                  //if foo[1..3] = 'QRG' then prSpots[i].rbsent := true;  // RB Server says bad QRG so don't try to send this again...
                                  //if foo[1..2] = 'NO' then prSpots[i].rbsent  := true; { TODO : Fix this (Set back to true) once I decide how to better handle retries }
                                  //if foo[1..3] = 'EXC' then prSpots[i].rbsent := true; { TODO : Fix this (Set back to true) once I decide how to better handle retries }
                                  //if foo[1..3] = 'ERR' then prSpots[i].rbsent := true;
                                  //if foo[1..3] = 'BAD' then prSpots[i].rbsent := true;  // RB Server doesn't like some of the data (probably big DT) so no resend
                                  inc(prRBFail);
                             end;
                        end
                        else
                        begin
                             inc(prRBDiscard);
                             // Excahnge did not parse to something of use or qrg invalid.  Mark it sent so it can be cleared.
                             prSpots[i].rbsent   := true;
                             prSpots[i].pskrsent := true;
                        end;
                        sleep(100); // Lets not overload the RB server with little or no delay between spot posts.
                   end;
              end;
         end
         else
         begin
              // Process any spots marked as not sent for RB lest the array fills with unsent entries. This is only called
              // when RB spotting is not enabled as it is otherwise cleared above.
              for i := 0 to 8191 do if not prSpots[i].rbsent then prSpots[i].rbsent := true;
         end;

         // Linux does not have PSKR ability
         for i := 0 to 8191 do if not prSpots[i].pskrsent then prSpots[i].pskrsent := true;
         // Internal db functions disable for switch to SQLite
         for i := 0 to 8191 do if not prSpots[i].dbfsent then prSpots[i].dbfsent := true;

         result := true;
         prBusy := false;
    end;

    function  TSpot.parseExchange(const exchange : String; var callheard : String; var gridheard : String) : Boolean;
    var
       w1,w2,w3  : String;
       w4,w5,w6  : String;
       resolved  : Boolean;
    Begin
         // I'm probably going to annoy some, but, as of 2.0.0 the RB/PSK Reporter
         // spots will only spot callsigns using JT65 frames that are strictly valid
         // in the sense of JT65 structured messages.
         // Those being:
         //
         // 2 Word frames
         //
         // CQ           PFX/CALLSIGN
         // CQ           CALLSIGN/SFX
         // QRZ          PFX/CALLSIGN
         // QRZ          CALLSIGN/SFX
         // CALLSIGN     PFX/CALLSIGN
         // CALLSIGN     CALLSIGN/SFX
         // PFX/CALLSIGN CALLSIGN
         // CALLSIGN/SFX CALLSIGN
         //
         // And I will allow the following messages that are not structured,
         // but, are safe enough to deal with in free text mode and not, in
         // general, abused.
         //
         // Non-structured 2 word frames
         //
         // TEST         CALLSIGN
         // CALLSIGN     TEST
         // CALLSIGN     GRID6
         // CALLSIGN     GRID4
         //
         // 3 Word frames
         //
         // CQ           CALLSIGN GRID
         // QRZ          CALLSIGN GRID
         // CALLSIGN     CALLSIGN GRID
         // CALLSIGN     CALLSIGN -##
         // CALLSIGN     CALLSIGN R-##
         // CALLSIGN     CALLSIGN RRR
         // CALLSIGN     CALLSIGN 73
         //
         // OK.  Those are what I'll allow.  This means stations using something
         // like CQ DX CALLSIGN or CQDX CALLSIGN or whatever of the endless things
         // people think to try will not be spotted.  Since the RB system is mine
         // I get to make the rules.  :)
         //
         //
         // If the word count is < 2 or > 3 then I'm not interested in trying
         // to extract anything from it.
         //
         resolved := false;
         result    := false;
         if (wordcount(exchange,[' ']) = 2) or (wordcount(exchange,[' ']) = 3) then resolved := true else resolved := false;
         if resolved then
         begin
              if(wordcount(exchange,[' ']) = 2) then
              begin
                   w1 := ExtractWord(1,exchange,[' ']);
                   w2 := ExtractWord(2,exchange,[' ']);
                   w3 := '   ';
              end;
              if(wordcount(exchange,[' ']) = 3) then
              begin
                   w1 := ExtractWord(1,exchange,[' ']);
                   w2 := ExtractWord(2,exchange,[' ']);
                   w3 := ExtractWord(3,exchange,[' ']);
              end;
         end;
         if resolved then
         begin
              // Have an exchange with 2 or 3 words so it is safe to proceed.
              // Evaluate excahnge for slashed callsign in a 3 word frame
              if (wordcount(exchange,[' '])=3) and (ansiContainsText(exchange,'/')) then resolved := false else resolved := true;
              if resolved then
              begin
                   // Passed the check for no slash in 3 word frame
                   // Doing the 3 word frame types first
                   resolved := false;
                   if not resolved and (w1='CQ') and prVal.evalCSign(w2) and prVal.evalGrid(w3) then
                   begin
                        // w1           w2       w3
                        // CQ           CALLSIGN GRID
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := w3;
                   end;
                   if not resolved and (w1='QRZ') and prVal.evalCSign(w2) and prVal.evalGrid(w3) then
                   begin
                        // w1           w2       w3
                        // QRZ          CALLSIGN GRID
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := w3;
                   end;
                   if not resolved and prVal.evalCSign(w1) and prVal.evalCSign(w2) and prVal.evalGrid(w3) then
                   begin
                        // w1           w2       w3
                        // CALLSIGN     CALLSIGN GRID
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := w3;
                   end;
                   if not resolved and prVal.evalCSign(w1) and prVal.evalCSign(w2) and (w3[1]='-') then
                   begin
                        // w1           w2       w3
                        // CALLSIGN     CALLSIGN -##
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := 'NILL';
                   end;
                   if not resolved and prVal.evalCSign(w1) and prVal.evalCSign(w2) and (w3[1]='R') then
                   begin
                        // w1           w2       w3
                        // CALLSIGN     CALLSIGN R-##
                        // CALLSIGN     CALLSIGN RRR
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := 'NILL';
                   end;
                   if not resolved and prVal.evalCSign(w1) and prVal.evalCSign(w2) and (w3[1]='7') then
                   begin
                        // w1           w2       w3
                        // CALLSIGN     CALLSIGN 73
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := 'NILL';
                   end;
              end;
              //
              // 3 word frames handled now on to 2 word frames
              //
              if not resolved then
              begin
                   if not resolved and (w1='TEST') and prVal.evalCSign(w2) and (w3 = '   ') then
                   begin
                        // w1           w2
                        // TEST         CALLSIGN
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := 'NILL';
                   end;
                   if not resolved and prVal.evalCSign(w1) and (w1='TEST') and (w3 = '   ') then
                   begin
                        // w1           w2
                        // CALLSIGN     TEST
                        resolved  := true;
                        result    := true;
                        callheard := w1;
                        gridheard := 'NILL';
                   end;
                   if not resolved and prVal.evalCSign(w1) and prVal.evalGrid(w2) and (w3 = '   ') then
                   begin
                        // w1           w2
                        // CALLSIGN     GRID6
                        // CALLSIGN     GRID4
                        resolved  := true;
                        result    := true;
                        callheard := w1;
                        gridheard := w2;
                   end;
                   if not resolved and ((w1='CQ') or (w1='QRZ')) and prVal.evalCSign(w2) and (w3 = '   ') then
                   begin
                        // w1           w2
                        // CQ           CALLSIGN
                        // QRZ          CALLSIGN
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := 'NILL';
                   end;
                   if not resolved and prVal.evalCSign(w1) and prVal.evalCSign(w2) and (w3 = '   ') then
                   begin
                        // Tentative on this one...
                        // w1           w2
                        // CALLSIGN     CALLSIGN
                        resolved  := true;
                        result    := true;
                        callheard := w2;
                        gridheard := 'NILL';
                   end;
                   if not resolved and (ansiContainsText(w1,'/') or ansiContainsText(w2,'/')) then
                   begin
                        if not resolved and ((w1='CQ') or (w1='QRZ')) then
                        Begin
                             // The slash has to be in the second word...
                             if ansiContainsText(w2,'/') then
                             begin
                                  w4 := ExtractWord(1,w2,['/']);
                                  w5 := ExtractWord(2,w2,['/']);
                                  if length(w4) > length(w5) then w6 := w4;
                                  if length(w5) > length(w4) then w6 := w5;
                                  if prVal.evalCSign(w6) then
                                  begin
                                       // w1           w2
                                       // CQ           PFX/CALLSIGN
                                       // CQ           CALLSIGN/SFX
                                       // QRZ          PFX/CALLSIGN
                                       // QRZ          CALLSIGN/SFX
                                       resolved  := True;
                                       result    := true;
                                       callheard := w2;  // Remember, w2 contains the full callsign where w6 only contains the base call
                                       gridheard := 'NILL';
                                  end;
                             end;
                        end;
                        if not resolved and prVal.evalCSign(w1) then
                        begin
                             // w2 must be the slashed callsign
                             if ansiContainsText(w2,'/') then
                             begin
                                  w4 := ExtractWord(1,w2,['/']);
                                  w5 := ExtractWord(2,w2,['/']);
                                  if length(w4) > length(w5) then w6 := w4;
                                  if length(w5) > length(w4) then w6 := w5;
                                  if prVal.evalCSign(w6) then
                                  begin
                                       // w1           w2
                                       // CALLSIGN     PFX/CALLSIGN
                                       // CALLSIGN     CALLSIGN/SFX
                                       resolved  := True;
                                       result    := true;
                                       callheard := w2;  // Remember, w2 contains the full callsign where w6 only contains the base call
                                       gridheard := 'NILL';
                                  end;
                             end;
                        end;
                        if not resolved and prVal.evalCSign(w2) then
                        begin
                             // w1 must be the slashed callsign and it doesn't matter so this is easy
                             // w1           w2
                             // PFX/CALLSIGN CALLSIGN
                             // CALLSIGN/SFX CALLSIGN
                             resolved  := True;
                             result    := true;
                             callheard := w2;
                             gridheard := 'NILL';
                        end;
                   end;
              end;
         end;
    end;

    function TSpot.BuildRemoteString (call, mode, freq, date, time : String) : WideString;
    begin
         If freq='0' Then
            result := 'call' + #0 + call + #0 + 'mode' + #0 + mode + #0 + 'QSO_DATE' + #0 + date + #0 + 'TIME_ON' + #0 + time + #0 + #0
         else
            result := 'call' + #0 + call + #0 + 'mode' + #0 + mode + #0 + 'freq' + #0 + freq + #0 + 'QSO_DATE' + #0 + date + #0 + 'TIME_ON' + #0 + time + #0 + #0;
    end;

    function TSpot.BuildRemoteStringGrid (call, mode, freq, grid, date, time : String) : WideString;
    begin
         If freq='0' Then
            result := 'call' + #0 + call + #0 + 'mode' + #0 + mode + #0 + 'gridsquare' + #0 + grid + #0 + 'QSO_DATE' + #0 + date + #0 + 'TIME_ON' + #0 + time + #0 + #0
         else
            result := 'call' + #0 + call + #0 + 'mode' + #0 + mode + #0 + 'freq' + #0 + freq + #0 + 'gridsquare' + #0 + 'QSO_DATE' + #0 + date + #0 + 'TIME_ON' + #0 + time + #0 + #0;
    end;

    function TSpot.BuildLocalString (station_callsign, my_gridsquare, programid, programversion, my_antenna : String) : WideString;
    begin
         result := 'station_callsign' + #0 + station_callsign + #0 + 'my_gridsquare' + #0 + my_gridsquare + #0 +
                   'programid' + #0 + programid + #0 +
                   'programversion' + #0 + programversion + #0 +
                   'my_antenna' + #0 + my_antenna + #0 + #0;
    end;

end.
