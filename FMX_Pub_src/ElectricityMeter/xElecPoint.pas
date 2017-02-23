unit xElecPoint;

interface

uses SysUtils, Classes;

const
  /// <summary>
  /// ����Ȩֵ
  /// </summary>
  C_WEIGHT_VALUE_INVALID = 9999;

type
  /// <summary>
  /// Ȩֵ��
  /// </summary>
  TWeightValue = class
  private
    FWID: Integer;
    FWValue: Integer;

  public
    constructor Create;

    /// <summary>
    /// Ȩֵ��С����ͬID��Ȩֵ�����ȨֵС�ĵط�����
    /// </summary>
    property WValue : Integer read FWValue write FWValue;

    /// <summary>
    /// ȨֵID ��ֻ����ͬȨֵ���бȽ�Ȩֵ��С�����壩
    /// </summary>
    property WID : Integer read FWID write FWID;

    /// <summary>
    /// ���Ȩֵ
    /// </summary>
    procedure ClearWValue;

  end;

type
  /// <summary>
  /// ��ĵ����
  /// </summary>
  TElecPoint = class
  private
    FOwner: TObject;
    FAngle: Double;
    FValue: Double;
    FPointName: string;
    FPointSN: string;
    FOnChange: TNotifyEvent;
    FIsLowPoint: Boolean;
    FIsVolRoot: Boolean;
    FIsHighPoint: Boolean;
    FWValueList: TStringList;
    FIsClear: Boolean;
    procedure SetValue(const Value: Double);
    procedure SetAngle(const Value: Double);

    procedure Changed;
    function GetTWeightValue(nWID : Integer): TWeightValue;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ������
    /// </summary>
    property Owner  : TObject read FOwner write FOwner;

    /// <summary>
    /// ����
    /// </summary>
    property PointSN : string read FPointSN write FPointSN;

    /// <summary>
    /// ����������
    /// </summary>
    property PointName : string read FPointName write FPointName;

    /// <summary>
    /// �Ƕ�   ˮƽ����Ϊ0�� ��ֱ����Ϊ90��
    /// </summary>
    property Angle : Double read FAngle write SetAngle;

    /// <summary>
    /// ����ֵ
    /// </summary>
    property Value : Double read FValue write SetValue;

    /// <summary>
    /// ���ֵ
    /// </summary>
    procedure ClearValue;

    /// <summary>
    /// ���Ȩֵ
    /// </summary>
    procedure ClearWValue;

    /// <summary>
    /// Ȩֵ�б�
    /// </summary>
    property WValueList : TStringList read FWValueList write FWValueList;

    /// <summary>
    /// ����ȨֵID��ȡȨֵ����û�л��Զ�������
    /// </summary>
    property WeightValue[nWID:Integer] : TWeightValue read GetTWeightValue;

    /// <summary>
    /// �Ƿ��ǵ����ĵͶ˻����ǵ���
    /// </summary>
    property IsLowPoint : Boolean read FIsLowPoint write FIsLowPoint;

    /// <summary>
    /// �Ƿ��ǵ����߶�(��Ȩֵ�������������Դ��ݵ���ֵ)
    /// </summary>
    property IsHighPoint : Boolean read FIsHighPoint write FIsHighPoint;

    /// <summary>
    /// �Ƿ��ǵ�ѹԴ
    /// </summary>
    property IsVolRoot : Boolean read FIsVolRoot write FIsVolRoot;

    /// <summary>
    /// �Ƿ����ֵ
    /// </summary>
    property IsClear : Boolean read FIsClear write FIsClear;

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChange : TNotifyEvent read FOnChange write FOnChange;

    /// <summary>
    /// ֵ��ֵ
    /// </summary>
    procedure AssignValue(APoint : TElecPoint);
  end;

implementation

{ TElecPoint }

procedure TElecPoint.AssignValue(APoint: TElecPoint);
begin
  if Assigned(APoint) then
  begin
    Angle := APoint.Angle;
    Value := APoint.Value;
  end;
end;

procedure TElecPoint.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TElecPoint.ClearValue;
begin
  FAngle := 0;
  FValue := 0;
  FIsClear := True;
end;

procedure TElecPoint.ClearWValue;
var
  i : Integer;
begin
  for i := 0 to FWValueList.Count - 1 do
  begin
    FWValueList.Objects[i].Free;
  end;

  FWValueList.Clear;
end;

constructor TElecPoint.Create;
begin
  FWValueList := TStringList.Create;
  FAngle := 0;
  FValue := 0;
  FPointName:= '';
  FPointSN:= '';
  FIsLowPoint:= False;
  FIsVolRoot := False;
  FIsHighPoint := False;
  FIsClear := True;
end;

destructor TElecPoint.Destroy;
var
  i : Integer;
begin
  for i := 0 to FWValueList.Count - 1 do
    FWValueList.Objects[i].Free;

  FWValueList.Clear;
  FWValueList.Free;

  inherited;
end;

function TElecPoint.GetTWeightValue(nWID: Integer): TWeightValue;
var
  nIndex : Integer;
begin
  nIndex := FWValueList.IndexOf(IntToStr(nWID));

  if nIndex = -1 then
  begin
    Result := TWeightValue.Create;
    Result.WID := nWID;
    FWValueList.AddObject(IntToStr(nWID), Result);
  end
  else
  begin
    Result := TWeightValue(FWValueList.Objects[nIndex]);
  end;
end;

procedure TElecPoint.SetAngle(const Value: Double);
begin
  if Abs(FAngle - Value) > 0.001 then
  begin
    FAngle := Value;
    Changed;
  end;
end;

procedure TElecPoint.SetValue(const Value: Double);
begin
  if Abs(FValue - Value) > 0.001 then
  begin
    FValue := Value;
    Changed;
  end;
end;

{ TWeightValue }

procedure TWeightValue.ClearWValue;
begin
  FWID    := C_WEIGHT_VALUE_INVALID;
  FWValue := C_WEIGHT_VALUE_INVALID;
end;

constructor TWeightValue.Create;
begin
  ClearWValue;
end;

end.

