unit Unit1;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   ShellAPI,
   JsonDataObjects,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
   Vcl.ExtCtrls, Vcl.FileCtrl, fs_synmemo, BCEditor.Editor.Base, BCEditor.Editor,
  SynEdit, SynMemo, SynHighlighterVB, SynEditHighlighter, SynHighlighterVBScript,
  SynHighlighterHtml, SynEditCodeFolding, SynHighlighterPas;

type
   TForm1 = class(TForm)
      SB: TStatusBar;
    pnl_body: TPanel;
    edt_dir: TLabeledEdit;
    pnl_head: TPanel;
    Panel1: TPanel;
    dirlistbox: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Panel2: TPanel;
    edt_ext: TLabeledEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    BeforFile: TSynMemo;
    SynVBScriptSyn1: TSynVBScriptSyn;
    SynVBSyn1: TSynVBSyn;
    SynHTMLSyn1: TSynHTMLSyn;
    SynPasSyn1: TSynPasSyn;
    AddFile: TSynMemo;
      procedure FormShow(Sender: TObject);
      procedure FormResize(Sender: TObject);
      procedure FormMouseMove(Sender: TObject; Shift: TShiftState;
         X, Y: Integer);
      procedure FormMouseActivate(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y, HitTest: Integer;
         var MouseActivate: TMouseActivate);
      procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
      procedure FormCreate(Sender: TObject);
    procedure dirlistboxChange(Sender: TObject);
    procedure edt_extChange(Sender: TObject);
    procedure FileListBox1Change(Sender: TObject);
   private
      { Private declarations }
   public
      procedure WMDropFiles(var msg: TMessage); message WM_DROPFILES;
      { Public declarations }
   end;

var
   Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.dirlistboxChange(Sender: TObject);
begin
   edt_dir.Text:= dirlistbox.Directory;
   filelistbox1.Directory :=dirlistbox.Directory; // ���丮 ���� ���� ������ ���丮
   filelistbox1.Mask := edt_ext.Text; //���ϸ���Ʈ�� ������ Ȯ����
end;

procedure TForm1.FileListBox1Change(Sender: TObject);
begin
   if FileExists(FileListBox1.FileName) then
   begin
      beforfile.Lines.Clear;
      beforfile.Lines.LoadFromFile(FileListBox1.FileName);
      //beforfile.SetActiveLine(0);
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   DragAcceptFiles(Handle, True); // �巡��&����� �����ϵ���
   //Beforfile.SyntaxType := stVB;
end;

procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
   edt_dir.Text := Source.ToString;
end;

procedure TForm1.FormMouseActivate(Sender: TObject; Button: TMouseButton;
   Shift: TShiftState; X, Y, HitTest: Integer;
   var MouseActivate: TMouseActivate);
begin
   SB.Panels[0].Text := FormatDateTime('YYYY-mm-dd hh:mm:ss', now());
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState;
   X, Y: Integer);
begin
   SB.Panels[0].Text := FormatDateTime('YYYY-mm-dd hh:mm:ss', now());
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   SB.Panels[0].Text := FormatDateTime('YYYY-mm-dd hh:mm:ss', now());
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   SB.Panels[0].Text := FormatDateTime('YYYY-mm-dd hh:mm:ss', now());
end;

procedure TForm1.edt_extChange(Sender: TObject);
begin

end;

// Drag&Drop �̺�Ʈ �ڵ鷯
procedure TForm1.WMDropFiles(var msg: TMessage);
var
   i, NumFiles, NameLength: Integer;
   hDrop: THandle;
   // WinApi.ShellAPI 1762Line �� ���� ���̵彺Ʈ������ ����Ǿ��ִ�.
   //function DragQueryFile; external shell32 name 'DragQueryFileW';
   tmpFile: array [0 .. MAX_PATH] of Char;

begin
   { 1 } // Drop �ڵ� ���
   hDrop := msg.WParam;
   try
      { 2 } // ��� ������ ��ӵǾ��°�
      NumFiles := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);

      { 3 } // ��ӵ� ���� �� ��ŭ ������ ���� �����Ŵ
      for i := 0 to NumFiles - 1 do
      begin
         { 4 } // �����̸� String �� ���̸� ����
         NameLength := DragQueryFile(hDrop, i, nil, 0);

         { 5 } // ��ӵ� ������ �̸��� �޾ƿ�
         DragQueryFile(hDrop, i,  tmpFile, NameLength + 1);
         //showmessage( tmpFile  );

         //edt_dir.Text := ExtractFilePath( tmpFile );
         edt_dir.Text := ExtractFileDir( tmpFile );
         //dir list box
         dirlistbox.Directory := tmpFile;
      end; // for

   finally
      DragFinish(hDrop); // �ڵ� ����
   end;

   msg.Result := 0;

   inherited;
end;

end.
