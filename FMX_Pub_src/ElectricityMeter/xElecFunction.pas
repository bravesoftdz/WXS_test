unit xElecFunction;

interface

uses xElecPoint, Math, xElecLine;

/// <summary>
/// ��֪ A��B�����������������ĺ�����C
/// </summary>
procedure GetCValue(APoint, BPoint, CPoint : TElecPoint);

/// <summary>
/// ��֪���ߺ����߼н��������
/// </summary>
procedure GetOtherValue(APoint, BPoint, CPoint : TElecPoint);

/// <summary>
/// �����Ƕ� ���ѽǶȵ�����0-360�ȷ�Χ�ڣ�
/// </summary>
function AdjustAngle(dAngle : Double) : Double;

/// <summary>
/// ��ȡ�Ƕ���������
/// </summary>
function GetQuadrantSN(dAngle : Double) : Integer;

/// <summary>
/// ��������ĵ���ֵ
/// </summary>
/// <param name="AHigtPoint">�����߶˵�</param>
/// <param name="ALowPoint">�����Ͷ˵�</param>
/// <param name="AOutCurrentPoint">�������ֵ</param>
procedure GetTwoPointCurrent(AHigtPoint, ALowPoint : TElecLine; AOutCurrentPoint : TElecPoint);

implementation

procedure GetTwoPointCurrent(AHigtPoint, ALowPoint : TElecLine; AOutCurrentPoint : TElecPoint);
var
  i : Integer;
  APointA, APointB, APointC : TElecPoint;
  nWID, nWValueIn, nWValueOut : Integer;
  AElecLineIn : TElecLine;
begin
  if Assigned(AHigtPoint) and Assigned(AHigtPoint) and Assigned(AHigtPoint) then
  begin
    APointA := TElecPoint.Create;
    APointB := TElecPoint.Create;
    APointC := TElecPoint.Create;

    if AHigtPoint.CurrentList.Count > 0 then
    begin
      for i := 0 to AHigtPoint.CurrentList.Count - 1 do
      begin
        AElecLineIn := TElecLine(AHigtPoint.CurrentList.Objects[i]);

        nWID := AElecLineIn.WID;
        nWValueIn := AHigtPoint.Current.WeightValue[nWID].WValue;
        nWValueOut := ALowPoint.Current.WeightValue[nWID].WValue;


        if (nWID <> C_WEIGHT_VALUE_INVALID) and
          (nWValueIn <> C_WEIGHT_VALUE_INVALID) and
          (nWValueOut <> C_WEIGHT_VALUE_INVALID) then
        begin
          APointA.Value := AElecLineIn.Current.Value;

          if nWValueOut > nWValueIn then
          begin
            APointA.Angle := AdjustAngle(AElecLineIn.Current.Angle + 180);
          end
          else
          begin
            APointA.Angle := AElecLineIn.Current.Angle;
          end;


          if i = 0 then
          begin
            APointC.Value := APointA.Value;
            APointC.Angle := APointA.Angle;
          end
          else
          begin
            GetCValue(APointA, APointB, APointC);
          end;

          APointB.Value := APointC.Value;
          APointB.Angle := APointC.Angle;
        end;

      end;
    end;
    AOutCurrentPoint.Angle := APointC.Angle;
    AOutCurrentPoint.Value := APointC.Value;

    APointA.Free;
    APointB.Free;
    APointC.Free;

  end;

end;

function GetQuadrantSN(dAngle : Double) : Integer;
var
  dValue : Double;
begin
  dValue := AdjustAngle(dAngle);

  if (dValue >= 0) and (dValue < 90) then
    Result := 1
  else if (dValue >= 90) and (dValue < 180) then
    Result := 2
  else if (dValue >= 180) and (dValue < 270) then
    Result := 3
  else if (dValue >= 270) and (dValue < 360) then
    Result := 4
  else
    Result := 1;
end;

function AdjustAngle(dAngle : Double) : Double;
var
  dTemp : Integer;
begin
  dTemp := Round(dAngle*1000);

  dTemp := dTemp mod 360000;

  Result := dTemp / 1000;

  if Result < 0 then
    Result := 360 + Result;

end;

procedure GetOtherValue(APoint, BPoint, CPoint : TElecPoint);
var
  dABAngle : Double; // ab�н�
  dAngle : Double;
begin
  // �����Ҷ���,c^2=a^2+b^2-2abcosC
  // ���Ҷ���  a/sinA=c/sinC=b/sinB
  if Assigned(APoint) and Assigned(BPoint) and Assigned(CPoint) then
  begin
    dABAngle := BPoint.Angle-APoint.Angle;

    // ֵ
    CPoint.Value := Sqrt(Sqr(APoint.Value) + Sqr(BPoint.Value) -
      2*APoint.Value*BPoint.Value * Cos(DegToRad(dABAngle)));

    // �Ƕ�
    if CPoint.Value* sin(DegToRad(dABAngle)) <> 0 then
    begin
      dAngle := RadToDeg(ArcSin(BPoint.Value/CPoint.Value*sin(DegToRad(dABAngle))));

      CPoint.Angle := APoint.Angle - dAngle;

//      if dAngle > APoint.Angle then
//      begin
//        CPoint.Angle := APoint.Angle + dAngle;
//      end
//      else
//      begin
//        CPoint.Angle := APoint.Angle - dAngle;
//      end;
    end;
  end;
end;

procedure GetCValue(APoint, BPoint, CPoint : TElecPoint);
var
  dABAngle : Double; // ab�н�
  dAngle : Double;
begin
  // �����Ҷ���,c^2=a^2+b^2-2abcosC
  // ���Ҷ���  a/sinA=c/sinC=b/sinB
  if Assigned(APoint) and Assigned(BPoint) and Assigned(CPoint) then
  begin
    dABAngle := abs(180- abs(BPoint.Angle-APoint.Angle));

    // ֵ
    CPoint.Value := Sqrt(Sqr(APoint.Value) + Sqr(BPoint.Value) -
      2*APoint.Value*BPoint.Value * Cos(DegToRad(dABAngle)));

    // �Ƕ�
    if CPoint.Value* sin(DegToRad(dABAngle)) <> 0 then
    begin
      dAngle := RadToDeg(ArcSin(BPoint.Value/CPoint.Value*sin(DegToRad(dABAngle))));



      if BPoint.Angle > APoint.Angle then
      begin
        if abs(BPoint.Angle-APoint.Angle) < 180 then
        begin
          CPoint.Angle := AdjustAngle(APoint.Angle + dAngle);
        end
        else
        begin
          CPoint.Angle := AdjustAngle(APoint.Angle - dAngle);
        end;
      end
      else
      begin
        if abs(BPoint.Angle-APoint.Angle) < 180 then
        begin
          CPoint.Angle := AdjustAngle(APoint.Angle - dAngle);
        end
        else
        begin
          CPoint.Angle := AdjustAngle(APoint.Angle + dAngle);
        end;
      end;

    end;
  end;
end;

end.


