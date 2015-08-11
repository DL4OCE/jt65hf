{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
Cette source est seulement employée pour compiler et installer le paquet.
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
