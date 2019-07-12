unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdAttachment, IdMessage, IdMessageParts, IdEMailAddress, IdAttachmentFile,
  IdAssignedNumbers,
  IdSMTPBase, IdSMTP, IdBaseComponent, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    MSG: TIdMessage;
    SMTP: TIdSMTP;
    IO_OpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    edt_id: TLabeledEdit;
    edt_pw: TLabeledEdit;
    btn_Send: TButton;
    OD_FILE: TOpenDialog;
    edt_body: TRichEdit;
    edt_subject: TLabeledEdit;
    ed_file: TLabeledEdit;
    mStatus: TRichEdit;
    edt_from_name: TLabeledEdit;
    edt_to: TLabeledEdit;
    edt_cc: TLabeledEdit;
    edt_bcc: TLabeledEdit;
    edt_from: TLabeledEdit;
    procedure btn_SendClick(Sender: TObject);
    procedure ed_fileDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
////////////////////////////////////////////////////////////////////////////////
//디버그 용도를 사용 2018-11-23 by minias<gnuhacker@gmail.com>
Const
  //Debug = true;
  Debug = false;
////////////////////////////////////////////////////////////////////////////////
///
implementation

{$R *.dfm}

{///////////////////////////////////////////////////////////////////////////////
  @author <minias>gnuhacker@gmail.com
  @date 2018-11-23
  @Description
    XE8 + Indy 10.6.2.5263
    IdSMTP + IdMessage + TidSSLIOHandlerSockertOpenSSL
    smtp Server name: Smtp.gmail.com
    ssmtp port :465
    OpenSSL을 사용하기에 실행파일에 libeay32.dll , ssleay32.dll 필요함.
 @See 지메일의 보안 수준이 낮은 앱 허용: 사용
 @ref https://myaccount.google.com/lesssecureapps
///////////////////////////////////////////////////////////////////////////////}
procedure TForm1.btn_SendClick(Sender: TObject);
begin
  btn_send.Enabled := false;//중복클릭 금지
  if Debug then mStatus.Clear;//디버그 모드시 디버그 클리어

  try
    //메일 메시지 설정
    with Msg do
    begin
      //메시지 초기화
      MessageParts.Clear;
      //반드시 UTF-8로 보내야 함.
      Charset                    := 'UTF-8';
      //발신자 이름
      From.Name                 := edt_from_name.Text;
      //발신 메일
      //기본적으로 Gmail smtp를 사용함.
      From.Address              := edt_from.Text;
      //보낸사람명
      From.DisplayName          := From.Name;
      //회신메일
      ReplyTo.EMailAddresses    :=  From.Address;
      //수신 메일
      Recipients.EMailAddresses := edt_to.Text;
      // CC
      CCList.EMailAddresses     := edt_cc.Text;
      //BCC
      BccList.EMailAddresses    := edt_bcc.Text;
      //제목
      Subject := edt_subject.Text;
      // 본문
      Body.Add(edt_body.Text);
    end;
    // 첨부파일
    if OD_FILE.FileName <> '' then
    begin
      TIdAttachmentFile.Create(Msg.MessageParts, OD_File.FileName);
    end;

    try
      //smtp.gmail.com Auth 설정
      with SMTP do
      begin
        Host           := 'smtp.gmail.com';//SMTP Server
        Port           := IdPORT_ssmtp;  //IdAssignedNumbers//465
        UseTLS         := utUseImplicitTLS;//반드시 TLS를 사용
        Username       := edt_id.Text;//gmail ID
        Password       := edt_pw.Text;//gmail PW
        ConnectTimeout := 20000;//20초
        ReadTimeout    := 20000;//20초
        AuthType       :=  satDefault;//인증사용
      end;
      IO_OpenSSL.SSLOptions.Method  := sslvTLSv1;//TLS
      IO_OpenSSL.SSLOptions.Mode    := sslmClient;//Client Auth mode

      //접촉
      if not SMTP.Connected then
      begin
        SMTP.Connect();
        if Debug then mStatus.Lines.Add('SMTP Connect');//디버그 모드
        SMTP.Authenticate();
        if Debug then mStatus.Lines.Add('SMTP AUTH');//디버그 모드
      end;

      // 접촉중?
      if SMTP.Connected then
      begin
        if Debug then mStatus.Lines.Add('MSG Send Start'); //디버그 모드
        Refresh;
        SMTP.Send(Msg);
        if Debug then mStatus.Lines.Add('MSG Send ok');//디버그 모드
        SMTP.Disconnect;
        if Debug then mStatus.Lines.Add('SMTP Disconnect'); //디버그 모드
      end;
      if Debug then
        mStatus.Lines.Add('MSG Sending OK')//디버그 모드
      else
        showmessage('발송완료');

    //여기로 오면 빡친다.
    EXcept on E: Exception do
      if Debug then
      begin
        if (tag = 0) Then
        begin
          if (Pos(UpperCase('Credentials Rejected'), UpperCase(E.Message)) > 0) Then
            mStatus.Lines.Add('Error : Login or PW!') //디버그 모드
          else if (Pos(UpperCase('Host not found'), UpperCase(E.Message)) > 0) Then
            mStatus.Lines.Add(SMTP.Host+ ' Not Found') //디버그 모드
          else if (Pos(UpperCase('Connection timed out'), UpperCase(E.Message)) > 0) Then
            mStatus.Lines.Add('Connection Time out:' +SMTP.Host+SMTP.Port.ToString + ' Check')
          else if (Pos(UpperCase('read timeout'), UpperCase(E.Message)) > 0)Then
            mStatus.Lines.Add(SMTP.Host+ ' SSL need')
          else if (Pos(UpperCase('connection closed'), UpperCase(E.Message)) > 0) Then
            mStatus.Lines.Add(SMTP.Host+ ' Connection Closed Error')
          else
            mStatus.Lines.Add('Fail '+ E.Message);
        end;
      end
      else //일반모드
      begin
        if (tag = 0) Then
        begin
          if (Pos(UpperCase('Credentials Rejected'), UpperCase(E.Message)) > 0) Then
            showmessage('Error : Login or PW!') //디버그 모드
          else if (Pos(UpperCase('Host not found'), UpperCase(E.Message)) > 0) Then
            showmessage(SMTP.Host+ ' Not Found') //디버그 모드
          else if (Pos(UpperCase('Connection timed out'), UpperCase(E.Message)) > 0) Then
            showmessage('Connection Time out:' +SMTP.Host+SMTP.Port.ToString + ' Check')
          else if (Pos(UpperCase('read timeout'), UpperCase(E.Message)) > 0)Then
            showmessage(SMTP.Host+ ' SSL need')
          else if (Pos(UpperCase('connection closed'), UpperCase(E.Message)) > 0) Then
            showmessage(SMTP.Host+ ' Connection Closed Error')
          else
            showmessage('Fail '+ E.Message);
        end;
      end;
    end;
  finally
    if SMTP.Connected then SMTP.Disconnect;
    btn_send.Enabled := true;//중복클릭 해제
  end;
end;

{///////////////////////////////////////////////////////////////////////////////
  @brief 따블클릭 이벤트
  @detail 파일 선택처리
  @author minias<gnuhacker@gmail.com>
  @date 2018-11-23
///////////////////////////////////////////////////////////////////////////////}
procedure TForm1.ed_fileDblClick(Sender: TObject);
begin
  if OD_FILE.Execute() then
  begin
    ed_file.Text := OD_FILE.Files.Text;
  end;
end;

end.
