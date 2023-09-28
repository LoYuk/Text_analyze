unit WorkingPanel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm5 }

  TForm5 = class(TForm)
    Label1: TLabel;
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
  private

  public
  end;

var
  Form5: TForm5;

implementation

uses MainMenu,FunctionButton;

{$R *.lfm}

{ TForm5 }

procedure TForm5.ListBox1Click(Sender: TObject);
var
  j: integer;
begin
  try
    case Label1.Caption of
      'SpellCount':
        if Listbox1.ItemIndex <> Listbox1.Count - 1 then
        begin
          val(copy(Listbox1.Items[Listbox1.ItemIndex], 2, pos(':', Listbox1.Items[Listbox1.ItemIndex]) - pos('(', Listbox1.Items[Listbox1.ItemIndex]) - 1), j);
          Form3.Listbox2.Selected[j] := True;
        end
        else
          Listbox1.ClearSelection;
      'SpellCheck': if Listbox1.ItemIndex <> Listbox1.Count - 1 then
        for j := 0 to Form3.Listbox2.Items.Count - 1 do
          if pos(Listbox1.Items[Listbox1.ItemIndex], Form3.Listbox2.Items[j]) > 0 then
          begin
            Form3.Listbox2.Selected[j] := True;
            Form3.Listbox2.MultiSelect := True;
          end
     else
       Listbox1.ClearSelection;
    end;
  except
  end;
end;


end.
