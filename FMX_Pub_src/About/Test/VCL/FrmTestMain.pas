unit FrmTestMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FrmAbout;

type
  TForm8 = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.dfm}

procedure TForm8.btn1Click(Sender: TObject);
begin
  with TfAbout.Create(nil) do
  begin
    SetCopyRight('2000');
    SetWebSite('http://www.beiyanxing.com');
    SetCompanyName('�����׺����dfdfdf999999999999999999d�Ǳ����޹�˾');
//    LoadPicture('d:1.bmp');
    SetVersion('');
    ShowCode2('d:\2.png');
    AddStrInfo('2234234234234');
    AddStrInfo('2234234234234');
    AddStrInfo('2234234234234');
    AddStrInfo('2234234234234');

    ShowAboutInfo('CKM-2008sdddddddddddddddddddddddddfsdfsdfsdfsdfD', '������ܱ�����sdfsdfsdfsdfsdfsdfsdf��ϵͳ');
    Free;
  end;
end;

end.
