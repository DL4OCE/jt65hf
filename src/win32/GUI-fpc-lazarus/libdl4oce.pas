unit libDL4OCE;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, httpsend, LCLIntf, verHolder, Dialogs, Controls, math;

type
  LonLat = record
    Lon, Lat: Double;
  end;

function checkForUpdate(): Boolean;
function VersionGreater(version: String; web_version: String): Boolean;
function calcDistance(strMyGrid, strHisGrid: String): Double;
function calcBearing(strMyGrid, strHisGrid: String): Double;
function rad2deg(rad: float): float;
function deg2rad(deg: float): float;
procedure sendStats(callsign, version_string: String);
procedure GridToLonLat(strGrid: String; var LonLat: LonLat);

implementation

function VersionGreater(version: String; web_version: String): Boolean;
//var A1, A2, B1, B2, C1, C2, D1, D2,
var intVersion, intWebVersion: Integer;
  split_version, split_web_version: TStringList;
begin
  split_version:= TStringList.Create;
  split_web_version:= TStringList.Create;
  split_version.Delimiter:= '.';
  split_version.DelimitedText:= version;
  split_version.StrictDelimiter:= true;
  //ShowMessage(split_version[0]+split_version[1]+split_version[2]+split_version[3]);
  intVersion:= StrToInt(split_version[0])*10000000+StrToInt(split_version[1])*100000+StrToInt(split_version[2])*1000+StrToInt(split_version[3]);
  split_web_version.Delimiter:= '.';
  split_web_version.DelimitedText:= web_version;
  intWebVersion:= StrToInt(split_web_version[0])*10000000+StrToInt(split_web_version[1])*100000+StrToInt(split_web_version[2])*1000+StrToInt(split_web_version[3]);
  //ShowMessage(inttostr(intWebVersion)+chr(13)+inttostr(intVersion));
  Result:= (web_version>version);
  split_version.Free;
  split_web_version.Free;
end;

function deg2rad(deg: float): float;
begin
  Result:= deg*pi/180;
end;

function rad2deg(rad: float): float;
begin
  //Result:= rad * pi / 180.0;
end;

procedure GridToLonLat(strGrid: String; var LonLat: LonLat);
var flagError, ff: Boolean;
  x_l, x_m, x_r, y_l, y_m, y_r: Integer;
  x, y: double;
begin
  strGrid:= UpperCase(strGrid);
  flagError:= false;
  if (Length(strGrid)=4) then begin
    strGrid:= strGrid+'MM';
    ff:= false;
  end else ff:= true;
  if (Length(strGrid)=6) then begin
    x_l:= Ord(strGrid[1])-65;
    x_m:= StrToInt(Copy(strGrid,3,1));
    x_r:= Ord(strGrid[5])-65;
    y_l:= Ord(strGrid[2])-65;
    y_m:= StrToInt(Copy(strGrid,4,1));
    y_r:= Ord(strGrid[6])-65;
    //DEBUG:
    //ShowMessage(strGrid+chr(13)+IntToStr(x_l)+chr(13)+IntToStr(y_l)+chr(13)+IntToStr(x_m)+chr(13)+IntToStr(y_m)+chr(13)+IntToStr(x_r)+chr(13)+IntToStr(y_r));
    if not ((x_l<0) or (x_l>17) or (y_l<0) or (y_l>17) or (x_r<0) or (x_r>23) or (y_r<0) or (y_r>23)) then begin
       x:= x_l*10 + x_m + x_r/24;
       if ff then x:= x + 1/48;
       x:= x * 2;
       x:= x - 180;
       y:= y_l*10 + y_m + y_r/24;
       if ff then y:= y + 1/48;
       y:= y - 90;
       LonLat.Lon:= x;
       LonLat.Lat:= y;
    end else flagError:= true;
  end else flagError:= true;
end;

function calcDistance(strMyGrid, strHisGrid: String): Double;
var myNlat, myNlon, hisNlat, hisNlon: float;
  MyLonLat, HisLonLat: LonLat;
  distance: Double;
  intDistance: Integer;
begin
  GridToLonLat(strMyGrid, MyLonLat);
  GridToLonLat(strHisGrid, HisLonLat);
  // ToDo: locale settings: if set to miles
  // distance:= distance * 0.621371192;
  // Result:= FloatToStr(distance) + ' mi';
  //intDistance:= round(distance);
  Result:= 6378.137*(arccos((sin(deg2rad(HisLonLat.Lat)))*sin(deg2rad(MyLonLat.Lat))+cos(deg2rad(HisLonLat.Lat))*cos(deg2rad(MyLonLat.Lat))*cos(deg2rad(HisLonLat.Lon-MyLonLat.Lon))));
end;

function calcBearing(strMyGrid, strHisGrid: String): Double;
var
  MyLonLat, HisLonLat: LonLat;
  b, d, w: Double;
begin
  GridToLonLat(strMyGrid, MyLonLat);
  GridToLonLat(strHisGrid, HisLonLat);
  d:= calcDistance(strMyGrid, strHisGrid);
  //ShowMessage(FloatToStr(d));
  //ShowMessage(FloatToStr(MyLonLat.Lat)+chr(13)+FloatToStr(MyLonLat.Lon)+chr(13)+FloatToStr(HisLonLat.Lat)+chr(13)+FloatToStr(HisLonLat.Lon));
  if (sin(deg2rad(HisLonLat.Lon)-deg2rad(MyLonLat.Lon))<0) then begin
    //b:= arccos(  (sin(deg2rad(HisLonLat.Lat))-sin(deg2rad(MyLonLat.Lat))*cos(d))/(sin(d)*cos(deg2rad(MyLonLat.Lat))));
    //b:= (sin(deg2rad(HisLonLat.Lat))-sin(deg2rad(MyLonLat.Lat))*cos(d)) / (sin(d)*cos(deg2rad(MyLonLat.Lat)));
    //b = Math.acos((Math.sin(deg2rad(y2)) - Math.sin(deg2rad(y1)) * Math.cos(d)) / (Math.sin(d) * Math.cos(deg2rad(y1))));
    //ShowMessage(FloatToStr(deg2rad(HisLonLat.Lat))+', '+FloatToStr(deg2rad(MyLonLat.Lat))+', '+FloatToStr(d/6378.137));
    b:= arccos((sin(deg2rad(HisLonLat.Lat))-sin(deg2rad(MyLonLat.Lat))*cos(d/6378.137)) / (sin(d/6378.137)*cos(deg2rad(MyLonLat.Lat))));
    //ShowMessage('variant1: '+FloatToStr(b))
  end else begin
      {w = (Math.sin(deg2rad(y2)) - Math.sin(deg2rad(y1)) * Math.cos(d)) / (Math.sin(d) * Math.cos(deg2rad(y1)));
	if(w >  1.0) w = 1.0;
	if(w < -1.0) w = -1.0;
	b = 2 * Math.PI - Math.acos(w);
        }
    //ShowMessage('variant2');
    w:= (sin(deg2rad(HisLonLat.Lat))-sin(deg2rad(MyLonLat.Lat))*cos(d/6378.137))/(sin(d/6378.137)*cos(deg2rad(MyLonLat.Lat)));
    if (w>1) then w:=1;
    if (w<-1) then w:= -1;
    b:= 2*pi-arccos(w);
  end;
  result:= Round(360-(b*180/pi));
  //result:= FloatToStr(rad2deg(arccos((sin(MyLonLat.Lat)-sin(HisLonLat.Lat)*cos())/(cos()*sin()))));
{
  if(Math.sin(deg2rad(x2) - deg2rad(x1)) < 0)
    {
    	b = Math.acos((Math.sin(deg2rad(y2)) - Math.sin(deg2rad(y1)) * Math.cos(d)) / (Math.sin(d) * Math.cos(deg2rad(y1))));
    else
    {
	w = (Math.sin(deg2rad(y2)) - Math.sin(deg2rad(y1)) * Math.cos(d)) / (Math.sin(d) * Math.cos(deg2rad(y1)));
	if(w >  1.0) w = 1.0;
	if(w < -1.0) w = -1.0;
	b = 2 * Math.PI - Math.acos(w);
    }
    return(Math.round(360.0 - (b * 180.0 / Math.PI)));
  }  }
  {     #calculate angle
    $bearing = rad2deg(acos ((sin($geo["n_lat"]) - sin($geo1["n_lat"]) * cos ($dummy)) / (cos ($geo1["n_lat"]) * sin ($dummy))));
    if (sin($geo["n_long"] - $geo1["n_long"]) < 0) {
      $bearing = 360 - $bearing;
    }
    $distance_bearing["distance"] = $distance;
    $distance_bearing["bearing"] = $bearing;
    return $distance_bearing;}
end;

procedure sendStats(callsign, version_string: String);
var HTTP: THTTPSend;
  http_result: Boolean;
begin
  HTTP := THTTPSend.Create;
  try
    http_result:= HTTP.HTTPMethod('GET', 'http://abcsolutions.myftp.org/stats/index.php?callsign='+callsign+'&version_string='+version_string);
  finally
    HTTP.Free;
  end;
end;

function checkForUpdate(): Boolean;
var version, web_alpha_version, web_version: String;
  HTTP: THTTPSend;
  http_result, notify_for_updates: Boolean;
  response: Tstringlist;
Begin
  notify_for_updates:= false;
  version:= verUpdCompare;
  HTTP := THTTPSend.Create;
  response:= TStringList.Create;
  try
    http_result:= HTTP.HTTPMethod('GET', 'http://abcsolutions.de/jt65hf/versions');
    if http_result then begin
      response.LoadFromStream(HTTP.Document);
      web_version:= Response.Values['version'];
      web_alpha_version:= Response.Values['alpha_version'];
      // check for new stable version?
      //if (CheckForUpdates) then begin
      if VersionGreater(version, web_version) or VersionGreater(version, web_alpha_version) then begin
        notify_for_updates:= true;
        if (MessageDlg('Update available', 'Installed version: '+version+chr(13)+'Latest version: '+web_version+chr(13)+'Latest alpha version: '+
        web_alpha_version+chr(13)+'Download update?', mtConfirmation, [mbYes, mbNo],0) = mrYes) then OpenURL('http://abcsolutions.de/jt65hf/');
      end;
      //end;
      // check for new alpha version?
      //if (CheckForAlphaVersions) then begin
      //  if VersionGreater(version, web_version) then notify_for_updates:= true;
      //end;
      //if notify_for_updates then begin
      //end;
      result:= notify_for_updates;
    end;
  finally
    HTTP.Free;
    response.Free;
  end;

end;

end.

