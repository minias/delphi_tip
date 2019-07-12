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

//���̺�
procedure TFmain.Button1Click(Sender: TObject);
begin
	SaveEnv();
  showmessage('���� �Ǿ����ϴ�.');
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
  // ���� ����
  Fmain.Caption := '�����ͺ��̽� ���� '+ GetVersion(false);
  Application.Title :=Fmain.Caption;

	LoadEnv();
end;

end.

