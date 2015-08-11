unit PSKReporter;
{$PACKRECORDS C}    (* GCC/Visual C/C++ compatible record packing *)
{$MODE DELPHI }

interface

  Uses Windows;

const
  REPORTER_SOURCE_MASK = $07;
  REPORTER_SOURCE_AUTOMATIC = $01;
  REPORTER_SOURCE_LOG = $02;
  REPORTER_SOURCE_MANUAL = $03;
  REPORTER_SOURCE_TENTATIVE = $40;
  REPORTER_SOURCE_TEST = $80;

  PSKR_DLL = 'PSKReporter.dll';

type
  REPORTER_STATISTICS  = record
    hostname: array[0..256-1] of WideChar;
    port: array[0..32-1] of WideChar;
    connected : Bool;
    callsigns_sent : Word;
    callsigns_buffered : Word;
    callsigns_discarded : Word;
    last_send_time : Word;
    next_send_time : Word;
    last_callsign_queued: array[0..24-1] of WideChar;
    bytes_sent : Word;
    bytes_sent_total : Word;
    packets_sent : Word;
    packets_sent_total : Word;
  end;  //REPORTER_STATISTICS

  function ReporterInitialize (const hostname: WideString;
                               const port: WideString): DWORD;  cdecl; external PSKR_DLL;

  function ReporterSeenCallsign (const remoteInformation: WideString;
                                 const localInformation: WideString;
                                 flags: DWORD): DWORD cdecl; external PSKR_DLL;
                                 
  function ReporterTickle : DWORD cdecl; external PSKR_DLL;

  function ReporterGetInformation (var buffer: WideString;
                                   maxlen: DWORD): DWORD cdecl; external PSKR_DLL;

  function ReporterGetStatistics (var buffer: REPORTER_STATISTICS;
                                  maxlen: DWORD): DWORD cdecl; external PSKR_DLL;

  function ReporterUninitialize : DWORD; cdecl; external PSKR_DLL;

  function ReporterInitializeSTD (const hostname: PChar;
                                  const port: PChar): DWORD stdcall; external PSKR_DLL;

  function ReporterSeenCallsignSTD (const remoteInformation: PChar;
                                    const localInformation: PChar;
                                    flags: DWORD): DWORD stdcall; external PSKR_DLL;

  function ReporterTickleSTD : DWORD stdcall;  external PSKR_DLL;

  function ReporterGetInformationSTD (buffer: PChar;
                                      maxlen: DWORD): DWORD stdcall; external PSKR_DLL;

  function ReporterGetStatisticsSTD (var buffer: REPORTER_STATISTICS;
                                     maxlen: DWORD): DWORD stdcall; external PSKR_DLL;

  function ReporterUninitializeSTD : DWORD;  stdcall; external PSKR_DLL;

implementation
end.
