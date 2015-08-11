unit hrdinterface4;
{$PACKRECORDS C}

interface

  const
     HRD_DLL = 'HRDInterface0014.dll';

  function  HRDInterfaceConnect(_para1:WideString; _para2:WORD):BOOLEAN;cdecl;external HRD_DLL;
  function  HRDInterfaceGetLastCode():DWORD;cdecl;external HRD_DLL;
  function  HRDInterfaceGetLastError():PWIDECHAR;cdecl;external HRD_DLL;
  function  HRDInterfaceIsConnected():BOOLEAN;cdecl;external HRD_DLL;
  function  HRDInterfaceSendMessage(_para1:WideString):PWIDECHAR;cdecl;external HRD_DLL;
  procedure HRDInterfaceDisconnect();cdecl;external HRD_DLL;
  procedure HRDInterfaceFreeString(_para1:PWIDECHAR);cdecl;external HRD_DLL;
  procedure HRDInterfaceTracing(_para1:BOOLEAN);cdecl;external HRD_DLL;

implementation
end.

