unit uQuestionList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Controls.Presentation, System.Rtti, FMX.Grid.Style, FMX.Grid,
  System.Actions, FMX.ActnList, FMX.ScrollBox, uSortList, xSortInfo, xSortControl,
  xQuestionInfo, uQuestionInfo, xFunction;

type
  TfQuestionList = class(TForm)
    pnl1: TPanel;
    cbbSortList: TComboBox;
    btnSortManage: TButton;
    lbl1: TLabel;
    strngrdQuestionList: TStringGrid;
    actnlstList: TActionList;
    actAdd: TAction;
    actDel: TAction;
    actUpdate: TAction;
    actSearch: TAction;
    actSearchAll: TAction;
    actClearAll: TAction;
    pnl2: TPanel;
    btnAdd: TButton;
    btnDel: TButton;
    btnEdit: TButton;
    btn3: TButton;
    pnl3: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    strngclmn1: TStringColumn;
    strngclmn2: TStringColumn;
    strngclmn3: TStringColumn;
    strngclmn4: TStringColumn;
    actLoadSort: TAction;
    procedure actLoadSortExecute(Sender: TObject);
    procedure btnSortManageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure actUpdateExecute(Sender: TObject);
    procedure actClearAllExecute(Sender: TObject);
    procedure cbbSortListChange(Sender: TObject);
  private
    { Private declarations }


  protected
    FSortInfo : TSortInfo;
    FFormInfo : TfQuestionInfo;

    /// <summary>
    /// ����������Ϣ����
    /// </summary>
    function CreateQuestionFrom : TfQuestionInfo; virtual;

    /// <summary>
    /// ������⿼��
    /// </summary>
    procedure LoadSortQuestions(ASortInfo : TSortInfo);


    /// <summary>
    /// ˢ��
    /// </summary>
    procedure RefurshAct;

    /// <summary>
    /// ��Ӽ�¼
    /// </summary>
    procedure AddRecord(AInfo : TQuestionInfo);

    /// <summary>
    /// ˢ��StringGrid��¼
    /// </summary>
    procedure RefurshGrd(nIndex : Integer);

    /// <summary>
    /// StringGrid ˫��   �����¼�
    /// </summary>
    procedure GridClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
  public
    { Public declarations }

    /// <summary>
    /// ѡ��һ������
    /// </summary>
    function SelOneQuestion : TQuestionInfo;


  end;

var
  fQuestionList: TfQuestionList;

implementation

{$R *.fmx}

procedure TfQuestionList.actAddExecute(Sender: TObject);
var
  AInfo : TQuestionInfo;
begin
  if Assigned(FFormInfo) then
  begin
    AInfo := TQuestionInfo.Create;

    FFormInfo.ShowInfo(AInfo);
    if FFormInfo.ShowModal = mrOk then
    begin
      FFormInfo.SaveInfo;

      if Assigned(FSortInfo) then
      begin
        FSortInfo.AddQuestion(AInfo);
        AddRecord(AInfo);
      end;
      strngrdQuestionList.SelectRow(strngrdQuestionList.RowCount - 1);
    end
    else
    begin
      AInfo.Free;
    end;
  end;
  RefurshAct;
end;

procedure TfQuestionList.actClearAllExecute(Sender: TObject);
begin
  if HintMessage(1, '��ȷ����ռ�¼��?', '��ʾ', hbtYesNo) = hrtYes then
  begin
    strngrdQuestionList.RowCount := 0;
    FSortInfo.ClearQuestion;
  end;
  RefurshAct;
end;

procedure TfQuestionList.actDelExecute(Sender: TObject);
var
  nValue : integer;
  AInfo : TQuestionInfo;
begin
  nValue := strngrdQuestionList.Selected;
  if nValue = -1 then
    HintMessage(1, '��ѡ��Ҫɾ���ļ�¼', '��ʾ', hbtOk)
  else
  begin
    if HintMessage(1, '��ȷ��ɾ����?', '��ʾ', hbtYesNo) = hrtYes then
    begin
      if (strngrdQuestionList.RowCount > 0) then
      begin
        if strngrdQuestionList.Selected <> -1 then
        begin
          AInfo := FSortInfo.QuestionInfo[strngrdQuestionList.Selected];
          FSortInfo.DelQuestion(AInfo.QID);
          LoadSortQuestions(FSortInfo);
        end;
      end
      else
      begin
        HintMessage(1, '��ѡ��Ҫɾ���ļ�¼', '��ʾ', hbtOk);
      end;
    end;
  end;
  RefurshAct;
end;

procedure TfQuestionList.actLoadSortExecute(Sender: TObject);
var
  i : Integer;
  ASortInfo : TSortInfo;
begin
  cbbSortList.Items.Clear;

  for i := 0 to SortControl.SortList.Count - 1 do
  begin
    ASortInfo := SortControl.SortInfo[i];
    cbbSortList.Items.AddObject(ASortInfo.SortName, ASortInfo);
  end;

  if SortControl.SortList.Count > 0 then
  begin
    cbbSortList.ItemIndex := -1;
    cbbSortList.ItemIndex := 0;
  end;


end;

procedure TfQuestionList.actUpdateExecute(Sender: TObject);
var
  AInfo : TQuestionInfo;
begin
  if strngrdQuestionList.Selected = -1 then
    HintMessage(1, '��ѡ��Ҫ�޸ĵļ�¼!', '��ʾ', hbtOk)
  else
  begin
    AInfo := FSortInfo.QuestionInfo[strngrdQuestionList.Selected];
    if Assigned(AInfo) then
    begin
      FFormInfo.ShowInfo(AInfo);
      if FFormInfo.ShowModal = mrOk then
      begin
        FFormInfo.SaveInfo;

        FSortInfo.EditQuestion(AInfo);

        RefurshGrd(strngrdQuestionList.Selected);
      end;
    end
    else
    begin
      HintMessage(1, '��ѡ��Ҫ�޸ĵļ�¼!', '��ʾ', hbtOk)
    end;
  end;
end;

procedure TfQuestionList.AddRecord(AInfo: TQuestionInfo);
var
  nGrdRowNum : Integer;
begin
  if Assigned(AInfo) and Assigned(FSortInfo) then
  begin
    strngrdQuestionList.RowCount := strngrdQuestionList.RowCount + 1;
    nGrdRowNum := strngrdQuestionList.RowCount - 1;

    with strngrdQuestionList, AInfo do
    begin
      Cells[0, nGrdRowNum] := IntToStr(AInfo.QID);
      Cells[1, nGrdRowNum] := AInfo.QName;
      Cells[2, nGrdRowNum] := AInfo.QDescribe;
      Cells[3, nGrdRowNum] := AInfo.QRemark1;
    end;
  end;
end;

procedure TfQuestionList.btnSortManageClick(Sender: TObject);
begin
  with TfSortList.Create(Self) do
  begin
    ShowModal;
    Free;
  end;
  actLoadSortExecute(nil);
end;

procedure TfQuestionList.cbbSortListChange(Sender: TObject);
begin
  if cbbSortList.ItemIndex <> -1 then
  begin
    FSortInfo := SortControl.SortInfo[cbbSortList.ItemIndex];
    FSortInfo.LoadQuestion;
    LoadSortQuestions(FSortInfo);
  end;
  RefurshAct;
end;

function TfQuestionList.CreateQuestionFrom: TfQuestionInfo;
begin
  Result := TfQuestionInfo.Create(Self);
end;

procedure TfQuestionList.FormCreate(Sender: TObject);
begin
  FFormInfo := CreateQuestionFrom;
  strngrdQuestionList.OnDblClick := GridDblClick;
  strngrdQuestionList.OnClick := GridClick;
end;

procedure TfQuestionList.FormDestroy(Sender: TObject);
begin
  FFormInfo.Free;
end;

procedure TfQuestionList.FormShow(Sender: TObject);
begin
  actLoadSortExecute(nil);
end;

procedure TfQuestionList.GridClick(Sender: TObject);
begin
  RefurshAct;
end;

procedure TfQuestionList.GridDblClick(Sender: TObject);
begin
  actUpdateExecute(nil);
end;

procedure TfQuestionList.LoadSortQuestions(ASortInfo: TSortInfo);
var
  i : Integer;
begin
  strngrdQuestionList.RowCount := 0;
  if Assigned(ASortInfo) then
  begin
    for i := 0 to ASortInfo.QuestionList.Count - 1 do
      AddRecord(ASortInfo.QuestionInfo[i]);
  end;
end;

procedure TfQuestionList.RefurshAct;
begin
  actDel.Enabled := strngrdQuestionList.Selected <> -1;
  actUpdate.Enabled := strngrdQuestionList.Selected <> -1;
  actClearAll.Enabled := strngrdQuestionList.RowCount > 0;
end;

procedure TfQuestionList.RefurshGrd(nIndex: Integer);
var
  AInfo : TQuestionInfo;
begin
  if (nIndex <> -1) and Assigned(FSortInfo) then
  begin
    AInfo := FSortInfo.QuestionInfo[nIndex];

    if Assigned(AInfo) then
    begin
      with strngrdQuestionList, AInfo do
      begin
        Cells[0, nIndex] := IntToStr(AInfo.SortID);
        Cells[1, nIndex] := AInfo.QName;
        Cells[2, nIndex] := AInfo.QDescribe;
        Cells[3, nIndex] := AInfo.QRemark1;
      end;
      strngrdQuestionList.SetFocus;
    end;
  end;
end;

function TfQuestionList.SelOneQuestion: TQuestionInfo;
begin
  pnl2.Visible := False;
  pnl3.Visible := True;

  Result := nil;

  if ShowModal = mrOk then
  begin
    if Assigned(FSortInfo) then
    begin
      if strngrdQuestionList.RowCount > 0 then
      begin
        if strngrdQuestionList.Selected <> -1 then
        begin
          Result := FSortInfo.QuestionInfo[strngrdQuestionList.Selected];
        end;
      end;
    end;
  end;

  pnl2.Visible := True;
  pnl3.Visible := False;
end;

end.
