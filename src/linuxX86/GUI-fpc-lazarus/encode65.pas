unit encode65;
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
  Classes, SysUtils, StrUtils, CTypes;

Const
  {$IFDEF WIN32}
          JT_DLL = 'jt65.dll';
  {$ENDIF}
  {$IFDEF LINUX}
          JT_DLL = 'JT65';
  {$ENDIF}
  {$IFDEF DARWIN}
          JT_DLL = 'JT65';
  {$ENDIF}
  CsvDelim = [','];

procedure gen65(PMsg,
                PTxDF,
                PIwave,
                PNwave,
                PSendingsh,
                PMsgSent,
                PNmsg : Pointer
               ); cdecl; external JT_DLL name 'gen65_';

procedure  gen4(PMsg,
                PTxDF,
                PIwave,
                PNwave,
                PSendingsh,
                PMsgSent,
                PNmsg : Pointer
               ); cdecl; external JT_DLL name 'gen24_';

procedure genCW(PMsg,
                Pfreqcw,
                Piwave,
                Pnwave : Pointer
               ); cdecl; external JT_DLL name 'gencwid_';

procedure pfxBuild();

Var
   e65pfx    : Array[0..338] of String;
   e65sfx    : Array[0..11] of String;
   e65cwid   : Packed Array[0..110249] of CTypes.cint16;

implementation
  procedure pfxBuild();
  Var
    i, wcount : Integer;
    foo : AnsiString;

  Begin
    // Clear pfx/sfx arrays
    for i := 0 to 338 do
    Begin
      e65pfx[i] := '';
    End;
    for i := 0 to 11 do
    Begin
      e65sfx[i] := '';
    End;
    // Prefix list
    foo  := '';
    foo  := foo + '1A,1S,3A,3B6,3B8,3B9,3C,3C0,3D2,3D2C,3D2R,3DA,3V,3W,3X,3Y,3YB,3YP,4J,';
    foo  := foo + '4L,4S,4U1I,4U1U,4W,4X,5A,5B,5H,5N,5R,5T,5U,5V,5W,5X,5Z,6W,6Y,7O,7P,';
    foo  := foo + '7Q,7X,8P,8Q,8R,9A,9G,9H,9J,9K,9L,9M2,9M6,9N,9Q,9U,9V,9X,9Y,A2,A3,A4,';
    foo  := foo + 'A5,A6,A7,A9,AP,BS7,BV,BV9,BY,C2,C3,C5,C6,C9,CE,CE0X,CE0Y,CE0Z,CE9,CM,';
    foo  := foo + 'CN,CP,CT,CT3,CU,CX,CY0,CY9,D2,D4,D6,DL,DU,E3,E4,EA,EA6,EA8,EA9,EI,EK,';
    foo  := foo + 'EL,EP,ER,ES,ET,EU,EX,EY,EZ,F,FG,FH,FJ,FK,FKC,FM,FO,FOA,FOC,FOM,FP,FR,';
    foo  := foo + 'FRG,FRJ,FRT,FT5W,FT5X,FT5Z,FW,FY,M,MD,MI,MJ,MM,MU,MW,H4,H40,HA,HB,HB0,';
    foo  := foo + 'HC,HC8,HH,HI,HK,HK0A,HK0M,HL,HM,HP,HR,HS,HV,HZ,I,IS,IS0,J2,J3,J5,J6,J7,';
    foo  := foo + 'J8,JA,JDM,JDO,JT,JW,JX,JY,K,KG4,KH0,KH1,KH2,KH3,KH4,KH5,KH5K,KH6,KH7,';
    foo  := foo + 'KH8,KH9,KL,KP1,KP2,KP4,KP5,LA,LU,LX,LY,LZ,OA,OD,OE,OH,OH0,OJ0,OK,OM,ON,';
    foo  := foo + 'OX,OY,OZ,P2,P4,PA,PJ2,PJ7,PY,PY0F,PT0S,PY0T,PZ,R1F,R1M,S0,S2,S5,S7,S9,SM,';
    foo  := foo + 'SP,ST,SU,SV,SVA,SV5,SV9,T2,T30,T31,T32,T33,T5,T7,T8,T9,TA,TF,TG,TI,TI9,TJ,';
    foo  := foo + 'TK,TL,TN,TR,TT,TU,TY,TZ,UA,UA2,UA9,UK,UN,UR,V2,V3,V4,V5,V6,V7,V8,VE,VK,';
    foo  := foo + 'VK0H,VK0M,VK9C,VK9L,VK9M,VK9N,VK9W,VK9X,VP2E,VP2M,VP2V,VP5,VP6,VP6D,VP8,';
    foo  := foo + 'VP8G,VP8H,VP8O,VP8S,VP9,VQ9,VR,VU,VU4,VU7,XE,XF4,XT,XU,XW,XX9,XZ,YA,YB,YI,';
    foo  := foo + 'YJ,YK,YL,YN,YO,YS,YU,YV,YV0,Z2,Z3,ZA,ZB,ZC4,ZD7,ZD8,ZD9,ZF,ZK1N,ZK1S,ZK2,';
    foo  := foo + 'ZK3,ZL,ZL7,ZL8,ZL9,ZP,ZS,ZS8,KC4,E5';
    // Populate pfx array
    wcount := WordCount(foo,csvDelim);
    for i := 0 to wcount-1 do
    Begin
      e65pfx[i] := ExtractWord(i+1,foo,csvDelim);
    End;
    foo := '';
    foo := foo + 'P,0,1,2,3,4,5,6,7,8,9,A';
    wcount := WordCount(foo,csvDelim);
    for i := 0 to wcount-1 do
    begin
      e65sfx[i] := ExtractWord(i+1,foo,csvDelim);
    End;
  End;

end.
