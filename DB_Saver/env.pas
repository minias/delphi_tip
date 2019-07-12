unit env;

{인터페이스}
interface

uses
  INIFILES, UEncrypt,SysUtils;

procedure SaveEnv();
procedure LoadEnv();
procedure DefaultEnv();

{전역 변수}
var
	FIni: TIniFile;

{구현}
implementation

{호출당하는 유닛}
USES
	Unit1;

// 저장할때 암호화 써야됨
procedure SaveEnv();
var
  key:integer;

begin
  // 키 수정 방지는 차후로 미룸
  key := 19771014;
  Fini := TIniFile.Create(GetCurrentDir()+'\srv.ini');
  try
    with Fmain do begin
      //암호화
      if(cmb_driver.Items[cmb_driver.ItemIndex] <> '') then FIni.WriteString('DB', 'driver', cmb_driver.Items[cmb_driver.ItemIndex]);
      if(edt_server.Text <> '') then FIni.WriteString('DB', 'server', edt_server.Text);
      if(edt_db.Text <> '') then FIni.WriteString('DB', 'db', edt_db.Text);
      if(edt_user.Text <> '') then FIni.WriteString('DB', 'user', edt_user.Text);
      if(edt_pw.Text <> '') then FIni.WriteString('DB', 'pw',  Encrypt( edt_pw.Text, key ));
    end;
  finally
		FreeAndNil(Fini);
  end;
end;

procedure LoadEnv();
var
  key:integer;
begin
  key :=19771014;
  Fini := TIniFile.Create(GetCurrentDir()+'\srv.ini');
  try
    with Fmain do
    begin
      //복호화
      if(FIni.ReadString('DB','driver','')<>'') then  cmb_driver.ItemIndex := 1;//우선 무조껀 1이다.//MariaDB이니까
      if(FIni.ReadString('DB','server','')<>'') then edt_server.Text := FIni.ReadString('DB','server','');
      if(FIni.ReadString('DB','db','')<>'') then edt_db.Text := FIni.ReadString('DB','db','');
      if(FIni.ReadString('DB','user','')<>'') then edt_user.Text := FIni.ReadString('DB','user','');
      if(FIni.ReadString('DB','pw','')<>'') then edt_pw.Text := Decrypt(FIni.ReadString('DB','pw',''), key);
    end;
  finally
		FreeAndNil(Fini);
  end;

end;

procedure DefaultEnv();
begin
  with Fmain do
  begin
    // 위치 저장
    //FIni.ReadInteger('position','top',0);
    //FIni.ReadInteger('position','left',0);
  end;
end;


end.

