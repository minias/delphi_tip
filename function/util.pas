unit Util;

{ 선언 }
interface

{ 제발 사용하지도 않은 클래스 추가해놓지 말자. 시작시 메모리에 전부 적재한다. }
USES

   Winapi.Windows, //
   Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
   Vcl.Imaging.pngimage, // png
   Vcl.Imaging.jpeg, // TJPEG
   IniFiles, // INIFiles
   BASS, // mp3
   Vcl.Clipbrd // clipboard uses
   ;

{ TODO 0 -o이창민 -cINFO : showmessage 대체 폼  구조체 }
type
   ShowRec = record
      Btn_type: integer;
      YES_NO: boolean;
      Left: integer;
      Top: integer;
      title: string;
      msg: string;
   end;
   { Procedure AND Function interface }
   procedure   get_image(img: Timage; fname: string);//이미지로드
   procedure   delay( milliseconds: integer);   // sleep시 프리징 되는거 막는 함수

 // 상수
Const
  Util_include = 1;
// Global Variable
var
  mesg: ShowRec; // Showmessage 구조체
implementation

//USES
//  참조유닛;

// 이미지 로드
procedure get_image(img: Timage; fname: string);
begin
   try
      img.Picture.LoadFromFile(fname);
   finally
      //
   end;
end;

//sleep 대체 (1000ms 이하일때 정확도 떨어지는 문제가 있음)
procedure delay( milliseconds: integer);
var
 dTime : DWORD;
begin
  dTime := GetTickCount;
  while GetTickCount <= ( dTime + milliseconds ) do
  begin
    if ( Application.terminated ) then Exit;
    Application.ProcessMessages;
    Sleep(10);
  end;
end;

end.
