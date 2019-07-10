unit ProgressU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TProgressF = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProgressF: TProgressF;

implementation

{$R *.dfm}

procedure TProgressF.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
