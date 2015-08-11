//unit dxcc;
//{im Moment nirgends verwendet, diente der Programmentwicklung um bestimmte
//Variablen während des 'RUN' anzuzeigen}
//
//{$mode objfpc}{$H+}
//
//interface
//
//uses
//  Classes, SysUtils, LResources, FileUtil, Forms, Controls, Graphics, Dialogs,
//  StdCtrls, StrUtils;
//  //Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,StdCtrls;
//type
//  { TForm7 }
//  TForm7 = class(TForm)
//   Button1: TButton;
//   ListBox1: TListBox;
//   procedure Button1Click(Sender: TObject);
//   procedure viewdxcc() ;
//
////   procedure FormCreate(Sender: TObject);
//  private
//    { private declarations }
//  public
//    { public declarations }
//  end;
//
//var
//  Form7        : TForm7;
//  dxfoo,dxtime : String;
//  dxCallRight  : String;
//  dxMinuteSyst : String;
//  dxUtcMinute  : Integer;
//  testges      : String;
//  lminute      : Integer;
//  dxIndex      : Integer;
//  dxDurchlauf  : integer;
//
//implementation
//
// { TForm7 }
//
//procedure TForm7.viewdxcc();
//
//begin
//
//    dxtime := ExtractWord(1,dxfoo,[' ']);
//    dxtime := dxtime[4..5];
//    dxMinuteSyst := IntToStr(dxUtcMinute);
//    lminute := Length(dxMinuteSyst);
//    if lminute < 2 then
//       begin
//            dxMinuteSyst := '0' + dxMinuteSyst;
//       end;
//    if dxtime = dxMinuteSyst then
//       begin
//       dxCallRight := ExtractWord(8,dxfoo,[' ']);
//       testges := dxtime + '  ' + dxCallRight  + '  '+dxMinuteSyst+ '  ' +'Index: '+ IntToStr(dxIndex)+ ' '+'Durchläufe: '+IntToStr(dxDurchlauf);
//       Form7.ListBox1.Items.Add(testges);
//       end;
//end;
//
//
//procedure TForm7.Button1Click(Sender: TObject);
//begin
//     Form7.ListBox1.Clear;
//end;
//
//
//{$R *.lfm}
//
//end.

