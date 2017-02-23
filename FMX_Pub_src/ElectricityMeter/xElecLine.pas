unit xElecLine;

interface

uses xElecPoint, SysUtils, Classes;

type
  /// <summary>
  /// ���߻�һ����
  /// </summary>
  TElecLine = class
  private
    FCurrent: TElecPoint;
    FVoltage: TElecPoint;
    FLineName: string;
    FOnChange: TNotifyEvent;
    FConnPoints: TStringList;
    FOnwner: TObject;
    FCurrentList: TStringList;
    FWID: Integer;

    procedure ValueChange(Sender : TObject);
    function GetConnPointInfo(nIndex: Integer): TElecLine;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ��������
    /// </summary>
    property Onwner : TObject read FOnwner write FOnwner;

    /// <summary>
    /// ������
    /// </summary>
    property LineName : string read FLineName write FLineName;

    /// <summary>
    /// ��ѹ
    /// </summary>
    property Voltage : TElecPoint read FVoltage write FVoltage;

    /// <summary>
    /// ����
    /// </summary>
    property Current : TElecPoint read FCurrent write FCurrent;

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChange : TNotifyEvent read FOnChange write FOnChange;

    /// <summary>
    /// ֵ��ֵ
    /// </summary>
    procedure AssignValue(ALine : TElecLine);

    /// <summary>
    /// ���Ȩֵ
    /// </summary>
    procedure ClearWValue;

    /// <summary>
    /// ���ݵ�ѹֵ
    /// </summary>
    procedure SendVolValue;


    /// <summary>
    /// �ݹ����Ȩֵ
    /// </summary>
    procedure CalcCurrWValue;

    /// <summary>
    /// ���ݵ���ֵ
    /// </summary>
    procedure SendCurrentValue;

    /// <summary>
    /// ȨֵID
    /// </summary>
    property WID : Integer read FWID write FWID;

  public
    /// <summary>
    /// ���ӵ��б�
    /// </summary>
    property ConnPoints : TStringList read FConnPoints write FConnPoints;

    property ConnPointInfo[nIndex:Integer] : TElecLine read GetConnPointInfo;

    /// <summary>
    /// ������ӵ�
    /// </summary>
    procedure ConnPointAdd(APoint : TElecLine; bSetOther : Boolean = True);

    /// <summary>
    /// ɾ�����ӵ�
    /// </summary>
    procedure ConnPointDel(APoint : TElecLine);

    /// <summary>
    /// ��ȡ���ӵ�
    /// </summary>
    function GetConnPoint(APoint : TElecLine): Integer;

    /// <summary>
    /// ������ӵ�
    /// </summary>
    procedure ClearConnPoint;

  public
    /// <summary>
    ///  ʵ������ԭ�������б�
    /// </summary>
    property CurrentList : TStringList read FCurrentList write FCurrentList;

    /// <summary>
    /// ��յ����б�
    /// </summary>
    procedure ClearCurrentList;

    /// <summary>
    /// ��ӵ������б�
    /// </summary>
    procedure AddCurrent(AElecLine : TElecLine);
  end;

implementation

uses xElecFunction;

{ TElecLine }

procedure TElecLine.AddCurrent(AElecLine: TElecLine);
begin
  FCurrentList.AddObject('', AElecLine)
end;

procedure TElecLine.AssignValue(ALine: TElecLine);
begin
  if Assigned(ALine) then
  begin
    FVoltage.AssignValue(ALine.Voltage);
    FCurrent.AssignValue(ALine.Current);
  end;
end;

procedure TElecLine.ConnPointAdd(APoint: TElecLine; bSetOther : Boolean);
var
  nIndex : Integer;
begin
  if Assigned(APoint) then
  begin
    // ���ڵ���ӵ��Է��ڵ�������б���
    if bSetOther then
      APoint.ConnPointAdd(Self, False);

    nIndex := GetConnPoint(APoint);

    if nIndex = -1 then
    begin
      FConnPoints.AddObject('', APoint);
    end;
  end;
end;

procedure TElecLine.CalcCurrWValue;
  procedure SetValue( nWValue, nWID: Integer; AElec : TElecLine);
  var
    i: Integer;
    AConn : TElecLine;
    AConnW, AConnElec : TWeightValue;
    nValue : Integer;
  begin

    AConnElec := AElec.Current.WeightValue[nWID];
    nValue := AConnElec.WValue + 1;


    for i := 0 to AElec.ConnPoints.Count - 1 do
    begin
      AConn := TElecLine(AElec.ConnPoints.Objects[i]);

      AConnW := AConn.Current.WeightValue[nWID];

      if AConnW.WValue > AConnElec.WValue then
      begin
        AConnW.WValue := nValue;

        SetValue(AConnW.WValue, nWID, AConn);
      end;
    end;
  end;
var
  AW : TWeightValue;
begin
  if FCurrent.IsLowPoint and (FCurrent.WValueList.Count > 0) then
  begin
    AW := TWeightValue(FCurrent.WValueList.Objects[0]);
    SetValue(AW.WValue, AW.WID, Self);
  end;

end;

procedure TElecLine.ClearConnPoint;
var
  i : Integer;
begin
  // ɾ���Է��ڵ���ڵ������
  for i := 0 to FConnPoints.Count - 1 do
    TElecLine(FConnPoints.Objects[i]).ConnPointDel(Self);


  FConnPoints.Clear;
end;

procedure TElecLine.ClearCurrentList;
begin
  FCurrentList.Clear;
end;

procedure TElecLine.ClearWValue;
begin
  FCurrent.ClearWValue;
end;

procedure TElecLine.ConnPointDel(APoint: TElecLine);
var
  nIndex : Integer;
begin
  nIndex := GetConnPoint(APoint);

  if nIndex <> -1 then
  begin
    FConnPoints.Delete(nIndex);
  end;
end;

function TElecLine.GetConnPoint(APoint: TElecLine): Integer;
var
  i: Integer;
begin
  Result := -1;

  if Assigned(APoint) then
  begin
    for i := 0 to FConnPoints.Count - 1 do
    begin
      if FConnPoints.Objects[i] = APoint then
      begin
        Result := i;
        Break;
      end;
    end;
  end;
end;

constructor TElecLine.Create;
begin
  FCurrent:= TElecPoint.Create;
  FVoltage:= TElecPoint.Create;
  FConnPoints:= TStringList.Create;
  FCurrentList:= TStringList.Create;

  FCurrent.OnChange := ValueChange;
  FVoltage.OnChange := ValueChange;
  FCurrent.Owner := Self;
  FVoltage.Owner := Self;
  FWID := C_WEIGHT_VALUE_INVALID;
end;

destructor TElecLine.Destroy;
begin
  FCurrent.Free;
  FVoltage.Free;
  FConnPoints.Free;
  FCurrentList.Free;

  inherited;
end;

function TElecLine.GetConnPointInfo(
  nIndex: Integer): TElecLine;
begin
  if (nIndex >= 0) and (nIndex < FConnPoints.Count) then
  begin
    Result := TElecLine(FConnPoints.Objects[nIndex]);
  end
  else
  begin
    Result := nil;
  end;
end;

procedure TElecLine.SendCurrentValue;
  procedure SetValue( AElecRoot, AElec : TElecLine; nWID : Integer);
  var
    i: Integer;
    AConn : TElecLine;
    AConnW, AConnElec : TWeightValue;
  begin

    for i := 0 to AElec.ConnPoints.Count - 1 do
    begin

      AConn := TElecLine(AElec.ConnPoints.Objects[i]);
      AConnW := AConn.Current.WeightValue[nWID];
      AConnElec := AElec.Current.WeightValue[nWID];

      if (AConnW.WValue < AConnElec.WValue) and (AConnW.WValue < C_WEIGHT_VALUE_INVALID) then
      begin
        AConn.AddCurrent(AElecRoot);

        SetValue(AElecRoot, AConn, nWID);
      end;
    end;
  end;
begin
  if FCurrent.IsHighPoint then
  begin
    AddCurrent(Self);
    SetValue( Self, Self, FWID);

  end;
end;

procedure TElecLine.SendVolValue;
  procedure SetValue( dVolValue, dAngle : Double; AElec : TElecLine);
  var
    i: Integer;
    AConn : TElecLine;
  begin
    if Abs(dVolValue) > 0.001 then
    begin
      for i := 0 to AElec.ConnPoints.Count - 1 do
      begin
        AConn := TElecLine(AElec.ConnPoints.Objects[i]);
        if Abs(AConn.Voltage.Value) < 0.0001 then
        begin
          AConn.Voltage.Value := dVolValue;
          AConn.Voltage.Angle := dAngle;
          AConn.Voltage.IsClear := False;

          SetValue(dVolValue,dAngle, AConn);
        end;
      end;
    end;
  end;
begin
  SetValue(FVoltage.Value, FVoltage.Angle, Self);
end;

procedure TElecLine.ValueChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

end.



