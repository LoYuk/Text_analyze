unit MainMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, EditBtn, Menus, Types, DateUtils, StrUtils, RegExpr,
  FunctionButton;

{ TForm3 }
type
  status = record
    alphabet: integer;
    Figure: integer;
    paragraph: integer;
    punctuation: integer;
    space: integer;
    word: integer;
    Line: integer;
  end;

  TForm3 = class(TForm)
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    PopupMenu1: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    procedure FormClick(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Label4DblClick(Sender: TObject);
    procedure Label6DblClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ListBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure ListBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure ListBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private

  public
    Content: array of status;
    Location: array of string[100];
    FN: string;
    Last: integer;
  end;

var
  Form3: TForm3;
  Open: TDateTime;
  First: boolean = True;
  Count: integer = 0;
  Hrs, Days: word;
  Screen: TMemo;
  i: integer;

procedure FindFile(Path: string);
procedure FileStatus;
implementation

{$R *.lfm}
{ TForm3 }
procedure FileStatus;
var
  Temp: string;
  k: integer;
  blank: boolean;
  Txt: TextFile;
begin
  for i := 0 to Length(Form3.Content) - 1 do
    with Form3.Content[i] do
    begin
      alphabet := 0;
      paragraph := 0;
      punctuation := 0;                                         // initialization
      space := 0;
      word := 0;
      Figure := 0;
      Line := 0;
    end;
  for i := 0 to Length(Form3.Location) - 1 do
    with Form3.Content[i] do
    begin
      Assign(Txt, Form3.Location[i]);
      reset(Txt);
      if EOF(Txt) then
          Continue;
      Blank := False;
      while not EOF(Txt) do
      begin
        readln(Txt, Temp);
        Inc(Line);
        if Trim(Temp) = '' then
        begin
          Blank := True;
          Continue;
        end
        else if Blank then
        begin
          Blank := False;
          Inc(Paragraph);
        end;
        Temp := TrimRight(Temp);
        word := word + WordCount(Temp, StdWordDelims);
        for k := 1 to length(Temp) do
        begin
          if Temp[k] in ['~', '!', '@', '#', '$', '%', '^', '&', '*','(', ')', '_', '-', '+', '=', '\', '/', '?', '.', ',', '>', '<', '{','}', '[', ']', ':', ';', '"', '|', '`'] then
             Inc(Punctuation)
          else if Temp[k] in ['a'..'z', 'A'..'Z'] then
             Inc(Alphabet)
          else if (Temp[k] = '') or (Temp[k] = chr(9)) then
             Inc(Space)
          else if Temp[k] in ['0'..'9'] then
             Inc(Figure);
        end;
      end;
      Inc(Paragraph);
      Closefile(Txt);
    end;
  with Form3.Content[0] do
  begin
    Form3.Label7.Caption := IntToStr(Alphabet);
    Form3.Label8.Caption := IntToStr(Paragraph);
    Form3.Label9.Caption := IntToStr(Punctuation);
    Form3.Label11.Caption := IntToStr(Space);
    Form3.Label14.Caption := IntToStr(word);
  end;
end;

procedure FindFile(Path: string);
var
  Mask: string;
  i,j,Count: integer;
  Found: boolean;
begin
  try
    Count := 0;
    Form3.Last := Length(Form3.Location);
    if ExtractFileExt(Form3.FN) = '.txt' then
    begin
      SetLength(Form3.Content, Length(Form3.Content) + 1);
      SetLength(Form3.Location, Length(Form3.Location) + 1);
      Form3.Listbox1.Items.Add(ExtractFileName(Path));
      Form3.Location[Length(Form3.Location) - 1] := Path;
    end
    else
    begin
      if Path = 'C:\' then
      begin
        ShowMessage('This File is too big');
        ShowMessage('Try to input another file!');
        Exit;
      end;
      Mask := '*.txt';
      if FindAllFiles(Path, '*', True).Count >= 100 then
        case QuestionDlg('Too much files', 'You have inputted over 100 files',
            mtCustom, [mrYes, 'I Know', mrNo, 'Press Wrong'], '') of
          mrYes: ;
          mrCancel: Exit;
          mrNo: Exit;
        end;
      Form3.Listbox3.Items.Clear;
      Form3.Listbox3.Items := FindAllFiles(Path, Mask, True);
      if Form3.ListBox3.Items.Count = 0 then
      begin
        ShowMessage('There are no text file in your folder');
        Exit;
      end;
      for i := 0 to Form3.Listbox3.Items.Count - 1 do
      begin
        Found := False;
        j := 0;
        repeat
          if Form3.Listbox1.Items.Count = 0 then
            break;
          if Form3.Listbox1.Items[j] =
            ExtractFileName(Form3.Listbox3.Items[i]) then
            Found := True
          else
            Inc(j);
        until (Found = True) or (j + 1 > Form3.Last);
        if Found = True then
          Inc(Count)
        else
        begin
          Form3.Listbox1.Items.Add(ExtractFileName(Form3.Listbox3.Items[i]));
          SetLength(Form3.Location, Length(Form3.Location) + 1);
          Form3.Location[Form3.Last + i] := Form3.Listbox3.Items[i];
          SetLength(Form3.Content, Length(Form3.Content) + 1);
        end;
      end;
      if Count = 1 then
        ShowMessage('You have inputed ' + IntToStr(Count) + ' file repeatedly')
      else if Count > 1 then
        ShowMessage('You have inputed ' + IntToStr(Count) + ' files repeatedly');
    end;
    FileStatus;
  finally
    Form3.Listbox2.Items.LoadFromFile(Form3.Location[0]);
    Form3.Listbox1.Selected[0] := True;
    Form3.Last := Length(Form3.Location);
    Form4.Show;
    Form4.Alarm.Enabled := True;
  end;
end;

procedure TForm3.ListBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin
  try
    if (Listbox1.ItemIndex < Length(Content)) and (Listbox2.Visible) then
    begin
      Listbox1.Selected[Listbox1.ItemIndex + 1] := True;
      Listbox2.Items.LoadFromFile(Location[Listbox1.ItemIndex]);
      with Content[Listbox1.ItemIndex] do
      begin
        Label7.Caption := IntToStr(Alphabet);
        Label8.Caption := IntToStr(Paragraph);
        Label9.Caption := IntToStr(Punctuation);
        Label11.Caption := IntToStr(Space);
        Label14.Caption := IntToStr(word);
      end;
    end
  except
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  SetLength(Form3.Location, 0);
  Listbox3.Visible := False;
  AllowDropFiles := True;
  SelectDirectoryDialog1.InitialDir := GetCurrentDir;
  Listbox2.Visible := True;
  Label1.Caption := 'Text Analyzer Menu';
  Label2.Caption := 'Number of alphabet character:';
  Label3.Caption := 'Number of paragraphs:';
  Label4.Caption := '';
  Label5.Caption := 'Number of punctuation:';
  Label6.Caption := '';
  Label7.Caption := '0';
  Label8.Caption := '0';
  Label9.Caption := '0';
  Label10.Caption := 'Number of Space:';
  Label11.Caption := '0';
  Label13.Caption := 'WordCount:';
  Label14.Caption := '0';
  Label15.Caption := '';
  Label1.Alignment := taCenter;
  Label4.Alignment := taCenter;
  Label6.Alignment := taCenter;
  Label15.Caption := '';
  Label7.AutoSize := True;
  Label8.AutoSize := True;
  Label9.AutoSize := True;
  Label11.AutoSize := True;
  Timer1.Interval := 1000;
  Timer2.Interval := 1000;
  Timer3.Interval := 1000;
  Timer3.Enabled := False;
  Label6.Visible := False;
  KeyPreview := True;
  Constraints.MaxHeight := 600;
  Constraints.MinHeight := 600;
  Constraints.MaxWidth := 780;
  Constraints.MinWidth := 780;
end;

procedure TForm3.ListBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin
  try
    if (Listbox2.Visible = True) and (Listbox1.ItemIndex > 0) then
    begin
      Form3.Listbox2.Items.LoadFromFile(Form3.Location[Listbox1.ItemIndex - 1]);
      Listbox1.Selected[Listbox1.ItemIndex - 1] := True;
      with Content[Listbox1.ItemIndex] do
      begin
        Label7.Caption := IntToStr(Alphabet);
        Label8.Caption := IntToStr(Paragraph);
        Label9.Caption := IntToStr(Punctuation);
        Label11.Caption := IntToStr(Space);
        Label14.Caption := IntToStr(word);
      end;
    end
  except
  end;
end;

procedure TForm3.Timer1Timer(Sender: TObject);
begin
  Label4.Caption := 'Date/Time: ' + FormatDateTime('yyy-mm-dd hh:nn:ss', Now);
end;

procedure TForm3.Timer2Timer(Sender: TObject);
begin
  Inc(Count);
  if Count = 60 then
  begin
    Count := 0;
    Inc(Hrs);
  end;
  if Hrs = 24 then
  begin
    Hrs := 0;
    Inc(Days);
  end;
  Label6.Caption := 'Working for: ' + TimeToStr(EncodeTime(Days, Hrs, Count, 0));
end;

procedure TForm3.Timer3Timer(Sender: TObject);
begin
  with Form4 do
  begin
    if Second > 0 then
      Dec(Second)
    else if Minute > 0 then
    begin
      Dec(Minute);
      Second := 59;
    end
    else if Hour > 0 then
    begin
      Dec(Hour);
      Minute := 59;
      Second := 59;
    end
    else if (Hour = 0) and (Minute = 0) and (Second = 0) then
    begin
      ShowMessage('Alarm!!!');
      Label15.Visible := False;
      Second := -1;
    end;
    Label15.Caption := 'After ' + IntToStr(Hour) + 'h ' + IntToStr(Minute) +
      'm ' + IntToStr(Second) + 's the alarm will be ring';
  end;
end;

procedure TForm3.ListBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin
  try
    with Listbox2 do
    begin
      if ItemIndex = Content[Listbox1.ItemIndex].Line - 1 then
        Selected[Content[Listbox1.ItemIndex].Line - 1] := True;
      if (SelCount > 0) and (ItemIndex < Content[Listbox1.ItemIndex].Line - 1) then
        Selected[ItemIndex + 1] := True;
      if SelCount = 0 then
        Selected[0] := True;
    end;
  except
  end;
end;

procedure TForm3.Label6DblClick(Sender: TObject);
begin
  Label6.Visible := False;
  Label4.Visible := True;
end;

procedure TForm3.ListBox1Click(Sender: TObject);
var
  Shifted: TShiftState;
  i,j,k,l: integer;
begin
  K := Listbox1.Items.Count;
  L := Listbox1.ItemIndex;
  if K > 0 then
  begin
    ShowMessage('Some of the file is not exist in the original file directory');
    ShowMessage('Please re-select the file');
    for i := 0 to Length(Form3.Location) - 1 do
      if not FileExists(Form3.Location[i]) then
        Form3.Location[i] := '';
    if (i = 0) and (Length(Form3.Location) = 1) and (Form3.Location[i] = '')then
    begin
      Listbox1.Items.Clear;
      Form3.Location[i] := '';
      SetLength(Form3.Location, 0);
      Exit;
    end
    else begin
           j := 0;
           repeat
             if Form3.Location[j] = '' then
               for i := j + 1 to Length(Location) do
                 if Form3.Location[i] = '' then
                   Continue
                 else if Form3.Location[i] <> '' then
                 begin
                  Form3.Location[j] := Form3.Location[i];
                  Form3.Location[i] := '';
                  Continue
                 end;
             Inc(j);
           until j = Length(Location);
         end;
    Listbox1.Items.Clear;
    for i := 0 to Length(Form3.Location) - 1 do
        Listbox1.Items.Add(ExtractFileName(Form3.Location[i]));
    SetLength(Form3.Location, i + 1);
    if K > Listbox1.Items.Count then
    begin
      ShowMessage('Some of the file is not exist in the original file');
      ShowMessage('Please re-select the file');
      Listbox2.Items.Clear;
      Label7.Caption := '0';
      Label8.Caption := '0';
      Label9.Caption := '0';
      Label11.Caption := '0';
      Label14.Caption := '0';
      Exit;
    end;
    if Listbox1.Items.Count = 0 then
    begin
      Listbox2.Items.Clear;
      Label7.Caption := '0';
      Label8.Caption := '0';
      Label9.Caption := '0';
      Label11.Caption := '0';
      Label14.Caption := '0';
      Exit;
    end
    else begin
           FileStatus;
           Shifted := GetKeyShiftState;
           if ssCtrl in Shifted then
             ListBox1.MultiSelect := True;
           Listbox2.Items.LoadFromFile(Form3.Location[L]);
           Listbox1.Selected[L] := True;
           with Content[L] do
           begin
             Label7.Caption := IntToStr(Alphabet);
             Label8.Caption := IntToStr(Paragraph);
             Label9.Caption := IntToStr(Punctuation);
             Label11.Caption := IntToStr(Space);
             Label14.Caption := IntToStr(word);
           end;
        end;
  end;
end;

procedure TForm3.ListBox1DblClick(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute = True then
    FindFile(SelectDirectoryDialog1.FileName);
end;

procedure TForm3.ListBox2DblClick(Sender: TObject);
begin
  if (Listbox1.Items.Count = 0) and (SelectDirectoryDialog1.Execute = True) then
    FindFile(SelectDirectoryDialog1.FileName);
end;

procedure TForm3.ListBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbRight then
    PopUpMenu1.PopUp(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TForm3.Label4DblClick(Sender: TObject);
begin
  Label4.Visible := False;
  Label6.Visible := True;
end;

procedure TForm3.FormDropFiles(Sender: TObject; const FileNames: array of string);
var
  i: integer;
  F: TSearchRec;
begin
  FN := '';
  for i := Low(FileNames) to High(FileNames) do
    FN := FN + FileNames[i];
  for i := 0 to Length(Location) - 1 do
    if FN = Location[i] then
    begin
      ShowMessage('You have input the text file once before!');
      Listbox1.Selected[i] := True;
      Listbox2.Items.LoadFromFile(Location[i]);
      with Content[i] do
      begin
        Label7.Caption := IntToStr(Alphabet);
        Label8.Caption := IntToStr(Paragraph);
        Label9.Caption := IntToStr(Punctuation);
        Label11.Caption := IntToStr(Space);
        Label14.Caption := IntToStr(word);
      end;
      Exit;
    end;
  if (ExtractFileExt(FN) = '.txt') or
    (FindFirst(FN + '\*.*', F.Attr and faAnyFile, F) = 0) then
  begin
    FindFile(FN);
    Form4.Alarm.Enabled := True;
    Form4.Visible := True;
  end
  else
    ShowMessage('Please drag a txt extension file or a folder!');
end;

procedure TForm3.FormClick(Sender: TObject);
var
  i:integer;
begin
   for i:= 0 to Listbox2.Items.Count - 1 do
     Listbox2.Selected[i] := False;
  if Listbox2.MultiSelect = True then
    Listbox2.MultiSelect := False;
  if Listbox1.MultiSelect = True then
  begin
    Listbox1.MultiSelect := False;
    Listbox2.Items.LoadFromFile(Location[Listbox1.ItemIndex]);
    with Content[Listbox1.ItemIndex] do
    begin
      Label7.Caption := IntToStr(Alphabet);
      Label8.Caption := IntToStr(Paragraph);
      Label9.Caption := IntToStr(Punctuation);
      Label11.Caption := IntToStr(Space);
      Label14.Caption := IntToStr(word);
    end;
  end;
end;

procedure TForm3.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  j: integer;
begin
  if ((Key = Ord('S')) or (Key = Ord('s'))) and (Shift = [ssCtrl]) then
    try
      for j := 0 to Listbox1.Items.Count - 1 do
      begin
        if FileSize(Location[j]) > 0 then
          Listbox2.Items.SaveToFile(Location[j]);
      end;
    finally
      ShowMessage('Please restart the program to get the latest data');
    end;
  if (Shift = [ssCtrl]) and ((Key = ord('q')) or (Key = ord('Q'))) and (Form3.Listbox1.Items.Count > 0) then
    Form4.Show;
end;

procedure TForm3.ListBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: boolean);
begin
  try
    with Listbox2 do
    begin
      if ItemIndex = 0 then
        Selected[0] := True;
      if (SelCount > 0) and (ItemIndex >= 1) then
        Selected[Listbox2.ItemIndex - 1] := True;
      if SelCount = 0 then
        Selected[Content[Listbox1.ItemIndex].Line - 1] := True;
    end;
  except
  end;
end;

end.
