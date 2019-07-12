unit version;

interface

uses
  SysUtils, Windows;

function GetVersion(opt:boolean): String;
function GetVersionInt(): Integer;

implementation

//���α׷� ���� ���� �������� �Լ� ����
function GetVersion(opt:boolean): String;
var
  Size, Size2 : DWord;
  Pt, Pt2     : Pointer;
  Version     : string;
begin
  Size := GetFileVersionInfoSize(Pchar (ParamStr (0)), Size2);
  if Size > 0 then
  begin
    GetMem (Pt, Size);
    try
      GetFileVersionInfo (Pchar (ParamStr (0)), 0, Size, Pt);
      VerQueryValue (Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo (Pt2^) do
      begin
				if opt then
        begin
        	// ���Ϲ��� �� ���ڸ� 2���� ��� 1.0.1234.1234
          version := IntToStr(HiWord (dwFileVersionMs)) + '.' +
                     IntToStr(LoWord (dwFileVersionMs)) + '.' +
                     IntToStr(HiWord (dwFileVersionLs)) + '.' +
                     IntToStr(LoWord (dwFileVersionLs));
        end else begin
	        // ���Ϲ��� �� ���ڸ� 2���� ��� 1.0
					version := IntToStr(HiWord (dwFileVersionMs)) + '.' +
  	      					 IntToStr(LoWord (dwFileVersionMs));
			  end;
        result := version;
      end;
    finally
      FreeMem (pt);
    end;
  end;
end;
//���� ���� �������� �Լ� ��

//���� ���� ������ �������� �Լ� ����
function GetVersionInt(): Integer;
var
  Size, Size2 : DWord;
  Pt, Pt2     : Pointer;
  Version     : string;
  VersionInt  : Integer;
begin
  result := 0;
  Size := GetFileVersionInfoSize(Pchar (ParamStr (0)), Size2);
  if Size > 0 then
  begin
    GetMem (Pt, Size);
    try
      GetFileVersionInfo (Pchar (ParamStr (0)), 0, Size, Pt);
      VerQueryValue (Pt, '\', Pt2, Size2);
      with TVSFixedFileInfo (Pt2^) do
      begin
        version := IntToStr(LoWord (dwFileVersionLs));
        VersionInt := StrToInt(Version);
        result := VersionInt;
      end;
    finally
      FreeMem (pt);
    end;
  end;
end;
//���� ���� ������ �������� �Լ� ��

end.
