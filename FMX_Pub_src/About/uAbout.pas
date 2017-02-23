unit uAbout;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, xFunction,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation, xBaseForm;

type
  TfAbout = class(TfBaseForm)
    img1: TImage;
    lstInfo: TListBox;
    btnClose: TButton;
    lbl1: TLabel;
    lbl2: TLabel;
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
    /// ��ʾ�汾��Ϣ
    /// </summary>
    /// <param name="sModel">�ͺ� ��CKM-S21</param>
    /// <param name="sName">����ȫ�� ��10/0.4KV ������ϵͳ</param>
    procedure ShowAboutInfo( sModel, sName : string; aFontColor: TAlphaColor = TAlphaColorRec.White );


  end;

var
  fAbout: TfAbout;

implementation

{$R *.fmx}

{ TForm2 }

procedure TfAbout.SetVersion(sFileName: string);
begin
  lstInfo.Items[0] := '�汾��' + GetFileVersion;
end;

procedure TfAbout.LoadPicture(sPicName: string);
begin
  if FileExists( sPicName ) then
    img1.Bitmap.LoadFromFile(sPicName);
end;

procedure TfAbout.SetCompanyName(sName: string);
begin
  if sName <> '' then
    lstInfo.Items[1] := '��˾��' + sName
  else
    lstInfo.Items[1] := '';
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
    lstInfo.Items[3] := '��Ȩ���У�'+ sFrom
  else
    lstInfo.Items[3] := '��Ȩ���У�'+ sFrom + ' - ' + sTo;
end;

procedure TfAbout.SetWebSite(aWebSite: string);
begin
  if aWebSite <> '' then
    lstInfo.Items[2] := '��ַ��' + aWebSite
  else
    lstInfo.Items[2] := '';
end;
procedure TfAbout.ShowAboutInfo(sModel, sName: string;
  aFontColor: TAlphaColor);
begin
  lbl1.Text := sModel;
  lbl2.Text := sName;
  lbl1.FontColor := aFontColor;
  lbl2.FontColor := aFontColor;
  ShowModal;
end;

end.
