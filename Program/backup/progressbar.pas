unit ProgressBar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

type

  { TForm6 }

  TForm6 = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form6: TForm6;

implementation
uses FunctionButton;
{$R *.lfm}

{ TForm6 }

procedure TForm6.FormCreate(Sender: TObject);
begin
  Self.ProgressBar1.Min := 0;
  Self.ProgressBar1.Max := Form4.Pointer ;
  Self.ProgressBar1.Enabled := True;
  Self.ProgressBar1.BarShowText := True;
  Self.ProgressBar1.Style := pbstMarquee;
  ProgressBar1.Caption := 'I go to school by bus';
  Self.Label1.Caption := 'sgg';
  Application.ProcessMessages;
end;

end.

