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
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads, cmem,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, runtimetypeinfocontrols, maincode, portaudio, encode65, globalData,
  spectrum, cmaps, fftw_jl, adc, samplerate, dac, dlog, rawdec, cfgvtwo,
  guiConfig, verHolder, PSKReporter, catControl, synaser, logformat, log,
  logscan, diagout, waterfall, d65, hrdinterface5, hrdinterface4, about, spot,
  valobject, madc, mdac, statistic, progtest, libDL4OCE, motd, someprogressunit,
  waterfallunit;

{$R *.res}

begin
  Application.Title:='JT65-HF-Comfort-DL4OCE';
  //Original CQZ = JT65-HF
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(Twaterfallform, waterfallform);


  Application.Run;
end.

