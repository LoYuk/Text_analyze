unit WordSearching;

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
  private

  public
  end;

var
  Form5: TForm5;
implementation
  uses MainMenu,FileDrop,FunctionButton;
{$R *.lfm}

{ TForm5 }

end.

