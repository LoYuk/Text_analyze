unit FileDrop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, ComCtrls;

type
  { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
  private
  public


  end;

var
  Form1: TForm1;
implementation
uses MainMenu,FunctionButton,crt,RegExpr;
{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Listbox1.Clear;
  Memo1.Visible := False;
  Memo1.Caption := '';
  Label1.Caption:='Text Analyzer';
  Label2.Caption := 'Enter or drag the file path here:';
  Button1.Caption:= 'Broswe';

  // Put all the objects to form 3
  // Use Byte-Order Mark to let the user can load the unicode file  (EF BB BF)
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String);
var
begin
//  i:integer;
//  temp:string = '';
//  F:TSearchRec;
//begin
//  for i := Low(FileNames) to High(FileNames) do
//    temp := temp + FileNames[i];
//  if (ExtractFileExt(temp) = '.txt') or (FindFirst(Temp + '\*.*', F.Attr and faAnyFile, F)= 0) then
//     begin
//       listbox1.Items.Add(temp);
//       FN := Listbox1.Items[0];
//       Form3.Show;
//       FindFile(FN);
//       Form3.Listbox2.Items.LoadFromFile(Location[1]);
//       AllowDropFiles := False;
//       Form4.Alarm.Enabled := True;
//     end
//  else
//     ShowMessage('Please drag a txt entension file or a folder!');
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  Listbox1.Visible := False;
  Memo1.Visible := True;
end;

procedure TForm1.Memo1DblClick(Sender: TObject);
begin
  Listbox1.Visible := True;
  Memo1.Visible := False;
end;

end.

