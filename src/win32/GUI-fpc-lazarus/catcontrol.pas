unit catControl;
//
// Copyright (c) 2008,2011 J C Large - W6CQZ
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
{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Process, globalData, hrdinterface4, hrdinterface5, StrUtils;

Const
    hrdDelim = [','];

Type
    omniRec = Record
     r1stat  : String;
     r1model : String;
     r1freqA : String;
     r1freqB : String;
     r1freq  : String;
     r2stat  : String;
     r2model : String;
     r2freqA : String;
     r2freqB : String;
     r2freq  : String;
    end;

  Var
     catControlautoQSY       : Boolean;
     catControlcatTxDF       : Boolean;

  procedure hrdrigCAPS();
  function  readOmni(rig : Integer) : String;  // rig = 1 or 2.
  function  readHRDQRG(): String;
  function  readHRD(_para1:WideString): WideString;
  function  readDXLabs(): String;
  function  writeHRD(_para1:WideString): Boolean;
  function  hrdConnected(): Boolean;
  procedure hrdDisconnect();

implementation

function hrdConnected(): Boolean;
begin
     result := False;
     if globalData.hrdVersion=4  Then
     Begin
          if hrdinterface4.HRDInterfaceIsConnected() Then result := True else result := False;
     end;
     if globalData.hrdVersion=5  Then
     Begin
          if hrdinterface5.HRDInterfaceIsConnected() Then result := True else result := False;
     end;
end;

procedure hrdDisconnect();
begin
     if globalData.hrdVersion = 4 Then
     Begin
          hrdinterface4.HRDInterfaceDisconnect();
     end;
     if globalData.hrdVersion = 5 Then
     Begin
          hrdinterface5.HRDInterfaceDisconnect();
     end;
end;

procedure hrdrigCAPS();
Var
   foo                : WideString;
   ifoo               : Integer;
   wcount             : Integer;
   hrdresult          : PWIDECHAR;
   hrdmsg             : WideString;
   hrdon              : Boolean;
Begin
     hrdon := False;

     globalData.hrdcatControlcurrentRig.hrdAlive        := False;
     globalData.hrdcatControlcurrentRig.hrdAlive        := False;
     globalData.hrdcatControlcurrentRig.hasAFGain       := False;
     globalData.hrdcatControlcurrentRig.hasRFGain       := False;
     globalData.hrdcatControlcurrentRig.hasMicGain      := False;
     globalData.hrdcatControlcurrentRig.hasPAGain       := False;
     globalData.hrdcatControlcurrentRig.hasTX           := False;
     globalData.hrdcatControlcurrentRig.hasSMeter       := False;
     globalData.hrdcatControlcurrentRig.hasAutoTune     := False;
     globalData.hrdcatControlcurrentRig.hasAutoTuneDo   := False;
     globalData.hrdcatControlcurrentRig.afgControl      := '';
     globalData.hrdcatControlcurrentRig.rfgControl      := '';
     globalData.hrdcatControlcurrentRig.micgControl     := '';
     globalData.hrdcatControlcurrentRig.pagControl      := '';
     globalData.hrdcatControlcurrentRig.txControl       := '';
     globalData.hrdcatControlcurrentRig.smeterControl   := '';
     globalData.hrdcatControlcurrentRig.autotuneControl := '';
     globalData.hrdcatControlcurrentRig.radioName       := '';
     globalData.hrdcatControlcurrentRig.radioContext    := '';

     if globalData.hrdVersion=4  Then
     Begin
          // Using HRD Version 4 support.
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if not hrdon then hrdon := hrdinterface4.HRDInterfaceConnect(globalData.hrdcatControlcurrentRig.hrdAddress, globalData.hrdcatControlcurrentRig.hrdPort);
          if hrdon then
          begin
               globalData.hrdcatControlcurrentRig.hrdAlive := True;

               hrdresult := '';

               hrdmsg := 'Get Radio';
               hrdresult := hrdinterface4.HRDInterfaceSendMessage(hrdmsg);
               globalData.hrdcatControlcurrentRig.radioName := hrdresult;
               hrdinterface4.HRDInterfaceFreeString(hrdresult);

               hrdmsg := 'Get Context';
               hrdresult := hrdinterface4.HRDInterfaceSendMessage(hrdmsg);
               globalData.hrdcatControlcurrentRig.radioContext := hrdresult;
               hrdinterface4.HRDInterfaceFreeString(hrdresult);

               // This retrieves the buttons available of interest
               hrdmsg := '[' + globalData.hrdcatControlcurrentRig.radioContext + '] get buttons';
               hrdresult := hrdinterface4.HRDInterfaceSendMessage(hrdmsg);
               wcount := WordCount(hrdresult,hrdDelim);
               if wcount > 0 Then
               Begin
                    for ifoo := 1 to wcount do
                    begin
                         foo := ExtractWord(ifoo,hrdresult,hrdDelim);
                         if foo = 'TX' then globalData.hrdcatControlcurrentRig.hasTX := True;
                         if foo = 'ATU' then globalData.hrdcatControlcurrentRig.hasAutoTune := True;
                         if foo = 'TUNE' then globalData.hrdcatControlcurrentRig.hasAutoTuneDo := True;

                    end;
               end
               else
               begin
                    globalData.hrdcatControlcurrentRig.hasTX := False;
                    globalData.hrdcatControlcurrentRig.hasAutoTune := False;
                    globalData.hrdcatControlcurrentRig.hasAutoTuneDo := False;
               end;

               hrdinterface4.HRDInterfaceFreeString(hrdresult);

               if globalData.hrdcatControlcurrentRig.hasTX then globalData.hrdcatControlcurrentRig.txControl := 'TX' else globalData.hrdcatControlcurrentRig.txControl := '';
               if globalData.hrdcatControlcurrentRig.hasAutoTune then globalData.hrdcatControlcurrentRig.autotuneControl := 'ATU' else globalData.hrdcatControlcurrentRig.autotuneControl := '';
               if globalData.hrdcatControlcurrentRig.hasAutoTune then globalData.hrdcatControlcurrentRig.autotuneControlDo := 'Tune' else globalData.hrdcatControlcurrentRig.autotuneControlDo := '';

               globalData.hrdcatControlcurrentRig.hasSMeter := False;

          end
          else
          begin
               globalData.hrdcatControlcurrentRig.hrdAlive        := False;
               globalData.hrdcatControlcurrentRig.hasAFGain       := False;
               globalData.hrdcatControlcurrentRig.hasRFGain       := False;
               globalData.hrdcatControlcurrentRig.hasMicGain      := False;
               globalData.hrdcatControlcurrentRig.hasPAGain       := False;
               globalData.hrdcatControlcurrentRig.hasTX           := False;
               globalData.hrdcatControlcurrentRig.hasSMeter       := False;
               globalData.hrdcatControlcurrentRig.hasAutoTune     := False;
               globalData.hrdcatControlcurrentRig.hasAutoTuneDo   := False;
               globalData.hrdcatControlcurrentRig.afgControl      := '';
               globalData.hrdcatControlcurrentRig.rfgControl      := '';
               globalData.hrdcatControlcurrentRig.micgControl     := '';
               globalData.hrdcatControlcurrentRig.pagControl      := '';
               globalData.hrdcatControlcurrentRig.txControl       := '';
               globalData.hrdcatControlcurrentRig.smeterControl   := '';
               globalData.hrdcatControlcurrentRig.autotuneControl := '';
               globalData.hrdcatControlcurrentRig.radioName       := '';
               globalData.hrdcatControlcurrentRig.radioContext    := '';
          end;
     end
     else
     begin
          // Using HRD Version 5 support.
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if not hrdon then hrdon := hrdinterface5.HRDInterfaceConnect(globalData.hrdcatControlcurrentRig.hrdAddress, globalData.hrdcatControlcurrentRig.hrdPort);
          if hrdon then
          begin
               globalData.hrdcatControlcurrentRig.hrdAlive := True;

               hrdresult := '';

               hrdmsg := 'Get Radio';
               hrdresult := hrdinterface5.HRDInterfaceSendMessage(hrdmsg);
               globalData.hrdcatControlcurrentRig.radioName := hrdresult;
               hrdinterface5.HRDInterfaceFreeString(hrdresult);

               hrdmsg := 'Get Context';
               hrdresult := hrdinterface5.HRDInterfaceSendMessage(hrdmsg);
               globalData.hrdcatControlcurrentRig.radioContext := hrdresult;
               hrdinterface5.HRDInterfaceFreeString(hrdresult);

               // This retrieves the buttons available of interest
               hrdmsg := '[' + globalData.hrdcatControlcurrentRig.radioContext + '] get buttons';
               hrdresult := hrdinterface5.HRDInterfaceSendMessage(hrdmsg);
               wcount := WordCount(hrdresult,hrdDelim);
               if wcount > 0 Then
               Begin
                    for ifoo := 1 to wcount do
                    begin
                         foo := ExtractWord(ifoo,hrdresult,hrdDelim);
                         if foo = 'TX' then globalData.hrdcatControlcurrentRig.hasTX := True;
                         if foo = 'ATU' then globalData.hrdcatControlcurrentRig.hasAutoTune := True;
                         if foo = 'TUNE' then globalData.hrdcatControlcurrentRig.hasAutoTuneDo := True;

                    end;
               end
               else
               begin
                    globalData.hrdcatControlcurrentRig.hasTX := False;
                    globalData.hrdcatControlcurrentRig.hasAutoTune := False;
                    globalData.hrdcatControlcurrentRig.hasAutoTuneDo := False;
               end;

               hrdinterface5.HRDInterfaceFreeString(hrdresult);

               if globalData.hrdcatControlcurrentRig.hasTX then globalData.hrdcatControlcurrentRig.txControl := 'TX' else globalData.hrdcatControlcurrentRig.txControl := '';
               if globalData.hrdcatControlcurrentRig.hasAutoTune then globalData.hrdcatControlcurrentRig.autotuneControl := 'ATU' else globalData.hrdcatControlcurrentRig.autotuneControl := '';
               if globalData.hrdcatControlcurrentRig.hasAutoTune then globalData.hrdcatControlcurrentRig.autotuneControlDo := 'Tune' else globalData.hrdcatControlcurrentRig.autotuneControlDo := '';
               globalData.hrdcatControlcurrentRig.hasSMeter := False;
          end
          else
          begin
               globalData.hrdcatControlcurrentRig.hrdAlive        := False;
               globalData.hrdcatControlcurrentRig.hasAFGain       := False;
               globalData.hrdcatControlcurrentRig.hasRFGain       := False;
               globalData.hrdcatControlcurrentRig.hasMicGain      := False;
               globalData.hrdcatControlcurrentRig.hasPAGain       := False;
               globalData.hrdcatControlcurrentRig.hasTX           := False;
               globalData.hrdcatControlcurrentRig.hasSMeter       := False;
               globalData.hrdcatControlcurrentRig.hasAutoTune     := False;
               globalData.hrdcatControlcurrentRig.hasAutoTuneDo   := False;
               globalData.hrdcatControlcurrentRig.afgControl      := '';
               globalData.hrdcatControlcurrentRig.rfgControl      := '';
               globalData.hrdcatControlcurrentRig.micgControl     := '';
               globalData.hrdcatControlcurrentRig.pagControl      := '';
               globalData.hrdcatControlcurrentRig.txControl       := '';
               globalData.hrdcatControlcurrentRig.smeterControl   := '';
               globalData.hrdcatControlcurrentRig.autotuneControl := '';
               globalData.hrdcatControlcurrentRig.radioName       := '';
               globalData.hrdcatControlcurrentRig.radioContext    := '';
          end;
     end;
end;

function writeHRD(_para1:WideString): Boolean;
Var
   hrdresult          : PWIDECHAR;
   hrdon              : Boolean;
Begin
     Result := False;
     hrdon := False;
     if globalData.hrdVersion=4 Then
     Begin
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if not hrdon then hrdRigCAPS();
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if hrdon then
          begin
               hrdresult := hrdinterface4.HRDInterfaceSendMessage(_para1);
               if hrdresult='OK' Then Result := True else Result := False;
               hrdinterface4.HRDInterfaceFreeString(hrdresult);
          end
          else
          begin
               Result := False;
          end;
     end
     else
     begin
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if not hrdon then hrdRigCAPS();
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if hrdon then
          begin
               hrdresult := hrdinterface5.HRDInterfaceSendMessage(_para1);
               if hrdresult='OK' Then Result := True else Result := False;
               hrdinterface5.HRDInterfaceFreeString(hrdresult);
          end
          else
          begin
               Result := False;
          end;
     end;
end;

function readHRDQRG(): String;
Var
   hrdresult          : PWIDECHAR;
   hrdmsg             : WideString;
   hrdon              : Boolean;
Begin
     hrdon := False;
     if globalData.hrdVersion=4 Then
     Begin
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if not hrdon then hrdRigCAPS();
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if hrdon then
          begin
               hrdresult := '';
               hrdmsg := 'Get Frequency';
               hrdresult := hrdinterface4.HRDInterfaceSendMessage(hrdmsg);
               Result := String(hrdresult);
               hrdinterface4.HRDInterfaceFreeString(hrdresult);
          end
          else
          begin
               Result := '0';
          end;
     end
     else
     begin
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if not hrdon then hrdRigCAPS();
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if hrdon then
          begin
               hrdresult := '';
               hrdmsg := 'Get Frequency';
               hrdresult := hrdinterface5.HRDInterfaceSendMessage(hrdmsg);
               Result := String(hrdresult);
               hrdinterface5.HRDInterfaceFreeString(hrdresult);
          end
          else
          begin
               Result := '0';
          end;
     end;
End;

function readHRD(_para1:WideString): WideString;
Var
   hrdresult          : PWIDECHAR;
   hrdon              : Boolean;
   foo                : WideString;
Begin
     hrdon := False;
     if globalData.hrdVersion=4 Then
     Begin
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if not hrdon then hrdRigCAPS();
          hrdon := hrdinterface4.HRDInterfaceIsConnected();
          if hrdon then
          begin
               hrdresult := hrdinterface4.HRDInterfaceSendMessage(_para1);
               foo := hrdresult;
               hrdinterface4.HRDInterfaceFreeString(hrdresult);
               result := foo;
          end
          else
          begin
               Result := 'NAK';
          end;
     end
     else
     begin
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if not hrdon then hrdRigCAPS();
          hrdon := hrdinterface5.HRDInterfaceIsConnected();
          if hrdon then
          begin
               hrdresult := hrdinterface5.HRDInterfaceSendMessage(_para1);
               foo := hrdresult;
               hrdinterface5.HRDInterfaceFreeString(hrdresult);
               result := foo;
          end
          else
          begin
               Result := 'NAK';
          end;
     end;
End;

function readDXLabs(): String;
Var
   catProc  : TProcess;
   inStrs   : TStringList;
Begin
     catProc := TProcess.Create(nil);
     Try
        inStrs := TStringList.Create;
        catProc.CommandLine := 'hamlib\rig_dde\commander_dde1';
        catProc.Options := catProc.Options + [poWaitOnExit];
        catProc.Options := catProc.Options + [poNoConsole];
        catProc.Options := catProc.Options + [poUsePipes];
        catProc.Execute;
        inStrs.LoadFromStream(catProc.Output);
        // Commander returns string for QRG like:
        // 28,076.30 or 1,836.00 for locales with thousands = , and decimal = .
        // 28.076,30 or 1.836,00 for locales with thousands = . and decimal = ,
        Result := inStrs.Strings[0];
        inStrs.Free;
     Except
        Result := '0';
     end;
     catProc.Destroy;
End;

function readOmni(rig : Integer) : String;
Var
   ostat   : omniRec;
   fQRG    : TextFile;
   catProc : TProcess;
Begin
     catProc := TProcess.Create(nil);
     catProc.CommandLine := 'hamlib\omnicontrol';
     catProc.Options := catProc.Options + [poWaitOnExit];
     catProc.Options := catProc.Options + [poNoConsole];
     catProc.Execute;
     If fileExists('omniqrg.txt') Then
     Begin
          assignFile(fQRG,'omniqrg.txt');
          reset(fQRG);
          readLn(fQRG,ostat.r1stat);
          readLn(fQRG,ostat.r1model);
          readLn(fQRG,ostat.r1freqA);
          readLn(fQRG,ostat.r1freqB);
          readLn(fQRG,ostat.r1freq);
          readLn(fQRG,ostat.r2stat);
          readLn(fQRG,ostat.r2model);
          readLn(fQRG,ostat.r2freqA);
          readLn(fQRG,ostat.r2freqB);
          readLn(fQRG,ostat.r2freq);
          closeFile(fQRG);
          if FileExists('omniqrg.txt') Then DeleteFile('omniqrg.txt');
          If (rig=1) And (ostat.r1stat='1-Online') Then Result := ostat.r1freq;
          If (rig=2) And (ostat.r2stat='2-Online') Then Result := ostat.r2freq;
     End
     Else
     Begin
          Result := '0';
     End;
     catProc.Destroy;
End;
end.

