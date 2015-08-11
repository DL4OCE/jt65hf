unit dac;
//
// Copyright (c) 2008,2009,2010, 2011 J C Large - W6CQZ
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
  Classes, SysUtils, PortAudio, globalData, CTypes;

function dacCallback(input: Pointer; output: Pointer; frameCount: Longword;
                       timeInfo: PPaStreamCallbackTimeInfo;
                       statusFlags: TPaStreamCallbackFlags;
                       inputDevice: Pointer): Integer; cdecl;

Var
   d65txBuffer    : Packed Array[0..661503] of CTypes.cint16;
   d65txBufferPtr : ^CTypes.cint16;
   d65txBufferIdx : Integer;

implementation

function dacCallback(input: Pointer; output: Pointer; frameCount: Longword;
                     timeInfo: PPaStreamCallbackTimeInfo;
                     statusFlags: TPaStreamCallbackFlags;
                     inputDevice: Pointer): Integer; cdecl;
Var
   i             : Integer;
   optr          : ^smallint;
Begin
     optr := output;
     if globalData.txInProgress Then
     Begin
          for i := 0 to frameCount-1 do
          Begin
               optr^ := d65txBuffer[d65txBufferIdx+i];
               inc(optr);
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
               optr^ := 0;
               inc(optr);
          End;
     End;
     result := paContinue;
End;
end.
