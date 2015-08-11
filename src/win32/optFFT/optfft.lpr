program optfft;
//
// Copyright (c) 2009,2010 J C Large - W6CQZ
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
{$PACKRECORDS C}    (* GCC/Visual C/C++ compatible record packing *)
{$MODE DELPHI }

uses
  Classes, SysUtils, CustApp, CTypes, Math, Process;

Const
  JT_DLL = 'jt65.dll';

type

  { TOptFFT }

  TOptFFT = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TOptFFT }
var
  sampfile                : File of CTypes.cint16;
  loBound, hiBound, cf, i : Integer;
  d65rxBuffer             : Packed Array[0..661503] of CTypes.cint16;
  d65inProcBuffer         : Packed Array[0..661503] of CTypes.cint16;
  lrxBuffer               : Packed Array[0..661503] of CTypes.cint16;
  d65Fbuffer1             : Packed Array[0..661503] of CTypes.cfloat;
  d65inProgress           : Boolean;
  d65Nseg                 : CTypes.cint;
  d65samfacin             : CTypes.cdouble;
  d65Nafc                 : CTypes.cint;
  d65Nzap                 : CTypes.cint;
  d65lowCF                : Integer;
  d65stepBW               : Integer;
  d65steps                : Integer;

procedure wsjt1(d : Pointer; jz0 : Pointer; istart : Pointer; MyCall : Pointer;
                Nseg : Pointer; MouseDF : Pointer; DFTolerance : Pointer;
                doshdec : Pointer; samfacin : Pointer; Nafc : Pointer;
                Nzap : Pointer; LDecoded : Pointer; nspecial : Pointer;
                ndf : Pointer; myline : Pointer; nsync : Pointer;
                ical : Pointer; wisfile : Pointer; kvfile : Pointer); cdecl;
                external JT_DLL name 'wsjt1_';

procedure doDecode();
Var
   istart, i, lp               : CTypes.cint;
   MyCall, myline, wisfile     : PChar;
   kvfile                      : PChar;
   jz, nspecial, ndf, nave     : CTypes.cint;
   inProcJz, inProcDecoderBw   : CTypes.cint;
   LDecoded                    : CTypes.cbool;
   inProcCF, nsync             : Integer;
   inProcSteps, inProcStepSize : Integer;
   sum, ave                    : CTypes.cfloat;
   doshdec, ical               : CTypes.cint;
   bStart, bEnd                : Integer;
   foo, kvdata                : String;
begin
     bStart := 0;
     bEnd   := 533504;
     //
     // ical =  0 = FFTW_ESTIMATE set, no load/no save wisdom.
     //
     // ical =  1 = FFTW_MEASURE set, yes load/no save wisdom.
     // ical = 11 = FFTW_MEASURE set, no load/no save wisdom.
     // ical = 21 = FFTW_MEASURE set, no load/yes save wisdom.
     //
     // Use ical =  1 to load saved wisdom.
     // Use ical = 11 when wisdom has been loaded and does not need saving.
     // Use ical = 21 to save wisdom.
     // Use ical = 0 for default WSJT implementation of four2a (No wisdom used).
     //
     ical := 21;
     // I need to copy rxBuffer to inProcBuffer so I can release rxBuffer back
     // to main thread for its next use.  If I don't copy it I may see it
     // changed before the decoder can finish its use of it.
     inProcJz := bStart;
     while inProcJz < bEnd do
     Begin
          d65inProcBuffer[inProcJz] := d65rxBuffer[inProcJz];
          inc(inProcJz);
     End;
     // rxBuffer now preserved in inProcBuffer so it's safe to let rxBuffer be
     // modified by an RX sequence in main thread.
     inProcJz := bEnd+1;
     istart := 1;
     MyCall := StrAlloc(12);
     myline := StrAlloc(43);
     wisfile := StrAlloc(Length(GetAppConfigDir(False)+'wisdom2.dat')+1);
     kvfile := StrAlloc(Length('kvasd.dat')+1);
     foo := '';
     // Set path to wisdom file
     foo := GetAppConfigDir(False)+'wisdom2.dat';
     StrPCopy(wisfile,foo);
     // Set path for kvasd.dat
     foo := 'kvasd.dat';
     StrPCopy(kvfile,foo);
     myline := '                                           ';
     LDecoded := False;
     nspecial := 0;
     ndf := 0;
     doshdec := 0;
     kvdata := 'KVASD.DAT';
     // inProcCF is the decoder center frequency which will be incremented by
     // inProcStepSize each pass through the multi-decoder loop.  It need to
     // intially be set to the low end of the overall decoder bandwidth which
     // is inProcBW.
     inProcCF := d65lowCF;
     inProcDecoderBW := d65stepBW;
     inProcStepSize := d65stepBW;
     inProcSteps := d65steps;
     // Convert inProcBuffer to d65Fbuffer
     sum := 0.0;
     nave := 0;
     for lp := bStart to bEnd do
     Begin
          sum := sum + d65inProcBuffer[lp];
     End;
     nave := Round(sum/bEnd);
     if nave <> 0 Then
     Begin
          for lp := bStart to bEnd do
          Begin
               lrxBuffer[lp] := d65inProcBuffer[lp]-nave;
          End;
     End
     Else
     Begin
          for lp := bStart to bEnd do
          Begin
               lrxBuffer[lp] := d65inProcBuffer[lp];
          End;
     End;
     sum := 0.0;
     ave := 0.0;
     for lp := bStart to bEnd do
     Begin
          d65Fbuffer1[lp] := 0.1 * lrxBuffer[lp];
          sum := sum + d65Fbuffer1[lp];
     End;
     ave := sum/bEnd;
     if ave <> 0.0 Then
     Begin
          for lp := bStart to bEnd do
          Begin
               d65Fbuffer1[lp] := d65Fbuffer1[lp]-ave;
          End;
     End;
     i := 0;
     WriteLn('Decoder will process ' + IntToStr(inProcSteps) + ' steps...');
     while i < inProcSteps do
     begin
          writeLn('Processing step ' + IntToStr(i+1));
          myline := '                                           ';
          LDecoded := False;
          jz := inProcJz;
          istart := 1;
          nspecial := 0;
          ndf := 0;
          nsync := 0;
          // doshdec = 0 = do sh decode, 1 = do not do sh decode.
          doshdec := 0;
          // Call decoder.
          wsjt1(@d65Fbuffer1[0], @jz, @istart, MyCall, @d65Nseg, @inProcCF,
                @inProcDecoderBW, @doshdec, @d65samfacin, @d65Nafc, @d65Nzap,
                @LDecoded, @nspecial, @ndf, myline, @nsync, @ical, wisfile,
                kvfile);
          //writeLn('BM Decode:  ' + myline);
          // Increment inProcCF
          inProcCF := inProcCF+inProcStepSize;
          inc(i);
          if FileExists(kvdata) Then DeleteFile(kvdata);
     end;
     if FileExists(kvdata) Then DeleteFile(kvdata);
End;

procedure TOptFFT.DoRun;
begin
  writeLn;
  writeLn;
  writeLn('This program calculates optimal FFT routines for JT65-HF.');
  writeLn;
  writeLn('Please note that this can take up to 20 minutes to complete on');
  writeLn('slower machines while it should take less than 10 minutes on most');
  writeLn('systems.  A typical value is 4 to 6 minutes on machines with a');
  writeLn('2GHz+ processor.');
  writeLn;
  writeLn('The program may seem to do nothing at first and will use 100% cpu');
  writeLn('time for most of its runtime.  This is normal.  Please be patient.');
  writeLn;
  writeLn;
  writeLn('Starting FFT optimizer...');
  writeLn();
  // This routine was borrowed from ultrastar deluxe, a game written in delphi/
  // free pascal and is GPL V2 code.  In the case of this routine it's copyright
  // belongs to its creator.  Routine defined in UCommon.pas in the ultrastar
  // source tree.
  (*
  // We will use SetExceptionMask() instead of Set8087CW()/SetSSECSR().
  // Note: Leave these lines for documentation purposes just in case
  //       SetExceptionMask() does not work anymore (due to bugs in FPC etc.).
  {$IF Defined(CPU386) or Defined(CPUI386) or Defined(CPUX86_64)}
  Set8087CW($133F);
  {$IFEND}
  {$IF Defined(FPC)}
  if (has_sse_support) then
    SetSSECSR($1F80);
  {$IFEND}
  *)
  // disable all of the six FPEs (x87 and SSE) to be compatible with C/C++ and
  // other libs which rely on the standard FPU behaviour (no div-by-zero FPE anymore).
  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide,
                    exOverflow, exUnderflow, exPrecision]);
  // Check for a previous run having left a partially computef FFT file...
  If FileExists(GetAppConfigDir(False)+'wisdom2.tmp') Then
  Begin
       writeLn('Found partially computed FFT data.  Deleting.');
       writeLn();
       DeleteFile(GetAppConfigDir(False)+'wisdom2.tmp');
  End;
  If FileExists(GetAppConfigDir(False)+'wisdom2.dat') Then
  Begin
       writeLn('Replacing previously computed FFT data.');
       writeLn();
       DeleteFile(GetAppConfigDir(False)+'wisdom2.dat');
  End;
  d65inProgress := False;
  // Read in sample sequence data
  AssignFile(sampfile, 'cal.dat');
  Reset(sampfile);
  i := 0;
  While not EOF(sampfile) Do
  Begin
       Read(sampfile,d65rxBuffer[i]);
       inc(i);
  End;
  CloseFile(sampfile);
  // Need to call the decoder with ical set to proper value.
  if not d65inProgress then
  Begin
       d65Nseg := 1;
       d65samfacin := 1.0;
       d65Nafc   := 1;
       d65Nzap   := 0;
       // Setup variables for multi decode pass.
       d65stepBW := 100;
       loBound := (0 - (1300 DIV 2))+ (100 DIV 2);
       hiBound := (0 + (1300 DIV 2))- (100 DIV 2);
       d65steps := 1;
       // Do midscale to low scale
       cf := 0;
       while cf > loBound do
       begin
            cf := cf - 100;
            inc(d65steps);
       end;
       d65lowCF := cf;
       // Do midscale to high scale
       cf := 0 + 100;
       while cf < hiBound do
       begin
            cf := cf + d65stepBW;
            inc(d65steps);
       end;
  End;
  WriteLn();
  WriteLn('Begin:  ', DateTimeToStr(Now));
  WriteLn();
  WriteLn();
  WriteLn('Calling decoder...');
  doDecode();
  WriteLn();
  WriteLn();
  WriteLn('Mock decoder session completed.');
  WriteLn();
  WriteLn('Optimum FFT computed and ready for JT65-HF.');
  WriteLn();
  WriteLn();
  WriteLn('  End:  ', DateTimeToStr(Now));
  WriteLn();
  // stop program loop
  Terminate;
end;

constructor TOptFFT.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TOptFFT.Destroy;
begin
  inherited Destroy;
end;

procedure TOptFFT.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: TOptFFT;
{$IFDEF WINDOWS}{$R optfft.rc}{$ENDIF}

begin
  Application:=TOptFFT.Create(nil);
  Application.Title:='Calculate Optimal FFT Parameters';
  Application.Run;
  Application.Free;
end.

