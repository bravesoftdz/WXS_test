unit TestMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uAbout,
  FMX.StdCtrls, FMX.Controls.Presentation;

type
  TForm2 = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.btn1Click(Sender: TObject);
begin
  with TfAbout.Create(nil) do
  begin
    SetCopyRight('2000');
    SetWebSite('http://www.beiyanxing.com');
    SetCompanyName('�����׺�����Ǳ����޹�˾');
//    LoadPicture('d:1.bmp');
    SetVersion('');
    ShowAboutInfo('CKM-2008D', '������ܱ�������ϵͳ');
    Free;
  end;
end;

end.
