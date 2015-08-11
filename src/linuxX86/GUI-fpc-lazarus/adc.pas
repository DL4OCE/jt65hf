unit adc;
//
// Copyright (c) 2008,2009,2010,2011 J C Large - W6CQZ
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
  Classes, SysUtils, PortAudio, globalData, spectrum, math, CTypes;

  function adcCallback(input: Pointer; output: Pointer; frameCount: Longword;
                       timeInfo: PPaStreamCallbackTimeInfo;
                       statusFlags: TPaStreamCallbackFlags;
                       inputDevice: Pointer): Integer; cdecl;

Var
   d65rxBuffer     : Packed Array[0..661503] of CTypes.cint16;   // This is slightly more than 60*11025 to make it evenly divided by 2048
   d65rxBufferPtr  : ^CTypes.cint16;
   d65rxBufferIdx  : Integer;
   adcChan         : Integer;  // 1 = Left, 2 = Right
   adcSpecCount    : Integer;
   adcErr          : CTypes.cdouble;
   adcRunning      : Boolean;
   adcLDgain       : Integer;
   adcRDgain       : Integer;
   specLevel1      : Integer;
   specLevel2      : Integer;
   adcECount       : Integer;
   specDataBuffer  : Packed Array[0..4095] Of CTypes.cint16;
   specDataBuffer1 : Packed Array[0..2047] Of smallint;
   specDataBuffer2 : Packed Array[0..2047] Of smallint;

implementation

function adcCallback(input: Pointer; output: Pointer; frameCount: Longword;
                       timeInfo: PPaStreamCallbackTimeInfo;
                       statusFlags: TPaStreamCallbackFlags;
                       inputDevice: Pointer): Integer; cdecl;
Var
   i               : Integer;
   inptr           : ^smallint;
   tempInt1        : smallint;
   tempInt2        : smallint;
   localIdx        : Integer;
Begin
     // Set ADC entry timestamp
     if adcRunning Then inc(adcECount);
     adcRunning := True;
     // Move paAudio Buffer to d65rxBuffer (d65rxBufferIdx ranges 0..661503)
     inptr := input;
     If d65rxBufferIdx > 661503 Then d65rxBufferIdx := 0;
     localIdx := d65rxBufferIdx;
     // Now I need to copy the frames to real rx buffer
     if not globalData.txInProgress Then
     Begin
          For i := 1 to frameCount do
          Begin
               tempInt1 := inptr^;  // inptr is a pointer ^ indicates read value at pointer address NOT the pointer's value. :)
               specDataBuffer1[i-1] := min(32766,max(-32766,tempInt1));
               inc(inptr);

               tempInt2 := inptr^;
               specDataBuffer2[i-1] := min(32766,max(-32766,tempInt2));
               inc(inptr);

               if localIdx < 661504 Then
               Begin
                    if adcChan = 1 Then d65rxBuffer[localIdx] := min(32766,max(-32766,tempInt1));
                    if adcChan = 2 Then d65rxBuffer[localIdx] := min(32766,max(-32766,tempInt2));
               End
               Else
               Begin
                    localIdx := 0;
                    d65rxBufferIdx := 0;
                    if adcChan = 1 Then d65rxBuffer[localIdx] := min(32766,max(-32766,tempInt1));
                    if adcChan = 2 Then d65rxBuffer[localIdx] := min(32766,max(-32766,tempInt2));
               End;
               inc(d65rxBufferIdx);
               if d65rxBufferIdx > 661503 Then d65rxBufferIdx := 0;
               localIdx := d65rxBufferIdx;
          End;
          // Compute audio levels
          If not globalData.audioComputing and not globalData.spectrumComputing65 Then specLevel1 := spectrum.computeAudio(specDataBuffer1);  // Chan 1 (Left)
          If not globalData.audioComputing and not globalData.spectrumComputing65 Then specLevel2 := spectrum.computeAudio(specDataBuffer2);  // Chan 2 (Right)
          // Spectrum generation handler.
          If adcSpecCount = 0 Then
          Begin
               // Copy proper 2K buffer to first half of 4K spectrum buffer
               inc(adcSpecCount);
               for i := 0 to 2047 do
               Begin
                    if adcChan = 1 Then specDataBuffer[i] := specDataBuffer1[i] else specDataBuffer[i] := specDataBuffer2[i];
               End;
          End
          Else
          Begin
               // Copy proper 2K buffer to second half of 4K spectrum buffer
               adcSpecCount := 0;
               for i := 0 to 2047 do
               Begin
                    if adcChan = 1 Then specDataBuffer[i+2048] := specDataBuffer1[i] else specDataBuffer[i+2048] := specDataBuffer2[i];
               End;
               // Also need to generate the spectrum
               if not globalData.spectrumComputing65 then spectrum.computeSpectrum(specDataBuffer);
          End;
     End;
     result := paContinue;
     adcRunning := False;
End;
end.
