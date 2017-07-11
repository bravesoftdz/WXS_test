unit FrmSimpleInfoList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.Menus, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup, System.Actions,
  Vcl.ActnList, Vcl.XPStyleActnCtrls, Vcl.ActnMan, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, xSimpleInfoControl, FrmSimpleInfo;

type
  TfSimpleInfoList = class(TForm)
    pnlBottom: TPanel;
    btnClose: TButton;
    btnSelect: TButton;
    lvSimpleInfoList: TListView;
    actnmngractmgr1: TActionManager;
    actAddPerson: TAction;
    actDelPerson: TAction;
    actEditInfo: TAction;
    actSearch: TAction;
    actImport: TAction;
    pctnbr1: TPopupActionBar;
    mntmAddPerson: TMenuItem;
    mntmEditInfo: TMenuItem;
    mntmDelPerson: TMenuItem;
    mntmImport: TMenuItem;
    dlgOpen1: TOpenDialog;
    imglstil1: TImageList;
    btnAddPerson: TButton;
    btnEditInfo: TButton;
    btnDelPerson: TButton;
    procedure actAddPersonExecute(Sender: TObject);
    procedure actEditInfoExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actDelPersonExecute(Sender: TObject);
    procedure lvSimpleInfoListDblClick(Sender: TObject);
  private
    { Private declarations }

    /// <summary>
    /// ˢ����
    /// </summary>
    procedure RefurshLV(nIndex : Integer);

    /// <summary>
    /// �����б�
    /// </summary>
    procedure LoadList;
  public
    { Public declarations }
    /// <summary>
    /// ѡ����Ϣ
    /// </summary>
    function SelectInfo : TSimpleInfo;
  end;

var
  fSimpleInfoList: TfSimpleInfoList;

implementation

{$R *.dfm}

{ TfSimpleInfoList }

procedure TfSimpleInfoList.actAddPersonExecute(Sender: TObject);
var
  AInfo : TSimpleInfo;
begin
  AInfo := TSimpleInfo.Create;

  with TfSimpleInfo.Create(Self) do
  begin
    ShowInfo(AInfo);
    if ShowModal = mrOk then
    begin
      SaveInfo;

      if Assigned(ASimpleInfoControl.GetInfoByName(AInfo.SIName)) then
      begin
        Application.MessageBox('�����ظ������������������ƣ�', '����', MB_OK +
          MB_ICONINFORMATION);
        AInfo.Free;
      end
      else
      begin
        with lvSimpleInfoList.Items.Add do
        begin
          Caption := '';
          SubItems.Add('');
          SubItems.Add('');
          Data := AInfo;
        end;
        ASimpleInfoControl.AddInfo(AInfo);
        RefurshLV(lvSimpleInfoList.Items.Count-1);
      end;
    end
    else
    begin
      AInfo.Free;
    end;

    Free;
  end;
end;

procedure TfSimpleInfoList.actDelPersonExecute(Sender: TObject);
var
  AInfo : TSimpleInfo;
  nIndex : Integer;
  i : Integer;
begin
  if lvSimpleInfoList.ItemIndex = -1 then
    Exit;

  nIndex := -1;

  if MessageBox(Handle, 'ȷ��ɾ��ѡ���¼��', '', MB_YESNO + MB_ICONQUESTION)
    = IDYES then
  begin
    for i := lvSimpleInfoList.Items.Count - 1 downto 0 do
    begin
      if lvSimpleInfoList.Items[i].Selected then
      begin
        AInfo := TSimpleInfo(lvSimpleInfoList.Items[i].Data);
        lvSimpleInfoList.Items.Delete(i);
        ASimpleInfoControl.DelInfo(AInfo.SIID);
        nIndex := i;
      end;
    end;

    if nIndex > 0 then
      lvSimpleInfoList.ItemIndex := nIndex - 1;
  end;
end;

procedure TfSimpleInfoList.actEditInfoExecute(Sender: TObject);
var
  AInfo : TSimpleInfo;
begin
  if lvSimpleInfoList.ItemIndex = -1 then
    Exit;

  AInfo := TSimpleInfo(lvSimpleInfoList.Items[lvSimpleInfoList.ItemIndex].Data);

  with TfSimpleInfo.Create(Self) do
  begin
    ShowInfo(AInfo);
    if ShowModal = mrOk then
    begin

      if Assigned(ASimpleInfoControl.GetInfoByName(edtSIName.Text, AInfo)) then
      begin
        Application.MessageBox('�޸�ʧ�ܣ������Ѵ��ڣ����������������ƣ�', '����', MB_OK +
          MB_ICONINFORMATION);
      end
      else
      begin
        SaveInfo;

        ASimpleInfoControl.EditInfo(AInfo);
        RefurshLV(lvSimpleInfoList.ItemIndex);
      end;
    end;
    Free
  end;
end;

procedure TfSimpleInfoList.FormCreate(Sender: TObject);
begin
  Caption := ASimpleInfoControl.SimpleInfoName + '�б�';
  LoadList;
end;

procedure TfSimpleInfoList.LoadList;
var
  i : Integer;
begin
  lvSimpleInfoList.Items.Clear;

  if not Assigned(ASimpleInfoControl) then
    Exit;

  for i := 0 to ASimpleInfoControl.SimpleInfoList.Count - 1 do
  begin
    with lvSimpleInfoList.Items.Add do
    begin
      Caption := '';
      SubItems.Add('');
      SubItems.Add('');
      Data := ASimpleInfoControl.SimpleInfoList.Objects[i];
    end;
    RefurshLV(i);
  end;
end;

procedure TfSimpleInfoList.lvSimpleInfoListDblClick(Sender: TObject);
begin
  actEditInfoExecute(nil);
end;

procedure TfSimpleInfoList.RefurshLV(nIndex: Integer);
var
  AInfo : TSimpleInfo;
begin
  if lvSimpleInfoList.Items.Count > nIndex then
  begin
    AInfo := TSimpleInfo(lvSimpleInfoList.Items[nIndex].Data);
    lvSimpleInfoList.Items[nIndex].Caption := IntToStr(AInfo.SIID);
    lvSimpleInfoList.Items[nIndex].SubItems[0] := AInfo.SIName;
    lvSimpleInfoList.Items[nIndex].SubItems[1] := AInfo.SIRemark1;
  end;
end;

function TfSimpleInfoList.SelectInfo: TSimpleInfo;
begin
  Result := nil;

  lvSimpleInfoList.MultiSelect := False;

  if ShowModal = mrOk then
  begin
    if lvSimpleInfoList.ItemIndex <> -1 then
    begin
      Result := TSimpleInfo(lvSimpleInfoList.Items[lvSimpleInfoList.ItemIndex].Data);
    end;
  end;
end;

end.
