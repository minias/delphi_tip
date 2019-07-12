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
//����� �뵵�� ��� 2018-11-23 by minias<gnuhacker@gmail.com>
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
    OpenSSL�� ����ϱ⿡ �������Ͽ� libeay32.dll , ssleay32.dll �ʿ���.
 @See �������� ���� ������ ���� �� ���: ���
 @ref https://myaccount.google.com/lesssecureapps
///////////////////////////////////////////////////////////////////////////////}
procedure TForm1.btn_SendClick(Sender: TObject);
begin
  btn_send.Enabled := false;//�ߺ�Ŭ�� ����
  if Debug then mStatus.Clear;//����� ���� ����� Ŭ����

  try
    //���� �޽��� ����
    with Msg do
    begin
      //�޽��� �ʱ�ȭ
      MessageParts.Clear;
      //�ݵ�� UTF-8�� ������ ��.
      Charset                    := 'UTF-8';
      //�߽��� �̸�
      From.Name                 := edt_from_name.Text;
      //�߽� ����
      //�⺻������ Gmail smtp�� �����.
      From.Address              := edt_from.Text;
      //���������
      From.DisplayName          := From.Name;
      //ȸ�Ÿ���
      ReplyTo.EMailAddresses    :=  From.Address;
      //���� ����
      Recipients.EMailAddresses := edt_to.Text;
      // CC
      CCList.EMailAddresses     := edt_cc.Text;
      //BCC
      BccList.EMailAddresses    := edt_bcc.Text;
      //����
      Subject := edt_subject.Text;
      // ����
      Body.Add(edt_body.Text);
    end;
    // ÷������
    if OD_FILE.FileName <> '' then
    begin
      TIdAttachmentFile.Create(Msg.MessageParts, OD_File.FileName);
    end;

    try
      //smtp.gmail.com Auth ����
      with SMTP do
      begin
        Host           := 'smtp.gmail.com';//SMTP Server
        Port           := IdPORT_ssmtp;  //IdAssignedNumbers//465
        UseTLS         := utUseImplicitTLS;//�ݵ�� TLS�� ���
        Username       := edt_id.Text;//gmail ID
        Password       := edt_pw.Text;//gmail PW
        ConnectTimeout := 20000;//20��
        ReadTimeout    := 20000;//20��
        AuthType       :=  satDefault;//�������
      end;
      IO_OpenSSL.SSLOptions.Method  := sslvTLSv1;//TLS
      IO_OpenSSL.SSLOptions.Mode    := sslmClient;//Client Auth mode

      //����
      if not SMTP.Connected then
      begin
        SMTP.Connect();
        if Debug then mStatus.Lines.Add('SMTP Connect');//����� ���
        SMTP.Authenticate();
        if Debug then mStatus.Lines.Add('SMTP AUTH');//����� ���
      end;

      // ������?
      if SMTP.Connected then
      begin
        if Debug then mStatus.Lines.Add('MSG Send Start'); //����� ���
        Refresh;
        SMTP.Send(Msg);
        if Debug then mStatus.Lines.Add('MSG Send ok');//����� ���
        SMTP.Disconnect;
        if Debug then mStatus.Lines.Add('SMTP Disconnect'); //����� ���
      end;
      if Debug then
        mStatus.Lines.Add('MSG Sending OK')//����� ���
      else
        showmessage('�߼ۿϷ�');

    //����� ���� ��ģ��.
    EXcept on E: Exception do
      if Debug then
      begin
        if (tag = 0) Then
        begin
          if (Pos(UpperCase('Credentials Rejected'), UpperCase(E.Message)) > 0) Then
            mStatus.Lines.Add('Error : Login or PW!') //����� ���
          else if (Pos(UpperCase('Host not found'), UpperCase(E.Message)) > 0) Then
            mStatus.Lines.Add(SMTP.Host+ ' Not Found') //����� ���
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
      else //�Ϲݸ��
      begin
        if (tag = 0) Then
        begin
          if (Pos(UpperCase('Credentials Rejected'), UpperCase(E.Message)) > 0) Then
            showmessage('Error : Login or PW!') //����� ���
          else if (Pos(UpperCase('Host not found'), UpperCase(E.Message)) > 0) Then
            showmessage(SMTP.Host+ ' Not Found') //����� ���
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
    btn_send.Enabled := true;//�ߺ�Ŭ�� ����
  end;
end;

{///////////////////////////////////////////////////////////////////////////////
  @brief ����Ŭ�� �̺�Ʈ
  @detail ���� ����ó��
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
