unit Unit1;

interface

uses
  {$IFDEF UNICODE}
  System.UITypes,
  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMySFTPClient,
  StdCtrls, ComCtrls, ExtCtrls, CheckLst;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ListView1: TListView;
    lblCurDir: TLabel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    edHost: TLabeledEdit;
    edPort: TLabeledEdit;
    edUser: TLabeledEdit;
    edPass: TLabeledEdit;
    btn_AllDown: TButton;
    edt_ServerDir: TLabeledEdit;
    btn_connect: TButton;
    edt_ExeDir: TLabeledEdit;
    edt_DllDir: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);

    procedure btnMkDirClick(Sender: TObject);
    procedure btnResSymlinkClick(Sender: TObject);
    procedure btnMkSymlinkClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnPutClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btn_AllDownClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_connectClick(Sender: TObject);

  private
    SFTP: TSFTPClient;
    procedure FillList;
    procedure OnProgress(ASender: TObject; const AFileName: WideString; ATransfered, ATotal: UInt64);
    procedure OnCantChangeStartDir(ASender: TObject; var Continue: Boolean);
    procedure OnAuthFailed(ASender: TObject; var Continue: Boolean);
    procedure OnKeybdInteractive(ASender: TObject; var Password: String);
    procedure ServerFileDown(Dir: String; ITem: TSFTPItem);
    procedure CloseAfterExec(EXEFile: String);
    procedure clear;
    procedure Set_Config;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  WideStrUtils, FileCtrl, libssh2_sftp, ProgressU;

var
  ProgressFrm: TProgressF;
  EXEFILE:String; //종료후 실행파일
{$R *.dfm}

procedure TForm1.btnGetClick(Sender: TObject);
var
  Dir: String;
  FS: TFileStream;
  I: Integer;
begin
  if ListView1.SelCount = 1 then
    if ListView1.Selected.Caption <> '..' then
    begin
      if SelectDirectory('Select dir where to save the file', '.', Dir) then
      begin
        I := ListView1.Selected.Index;
        if ListView1.Items[0].Caption = '..' then
          Dec(I);

        // process "file" items only, on the otherside
        // if the item is symlink, then we could resolve it and
        // follow the path
        if SFTP.DirectoryItems[I].ItemType <> sitFile then
        begin
          ShowMessage('Select file first.');
          Exit;
        end;
        // the code below is put in a tworkerthread in the original program
        // this is just a demo, so :P
        FS := TFileStream.Create(Dir + '\' + SFTP.DirectoryItems[I].FileName, fmCreate);
        if ProgressFrm = nil then
          ProgressFrm := TProgressF.Create(Self);
        try
          ProgressFrm.Caption := 'Getting file...';
          ProgressFrm.Show;
          try
            SFTP.Get(SFTP.CurrentDirectory + '/' + SFTP.DirectoryItems[I].FileName, FS, False)
          except on E: ESSH2Exception do
            ShowMessage(E.Message);
          end;
        finally
          ProgressFrm.Close;
          FS.Free;
        end;
      end;
    end;
end;

procedure TForm1.ServerFileDown(Dir:String;ITem:TSFTPItem) ;
var
   FS: TFileStream;
begin
  // process "file" items only, on the otherside
  // if the item is symlink, then we could resolve it and
  // follow the path
  if ITem.ItemType <> sitFile then
  begin
    ShowMessage('Select file first.');
    Exit;
  end;
  // the code below is put in a tworkerthread in the original program
  // this is just a demo, so :P
  FS := TFileStream.Create(Dir + '\' + ITem.FileName, fmCreate);
  if ProgressFrm = nil then
    ProgressFrm := TProgressF.Create(nil);
  try
    ProgressFrm.Caption := 'Getting file...';
    ProgressFrm.Show;
    try
      SFTP.Get(SFTP.CurrentDirectory + '/' + ITem.FileName, FS, False)
    except on E: ESSH2Exception do
      ShowMessage(E.Message);
    end;
  finally
    ProgressFrm.Close;
    FS.Free;
  end;

end;


procedure TForm1.btnPutClick(Sender: TObject);
var
  FS: TFileStream;
begin
  with TOpenDialog.Create(Self) do
  begin
    Title := 'Select file';
    Filter := '*.*';
    if Execute(Handle) then
    begin
      // the code below is put in a tworkerthread in the original program
      // this is just a demo, so :P
      FS := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
      if ProgressFrm = nil then
        ProgressFrm := TProgressF.Create(Self);
      try
        ProgressFrm.Caption := 'Putting file...';
        ProgressFrm.Show;
        try
          SFTP.Put(FS, SFTP.CurrentDirectory + '/' + ExtractFileName(FileName));
          SFTP.List;
          FillList;
        except
          on E: ESSH2Exception do
            ShowMessage(E.Message);
        end;
      finally
        ProgressFrm.Close;
        FS.Free;
      end;
    end;
    Free;
  end;
end;

procedure TForm1.btnDeleteClick(Sender: TObject);
var
  I: Integer;
begin
  if ListView1.SelCount = 1 then
    if ListView1.Selected.Caption <> '..' then
    begin
      if MessageDlg('Are you sure?', mtWarning, mbYesNo, 0) = mrNo then
        Exit;
      I := ListView1.Selected.Index;
      if ListView1.Items[0].Caption = '..' then
        Dec(I);
      try
        if SFTP.DirectoryItems[I].ItemType = sitDirectory then
          SFTP.DeleteDir(SFTP.CurrentDirectory + '/' + SFTP.DirectoryItems[I].FileName)
        else
          SFTP.DeleteFile(SFTP.CurrentDirectory + '/' + SFTP.DirectoryItems[I].FileName);

        SFTP.List;
        FillList;
      except
        on E: ESSH2Exception do
          ShowMessage(E.Message);
      end;
    end;
end;

procedure TForm1.btnRenameClick(Sender: TObject);
var
  I: Integer;
  NewName: String;
begin
  if ListView1.SelCount = 1 then
    if ListView1.Selected.Caption <> '..' then
    begin
      I := ListView1.Selected.Index;
      if ListView1.Items[0].Caption = '..' then
        Dec(I);
      NewName := SFTP.DirectoryItems[I].FileName;
      if InputQuery('Rename', 'Enter new name', NewName) then
        try
          SFTP.Rename(SFTP.DirectoryItems[I].FileName, SFTP.CurrentDirectory + '/' + NewName);
          SFTP.List;
          FillList;
        except
          on E: ESSH2Exception do
            ShowMessage(E.Message);
        end;
    end;
end;

procedure TForm1.btnMkSymlinkClick(Sender: TObject);
var
  ATarget, AName: String;
begin
  //
  ATarget := '';
  if ListView1.SelCount = 1 then
    if ListView1.Selected.Caption <> '..' then
      ATarget := SFTP.CurrentDirectory + '/' + ListView1.Selected.Caption;
  if InputQuery('Link target', 'Enter link target', ATarget) then
    if InputQuery('Link name', 'Enter link name', AName) then
      try
        SFTP.MakeSymLink(SFTP.CurrentDirectory + '/' + AName, ATarget);
        SFTP.List;
        FillList;
      except
        on E: ESSH2Exception do
          ShowMessage(E.Message);
      end;
end;

procedure TForm1.btnResSymlinkClick(Sender: TObject);
var
  A: LIBSSH2_SFTP_ATTRIBUTES;
  I: Integer;
  S, S1: WideString;
begin
  //
  if SFTP.Connected and (ListView1.SelCount = 1) then
  begin
    try
      if ListView1.Selected.Caption <> '..' then
      begin
        I := ListView1.Selected.Index;
        if ListView1.Items[0].Caption = '..' then
          Dec(I);

        if SFTP.DirectoryItems[I].ItemType in [sitSymbolicLink, sitSymbolicLinkDir] then
        begin
          S := SFTP.ResolveSymLink(SFTP.CurrentDirectory + '/' + ListView1.Selected.Caption, A);
          S1 := SFTP.ResolveSymLink(SFTP.CurrentDirectory + '/' + ListView1.Selected.Caption, A, True);
          ShowMessage('Links to: ' + S + #13#10 + 'Realpath: ' + S1);
        end;
      end;
    except
      on E: ESSH2Exception do
        ShowMessage(E.Message);
    end;
  end;
end;



procedure TForm1.btn_AllDownClick(Sender: TObject);
var
  Dir: String;
  FS: TFileStream;
  I: Integer;
begin

  for I := 0 to ListView1.Items.Count -1 do
  begin
      if LowerCase(ExtractFileExt(SFTP.DirectoryItems[I].FileName)) = '.exe' then
      begin
         EXEFILE := SFTP.DirectoryItems[I].FileName;//실행파일명
         ServerFileDown(edt_Exedir.Text,SFTP.DirectoryItems[I]);
      end;
      if LowerCase(ExtractFileExt(SFTP.DirectoryItems[I].FileName)) = '.dll' then
      begin
         ServerFileDown(edt_Dlldir.Text,SFTP.DirectoryItems[I]);
      end;
  end;

  // 다받으면 종료
  close;
end;

procedure TForm1.btn_connectClick(Sender: TObject);
begin
   SFTP := TSFTPClient.Create(Self);
   Set_Config;

  try
    SFTP.Connect;
    if not SFTP.Connected then
      Exit;
    StatusBar1.Panels[0].Text := SFTP.GetSessionMethodsStr;
    SFTP.List;
    FillList;
    SFTP.Connected;

    //디렉 변경?
    SFTP.List('/'+ edt_ServerDir.Text);
    FillList;

  except
    on E: ESSH2Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TForm1.btnMkDirClick(Sender: TObject);
var
  Dir: string;
begin
  if InputQuery('Create directory', 'Directory name', Dir) then
  begin
    SFTP.MakeDir(SFTP.CurrentDirectory + '/' + Dir);
    SFTP.List;
    FillList;
  end;
end;

procedure TForm1.FillList;
  function ItemTypeToStr(AType: TSFTPItemType): String;
  begin
    Result := '';
    case AType of
      sitUnknown:
        Result := 'unknown';
      sitDirectory:
        Result := '<DIR>';
      sitFile:
        Result := 'file';
      sitSymbolicLink:
        Result := 'symlink';
      sitSymbolicLinkDir:
        Result := '<LNK>';
      sitBlockDev:
        Result := 'block';
      sitCharDev:
        Result := 'char';
      sitFIFO:
        Result := 'fifo';
      sitSocket:
        Result := 'socket';
    end;
  end;

var
  I: Integer;
  Item: TListItem;
  SFTPItem: TSFTPItem;
begin
  lblCurDir.Caption := SFTP.CurrentDirectory;
  ListView1.Clear;
  ListView1.Items.BeginUpdate;
  SFTP.DirectoryItems.SortDefault;
  //if SFTP.CurrentDirectory <> '/' then
  //  ListView1.AddItem('..', nil);
  for I := 0 to SFTP.DirectoryItems.Count - 1 do
  begin
    SFTPItem := SFTP.DirectoryItems[I];
    Item := ListView1.Items.Add;
    Item.Caption := SFTPItem.FileName;
    Item.SubItems.Add(ItemTypeToStr(SFTPItem.ItemType));
    Item.SubItems.Add(IntToStr(SFTPItem.FileSize));
    //Item.SubItems.Add(SFTPItem.PermsOctal);
    //Item.SubItems.Add(SFTPItem.UIDStr + '-' + SFTPItem.GIDStr);
    //Item.SubItems.Add(DateTimeToStr(SFTPItem.LastModificationTime));
    Item.SubItems.Add(FormatDateTime('YYYYMMDDHHMMSS',SFTPItem.LastModificationTime));
  end;
  ListView1.Items.EndUpdate;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if SFTP.Connected then
     SFTP.Disconnect;

  clear();

  CloseAfterExec(EXEFile);//Exec
end;

procedure TForm1.clear();
begin
  ListView1.Clear;
  lblCurDir.Caption := '::';
  StatusBar1.Panels[0].Text := '';
end;

procedure TForm1.CloseAfterExec(EXEFile:String);
begin
  //실행하자.
  if FileExists(EXEFile) then
  begin
     WinExec(PAnsiChar(AnsiString(EXEFile)), SW_SHOWNORMAL);
  end;
end;

procedure TForm1.Set_Config;
begin
  SFTP.OnTransferProgress := OnProgress;
  SFTP.OnAuthFailed := OnAuthFailed;
  SFTP.OnCantChangeStartDir := OnCantChangeStartDir;
  SFTP.OnKeybdInteractive := OnKeybdInteractive;
  StatusBar1.Panels[1].Text := 'libssh2 ver: ' + SFTP.LibraryVersion;
  SFTP.UserName := edUser.Text;
  SFTP.Password := edPass.Text;
  SFTP.Host := edHost.Text;
  SFTP.Port := StrToIntDef(edPort.Text, 22);
  SFTP.KeepAlive := true;
  SFTP.IPVersion := IPv4;
  SFTP.AuthModes := [amPassword];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SFTP := TSFTPClient.Create(Self);
  //Set_Config;

  //btn_connectClick(sender);//connection
  //btn_AllDownClick(sender);//Download

end;

procedure TForm1.ListView1DblClick(Sender: TObject);
var
  W: WideString;
  Item: TListItem;
  A: LIBSSH2_SFTP_ATTRIBUTES;
  I: Integer;
begin
  //
  if ListView1.SelCount = 1 then
  begin
    try
      Item := ListView1.Selected;
      if Item.Caption = '..' then
      begin
        W := ExtractFileDir(WideStringReplace(SFTP.CurrentDirectory, '/', '\', [rfReplaceAll, rfIgnoreCase]));
        if W = '' then
          W := '/'
        else
          W := WideStringReplace(W, '\', '/', [rfReplaceAll, rfIgnoreCase]);
        SFTP.List(W);
        FillList;
        Exit;
      end;

      I := Item.Index;
      if (I <> 0) and (ListView1.Items[0].Caption = '..') then
        Dec(I);
      if SFTP.DirectoryItems[I].ItemType in [sitDirectory, sitSymbolicLinkDir] then
      begin
        if SFTP.DirectoryItems[I].ItemType = sitSymbolicLinkDir then
        begin
          W := SFTP.ResolveSymLink(SFTP.CurrentDirectory + '/' + Item.Caption, A, True);
          if W = '' then
            W := '/';
          SFTP.List(W);
        end
        else
        begin
          W := SFTP.CurrentDirectory;
          if W = '/' then
            W := '';
          SFTP.List(W + '/' + Item.Caption);
        end;
        FillList;
      end;

    except
      on E: ESSH2Exception do
        ShowMessage(E.Message);
    end;
  end;
end;

procedure TForm1.OnAuthFailed(ASender: TObject; var Continue: Boolean);
begin
  Continue := MessageDlg('Auth failed. Try again?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TForm1.OnCantChangeStartDir(ASender: TObject; var Continue: Boolean);
begin
  Continue := MessageDlg('Could not change to start dir. Continue?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TForm1.OnKeybdInteractive(ASender: TObject; var Password: String);
begin
  InputQuery('Enter password for kybdinteractive', 'Password', Password);
end;

procedure TForm1.OnProgress(ASender: TObject; const AFileName: WideString; ATransfered, ATotal: UInt64);
begin
  //
  if Assigned(ProgressFrm) then
  begin
    ProgressFrm.ProgressBar1.Max := ATotal;
    ProgressFrm.ProgressBar1.Position := ATransfered;
    ProgressFrm.Label1.Caption := AFileName;
    ProgressFrm.Update;
    Application.ProcessMessages;
    if ProgressFrm.ModalResult = mrCancel then
      SFTP.Cancel(False);
    if ATransfered >= ATotal then
      ProgressFrm.ModalResult := mrOk;
  end;
end;

end.
