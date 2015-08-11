program omnicontrol;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, CustApp, variants, comobj;

//Const ST_NOTCONFIGURED = '0';
//Const ST_DISABLED = '1';
//Const ST_PORTBUSY = '2';
//Const ST_NOTRESPONDING = '3';
Const ST_ONLINE = '4';
type

  { OmniControl }

  Omni = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

{ OmniControl }

procedure Omni.DoRun;
var
  foo           : String;
  OmniRigEngine : Variant;
  omniFile      : TextFile;
begin
     assignFile(omniFile,'omniqrg.txt.');
     rewrite(omniFile);
     Try
        OmniRigEngine := CreateOleObject('OmniRig.OmniRigX');
        Try
           foo := '';
           foo := OmniRigEngine.Rig1.Status;
           If foo <> ST_ONLINE Then
           Begin
                writeLn(omniFile,'1-Offline');
                writeLn(omniFile,'None');
                writeLn(omniFile,'0');
                writeLn(omniFile,'0');
                writeLn(omniFile,'0');
           End
           Else
           Begin
                writeLn(omniFile,'1-Online');
                writeLn(omniFile,OmniRigEngine.Rig1.RigType);
                writeLn(omniFile,OmniRigEngine.Rig1.FreqA);
                writeLn(omniFile,OmniRigEngine.Rig1.FreqB);
                writeLn(omniFile,OmniRigEngine.Rig1.Freq);
           End;
        Except
           writeLn('Exception in reading object');
        End;
        Try
           foo := '';
           foo := OmniRigEngine.Rig2.Status;
           If foo <> ST_ONLINE Then
           Begin
                writeLn(omniFile,'2-Offline');
                writeLn(omniFile,'None');
                writeLn(omniFile,'0');
                writeLn(omniFile,'0');
                writeLn(omniFile,'0');
           End
           Else
           Begin
                writeLn(omniFile,'2-Online');
                writeLn(omniFile,OmniRigEngine.Rig2.RigType);
                writeLn(omniFile,OmniRigEngine.Rig2.FreqA);
                writeLn(omniFile,OmniRigEngine.Rig2.FreqB);
                writeLn(omniFile,OmniRigEngine.Rig2.Freq);
           End;
        Except
           writeLn('Exception in reading object');
        End;
     Except
        writeLn('Exception in creation of object');
     End;
     //Try
        //FreeAndNil(OmniRigEngine);
     //Except
        //writeLn('Exception in destruction of object');
     //End;
     // stop program loop
     closeFile(omniFile);
     Terminate;
end;

constructor Omni.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor Omni.Destroy;
begin
  inherited Destroy;
end;

var
  Application: Omni;

{$IFDEF WINDOWS}{$R omnicontrol.rc}{$ENDIF}

begin
  Application:=Omni.Create(nil);
  Application.Title:='omnicontrol';
  Application.Run;
  Application.Free;
end.

