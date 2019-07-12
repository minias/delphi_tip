program DB_setting;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Fmain},
  UEncrypt in 'UEncrypt.pas',
  env in 'env.pas',
  version in 'version.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFmain, Fmain);
  Application.Run;
end.

