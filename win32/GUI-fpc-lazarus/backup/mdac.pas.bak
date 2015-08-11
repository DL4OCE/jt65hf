unit mdac;
//
// Copyright (c) 2008,2009 J C Large - W6CQZ
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
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PortAudio, globalData, DateUtils, CTypes;

function dacCallback(input: Pointer; output: Pointer; frameCount: Longword;
                       timeInfo: PPaStreamCallbackTimeInfo;
                       statusFlags: TPaStreamCallbackFlags;
                       inputDevice: Pointer): Integer; cdecl;

Var
   d65txBuffer    : Packed Array[0..661503] of CTypes.cint16;
   d65txBufferPtr : ^CTypes.cint16;
   d65txBufferIdx : Integer;
   dacE, dacT     : LongInt;
   dacErate       : Double;
   dacEavg        : Double;
   dacErr         : CTypes.cdouble;
   dacTimeStamp   : Integer;
   dacLTimeStamp  : Integer;
   dacSTimeStamp  : TTimeStamp;

implementation

function dacCallback(input: Pointer; output: Pointer; frameCount: Longword;
                     timeInfo: PPaStreamCallbackTimeInfo;
                     statusFlags: TPaStreamCallbackFlags;
                     inputDevice: Pointer): Integer; cdecl;
Var
   i             : Integer;
   optr          : ^smallint;
Begin
     // Set DAC entry timestamp
     dacSTimeStamp := DateTimeToTimeStamp(Now);
     if dacT = 0 Then
     Begin
          dacE := 0;
          dacErr := 0;
          dacErate := 0;
          dacEavg := 0;
          dacLTimeStamp := dacSTimeStamp.Time;
          dacTimeStamp  := dacSTimeStamp.Time;
     End
     Else
     Begin
          dacTimeStamp := dacSTimeStamp.Time;
          if dacTimeStamp > dacLTimeStamp Then
          Begin
               dacE := dacE+(dacTimeStamp - dacLTimeStamp);
               dacLTimeStamp := dacTimeStamp;
          End
          Else
          Begin
               dacT := -1;
          End;
     End;
     if dacT > 0 Then dacErr := dacE / dacT;
     dacErate := 185.75963718820861678004535147392/dacErr;
     inc(dacT);
     if dacT > 100000 Then dacT := 0;
     optr := output;
     if globalData.txInProgress Then
     Begin
          for i := 0 to frameCount-1 do
          Begin
               optr^ := d65txBuffer[d65txBufferIdx+i];
               inc(optr);
          End;
          d65txBufferPtr := d65txBufferPtr+frameCount;
          d65txBufferIdx := d65txBufferIdx+frameCount;
     End
     Else
     Begin
          for i := 0 to frameCount-1 do
          Begin
               optr^ := 0;
               inc(optr);
          End;
     End;
     result := paContinue;
End;
end.

