unit uSortList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, ImgList, ToolWin,
  ActnCtrls, Menus, ActnPopup, Vcl.PlatformDefaultStyleActnCtrls,
  System.Actions, System.ImageList, Vcl.StdCtrls, Vcl.ExtCtrls, uSortInfo,
  xSortControl, xSortInfo, xfunction;

type
  TfSortList = class(TForm)
    lvSortList: TListView;
    actmgr1: TActionManager;
    il1: TImageList;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    pctnbr1: TPopupActionBar;
    A1: TMenuItem;
    C1: TMenuItem;
    D1: TMenuItem;
    pnl1: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnEdit: TButton;
    btnClear: TButton;
    actClear: TAction;
    actLoadList: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure lvSortListDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actLoadListExecute(Sender: TObject);
    procedure lvSortListClick(Sender: TObject);
  private
    { Private declarations }
    FFormSortInfo : TfSortInfo;

    /// <summary>
    /// ˢ��
    /// </summary>
    procedure RefurshAct;

    /// <summary>
    /// ������
    /// </summary>
    procedure AddRecord( ASubSort : TSortInfo );

    /// <summary>
    /// ˢ�����
    /// </summary>
    procedure RefurshGrd( AIndex : Integer );
  public
    { Public declarations }
  end;

var
  fSortList: TfSortList;

implementation

{$R *.dfm}

procedure TfSortList.actAddExecute(Sender: TObject);
var
  AInfo : TSortInfo;
begin
  if Assigned(FFormSortInfo) then
  begin
    AInfo := TSortInfo.Create;

    FFormSortInfo.ShowInfo(AInfo);
    if FFormSortInfo.ShowModal = mrOk then
    begin
      FFormSortInfo.SaveInfo;

      if Assigned(SortControl) then
      begin
        SortControl.AddSort(AInfo);
        AddRecord(AInfo);
      end;
      lvSortList.ItemIndex := lvSortList.Items.Count - 1;
    end
    else
    begin
      AInfo.Free;
    end;
  end;
  RefurshAct;
end;

procedure TfSortList.actClearExecute(Sender: TObject);
begin
  if HintMessage(1, '��ȷ����ռ�¼��?', '��ʾ', hbtYesNo) = hrtYes then
  begin
    lvSortList.Items.Clear;
    SortControl.ClearSrot;
    RefurshAct;
  end;
end;

procedure TfSortList.actDeleteExecute(Sender: TObject);
var
  AInfo : TSortInfo;
begin
  if lvSortList.ItemIndex = -1 then
    exit;

  if MessageBox(Handle, 'ɾ����⽫ͬʱɾ������µĿ��⣬' + #13#10 +
    'ȷ��ɾ�������', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
  begin
    AInfo := TSortInfo( lvSortList.Items[ lvSortList.ItemIndex ].Data );
    SortControl.DelSort(AInfo.SortID);
    lvSortList.Items[ lvSortList.ItemIndex ].Delete;
  end;

  RefurshAct;
end;

procedure TfSortList.actEditExecute(Sender: TObject);
var
  ASortInfo : TSortInfo;
begin
  if lvSortList.ItemIndex = -1 then
    Exit;

  ASortInfo := TSortInfo( lvSortList.Items[ lvSortList.ItemIndex ].Data );

  // �༭
  FFormSortInfo.ShowInfo(ASortInfo);
  if FFormSortInfo.ShowModal = mrOk then
  begin
    FFormSortInfo.SaveInfo;

    SortControl.EditSort(ASortInfo);

    RefurshGrd(lvSortList.ItemIndex);
  end;
end;

procedure TfSortList.actLoadListExecute(Sender: TObject);
var
  i : Integer;
begin
  lvSortList.Clear;

  if Assigned(SortControl) then
  begin
    for i := 0 to SortControl.SortList.Count - 1 do
      AddRecord(SortControl.SortInfo[i]);
  end;
end;

procedure TfSortList.AddRecord(ASubSort: TSortInfo);
var
  oItem : TListItem;
begin
  if Assigned( ASubSort ) then
  begin
    oItem := lvSortList.Items.Add;

    with oItem do
    begin
      Caption := IntToStr( ASubSort.SortID );
      Data := ASubSort;
    end;

    RefurshGrd( lvSortList.Items.IndexOf( oItem ) );
  end;
end;

procedure TfSortList.FormCreate(Sender: TObject);
begin
  FFormSortInfo := TfSortInfo.Create(nil);
end;

procedure TfSortList.FormDestroy(Sender: TObject);
begin
  FFormSortInfo.Free;
end;

procedure TfSortList.FormShow(Sender: TObject);
begin
  actLoadListExecute(nil);
end;

procedure TfSortList.lvSortListClick(Sender: TObject);
begin
  RefurshAct;
end;

procedure TfSortList.lvSortListDblClick(Sender: TObject);
begin
  actEditExecute( nil );
end;

procedure TfSortList.RefurshAct;
begin
  actDelete.Enabled := lvSortList.ItemIndex <> -1;
  actEdit.Enabled := lvSortList.ItemIndex <> -1;
  actClear.Enabled := lvSortList.Items.Count > 0;
end;

procedure TfSortList.RefurshGrd(AIndex: Integer);
var
  oItem : TListItem;
  oSubSort : TSortInfo;
begin
  if ( AIndex > -1 ) and ( AIndex < lvSortList.Items.Count ) then
  begin
    oItem := lvSortList.Items[ aindex ];
    oSubSort := TSortInfo( oitem.Data );

    with oItem.SubItems do
    begin
      Clear;
      Add( oSubSort.SortName );
      Add( oSubSort.SortRemark );
    end;
  end;
end;

end.

