program jt65hf;
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

uses
  cthreads, Interfaces, Forms, maincode, portaudio, encode65,
  globalData, spectrum, cmaps, fftw_jl, adc, dac, cfgvtwo, guiConfig,
  verHolder, synaser, adif, log, waterfall, d65, about, spot, valobject;

{$R *.res}

begin
  writeln('');
  writeln('');
  writeln('JT65-HF Linux 1.0.9 DEBUG VERSION.  EXPIRES 31-November-2011.');
  writeln('');
  writeln('');
  Application.Title:='JT65-HF';
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
