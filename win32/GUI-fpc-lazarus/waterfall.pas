unit waterfall;
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
// Code based on example from Free Pascal - Lazarus Wiki.
//
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, LCLType, globalData, dlog;

type
  TWaterfallControl = class(TCustomControl)
  property
     onMouseDown;
  public
     procedure EraseBackground(DC: HDC); override;
     procedure Paint; override;
  end;

implementation

  procedure TWaterfallControl.EraseBackground(DC: HDC);
  begin
       // Uncomment next to enable default background erase
       //inherited EraseBackground(DC);
  end;

  procedure TWaterfallControl.Paint;
  var
     Bitmap : TBitmap;
  begin
     if globalData.specNewSpec65 Then
     Begin
          Bitmap := TBitmap.Create;
          Bitmap.Height := 180; //180
          Bitmap.Width  := 750;
          globalData.specMs65.Position := 0;
          Try
             Bitmap.LoadFromStream(globalData.specMs65);
             Canvas.Draw(0,0, Bitmap);
             inherited Paint;
             Bitmap.Free;
          Except
             // Do nothing for now...
             dlog.fileDebug('Exception raised in waterfall unit');
             inherited Paint;
             Bitmap.Free;
          End;
     End;
  end;
end.

