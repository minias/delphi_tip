unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFmain = class(TForm)
    Panel1: TPanel;
    edt_server: TLabeledEdit;
    edt_db: TLabeledEdit;
    edt_user: TLabeledEdit;
    edt_pw: TLabeledEdit;
    Button1: TButton;
    cmb_driver: TComboBox;
    lbl_driver: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure edt_pwKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fmain: TFmain;

implementation

USES
	env,version;
{$R *.dfm}

//세이브
procedure TFmain.Button1Click(Sender: TObject);
begin
	SaveEnv();
  showmessage('저장 되었습니다.');
  close;
end;


procedure TFmain.edt_pwKeyPress(Sender: TObject; var Key: Char);
begin
	if (key = char(VK_Return)) then
  begin
    Button1.Click;
  end;
end;

procedure TFmain.FormCreate(Sender: TObject);
begin
  // 버전 공지
  Fmain.Caption := '데이터베이스 설정 '+ GetVersion(false);
  Application.Title :=Fmain.Caption;

	LoadEnv();
end;

end.

