unit TestLogMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uLog,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm6 = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.fmx}

procedure TForm6.btn1Click(Sender: TObject);
begin
  with TfLog.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

end.
