unit U_WE_VECTOR_MAP;

{===============================================================================
  Copyright(c) 2007-2009, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ������ߣ�����ͼ���Ƶ�Ԫ
  + TWE_VECTOR_MAP ����ͼ����
  + TWE_VECTOR_MAP_COLOR ɫ������

===============================================================================}

interface

uses SysUtils, Classes, Windows, Graphics, U_WE_EQUATION_DRAW, U_WE_EQUATION,
  U_WIRING_ERROR, U_WE_EQUATION_MATH, U_WE_EXPRESSION, IniFiles, U_WE_ORGAN,
  Math, Dialogs, Forms, U_WE_PHASE_MAP, System.Types,System.UITypes;

type
  /// <summary>
  /// ɫ������
  /// </summary>
  TWE_VECTOR_MAP_COLOR = class(TPersistent)
  private
    FIniFile : string;

    FPhaseLine: Integer;
    FDotLine: Integer;
    FBackground: Integer;
    FPhaseB: Integer;
    FPhaseC: Integer;
    FPhaseA: Integer;
    FPhaseCB: Integer;
    FPhaseAB: Integer;
  public
    /// <summary>
    /// ����ͼ ��ɫ
    /// </summary>
    property Background  : Integer read FBackground write FBackground;
    /// <summary>
    /// ����ͼ ������ɫ
    /// </summary>
    property DotLine     : Integer read FDotLine write FDotLine;
    /// <summary>
    /// ����ͼ ���� ������ɫ
    /// </summary>
    property PhaseLine   : Integer read FPhaseLine write FPhaseLine;
    /// <summary>
    /// ����ͼ ���� ��һԪ��
    /// </summary>
    property PhaseAB     : Integer read FPhaseAB write FPhaseAB;
    /// <summary>
    /// ����ͼ ���� �ڶ�Ԫ��
    /// </summary>
    property PhaseCB     : Integer read FPhaseCB write FPhaseCB;

    /// <summary>
    /// ����ͼ ���� ��һԪ��
    /// </summary>
    property PhaseA      : Integer read FPhaseA write FPhaseA;
    /// <summary>
    /// ����ͼ ���� �ڶ�Ԫ��
    /// </summary>
    property PhaseB      : Integer read FPhaseB write FPhaseB;
    /// <summary>
    /// ����ͼ ���� ����Ԫ��
    /// </summary>
    property PhaseC      : Integer read FPhaseC write FPhaseC;

    procedure Assign(Source: TPersistent); override;

    constructor Create(sIniFile : string);
    destructor Destroy; override;
  end;

/// <summary>
/// ��ȡ����֮��ĳ��ȺͽǶ� �����Ϊ�����Ŵ�100����ֵ��
/// </summary>
procedure GetLenAngle( dP1x, dP1y, dP2x, dP2y : Double;
  var dLen:Double; var dAngle:Double );

type
  /// <summary>
  /// ����ͼ
  /// </summary>
  TWE_VECTOR_MAP = class( TComponent )
  private
    FMapCenter : TPoint;
    FCanvas : TCanvas;
    FRect : TRect;
    FMapColor : TWE_VECTOR_MAP_COLOR;
    FUnitStep : Integer;
    FPenWidth : Integer;
    FEquationDraw : TWE_EQUATION_DRAW;
    FUIAngle: Double;
  protected
    /// <summary>
    /// ������
    /// </summary>
    procedure DrawBackground( AHasCrossLine, AHasBorder : Boolean );

    /// <summary>
    /// ��ʸ����
    /// </summary>
    procedure DrawLine( APen : TPen; APos : TPoint; ALen, AAngle : Double;
      AHasArrow : Boolean; ASign : string );

    /// <summary>
    /// ���Ƕ�
    /// </summary>
    procedure DrawAngle( APen : TPen; APos : TPoint;
      ARadius, AStartAngle, AEndAngle : Double; AHasArrow : Boolean; ASign : string );

    /// <summary>
    /// ����ͷ
    /// </summary>
    procedure DrawArrow( APen : TPen; APos : TPoint; AAngle : Double );
  protected
    /// <summary>
    /// �Ƕ�ת��, ��ʽ�ͻ�ͼ�ĽǶȲ�ͬ����Ҫת��
    /// </summary>
    function CovAngle( AValue : Double ) : Double;

    /// <summary>
    /// ������Ԫ��
    /// </summary>
    procedure DrawSingleEquation( AOrgan: TWE_ORGAN;
      APen : TPen; APos : TPoint; AAngleRadius : Double );

    /// <summary>
    /// ������ͼ
    /// </summary>
    procedure DrawPhase3Map( ROrgans: TStringList );
    procedure DrawPhase4Map( ROrgans : TStringList );
  published
    /// <summary>
    /// ����
    /// </summary>
    property Canvas : TCanvas read FCanvas write FCanvas;

    /// <summary>
    /// ��ͼ������
    /// </summary>
    property Rect : TRect read FRect write FRect;

    /// <summary>
    /// ��ɫ����
    /// </summary>
    property MapColor : TWE_VECTOR_MAP_COLOR read FMapColor write FMapColor;

    /// <summary>
    /// ��λ����
    /// </summary>
    property UnitStep : Integer read FUnitStep write FUnitStep;

    /// <summary>
    /// ���ʿ��
    /// </summary>
    property PenWidth : Integer read FPenWidth write FPenWidth;

    /// <summary>
    /// UI�нǣ��սǣ�
    /// </summary>
    property UIAngle : Double read FUIAngle write FUIAngle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// <summary>
    /// ��������ͼ
    /// </summary>
    procedure DrawPhaseMap( APhaseType: TWE_PHASE_TYPE; ROrgans: TStringList;
      dUIAngle : Double; sCaption : string = '');

  end;

implementation

{ TWE_VECTOR_MAP }

function TWE_VECTOR_MAP.CovAngle(AValue: Double): Double;
begin
  if AValue >= -90 then
    Result := (90 - AValue) / 180 * Pi
  else
    Result := (- AValue - 270) / 180 * Pi;
end;

constructor TWE_VECTOR_MAP.Create(AOwner: TComponent);
begin
  inherited;
  FEquationDraw := TWE_EQUATION_DRAW.Create( nil ); // ����ʽ
  FMapColor := TWE_VECTOR_MAP_COLOR.Create(ChangeFileExt( Application.ExeName, '.ini' ));
  FUIAngle := 20;
end;

destructor TWE_VECTOR_MAP.Destroy;
begin
  FMapColor.Free;
  FEquationDraw.Free;
  inherited;
end;

procedure TWE_VECTOR_MAP.DrawAngle(APen: TPen; APos: TPoint; ARadius,
  AStartAngle, AEndAngle: Double; AHasArrow: Boolean; ASign: string);
var
  dAngle : Double;
  pts: array[0..3] of TPoint;
  dR : Double;
begin
  if AStartAngle > AEndAngle then
  begin
    dAngle := AStartAngle;
    AStartAngle := AEndAngle;
    AEndAngle := dAngle;
  end;
  if Abs(AStartAngle - AEndAngle) > Pi then
  begin
    dAngle := AStartAngle;
    AStartAngle := AEndAngle;
    AEndAngle := dAngle;
  end;
  
  dR := ARadius* FUnitStep;
  pts[0].X := Round(-dR) + FMapCenter.X;
  pts[0].Y := Round(-dR)+ FMapCenter.Y;
  pts[1].X := Round(dR)+ FMapCenter.X;
  pts[1].Y := Round(dR)+ FMapCenter.Y;
  pts[3].X := Round(dR*Cos(AStartAngle)+ FMapCenter.X);
  pts[3].Y := Round(dR*Sin(AStartAngle)+ FMapCenter.Y);
  pts[2].X := Round(dR*Cos(AEndAngle))+ FMapCenter.X;
  pts[2].Y := Round(dR*Sin(AEndAngle))+ FMapCenter.Y;

  FCanvas.Arc( pts[0].X,pts[0].Y,
      pts[1].X,pts[1].Y,
      pts[2].X,pts[2].Y,
      pts[3].X,pts[3].Y);


  // ����ͷ
  if AHasArrow and (Abs(AStartAngle - AEndAngle)>pi/6) then
  begin
    DrawArrow( APen, pts[3], pi/2 - AStartAngle);
    DrawArrow( APen, pts[2], 2*pi - (AEndAngle+pi/2));
  end;
end;

procedure TWE_VECTOR_MAP.DrawArrow(APen: TPen; APos: TPoint; AAngle: Double);
var
  pArw : TPoint;
  dPosX, dPosY : Double;
begin
  with FCanvas do
  begin
    Pen := APen;

    // ȷ����ͷ��С
    if FUnitStep / 30 > 2 then
      dPosX := - FUnitStep / 30
    else
      dPosX := -2;

    dPosY := dPosX * 2;

    pArw.X := APos.X + Round(dPosY * Cos(AAngle) + dPosX * Sin(AAngle));
    pArw.Y := APos.Y - Round(dPosY * Sin(AAngle) - dPosX * Cos(AAngle));

    Polyline( [ APos, pArw ] );

    dPosX := - dPosX;

    pArw.X := APos.X + Round(dPosY * Cos(AAngle) + dPosX * Sin(AAngle));
    pArw.Y := APos.Y - Round(dPosY * Sin(AAngle) - dPosX * Cos(AAngle));

    Polyline( [ APos, pArw ] );
  end;
end;

procedure TWE_VECTOR_MAP.DrawBackground(AHasCrossLine, AHasBorder: Boolean);
var
  pO, pLen : TPoint;
begin
  if not Assigned( FCanvas ) then
    Exit;

  with FCanvas do
  begin
    Brush.Color := FMapColor.Background;
    Brush.Style := bsSolid;
    FillRect( FRect );

    // ���������꣬���ָ�
    if AHasCrossLine then
    begin
      Pen.Color := FMapColor.DotLine;
      Pen.Style := psDot;
      Pen.Width := FPenWidth;
      pO.X  := ( FRect.Right + FRect.Left ) div 2;
      pO.Y  := ( FRect.Bottom + FRect.Top ) div 2;
      pLen  := Point(  Round( 0.9 * ( FRect.Right - FRect.Left ) / 2 ),
        Round( 0.9 * ( FRect.Bottom - FRect.Top ) / 2 ) );

      Rectangle( pO.X - pLen.X, pO.Y - pLen.Y, pO.X + pLen.X, pO.Y + pLen.Y );

      MoveTo( pO.X - pLen.X, pO.Y );
      LineTo( pO.X + pLen.X, pO.Y );

      MoveTo( pO.X, pO.Y - pLen.Y );
      LineTo( pO.X, pO.Y + pLen.Y );
    end;

    // ���߽�
    if AHasBorder then
    begin
      Pen.Color := FMapColor.DotLine;
      Pen.Style := psSolid;
      Pen.Width := FPenWidth;
      Brush.Style := bsClear;
      Rectangle( FRect );
    end;
  end;
end;

procedure TWE_VECTOR_MAP.DrawLine(APen: TPen; APos: TPoint; ALen, AAngle: Double;
  AHasArrow: Boolean; ASign: string);
var
  pEnd : TPoint;
  pArw : TPoint;
begin
  // ���� �յ� λ��
  pEnd.X := APos.X + Round( FUnitStep * ALen * Cos( AAngle ) );
  pEnd.Y := APos.Y - Round( FUnitStep * ALen * Sin( AAngle ) );

  // ����
  with FCanvas do
  begin
    Pen := APen;
    Polyline( [ APos, pEnd ] );

    // ����ͷ
    if AHasArrow then
      DrawArrow( APen, pEnd, AAngle );
  end;

  if ASign <> '' then
  begin
//    pArw.X := pEnd.X + Round(Cos(AAngle) * FUnitStep/4);
//    pArw.Y := pEnd.Y - Round(Sin(AAngle) * FUnitStep/4);



    if AAngle > 3 * Pi / 2 then              // ��������
    begin
      pArw.X := pEnd.X + FUnitStep div 10;
      pArw.Y := pEnd.Y ;
    end
    else if AAngle > Pi + 0.02 then               // ��������
    begin
      pArw.X := pEnd.X - FUnitStep div 4;
      pArw.Y := pEnd.Y;
    end
    else if AAngle > Pi / 2 then         // �ڶ�����
    begin
      pArw.X := pEnd.X - FUnitStep div 2;
      pArw.Y := pEnd.Y - FUnitStep div 4;
    end
    else              // ��һ����
    begin
      pArw.X := pEnd.X + FUnitStep div 20;
      pArw.Y := pEnd.Y - FUnitStep div 3;
    end;

//    else if AAngle > 0 then
//    begin
//      pArw.X := pEnd.X - Round( FUnitStep * Length( ASign ) / 30 );
//      pArw.Y := pEnd.Y - Round( FUnitStep / 3.5 );
//    end
//    else if AAngle > - Pi / 4 then
//    begin
//      pArw.X := pEnd.X - Round( FUnitStep * Length( ASign ) / 30 );
//      pArw.Y := pEnd.Y - Round( FUnitStep / 3.5 );
//    end
//    else if AAngle > - Pi / 2.5 then
//    begin
//      pArw.X := pEnd.X - Round( FUnitStep * Length( ASign ) / 15 );
//      pArw.Y := pEnd.Y - FUnitStep div 8;
//    end
//    else if AAngle > - Pi / 2 then
//    begin
//      pArw.X := pEnd.X - Round( FUnitStep * Length( ASign ) / 15 );
//      pArw.Y := pEnd.Y - FUnitStep div 8;
//    end
//    else if AAngle > - 3 * Pi / 4 then
//    begin
//      pArw.X := pEnd.X - Round( FUnitStep * Length( ASign ) / 15 );
//      pArw.Y := pEnd.Y - FUnitStep div 8;
//    end
//    else if AAngle > - Pi then
//    begin
//      pArw.X := pEnd.X - Round( FUnitStep * Length( ASign ) / 15 );
//      pArw.Y := pEnd.Y + FUnitStep div 15;
//    end;

    FEquationDraw.DrawText( FCanvas, pArw, ASign, APen.Color,
      FMapColor.Background, FUnitStep / 75 );
  end;
end;

procedure TWE_VECTOR_MAP.DrawPhase3Map( ROrgans: TStringList );
var
  AOrgan: TWE_ORGAN;
  i: Integer;
begin
  // �� �ߵ�ѹ
  with FCanvas do
  begin
    Pen.Style := psSolid;
    Pen.Color := FMapColor.PhaseLine;
    Pen.Width := FPenWidth;
    
    DrawLine( Pen, FMapCenter, 1, pi/2, True, DotVar( 'U' ) + SuffixVar( C_EQ_SIGN_A ) );
    DrawLine( Pen, FMapCenter, 1, DegToRad(330) , True, DotVar( 'U' ) + SuffixVar( C_EQ_SIGN_B ) );
    DrawLine( Pen, FMapCenter, 1, DegToRad(210), True, DotVar( 'U' ) + SuffixVar( C_EQ_SIGN_C ) );
  end;

  for i := 0 to ROrgans.Count - 1 do
  begin
    case i of
      0:FCanvas.Pen.Color := FMapColor.PhaseAB;
      1:FCanvas.Pen.Color := FMapColor.PhaseCB;
    end;

    AOrgan := TWE_ORGAN(ROrgans.Objects[i]);
    DrawSingleEquation( AOrgan, FCanvas.Pen, FMapCenter, 0.3 + 0.1*i );
  end;
end;

procedure TWE_VECTOR_MAP.DrawPhase4Map( ROrgans : TStringList );
var
  i : Integer;
  AOrgan: TWE_ORGAN;
begin
  FCanvas.Pen.Style := psSolid;
  FCanvas.Pen.Width := FPenWidth;
  with FCanvas do
  begin
    Pen.Style := psSolid;
    Pen.Color := FMapColor.PhaseLine;
    Pen.Width := FPenWidth;

    DrawLine( Pen, FMapCenter, 1, pi/2, True, DotVar( 'U' ) + SuffixVar( C_EQ_SIGN_A ) );
    DrawLine( Pen, FMapCenter, 1, DegToRad(330) , True, DotVar( 'U' ) + SuffixVar( C_EQ_SIGN_B ) );
    DrawLine( Pen, FMapCenter, 1, DegToRad(210), True, DotVar( 'U' ) + SuffixVar( C_EQ_SIGN_C ) );
  end;

  for i := 0 to ROrgans.Count - 1 do
  begin
    case i of
      0:FCanvas.Pen.Color := FMapColor.PhaseA;
      1:FCanvas.Pen.Color := FMapColor.PhaseB;
      2:FCanvas.Pen.Color := FMapColor.Phasec;
    end;

    AOrgan := TWE_ORGAN(ROrgans.Objects[i]);
    DrawSingleEquation( AOrgan, FCanvas.Pen, FMapCenter, 0.3 + 0.1*i );
//    Break;
  end;
end;

procedure TWE_VECTOR_MAP.DrawPhaseMap(APhaseType: TWE_PHASE_TYPE;
  ROrgans: TStringList; dUIAngle : Double; sCaption : string);
begin
  FUIAngle := dUIAngle;

  // ��ʼ������
  FMapCenter.X  := ( FRect.Right + FRect.Left )  div 2;
  FMapCenter.Y  := ( FRect.Bottom + FRect.Top )  div 2;

  FUnitStep := ( FRect.Right - FRect.Left )  div 5;
  FPenWidth := FUnitStep div 100;

  if FUnitStep = 0 then
    Exit;
  FMapColor.Background := PhaseMapColor.Background;
  FMapColor.DotLine := PhaseMapColor.DotLine;
  FMapColor.PhaseLine := PhaseMapColor.PhaseLine;
  FMapColor.PhaseAB := PhaseMapColor.PhaseAB;
  FMapColor.PhaseCB := PhaseMapColor.PhaseCB;
  FMapColor.PhaseA := PhaseMapColor.PhaseA;
  FMapColor.PhaseB := PhaseMapColor.PhaseB;
  FMapColor.PhaseC := PhaseMapColor.PhaseC;

  // ������������
  DrawBackground( True, False );

  FCanvas.Font.Size  := Round( FUnitStep /8 );
  FCanvas.Font.Name  := '����';
  FCanvas.Font.Style := [];
  FCanvas.Font.Color := clBlack;

  FCanvas.TextOut(FRect.Right-90, FRect.Top+30, sCaption);


  if APhaseType = ptThree then
    DrawPhase3Map( ROrgans )
  else
    DrawPhase4Map( ROrgans );
end;

procedure TWE_VECTOR_MAP.DrawSingleEquation(AOrgan: TWE_ORGAN;
  APen : TPen; APos: TPoint; AAngleRadius: Double);
var
  dLen, dIAngle, dUAngle : Double;
  AVectorIn, AVectorOut:TVECTOR_LINE;
  dX, dY: Double;
  dTemp, dTemp1 : Double;
  bDraw : Boolean;
  s : string;
begin
  bDraw := True;
  if not Assigned( AOrgan ) then
    Exit;

  if not Assigned( VectorLines ) then
    Exit;

  {��ѹ��}
  //  ��ѹ���յ�
  AVectorIn:=VectorLines.GetLine(AOrgan.UInType);
  AVectorOut:= VectorLines.GetLine(AOrgan.UOutType);

  if Assigned(AVectorIn) and Assigned(AVectorOut) then
  begin
//    AVectorIn.LineName := StringReplace(AVectorIn.LineName, '-', '',[]);
//    AVectorOut.LineName := StringReplace(AVectorOut.LineName, '-', '',[]);
    if AVectorIn.LineAngle = AVectorOut.LineAngle then
      bDraw := False;

    dTemp := DegToRad(AVectorIn.LineAngle);
    dTemp1 := DegToRad(AVectorOut.LineAngle);
    dX := Cos(dTemp)-Cos(dTemp1);
    dY := Sin(dTemp)-Sin(dTemp1);

    if (dX <> 0)or (dY<>0) then
    begin
      // ���㳤�ȺͽǶ�
      GetLenAngle(0,0,dX*100,dY*100, dLen, dUAngle);

      dUAngle := dUAngle + DegToRad(30);
      AOrgan.UAngle := RadToDeg(dUAngle);

      dLen := dLen/100;
      if AOrgan.UParam = pt1_2 then
        dLen := dLen/2;

      // ����
      s := '.'+AOrgan.UType;
      if AOrgan.UParam = pt1_2 then
      s := '{1,2}' + s;

      DrawLine( APen, APos, dLen, dUAngle, True, s );
    end;
  end
  else
  begin
    bDraw := False;
  end;

  {������}
  AVectorIn:=VectorLines.GetLine(AOrgan.IInType);
  AVectorOut:= VectorLines.GetLine(AOrgan.IOutType);

  dLen := 1;

  if Assigned(AVectorIn) then
    AOrgan.IAngle := AVectorIn.LineAngle
  else if Assigned(AVectorOut) then
    AOrgan.IAngle := AVectorOut.LineAngle+180
  else
    AOrgan.IAngle := 90;

  dIAngle := DegToRad(AOrgan.IAngle-FUIAngle);

  // ����
  if Assigned(AVectorIn) or Assigned(AVectorOut) then
  begin
    s := AOrgan.IType;
    Insert('.', s, Pos('-',s)+1);

    DrawLine( APen, APos, dLen, dIAngle, True, s )
  end
  else
    bDraw := False;

  {���Ƕ�}
  if bDraw then
    DrawAngle( APen, APos, AAngleRadius, 2*pi-dUAngle, 2*pi-dIAngle, True, '' );
end;

procedure GetLenAngle(dP1x, dP1y, dP2x, dP2y : Double; var dLen,
  dAngle: Double);
var
  dTemp : Double;
begin
  dLen := Sqrt(Sqr(dP2x-dP1x)+Sqr(dP2y-dP1y));
  dTemp := ArcTan(Abs(dP2y-dP1y)/abs(dP2x-dP1x));

  if dP2y >= dP1y then
  begin
    if dP2x >= dP1x then
      dAngle := dTemp
    else
      dAngle := Pi-dTemp;
  end
  else
  begin
    if dP2x >= dP1x then
      dAngle := 2*Pi-dTemp
    else
      dAngle := Pi+dTemp;
  end;

//  // ת���ɽǶ�
//  dAngle := RadToDeg(dAngle);
end;

{ TWE_VECTOR_MAP_COLOR }

procedure TWE_VECTOR_MAP_COLOR.Assign(Source: TPersistent);
begin
  inherited;
  if Source is TWE_VECTOR_MAP_COLOR then
  begin
    FPhaseLine  := TWE_VECTOR_MAP_COLOR(Source).PhaseLine;
    FDotLine    := TWE_VECTOR_MAP_COLOR(Source).DotLine;
    FBackground := TWE_VECTOR_MAP_COLOR(Source).Background;
    FPhaseB     := TWE_VECTOR_MAP_COLOR(Source).PhaseB;
    FPhaseC     := TWE_VECTOR_MAP_COLOR(Source).PhaseC;
    FPhaseA     := TWE_VECTOR_MAP_COLOR(Source).PhaseA;
    FPhaseCB    := TWE_VECTOR_MAP_COLOR(Source).PhaseCB;
    FPhaseAB    := TWE_VECTOR_MAP_COLOR(Source).PhaseAB;
  end;
end;

constructor TWE_VECTOR_MAP_COLOR.Create(sIniFile: string);
begin
  FIniFile := sIniFile;
  with TIniFile.Create(sIniFile) do
  begin
    FBackground := ReadInteger( 'PhaseMapColor', 'Background', clWhite );
    FDotLine    := ReadInteger( 'PhaseMapColor', 'DotLine', $00D1D1D1 );
    FPhaseLine  := ReadInteger( 'PhaseMapColor', 'PhaseLine', $005E5E5E );
    FPhaseAB    := ReadInteger( 'PhaseMapColor', 'PhaseAB', $003D9DFE );
    FPhaseCB    := ReadInteger( 'PhaseMapColor', 'PhaseCB', clRed     );
    FPhaseA     := ReadInteger( 'PhaseMapColor', 'PhaseA', $003D9DFE );
    FPhaseB     := ReadInteger( 'PhaseMapColor', 'PhaseB', $00009700 );
    FPhaseC     := ReadInteger( 'PhaseMapColor', 'PhaseC', clRed     );
    Free;
  end;
end;

destructor TWE_VECTOR_MAP_COLOR.Destroy;
begin
  with TIniFile.Create(FIniFile) do
  begin
    WriteInteger('VectorMapColor', 'Background', FBackground);
    WriteInteger('VectorMapColor', 'DotLine',    FDotLine   );
    WriteInteger('VectorMapColor', 'PhaseLine',  FPhaseLine );
    WriteInteger('VectorMapColor', 'PhaseAB',    FPhaseAB   );
    WriteInteger('VectorMapColor', 'PhaseCB',    FPhaseCB   );
    WriteInteger('VectorMapColor', 'PhaseA',     FPhaseA    );
    WriteInteger('VectorMapColor', 'PhaseB',     FPhaseB    );
    WriteInteger('VectorMapColor', 'PhaseC',     FPhaseC    );
    Free;
  end;

  inherited;
end;

end.


