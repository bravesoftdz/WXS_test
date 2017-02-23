unit xSortInfo;

interface

uses System.Classes, system.SysUtils, xQuestionInfo, xQuestionAction, xFunction;

type
  TSortInfo = class
  private
    FSortid     : Integer   ;
    FSortname   : String    ;
    FSortremark : String    ;
    FQuestionList: TStringList;

    FQuestionAction : TQuestionAction;
    function GetQuestionInfo(nIndex: Integer): TQuestionInfo;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ���ƶ���
    /// </summary>
    procedure Assign(Source : TSortInfo);

    /// <summary>
    /// ���ID
    /// </summary>
    property SortID     : Integer    read FSortid     write FSortid    ;
    /// <summary>
    /// �������
    /// </summary>
    property SortName   : String     read FSortname   write FSortname  ;
    /// <summary>
    /// ��ⱸע
    /// </summary>
    property SortRemark : String     read FSortremark write FSortremark;

    /// <summary>
    /// �����б�
    /// </summary>
    property QuestionList : TStringList read FQuestionList write FQuestionList;
    property QuestionInfo[nIndex : Integer] : TQuestionInfo read GetQuestionInfo;

    /// <summary>
    /// ��ȡ����
    /// </summary>
    function GetQInfo(nQID : Integer) : TQuestionInfo;

    /// <summary>
    /// ��ӿ���
    /// </summary>
    procedure AddQuestion(AQuestion : TQuestionInfo);

    /// <summary>
    /// �༭����
    /// </summary>
    procedure EditQuestion(AQuestion : TQuestionInfo);

    /// <summary>
    /// ɾ������
    /// </summary>
    procedure DelQuestion(nQID : Integer); overload;
    procedure DelQuestion(AQuestion : TQuestionInfo); overload;



    /// <summary>
    /// ��տ���
    /// </summary>
    procedure ClearQuestion;

    /// <summary>
    /// ���ؿ���
    /// </summary>
    procedure LoadQuestion;
  end;

implementation

{ TSortInfo }

procedure TSortInfo.AddQuestion(AQuestion : TQuestionInfo);
begin
  if Assigned(AQuestion) then
  begin
    AQuestion.SortID := FSortid;
    AQuestion.QID := FQuestionAction.GetMaxSN + 1;
    FQuestionList.AddObject('', AQuestion);
    FQuestionAction.AddQuestion(AQuestion);
  end;
end;

procedure TSortInfo.Assign(Source: TSortInfo);
begin
  FSortid     := Source.Sortid;
  FSortname   := Source.Sortname;
  FSortremark := Source.Sortremark;
end;

procedure TSortInfo.ClearQuestion;
begin
  ClearStringList(FQuestionList);
  FQuestionAction.DelQuestion(FSortid);
end;

constructor TSortInfo.Create;
begin
  FQuestionList:= TStringList.Create;
  FQuestionAction := TQuestionAction.Create;
end;

procedure TSortInfo.DelQuestion(nQID: Integer);
var
  i : Integer;
begin
  for i := FQuestionList.Count - 1 downto 0 do
  begin
    if TQuestionInfo(FQuestionList.Objects[i]).QID = nQID then
    begin
      FQuestionAction.DelQuestion(FSortid, nQID);
      TQuestionInfo(FQuestionList.Objects[i]).Free;
      FQuestionList.Delete(i);
      Break;
    end;
  end;
end;

procedure TSortInfo.DelQuestion(AQuestion: TQuestionInfo);
begin
  if Assigned(AQuestion) then
  begin
    DelQuestion(AQuestion.QID);
  end;
end;

destructor TSortInfo.Destroy;
begin
  ClearStringList(FQuestionList);
  FQuestionList.Free;
  FQuestionAction.Free;

  inherited;
end;

procedure TSortInfo.EditQuestion(AQuestion: TQuestionInfo);
begin
  if Assigned(AQuestion) then
    FQuestionAction.EditQuestion(AQuestion);
end;

function TSortInfo.GetQInfo(nQID: Integer): TQuestionInfo;
var
  i : Integer;
begin
  Result := nil;
  for i := FQuestionList.Count - 1 downto 0 do
  begin
    if TQuestionInfo(FQuestionList.Objects[i]).QID = nQID then
    begin
      Result := TQuestionInfo(FQuestionList.Objects[i]);
      Break;
    end;
  end;
end;

function TSortInfo.GetQuestionInfo(nIndex: Integer): TQuestionInfo;
begin
  if (nIndex >= 0) and (nIndex < FQuestionList.Count) then
  begin
    Result := TQuestionInfo(FQuestionList.Objects[nIndex]);
  end
  else
  begin
    Result := nil;
  end;
end;

procedure TSortInfo.LoadQuestion;
begin
  FQuestionAction.LoadQuestion(FSortid, FQuestionList);
end;

end.
