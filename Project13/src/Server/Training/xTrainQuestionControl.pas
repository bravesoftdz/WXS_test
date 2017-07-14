unit xTrainQuestionControl;

interface

uses xTrainQuestionInfo, System.SysUtils, System.Classes, xFunction,
  xTrainQuestionAction, xSortControl, xQuestionInfo;

type
  /// <summary>
  /// ������
  /// </summary>
  TTrainQuestionControl = class
  private
    FTrainQuestionList: TStringList;
    FTrainQuestionAction : TTrainQuestionAction;
    function GetTrainQuestionInfo(nIndex: Integer): TTrainQuestion;

    /// <summary>
    /// ɾ��
    /// </summary>
    procedure DelInfo(nTrainQuestionID : Integer); overload;

  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// �б�
    /// </summary>
    property TrainQuestionList : TStringList read FTrainQuestionList write FTrainQuestionList;
    property TrainQuestionInfo[nIndex:Integer] : TTrainQuestion read GetTrainQuestionInfo;

    /// <summary>
    /// ���
    /// </summary>
    procedure AddTrainQuestion(ATrainQuestionInfo : TTrainQuestion);


    /// <summary>
    /// ɾ��
    /// </summary>
    procedure DelInfo(ATrainQuestion : TTrainQuestion); overload;

    /// <summary>
    /// ������
    /// </summary>
    procedure Rename(ATrainQuestion : TTrainQuestion; sNewName : string);

    /// <summary>
    /// �༭
    /// </summary>
    procedure EditTrainQuestion(ATrainQuestionInfo : TTrainQuestion);

    /// <summary>
    /// ����
    /// </summary>
    procedure LoadTrainQuestion;

    /// <summary>
    /// ���
    /// </summary>
    procedure ClearTrainQuestion;

  end;

implementation

{ TTrainQuestionControl }

procedure TTrainQuestionControl.AddTrainQuestion(
  ATrainQuestionInfo: TTrainQuestion);
begin
  if Assigned(ATrainQuestionInfo) then
  begin
    ATrainQuestionInfo.Tqid := FTrainQuestionAction.GetMaxSN + 1;

    FTrainQuestionList.AddObject('', ATrainQuestionInfo);
    FTrainQuestionAction.AddInfo(ATrainQuestionInfo);
  end;
end;

procedure TTrainQuestionControl.ClearTrainQuestion;
var
  i : Integer;
begin
  for i := FTrainQuestionList.Count - 1 downto 0 do
  begin
    FTrainQuestionAction.DelInfo(TTrainQuestion(FTrainQuestionList.Objects[i]).Tqid);
    TTrainQuestion(FTrainQuestionList.Objects[i]).Free;
    FTrainQuestionList.Delete(i);
  end;
end;

constructor TTrainQuestionControl.Create;
begin
  FTrainQuestionList:= TStringList.Create;
  FTrainQuestionAction := TTrainQuestionAction.Create;

  LoadTrainQuestion;
end;

procedure TTrainQuestionControl.DelInfo(nTrainQuestionID: Integer);
var
  i : Integer;
begin
  for i := FTrainQuestionList.Count - 1 downto 0 do
  begin
    if TTrainQuestion(FTrainQuestionList.Objects[i]).Tqid = nTrainQuestionID then
    begin
      FTrainQuestionAction.DelInfo(nTrainQuestionID);
      TTrainQuestion(FTrainQuestionList.Objects[i]).Free;
      FTrainQuestionList.Delete(i);
      Break;
    end;
  end;
end;

procedure TTrainQuestionControl.DelInfo(ATrainQuestion: TTrainQuestion);
var
  i : Integer;
  AInfo : TTrainQuestion;
begin
  if not Assigned(ATrainQuestion) then
    Exit;

  // Ŀ¼
  if ATrainQuestion.Tqtype = 0 then
  begin

    for i := FTrainQuestionList.Count - 1 downto 0 do
    begin
      AInfo := TTrainQuestion(FTrainQuestionList.Objects[i]);

      if Pos(ATrainQuestion.Tqpath + '\' + ATrainQuestion.Tqqname, AInfo.Tqpath) = 1 then
      begin
        FTrainQuestionAction.DelInfo(AInfo.Tqid);
        AInfo.Free;
        FTrainQuestionList.Delete(i);
      end;
    end;
  end;

  DelInfo(ATrainQuestion.Tqid);

end;

destructor TTrainQuestionControl.Destroy;
begin
  ClearStringList(FTrainQuestionList);
  FTrainQuestionList.Free;
  FTrainQuestionAction.Free;
  inherited;
end;

procedure TTrainQuestionControl.EditTrainQuestion(
  ATrainQuestionInfo: TTrainQuestion);
begin
  FTrainQuestionAction.EditInfo(ATrainQuestionInfo);
end;

function TTrainQuestionControl.GetTrainQuestionInfo(
  nIndex: Integer): TTrainQuestion;
begin
  if (nIndex >= 0) and (nIndex < FTrainQuestionList.Count) then
  begin
    Result := TTrainQuestion(FTrainQuestionList.Objects[nIndex]);
  end
  else
  begin
    Result := nil;
  end;
end;

procedure TTrainQuestionControl.LoadTrainQuestion;
var
  i, nID : Integer;
  AInfo : TTrainQuestion;
  AQuestionInfo : TQuestionInfo;
begin

  FTrainQuestionAction.LoadInfo( FTrainQuestionList);

  for i := FTrainQuestionList.Count - 1 downto 0 do
  begin
    AInfo := TTrainQuestion(FTrainQuestionList.Objects[i]);

    if AInfo.Tqtype = 1 then
    begin
      TryStrToInt(AInfo.Tqremark, nID);

      AQuestionInfo := SortControl.GetQInfo(nID);

      // �������в������򲻼�����ϰ��,��ɾ�����ݿ��еĿ���
      if not Assigned(AQuestionInfo) then
      begin
        FTrainQuestionAction.DelInfo(AInfo.Tqid);
        AInfo.Free;
        FTrainQuestionList.Delete(i);
      end
      else
      begin
        AInfo.Tqqname := AQuestionInfo.QName;
        AInfo.Tqcode1 := AQuestionInfo.QCode;
        AInfo.TqCode2 := AQuestionInfo.QRemark2;
        AInfo.TqRemark := IntToStr(AQuestionInfo.QID);
      end;
    end;
  end;
end;

procedure TTrainQuestionControl.Rename(ATrainQuestion: TTrainQuestion; sNewName : string);
var
  i : Integer;
  AInfo : TTrainQuestion;
begin
  if not Assigned(ATrainQuestion) then
    Exit;

  // Ŀ¼
  if ATrainQuestion.Tqtype = 0 then
  begin

    for i := FTrainQuestionList.Count - 1 downto 0 do
    begin
      AInfo := TTrainQuestion(FTrainQuestionList.Objects[i]);

      if Pos(ATrainQuestion.Tqpath + '\' + ATrainQuestion.Tqqname, AInfo.Tqpath) = 1 then
      begin
        AInfo.Tqpath := StringReplace(AInfo.Tqpath,ATrainQuestion.Tqpath + '\' + ATrainQuestion.Tqqname, ATrainQuestion.Tqpath + '\' + sNewName, []) ;
        FTrainQuestionAction.EditInfo(AInfo);
      end;
    end;
  end;

  ATrainQuestion.Tqqname := sNewName;
  FTrainQuestionAction.EditInfo(ATrainQuestion);
end;

end.






