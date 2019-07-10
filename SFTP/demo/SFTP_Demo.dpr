program SFTP_Demo;

{$i app_linker.inc}

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  ProgressU in 'ProgressU.pas' {ProgressF},
  uMySFTPClient in '..\lib\uMySFTPClient.pas',
  libssh2 in '..\lib\libssh2.pas',
  uFxtDelayedHandler in '..\lib\uFxtDelayedHandler.pas',
  libssh2_sftp in '..\lib\libssh2_sftp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
