unit FrmAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  dxGDIPlusClasses, xFunction;

type
  TfAbout = class(TForm)
    lstInfo: TListBox;
    pnl1: TPanel;
    pnlCode: TPanel;
    lblName: TLabel;
    lblNumbers: TLabel;
    img2: TImage;
    imgMoreInfo: TImage;
    pnl3: TPanel;
    btn1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure lstInfoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    /// <summary>
    /// ��Ȩ��Ϣ
    /// </summary>
    /// <param name="FormYear">��Ȩ��ʼ���,��1998</param>
    /// <param name="ToYear">��Ȩ��ֹ��ݣ���2000</param>
    procedure SetCopyRight(FromYear: string; ToYear: string = '');

    /// <summary>
    /// ���ù�˾����
    /// </summary>
    procedure SetCompanyName(sName: string);

    /// <summary>
    /// ���ù�˾��ַ
    /// </summary>
    procedure SetWebSite(aWebSite: string);

    /// <summary>
    /// ����ͼƬ
    /// </summary>
    /// <param name="sPicName">ͼƬ���������ƣ���������·������չ��,��СΪ470x130</param>
    procedure LoadPicture(sPicName: string);

    /// <summary>
    /// �����ʾ�汾��Ϣ
    /// </summary>
    procedure SetVersion(sFileName: string);

    /// <summary>
    /// ����ַ�����Ϣ
    /// </summary>
    procedure AddStrInfo(sStr : string);

    /// <summary>
    /// ��ʾ�汾��Ϣ
    /// </summary>
    /// <param name="sModel">�ͺ� ��CKM-S21</param>
    /// <param name="sName">����ȫ�� ��10/0.4KV ������ϵͳ</param>
    procedure ShowAboutInfo( sModel, sName : string);

    /// <summary>
    /// ��ʾ��ά����Ϣ
    /// </summary>
    procedure ShowCode2(sFileName : string);

  end;

var
  fAbout: TfAbout;

implementation

{$R *.dfm}

{ TfAbout }

procedure TfAbout.SetVersion(sFileName: string);
begin
  lstInfo.Items.Add('�汾��' + GetFileVersion);
end;

procedure TfAbout.AddStrInfo(sStr: string);
begin
  if sStr <> '' then
    lstInfo.Items.Add(sStr);
end;


procedure TfAbout.btn1Click(Sender: TObject);
begin
  Close;
end;

procedure TfAbout.FormCreate(Sender: TObject);
begin
  lstInfo.Items.Clear;
end;

procedure TfAbout.LoadPicture(sPicName: string);
begin
  if FileExists( sPicName ) then
    img2.Picture.LoadFromFile(sPicName);
end;

procedure TfAbout.lstInfoDblClick(Sender: TObject);
begin
  if lstInfo.ItemIndex <> -1 then
    ShowMessage(lstInfo.Items[lstInfo.ItemIndex]);
end;

procedure TfAbout.SetCompanyName(sName: string);
begin
  if sName <> '' then
    lstInfo.Items.Add('��˾��' + sName);
end;

procedure TfAbout.SetCopyRight(FromYear, ToYear: string);
var
  sFrom, sTo : string;
begin
  if FromYear = '' then
    sFrom := FormatDateTime('YYYY', Now)
  else
    sFrom := FromYear;

  if ToYear = '' then
    sTo := FormatDateTime('YYYY', Now)
  else
    sTo := ToYear;

  if sFrom = sTo then
    lstInfo.Items.Add('��Ȩ���У�'+ sFrom)
  else
    lstInfo.Items.Add('��Ȩ���У�'+ sFrom + ' - ' + sTo);
end;

procedure TfAbout.SetWebSite(aWebSite: string);
begin
  if aWebSite <> '' then
    lstInfo.Items.Add('��ַ��' + aWebSite);
end;
procedure TfAbout.ShowAboutInfo(sModel, sName: string);
begin
  lblNumbers.Caption := sModel;
  lblName.Caption := sName;
  ShowModal;
end;

procedure TfAbout.ShowCode2(sFileName: string);
begin
  pnlCode.Visible := FileExists(sFileName);

  if pnlCode.Visible then
  begin
    imgMoreInfo.Picture.LoadFromFile(sFileName);
  end;
end;

end.
