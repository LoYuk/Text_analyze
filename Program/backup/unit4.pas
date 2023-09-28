unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus,Unit2;

type

  { TForm4 }

  TForm4 = class(TForm)
    Extract: TButton;
    Search: TButton;
    Replace: TButton;
    SpellCount: TButton;
    SpellCheck: TButton;
    procedure ExtractClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Word : string;
  end;

var
  Form4: TForm4;

implementation
 uses Unit1,Unit3,RegExpr,Unit5;
{$R *.lfm}

{ TForm4 }
 procedure WordExtract(foldername:string);
 var infile, outfile : text;
     i, j : integer;
     n : intger = 0;
     s, t, w,x : string;
     outarr : array[1..10000] of string[100];
     found : boolean;
     Input : string;
   F: TSearchRec;    //the input folder name
 begin
  try
    Input := '';
    Input:= InputBox('FileName','Write down the out-put file name:','');
    if ExecRegExpr('\W',Input)= true then
       begin
         ShowMessage('Please write down a valid file name');
         Exit;
       end;
    if pos(Input,'.txt') = 0 then
       Input := Input + '.txt';
    if Input = '' then
       Input := 'output.txt' ;

   assign(outfile, Input);
   rewrite(outfile);

     for i := 1 to 10000 do
     outarr[i] := '';

  //start reading files
   if FindFirst(FolderName + '\*.*', faAnyFile, F) = 0 then
   begin
       repeat
           if (F.Name <> '.') and (F.Name <> '..') then
           begin
   x:= F.Name;
   assign(infile, FolderName+'\'+x);
   reset(infile);
  while not eof(infile) do
   begin
     readln(infile, s);
     if s = '' then continue; //skip empty lines
     for i := 1 to length(s) do //replace tab with space
       if s[i] = chr(9) then s[i] := ' '; //add extra space at the end
     if (s[length(s)] <> ' ') then s := s + ' ';
     if (s = 'the') or (s = 'The') or (s = 'are') or (s = 'Are') then continue;
    repeat
     //extract a word from file
     w := copy(s, 1, pos(' ', s)-1);
     s := copy(s, pos(' ', s)+1, length(s));

     {
      if (w = '(a)') or (w = '(b)') or (w = '(c)') or (w = '(e)') or (w = '(f)') or (w = '(g)') or
        (w = '(i)') or (w = '(ii)') or (w = '(iii)') or (w = '(iv)') or (w = '(v)') or (w = '(vi)') or
        (w = '(vii)') or (w = '(viii)') or (w = '(ix)') or (w = '(x)') then
        continue;
     }
      if  ExecRegExpr('^()$',w) then
        continue;
     //skip all the punctuations
     t := '';
     for i := 1 to length(w) do
       if (w[i] <= 'Z') and (w[i] >= 'A') then
         t := t + lowercase(w[i])
       else
       if (w[i] > 'z') or (w[i] < 'a') then //skip
       else t := t + w[i];
     w := t;
     //put the extracted string into outarr
     if (length(w) >= 4) then
     begin
       found := false;
       for j := 1 to n do
         if (outarr[j] = w) or (outarr[j] = w+'s') then
         begin
           found := true;
           break;
         end;
       if not found then
       begin
         inc(n);
         outarr[n] := w;
       end;
     end;
    until length(s) <= 1;
   end; //of while not eof
   close(infile);

           end;
   until FindNext(F) <> 0;
   end;

   FindClose(F);
   //save to file
   for i := 1 to n do
     writeln(outfile, outarr[i]);
   close(outfile);
  except
    ShowMessage('couldn''t open the folder!');
  end;
 end;
procedure TForm4.SearchClick(Sender: TObject);
var
  Place :integer;
begin
  Word:= InputBox('WordSearch','Enter Here','');
  Form5.show;
end;
procedure TForm4.ExtractClick(Sender: TObject);
begin
  WordExtract(Form1.FN);
end;
end.

