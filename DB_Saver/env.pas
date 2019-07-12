unit env;

{�������̽�}
interface

uses
  INIFILES, UEncrypt,SysUtils;

procedure SaveEnv();
procedure LoadEnv();
procedure DefaultEnv();

{���� ����}
var
	FIni: TIniFile;

{����}
implementation

{ȣ����ϴ� ����}
USES
	Unit1;

// �����Ҷ� ��ȣȭ ��ߵ�
procedure SaveEnv();
var
  key:integer;

begin
  // Ű ���� ������ ���ķ� �̷�
  key := 19771014;
  Fini := TIniFile.Create(GetCurrentDir()+'\srv.ini');
  try
    with Fmain do begin
      //��ȣȭ
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
      //��ȣȭ
      if(FIni.ReadString('DB','driver','')<>'') then  cmb_driver.ItemIndex := 1;//�켱 ������ 1�̴�.//MariaDB�̴ϱ�
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
    // ��ġ ����
    //FIni.ReadInteger('position','top',0);
    //FIni.ReadInteger('position','left',0);
  end;
end;


end.

