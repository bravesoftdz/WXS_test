unit FrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, ShellAPI;

type
  TfAbout = class(TForm)
    lblCopyright: TLabel;
    lblVersion: TLabel;
    mmoVersion: TMemo;
    img1: TImage;
    lblweb: TLabel;
    pnl1: TPanel;
    btn1: TButton;
    lbl1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure lblwebClick(Sender: TObject);
    procedure lblwebMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblwebMouseLeave(Sender: TObject);
  private
    { Private declarations }
    sFilePath : string;
    sWebLink : string;
  public
    { Public declarations }
    /// <summary>
    /// ��ʾ�汾��Ϣ
    /// </summary>
    /// <param name="sNumbers">�ͺ� </param>
    /// <param name="sName">����ȫ��</param>
    procedure ShowAboutInfo( sNumbers, sName,sCompany,sWeb : string );

//    /// <summary>
//    /// �����ʾ�汾��Ϣ
//    /// </summary>
//    procedure AddVersion( sFileName : string );
  end;

var
  fAbout: TfAbout;

implementation

{$R *.dfm}

procedure TfAbout.FormCreate(Sender: TObject);
begin
  sFilePath := ExtractFilePath( Application.ExeName );
end;

procedure TfAbout.img1Click(Sender: TObject);
begin
  Close;
end;

procedure TfAbout.lblwebClick(Sender: TObject);
begin
  ShellExecute(handle,nil,pchar(sWebLink),nil,nil,sw_ShowNormal);
end;

procedure TfAbout.lblwebMouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
  lblweb.Font.Style:=[];
end;

procedure TfAbout.lblwebMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lblweb.Font.Style:=[fsbold,fsunderline]; //�Ӵ֡����»��ߣ�
  Screen.Cursor := crHandPoint;
end;

procedure TfAbout.ShowAboutInfo(sNumbers, sName,sCompany,sWeb : string);
begin
  img1.Picture.LoadFromFile('res\logo\About.png');
  sWebLink := sWeb;
//  lblVersion.Caption := '����汾��'+GetFileFullVersion( Application.ExeName );
  Caption := '���� ' + sNumbers + ' ' +sName;
  lblCopyright.Caption := sCompany;
  lblweb.Caption := sWebLink;
  ShowModal;
end;

end.
