unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm5 }

  TForm5 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Searching: TButton;
    procedure Memo1Change(Sender: TObject);
    procedure SearchingClick(Sender: TObject);
  private

  public

  end;

var
  Form5: TForm5;
  Place : integer = 0;
implementation
  uses Unit3,Unit4;
{$R *.lfm}

{ TForm5 }

procedure TForm5.SearchingClick(Sender: TObject);
var
  s: string;
  i, Start: Integer;
begin
  Memo1.Clear;
  Memo1.Text:= Form3.Listbox2.Items.Text;
  Start:=Place+1;
  s := Copy(Memo1.Text, Start, length(Memo1.Text)-(Start));
  i := Place(Form4.word, s);
  if (i <> 0) then begin
    Memo1.SelStart := (i-2)+(Start);
    Memo1.SelLength := length(Form4.word);
    memo1.SetFocus;
    Place:= Place + i+ Length(Form4.word)-1;
  end else begin
    ShowMessage('The word is found no further.');
    Place:=0;
  end;

end;

procedure TForm5.Memo1Change(Sender: TObject);
begin
  Place := 0
end;

end.

