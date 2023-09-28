unit FunctionButton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, ExtCtrls, LCLType, Buttons, ComCtrls, EditBtn;

type
  { TForm4 }

  TForm4 = class(TForm)
    Alarm: TButton;
    OutPut: TButton;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    PopupMenu2: TPopupMenu;
    Extract: TButton;
    Label2: TLabel;
    Search: TButton;
    Replace: TButton;
    SpellCount: TButton;
    SpellCheck: TButton;
    procedure AlarmMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ExtractClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OutPutClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure SpellCheckClick(Sender: TObject);
    procedure SpellCountClick(Sender: TObject);
    procedure ContinueClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure RestartClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    word: string;
    Pointer: integer;
    Time: string;
    Days :integer;
    Hour: integer;
    Minute: integer;
    Second: integer;
    Cnt: integer;
  end;

var
  Form4: TForm4;
  n: integer;
  Button: array of TButton;
  Counter: integer;
  outfile: TextFile;
  outarr,WordBank: array of string;
  Cal :array of TButton;
  Alarm_Option: array of TMenuItem;
  path : TMenuItem;
  Re_s,Re_m,Re_h,Re_d: integer;
implementation

uses MainMenu, RegExpr, WorkingPanel;

{$R *.lfm}
{ TForm4 }

procedure QuickSort(Top,Bottom:integer);
var
  i,j:integer;
  k,temp : string;
begin
  i := Top;
  j := Bottom;
  k := outarr[(Top + Bottom) div 2];
    repeat
    While k > outarr[i] do
      inc(i);
    While k < outarr[j] do
      dec(j);
    if i <= j then
    begin
      Temp := outarr[i];
      outarr[i] := outarr[j];
      outarr[j] := Temp;
      dec(j);
      inc(i);
    end;
  until i > j;
  if Top < j then
    Quicksort(Top,j);
  if i < Bottom then
    QuickSort(i,Bottom);
end;

procedure Extracting(Folder: string);
var
  Code ,No ,i ,H ,M ,L: integer;
  infile :Text;
  s, w: string;
  Found: boolean;
begin
  try
    Assign(infile, Folder);
    reset(infile);
    SetLength(outarr,1);
    outarr[0] := '';
    while not eof(infile) do
    begin
      readln(infile, s);
      if Trim(s) = '' then
        continue;
      for i := 1 to Length(s) do
         if (s[i] = chr(9)) or (ExecRegExpr('\W',s[i])) then
           s[i] := ' ';
      s := AnsiLowerCase(s);
      repeat
        if pos(' ',s) > 0 then
        begin
          w := copy(s, 1, pos(' ', s) - 1);
          s := copy(s, pos(' ', s) + 1, length(s));
          s := TrimLeft(s);
        end
        else begin
               w := s;
               s := '';
             end;
        val(w,No,Code);
        if ExecRegExpr('^()$', w) or (Code = 0) or (Length(w) = 1) then  //  Continue if w = (.....)
          continue;
        if outarr[0] <> '' then
        begin
          H := 0;
          L := Length(outarr) - 1;
          Found := False;
          repeat
            M := (H + L) div 2;
            if w > outarr[M] then         // Binary Search
              H := M + 1
            else if w < outarr[M] then
              L := M - 1
            else
              Found := True;
          until (H > L) or Found;
          if not Found then
          begin
            SetLength(outarr,Length(outarr) + 1);
            outarr[Length(outarr) - 1] := w;
          end;
        end
        else
           outarr[0] := w;
      until s = '';
    end;
  finally
    QuickSort(0,Length(outarr) - 1);
    Close(infile);
  end;
end;

procedure WordExtract;
var
  F: TSearchRec;
  Input: string;
  i:integer;
begin
  try
    try
      SetLength(outarr,0);
      Input := InputBox('Input FileName', 'Write down the out-put file name:', '');
      if ExecRegExpr('[?\/:"<>]', Input) = True then
      begin
        ShowMessage('Please write down a valid file name');
        Exit;
      end;
      if Input = '' then
      begin
        case QuestionDlg('Oops', 'You haven''t input the Out-put file name',mtCustom, [mrYes, 'Use the default file name', mrIgnore, 'Exit'], '') of
          mrYes: Input := 'Default.txt';
          mrCancel: Exit;
          mrIgnore: Exit;
        end;
      end
      else if pos('.txt', Input) = 0 then
        Input := Input + '.txt';
      if (pos('#',Input) = 1) and (Length(Input) > 1) and (Form3.SelectDirectoryDialog1.Execute = True) then
      begin
        Delete(Input,1,1);
        assign(outfile,Form3.SelectDirectoryDialog1.FileName + '\' + Input);
      end
      else
        Assign(outfile,GetCurrentDir + '\' + Input);   // Add a location for one text file only and self-selected location
      rewrite(outfile);
      for i := 0 to Form3.ListBox1.Items.Count - 1 do
         if Form3.Listbox1.Selected[i] = True then
            Extracting(Form3.Location[i]);
      for i := 0 to Length(outarr) - 1 do
        writeln(outfile, outarr[i]);
    except
      ShowMessage('couldn''t open the folder!');
      ShowMessage('Please try again!');
    end;
  finally
    Close(outfile);
    ShowMessage('The file have been saved into ' + GetCurrentDir + '\' + Input);
  end;
end;

procedure TForm4.SearchClick(Sender: TObject);
var
  i,j,Count: integer;
  Temp: string;
begin
  try
    Count := 0;
    Form3.Listbox2.MultiSelect := True;
    Form3.Listbox1.MultiSelect := False;
    Form3.Listbox2.ClearSelection;
    Word := InputBox('WordSearch', 'Enter Here', '');
    if Word = '' then
      Exit;
    if ExecRegExpr('^#',word) = False then
       for j := 0 to Form3.Listbox2.Items.Count - 1 do
       begin
         Temp := Form3.Listbox2.Items[j];
         repeat
           if pos(Word,Temp) > 0 then
           begin
             inc(Count);
             Delete(Temp,1,pos(Word,Temp) + Length(Word));
             Form3.Listbox2.Selected[j] := True;
           end
         until pos(Word,Temp) = 0;
       end
    else begin
           if Length(Word) > 1 then
             Delete(word, 1, 1);
           for j := 0 to Form3.Listbox2.Items.Count - 1 do
           begin
             if pos(Word,Temp) = 0 then
               continue;
             Temp := Trim(Form3.Listbox2.Items[j]) + ' ';
             for i := 1 to Length(Temp) do
                if ExecRegExpr('\W',Temp[i]) = True then
                   Temp[i] := ' ';
             if Temp[Length(Temp)] <> ' ' then
                Temp := Temp + ' ';
             repeat
               if (Temp[pos(Word,Temp) - 1] = ' ') and (Temp[pos(Word,Temp) + Length(Word)] = ' ') then
               begin
                 inc(Count);
                 Form3.Listbox2.Selected[j] := True;
               end;
               Delete(Temp,1,pos(Word,Temp) + Length(Word));
             until pos(Word,Temp) = 0;
           end;
         end;
    case Count of
      0:begin
          ShowMessage('No result has found');
          Form3.Listbox2.MultiSelect := False;
        end;
      1:begin
          ShowMessage(IntToStr(Count) + ' Results have found');
          Form3.Listbox2.MultiSelect := False;
        end;
    else
      ShowMessage(IntToStr(Count) + ' Results have found');
    end;
  except
  end;
end;

procedure TForm4.SpellCheckClick(Sender: TObject);
var
  Bank: Text;
  Number,code ,i ,Hi, Middle, Bottom, j: integer;
  Temp: string;
  Temp3: array of string;
  k: integer = 0;
  Found: boolean;
begin
  try
    Form5.Listbox1.Clear;
    SetLength(WordBank,0);
    SetLength(Temp3,1);
    AssignFile(Bank, GetCurrentDir + '\WordBank.txt');
    reset(Bank);
    while not EOF(Bank) do
    begin
      SetLength(WordBank,Length(WordBank) + 1);
      readln(Bank, WordBank[Length(WordBank) - 1]);  //  Inserting the vocabulary
    end;
    CloseFile(Bank);
    for i := 0 to Form3.Listbox2.Items.Count - 1 do
    begin
      if Trim(Form3.Listbox2.Items[i]) <> '' then
        Temp := AnsiLowerCase(Trim(Form3.Listbox2.Items[i]))
      else
        continue;
      for j := 1 to length(Temp) do
        if ExecRegExpr('\W', Temp[j]) = True then
          Temp[j] := ' ';
      repeat
        Temp := Trim(Temp);
        if pos(' ', Temp) > 0 then
        begin
          Temp3[Length(Temp3) - 1] := copy(Temp, 1, pos(' ', Temp) - 1);
          Temp := copy(Temp, pos(' ', Temp) + 1, length(Temp));
        end
        else begin
              Temp3[Length(Temp3) - 1] := Temp;
              Temp := '';
             end;
        val(Temp3[Length(Temp3) - 1],Number,Code);
        if Code = 0 then
        begin
          Temp3[Length(Temp3) - 1] := '';
          continue;
        end;
        if Temp3[Length(Temp3) - 1] <> ' ' then
           SetLength(Temp3,Length(Temp3) + 1);
      until Temp = '';
    end;
    for k := 0 to Length(Temp3) - 1 do
    begin
      Hi := 1;
      Bottom := Length(WordBank) - 1;
      Found := False;
      repeat
        Middle := (Hi + Bottom) div 2;
        if Temp3[k] > WordBank[Middle] then         // Binary Search
          Hi := Middle + 1
        else if Temp3[k] < WordBank[Middle] then
          Bottom := Middle - 1
        else
          Found := True;
      until (Hi > Bottom) or Found;
      for i := 0 to Form5.Listbox1.Items.Count - 1 do
        if Form5.Listbox1.Items[i] = Temp3[k] then
          Continue;
      if Found = False then
      begin
        Form5.ListBox1.Items.Add(Temp3[k]);
      end;
    end;
  finally
    with Form5.Listbox1.Items do
    begin
      if Count = 1 then
        ShowMessage('There are no mistakes in this passage!')
      else begin
             ShowMessage('Done');
             if Count = 2 then
               ShowMessage('There are ' + IntToStr(Count - 1) + ' mistake in the passage!')
             else
               ShowMessage('There are ' + IntToStr(Count - 1) + ' mistakes in the passage!');
             Form5.Label1.Caption := 'SpellCheck';
             Add('Count: ' + IntToStr(Count - 1));
             Form5.Show;
           end;
    end;
  end;
end;

procedure TForm4.SpellCountClick(Sender: TObject);
var
  Target: string = '';
  z: integer;
  Count: integer = 0;
  Temp,Temp3: string;
  Temp2: string = '';
begin
  Target := Inputbox('Please write down the word you want to count', '', '');
  if Target = '' then
    Exit;
  Form5.Listbox1.Clear;
  for z := 0 to Form3.Listbox2.Items.Count - 1 do
  begin
    if (Form3.listbox2.SelCount > 1) and (Form3.Listbox2.Selected[z] = False) then
        continue;
    if pos(Target,Form3.Listbox2.Items[z]) > 0 then
    begin
      Temp := Form3.Listbox2.Items[z];
      Temp3 := '';
      repeat
        Temp2 := copy(Temp, 1, pos(Target, Temp) + length(Target) - 1);
        Temp := copy(Temp, pos(Target, Temp) + length(Target), length(Temp));
        Form5.Listbox1.Items.Add('(' + IntToStr(z) + ':' +
          IntToStr(pos(Target, Temp2) + length(Temp3)) + ')');
        inc(Count);
        Temp3 := Temp3 + Temp2;
      until pos(Target, Temp) = 0;
    end;
  end;
  if Form5.Listbox1.Items.Count = 0 then
     ShowMessage('The word doesn''t occur in the passage!')
  else begin
         Form5.Label1.Caption := 'SpellCount';
         Form5.Listbox1.Items.Add('Count: ' + IntToStr(Count));
         Form5.Show;
       end;
end;

procedure TForm4.ExtractClick(Sender: TObject);
begin
  WordExtract;
end;

procedure TForm4.FormCreate(Sender: TObject);
var
  Count: integer = 0;
  i: integer;
begin
  Visible := False;
  Constraints.MaxHeight := 275;
  Constraints.MinHeight := 275;
  Constraints.MinWidth := 275 ;
  Constraints.MaxWidth := 275;
  Extract.Caption := 'Extract';
  Search.Caption := 'Search';
  Replace.Caption := 'Replace';
  SpellCount.Caption := 'SpellCount';
  SpellCheck.Caption := 'SpellCheck';
  OutPut.Caption := 'OutPut';
  with Extract do
  begin
    BorderSpacing.Bottom := 20;
    BorderSpacing.Top := 20;
    BorderSpacing.Left := 20;
    BorderSpacing.Right := 40;
    Parent := Self;
    inc(Count);
  end;
  with Search do
  begin
    BorderSpacing.Top := 20;
    AnchorSide[akTop].Side := asrBottom;
    AnchorParallel(akLeft, 0, Extract);
    AnchorSide[akTop].Control := Extract;
    Count := Count + 1;
  end;
  with Replace do
  begin
    BorderSpacing.Top := 20;
    AnchorSide[akTop].Side := asrBottom;
    AnchorParallel(akLeft, 0, Search);
    AnchorSide[akTop].Control := Search;
    Count := Count + 1;
  end;
  with SpellCount do
  begin
    BorderSpacing.Top := 20;
    AnchorSide[akTop].Side := asrBottom;
    AnchorParallel(akLeft, 0, Replace);
    AnchorSide[akTop].Control := Replace;
    Count := Count + 1;
  end;
  with SpellCheck do
  begin
    BorderSpacing.Top := 20;
    AnchorSide[akTop].Side := asrBottom;
    AnchorParallel(akLeft, 0, SpellCount);
    AnchorSide[akTop].Control := SpellCount;
    Count := Count + 1;
  end;
  SetLength(Alarm_Option,3);
  for i := 0 to 3 do
    begin
      Alarm_Option[i] := TMenuItem.Create(PopUpMenu2);
      PopUpMenu2.Items.Add(Alarm_Option[i]);
      Alarm_Option[i].Tag := i;
      case i of
        0:Alarm_Option[i].Caption := 'Pause';
        1:Alarm_Option[i].Caption := 'Stop';
        2:Alarm_Option[i].Caption := 'Restart';
        3:Alarm_Option[i].Caption := 'Continue';
      end;
    end;
  // Select the form size
end;

procedure TForm4.OutPutClick(Sender: TObject);
var
  outputfile:text;
  i:integer = 1;
  FileName:string;
begin
  FileName := 'LogOutPut';
  if SelectDirectoryDialog1.Execute = True then
  begin
    if FileExists(SelectDirectoryDialog1.FileName + '\' + FileName + '.txt') = True then
      repeat
        FileName := FileName + Inttostr(i);
      until FileExists(SelectDirectoryDialog1.FileName + '\' + FileName + '.txt') = False;
    assignfile(outputfile,SelectDirectoryDialog1.FileName + '\' + FileName + '.txt');
    rewrite(outputfile);
    for i := 0 to Form3.Listbox1.Items.Count - 1 do
    with Form3.Content[i] do
    begin
      writeln(outputfile,Form3.Listbox1.Items[i]);
      writeln(outputfile,'  Alphabet:' + inttostr(alphabet));
      writeln(outputfile,'  Figure:' + inttostr(Figure));
      writeln(outputfile,'  Paragraph:' + inttostr(Paragraph));
      writeln(outputfile,'  Punctuation:' + inttostr(Punctuation));
      writeln(outputfile,'  Space:' + inttostr(Space));
      writeln(outputfile,'  Word:' + inttostr(Word));
      writeln(outputfile,'  Line:' + inttostr(Line));
    end;
    writeln(outputfile);
    writeln(outputfile,'Edited Time:' + DateTimetoStr(Now));
    closefile(outputfile);
    ShowMessage('The data has been saved in ' + SelectDirectoryDialog1.FileName);
  end;

end;

procedure TForm4.ReplaceClick(Sender: TObject);
var
  str: string = '';
  Replace_Word: string = '';
  z: integer;
  temp3, temp, temp2: string;
begin
  try
    str := Inputbox('The word you want to replace', 'Enter the word:', '');
    if str = '' then
       Exit;
    Replace_Word := Inputbox('Replace with "' + str + '"', 'Enter the word:', '');
    if Replace_Word = '' then
      repeat
        case QuestionDlg('Oops', 'You haven''t input the word you want to replace with',
            mtCustom, [mrYes, 'Input Again', mrNo, 'Exit'], '') of
          mrYes: Replace_Word :=
              Inputbox('Replace with "' + str + '"', 'Enter the word:', '');
          mrCancel: Exit;
          mrNo: Exit;
        end;
      until (Replace_Word <> '');
    if (Replace_Word = str) then
    begin
      ShowMessage('You have inputted the same word!');
      ShowMessage('Please try again');
      Exit;
    end;
    for z := 0 to Form3.Listbox2.Count - 1 do
    begin
      Temp := Form3.Listbox2.Items[z];
      if (Form3.listbox2.SelCount > 1) and (Form3.Listbox2.Selected[z] = False) then
        continue;
      if pos(str, Form3.Listbox2.Items[z]) > 0 then
      begin
        temp3 := '';
        temp2 := Form3.Listbox2.Items[z];
        repeat
          temp := copy(temp2, 1, pos(str, temp2) - 1);
          temp2 := copy(temp2, pos(str, temp2) + length(str), length(temp2));
          Temp3 := Temp3 + Temp + Replace_Word;
        until pos(str, temp2) = 0;
        Form3.Listbox2.Items[z] := Temp3 + Temp2;
      end;
    end;
      ShowMessage('Success!');
  except
  end;
end;

procedure TForm4.AlarmMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  Temp: string;
  i:integer;
begin
  if Button = mbLeft then
  begin
    Second := 0;
    Minute := 0;
    Hour := 0;
    Days := 0;
    Time := Inputbox('Alarm', 'Enter the time here:', '');
    if Time = '' then
      Exit;
    if Time = '0' then
    begin
      ShowMessage('Please input a correct time!');
      Exit;
    end;
    for i := 1 to Length(Time) do
       if Time[i] in [' ','0'..'9',':'] = False then
       begin
         ShowMessage('Please input a correct time!');
         Exit;
       end;
    Temp := Time;
    repeat
      if pos(':', Temp) > 0 then
      begin
        Temp := copy(Temp, pos(':', Temp) + 1, Length(Temp));
        Inc(Cnt);
      end;
    until pos(':', Temp) = 0;
    case Cnt of
      0: Second := StrToInt(Time);
      1:
      begin
        Minute := StrToInt(copy(Time, 1, pos(':', Time) - 1));
        Second := StrToInt(copy(Time, pos(':', Time) + 1, Length(Time)));
      end;
      2:
      begin
        Hour := StrToInt(copy(Time, 1, pos(':', Time) - 1));
        Time := copy(Time, pos(':', Time) + 1, Length(Time));
        Minute := StrToInt(copy(Time, 1, pos(':', Time) - 1));
        Second := StrToInt(copy(Time, pos(':', Time) + 1, Length(Time)));
      end
      else begin
            ShowMessage('You''ve inputted a wrong number.Please try again!');
            Exit;
           end;
    end;
    if Second > 60 then
      begin
        Minute := Minute + Second div 60;
        Second := Second mod 60;
      end;
    if Minute > 60 then
      begin
        Hour := Hour + Minute div 60;
        Minute := Minute mod 60;
      end;
    Re_s := Second;
    Re_m := Minute;
    Re_h := Hour;
    Form3.Timer3.Enabled := True;
    Form3.Label15.Visible := True;
  end
  else
    with PopUpMenu2 do
    begin
      PopUp(Mouse.CursorPos.X, Mouse.CursorPos.Y);
      Items[0].OnClick := @PauseClick;
      Items[1].OnClick := @StopClick;
      Items[2].OnClick := @RestartClick;
      Items[3].OnClick := @ContinueClick;
    end;
end;

procedure TForm4.PauseClick(Sender: TObject);
begin
  if Form3.Timer3.Enabled then
    Form3.Timer3.Enabled := False;
end;

procedure TForm4.StopClick(Sender: TObject);
begin
  if Form3.Timer3.Enabled then
  begin
   Hour := 0;
   Minute := 0;
   Second := 0;
   Form3.Label15.Visible := False;
  end;
end;

procedure TForm4.RestartClick(Sender: TObject);
begin
 Case QuestionDlg('Confirm','Are you sure to restart the Timer?',mtCustom,[mrYes,'Yes',mrNo,'No'],'') of
   mrYes:;
   mrNo:Exit;
   mrCancel:Exit;
   mrIgnore:Exit;
 end;
 if Form3.Timer3.Enabled then
 begin
   Hour := Re_s;
   Minute :=Re_m;
   Second := Re_h;
 end;
end;

procedure TForm4.ContinueClick(Sender: TObject);
begin
  if (((Hour > 0) or (Minute > 0) or (Second > 0)) and Form3.Label15.Visible = True)then
    Form3.Timer3.Enabled := True;
end;

end.
