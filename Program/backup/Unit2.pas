unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Edit1: TEdit;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure ListBox1Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
  private

  public
    end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Memo2Change(Sender: TObject);
begin

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  Edit1.clear;
end;

procedure TForm2.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TForm2.FormClick(Sender: TObject);
begin

end;

procedure TForm2.ListBox1Click(Sender: TObject);
begin

end;

end.

