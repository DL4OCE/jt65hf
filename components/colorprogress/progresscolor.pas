{ Ce fichier a �t� automatiquement cr�� par Lazarus. Ne pas l'�diter !
Cette source est seulement employ�e pour compiler et installer le paquet.
 }

unit progresscolor; 

interface

uses
  ColorProgress, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('ColorProgress', @ColorProgress.Register); 
end; 

initialization
  RegisterPackage('progresscolor', @Register); 
end.
