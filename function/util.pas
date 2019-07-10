unit Util;

{ ���� }
interface

{ ���� ��������� ���� Ŭ���� �߰��س��� ����. ���۽� �޸𸮿� ���� �����Ѵ�. }
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

{ TODO 0 -o��â�� -cINFO : showmessage ��ü ��  ����ü }
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
   procedure   get_image(img: Timage; fname: string);//�̹����ε�
   procedure   delay( milliseconds: integer);   // sleep�� ����¡ �Ǵ°� ���� �Լ�

 // ���
Const
  Util_include = 1;
// Global Variable
var
  mesg: ShowRec; // Showmessage ����ü
implementation

//USES
//  ��������;

// �̹��� �ε�
procedure get_image(img: Timage; fname: string);
begin
   try
      img.Picture.LoadFromFile(fname);
   finally
      //
   end;
end;

//sleep ��ü (1000ms �����϶� ��Ȯ�� �������� ������ ����)
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
