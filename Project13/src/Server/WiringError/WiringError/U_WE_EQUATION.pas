{===============================================================================
  Copyright(c) 2007-2009, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ������ߣ���ʽ���㵥Ԫ
  + TWE_EQUATION     ��ʽ����

===============================================================================}

unit U_WE_EQUATION;

interface

uses SysUtils, Classes, math, U_WIRING_ERROR, U_WE_EQUATION_MATH,
  U_WE_EXPRESSION, Dialogs, U_POWER_LIST_INFO;

const
  C_WE_POWER_RIGHT_3 = '#UIcos\o';
  C_WE_POWER_RIGHT_4 = '3UIcos\o';
  C_WE_POWER_RIGHT_SINGLE = 'UIcos\o';

type
  /// <summary>
  /// ������߹�ʽ
  /// </summary>
  TWE_EQUATION = class( TPersistent )
  private
    FExpression : TWE_EXPRESSION;
    FEquationP : TStrings;
    FEquationK : TStrings;
    FAnalysisK : TStrings;
    FPhaseEquations : TList;
    FKValue : Double;
    function GetWiringError : TWIRING_ERROR;
    procedure SetWiringError(const Value: TWIRING_ERROR);
    function GetUIAngle : Double;
    procedure SetUIAngle(const Value: Double);
  private
    FRunTpye: Integer;
	FFourPower: TFourPower;
    FThreePower: TThreePower;
    /// <summary>���� ���߹�ʽ  /// </summary>
    procedure CalEquationP3;
    /// <summary>���� ���߹�ʽ  /// </summary>
    procedure CalEquationP4;
    /// <summary>���� ����PT��ʽ  /// </summary>
    procedure CalEquationP4PT;
    /// <summary>���� ���๫ʽ  /// </summary>
    procedure CalEquationSingle;

    /// <summary>���� ����ϵ��  /// </summary>
    procedure CalEquationK;
    /// <summary>��������ϵ��  /// </summary>
    procedure CalAnalysisK( ACoefs : array of string; AIntCoefs : array of Integer );

    /// <summary>
    /// ���յļ�����
    /// </summary>
    function FinalEquation : string;

    /// <summary>
    /// ������ʽ
    /// </summary>
    procedure AnalysisExpression( APhaseEquation : TWE_PHASE_EXPRESSION );

    /// <summary>
    /// ��չ�ʽ
    /// </summary>
    procedure CleanEquation;

    /// <summary>
    /// �������߱��ʽ
    /// </summary>
    procedure CreateExpression3;

    /// <summary>
    /// �������߱��ʽ
    /// </summary>
    procedure CreateExpression4;

    /// <summary>
    /// ��������PT���ʽ
    /// </summary>
    procedure CreateExpression4PT;


  public
    /// <summary>
    /// ���ɵ�����ʽ
    /// </summary>
    procedure CreateExpressionSingle;
    /// <summary>
    /// ���ʹ�ʽ
    /// </summary>
    property EquationP : TStrings read FEquationP;

    /// <summary>
    /// ����ϵ����ʽ
    /// </summary>
    property EquationK : TStrings read FEquationK;

    /// <summary>
    /// ����ϵ������
    /// </summary>
    property AnalysisK : TStrings read FAnalysisK;

    /// <summary>
    /// UI�н�
    /// </summary>
    property UIAngle : Double read GetUIAngle write SetUIAngle;

    /// <summary>
    /// �������
    /// </summary>
    property WiringError : TWIRING_ERROR read GetWiringError write SetWiringError;

    /// <summary>
    /// �������� 0��ת�� 1��ת�� 2��ת
    /// </summary>
    property RunTpye : Integer read FRunTpye write FRunTpye;

    /// <summary>
    /// ��ǰ����ϵ��Kֵ
    /// </summary>
    property KValue : Double read FKValue write FKValue;
	
    /// <summary>
    /// �������߹��ʶ���
    /// </summary>
    property FourPower : TFourPower read FFourPower write FFourPower;

    /// <summary>
    /// �������߹��ʶ���
    /// </summary>
    property ThreePower : TThreePower read FThreePower write FThreePower;
  public
    constructor Create();
    destructor Destroy; override;

    /// <summary>
    /// ��ȡ�๫ʽ
    /// </summary>
    function GetPhaseEquation( const AIndex : Integer ) : TWE_PHASE_EXPRESSION;

    /// <summary>
    /// ���ɼ��㹫ʽ
    /// </summary>
    procedure GenerateEquations( AWE : TWIRING_ERROR; AUIAngle : Double ); overload;

    /// <summary>
    /// ���ɹ�ʽ
    /// </summary>
    procedure GenerateEquations; overload;

    /// <summary>
    /// ��ʾ����
    /// </summary>
    procedure ShowAnalysis( AText : TStrings; AMaxSize : Integer );
  end;

implementation

{ TWE_EQUATION }

procedure TWE_EQUATION.AnalysisExpression(APhaseEquation : TWE_PHASE_EXPRESSION);
var
  sCoUI, sCoI : string;   // U, I ϵ��
begin
  if not Assigned( APhaseEquation ) then
    Exit;

  with APhaseEquation do        // ��ʼ������
  begin
    Result1  := '';
    Result2  := '';
    CoCos    := '';
    CoSin    := '';
  end;

  sCoUI := '';
  sCoI := '';

  // �����ʽ���Ϊ0
  if APhaseEquation.Expression = '0' then
    Exit;

  with APhaseEquation do
  begin
    //------------------------------------------------------------------------
    // ����UI��ϵ��, ͬʱ���ɽ����ʽ
    //------------------------------------------------------------------------
    // ȡU��ϵ��
    if ExpressU[ 1 ] <> 'U' then
    begin
      sCoUI   := Copy( ExpressU, 1, Pos( 'U', ExpressU ) - 1 );
      sCoUI := StringReplace( sCoUI, '-', '', [] );
    end;

    // ȡI��ϵ��
    if ( Pos( '_a_c', ExpressI ) > 0 ) or
       ( Pos( '_c_a', ExpressI ) > 0 ) then
      sCoI := C_EQ_SIGN_SQRT3;

    if ExpressI[ 1 ] <> 'I' then
    begin
      sCoI := Copy( ExpressI, 1, Pos( 'I', ExpressI ) - 1 ) + sCoI;
      sCoI := StringReplace( sCoI, '-', '', [] );
      CleanSigns( sCoI );
    end;

    // ����UI��ʽ
    Result1 := sCoUI + 'U' + sCoI + 'I';

    // ����ϵ��
    sCoUI := sCoUI + sCoI;
    CleanSigns( sCoUI );

    Result2 := sCoUI + 'UI';

    //------------------------------------------------------------------------
    // ����Cos/Sin��ϵ��, ͬʱ���ɽ����ʽ
    //------------------------------------------------------------------------
    if AngleO = 0 then
    begin
      // cos(0+O) = -cosO
      // cos(0-O) = -cosO
      Result1 := Result1 + 'cos\o';
      Result2 := Result2 + 'cos\o';

      // ����ϵ��
      CoCos := '1'; // ���Ϊ�գ���ϵ��Ϊ +
    end
    else if AngleO = 90 then
    begin
      if SignO then // cos(90+O) = -sinO
      begin
        Result1 := Result1 + '(-sin\o)';
        sCoUI   := '-' + sCoUI;
        Result2 := '-' + Result2 + 'sin\o';
      end
      else
      begin
        Result1 := Result1 + 'sin\o';
        Result2 := Result2 + 'sin\o';
      end;

      // ȥ�����ܳ��ֵ� --
      Result1 := StringReplace( Result1, '--', '', [] );
      Result2 := StringReplace( Result2, '--', '', [] );

      // ����ϵ��
      CoSin := sCoUI + CoSin;
      CoSin := StringReplace( CoSin, '--', '', [] );

      if CoSin = '' then // ���Ϊ�գ���ϵ��Ϊ @
        CoSin := '1';
    end
    else if AngleO = 180 then
    begin
      // cos(180+O) = -cosO
      // cos(180-O) = -cosO
      Result1 := Result1 + '(-cos\o)';

      sCoUI   := '-' + sCoUI;
      Result2 := '-' + Result2 + 'cos\o';

      // ȥ�����ܳ��ֵ� --
      Result1 := StringReplace( Result1, '--', '', [] );
      Result2 := StringReplace( Result2, '--', '', [] );

      // ����ϵ��
      CoCos := sCoUI + CoCos;
      CoCos := StringReplace( CoCos, '--', '', [] );

      if CoCos = '' then // ���Ϊ�գ���ϵ��Ϊ +
        CoCos := '1';
    end
    else
    begin
      // �������ǹ�ʽ����
      // cos(@+O) = cos@cosO-sin@sinO
      // cos(@-O) = cos@cosO+sin@sinO
      CoCos  := 'cos' + IntToStr( AngleO ) + '`';
      CoSin  := 'sin' + IntToStr( AngleO ) + '`';

      if SignO then
        CoSin  := '-' + CoSin;

      // ���ɹ�ʽ1
      Result1 := Result1 + '(' + CoCos + 'cos\o' + '+' + CoSin + 'sin\o)';
      CleanSigns( Result1 );

      // ת��Ϊ����
      ReplaceCosSinWithFrac( CoCos );
      ReplaceCosSinWithFrac( CoSin );

      // ���ɽ��2
      Result2 := Result2 + '(' + CoCos + 'cos\o' + '+' + CoSin + 'sin\o)';
      CleanSigns( Result2 );

      // ���� UIcos, UIsin ϵ��
      CoCos := sCoUI + CoCos;
      CoSin := sCoUI + CoSin;
    end;
  end;
end;

procedure TWE_EQUATION.CalAnalysisK(ACoefs: array of string;
  AIntCoefs: array of Integer);
var
  sCoR, sCoWcos, sCoWsin : string;
  nR, nR3, nWCos, nW3Cos, nWSin, nW3Sin : Integer;
  d : Double;
  dtg : Double;
  dCos : Double;
  sCos : string;
  s : string;
  X, Y1, Y2 : Double;
  dTemp : Double;
  dAngle : Double;
begin
  sCoR    := ACoefs[ 0 ];
  sCoWcos := ACoefs[ 1 ];
  sCoWsin := ACoefs[ 2 ];
  nR     := AIntCoefs[ 0 ];
  nR3    := AIntCoefs[ 1 ];
  nWCos  := AIntCoefs[ 2 ];
  nW3Cos := AIntCoefs[ 3 ];
  nWSin  := AIntCoefs[ 4 ];
  nW3Sin := AIntCoefs[ 5 ];

  X := nR + nR3 * Sqrt( 3 );
  Y1 := nWCos + nW3Cos * Sqrt( 3 );
  Y2 := nWSin + nW3Sin * Sqrt( 3 );

  dAngle := DegToRad(UIAngle);
  dTemp := Cos(dAngle);

  // Xcoso / Y1coso = X/Y1
  if (sCoWcos <> '') and (sCoWsin = '') then
  begin
    try
      d := X / Y1;
      FKValue := d;

      // d = 0 �Ŀ��ܲ�����, ���Ӳ�Ϊ 0
      if d < 0 then
        FAnalysisK.Add('��ת��')
      else if IsZero( d - 1 ) then  // dK = 1 ���ܴ��ڣ���ȷ��
        FAnalysisK.Add('������ȷ��')
      else if d < 1 then
        FAnalysisK.Add('��졣')
      else if d > 1 then
        FAnalysisK.Add('������');

      if d < 0 then
        FRunTpye := 1
      else
        FRunTpye := 0;
    except
      FAnalysisK.Add('��ת��');  // ��ĸΪ 0, ��Ӧ�ô���
      FRunTpye := 2;
    end;
  end
  // Xcoso / Y2Sino = 1 -> tg = X/Y2
  else if (sCoWcos = '') and (sCoWsin <> '') then
  begin
    try
      dtg := X / Y2;
      if (y2* Sin(dAngle)) <> 0 then
        FKValue := (X * Cos(dAngle))/(y2* Sin(dAngle))
      else
        FKValue := 0;

      // cosO^2 = 1 / ( 1 + tgO^2 )
      dCos := Sqrt(1 / ( 1 + Power( dtg, 2 )));
      sCos := FloatToStr( Round( dCos * 1000 ) / 1000 );

      FAnalysisK.Add('�� cos��= 1 ʱ����ת��');

      if dtg < 0 then
      begin
        FAnalysisK.Add('������Ϊ���ԣ�0 < cos�� < 1 ʱ����ת��');
        FAnalysisK.Add('������Ϊ���ԣ�0 < cos�� < 1 ʱ������ת��');
      end
      else
      begin
        FAnalysisK.Add('������Ϊ���ԣ�0 < cos�� < 1 ʱ������ת��');
        FAnalysisK.Add('������Ϊ���ԣ�0 < cos�� < 1 ʱ����ת��');
      end;

      FAnalysisK.Add( Format( '�� cos�� < %s ʱ�� ��졣', [ sCos ] ) );
      FAnalysisK.Add( Format( '�� cos�� > %s ʱ�� ������', [ sCos ] ) );

      if Cos(DegToRad(UIAngle))= 1 then
      begin
        FRunTpye := 2;
      end;

      if dtg < 0 then
      begin
        if UIAngle > 0 then
          FRunTpye := 0
        else
          FRunTpye := 1;
      end
      else
      begin
        if UIAngle > 0 then
          FRunTpye := 1
        else
          FRunTpye := 0;
      end;
    except
    end;
  end
  else
  // K = Xcos / ( Y1Cos + Y2Sin )  ����  sin cos
  begin
    try
      FKValue := (X * Cos(dAngle))/(y1 * Cos(dAngle) + y2* Sin(dAngle));
      // �����ٽ�ֵ������ĸΪ0 �����
      // Y1cos + Y2sin = 0 -> tg = - Y1/Y2
      dtg := - Y1 / Y2;
      dCos := Sqrt(1 / ( 1 + Power( dtg, 2 )));
      sCos := FloatToStr( Round( dCos * 1000 ) / 1000 );

      // �ж� K ����, ����Kֵ
      // tg���ʱ��cos��С
      // K = X / ( Y1 + Y2tg ), X > 0�� ֻ���жϷ�ĸ����
      d := Y1 + ( dtg + 0.1 ) * Y2;

      if Abs(d) > 0 then
        s := '������Ϊ���ԣ�cos�� = %s ʱ����ת��cos�� > %s ʱ����ת��cos�� < %s ʱ������ת��'
      else
        s := '������Ϊ���ԣ�cos�� = %s ʱ����ת��cos�� > %s ʱ������ת��cos�� < %s ʱ����ת��';

      FAnalysisK.Add( Format( s, [ sCos, sCos, sCos ] ) );

      if Abs(d) > 0 then
      begin
        if dTemp < dCos then
          FRunTpye := 1
        else if dTemp = dCos then
          FRunTpye := 2
        else
         FRunTpye := 0;
      end
      else
      begin
        if dTemp < dCos then
          FRunTpye := 0
        else if dTemp = dCos then
          FRunTpye := 2
        else
         FRunTpye := 1;
      end;
    except
    end;

    try
      // ������ȷʱ
      // K = Xcos / ( Y1Cos + Y2Sin ) = 1 -> tg = (X-Y1)/Y2       ����  sin cos
      dtg := ( X - Y1 ) / Y2;

      // coso��ֵ
      dCos := Sqrt(1 / ( 1 + Power( dtg, 2 )));
      sCos := FloatToStr( Round( dCos * 1000 ) / 1000 );

      // ����cosO��Сʱ��Kֵ, dtg���cos��С
      // K = X / ( Y1 + Y2tg )
      if dtg < 0 then
        dtg := dtg - 0.1
      else
        dtg := dtg + 0.1;

      d := X / ( Y1 + ( dtg ) * Y2 );

      if Abs(dtg) > 0 then
        s := '������Ϊ���ԣ�'
      else
        s := '������Ϊ���ԣ�';

      if d > 1 then
        s := s + 'cos�� = %s ʱ��������ȷ��cos�� > %s ʱ����죻cos�� < %s ʱ��������'
      else
        s := s + 'cos�� = %s ʱ��������ȷ��cos�� > %s ʱ��������cos�� < %s ʱ����졣';

      FAnalysisK.Add( Format( s, [ sCos, sCos, sCos ] ) );
    except
    end;

    try
      // ���㷴תʱ������ȷ
      // K = Xcos / ( Y1Cos + Y2Sin ) = -1 -> tg = -(X+Y1)/Y2
      dtg := -( X + Y1 ) / Y2;
      
      // coso��ֵ
      dCos := Sqrt(1 / ( 1 + Power( dtg, 2 )));
      sCos := FloatToStr( Round( dCos * 1000 ) / 1000 );

      if Abs(dtg) > 0 then
        s := '������Ϊ���ԣ�cos�� = %s ʱ��������ȷ����ת��'
      else
        s := '������Ϊ���ԣ�cos�� = %s ʱ��������ȷ����ת��';

      if Abs(dtg) > 0 then
      begin
        if dTemp = dCos then
          FRunTpye := 1
      end;

      FAnalysisK.Add( Format( s, [ sCos ] ) );
    except
    end;
  end;

  FAnalysisK.Add( '����ϵ��KΪ' + FormatFloat('0.000', FKValue));
end;

procedure TWE_EQUATION.CalEquationK;
var
  sEquation : string;
  sRightE : string;
  sWrongE : string;

  // ϵ��
  sCoR, sCoW, sCoWcos, sCoWsin : string;
  s : string;
  sTemp : string;

  FracR, FracR3 : TWE_FRAC;
  FracWCos, FracW3Cos : TWE_FRAC;
  FracWSin, FracW3Sin : TWE_FRAC;
  nFactor, nCommonDen : Integer;
begin
  if FEquationP.Count = 0 then
    Exit;

  if GetWiringError.PhaseType = ptThree then
    sRightE := C_WE_POWER_RIGHT_3
  else if GetWiringError.PhaseType = ptSingle then
    sRightE := C_WE_POWER_RIGHT_SINGLE
  else
    sRightE := C_WE_POWER_RIGHT_4;

  sWrongE := FEquationP[FEquationP.Count -1];

  FEquationK.Add('P/P''');
  FEquationK.Add(sRightE + '/' + sWrongE);

  if sWrongE = '0' then
  begin
    FEquationK.Add('\q');    // �����
    FAnalysisK.Add('��ת��');
    FRunTpye := 2;

    FKValue := -1;
    FAnalysisK.Add( '����ϵ��KΪ �����');
  end
  else if sWrongE = sRightE then
  begin
    FEquationK.Add('1');
    FAnalysisK.Add('������ȷ��');
    FRunTpye := 0;
    FKValue := 1;
    FAnalysisK.Add( '����ϵ��KΪ' + FormatFloat('0.000', FKValue));
  end
  else // ����
  begin
    // 1. ��ȡϵ��
    DivStr( sRightE, 'U', sCoR, s );     // ��ȷ��ʽ

    DivStr( sWrongE, 'U', sCoW, s );     // ����ʽ
    if sCoW = '' then sCoW := '1';
    sCoWsin := '';
    sCoWcos := '';
    s := Copy( s, 3, Length( s ) - 2 );   // ȥ��UI

    if Pos('(', s ) > 0 then
    begin
      // ��ȡ cos, sin ��ϵ��
      s := Copy( s, 2, Length( s ) - 2 );   // ���������, ȥ������
      DivStr( s, 'cos\o', sCoWcos, sTemp );
      s := Copy( sTemp, 6,  Length( sTemp ) - 5 ); // ȥ�� cos\o
      DivStr( s, 'sin\o', sCoWsin, sTemp );
      sCoWcos := sCoW + sCoWcos;
      sCoWsin := sCoW + sCoWsin;
    end
    else
    begin
      if Pos('cos', sWrongE) > 0 then
        sCoWcos := sCoW
      else
        sCoWsin := sCoW;
    end;

    // ��ȡϵ��
    PlusCoefs( [ sCoR ], FracR, FracR3 );
    PlusCoefs( [ sCoWcos ], FracWCos, FracW3Cos );
    PlusCoefs( [ sCoWsin ], FracWSin, FracW3Sin );

    // 2. ϵ������
    // ��ȡ����ĸ, K��ʽ����ͬʱ���Թ���ĸ����������
    nCommonDen := GetCommonDen( [ FracR, FracR3, FracWCos, FracW3Cos, FracWSin,
      FracW3Sin ] );
    
    FracR      := MultiplyFrac( FracR,      nCommonDen );
    FracR3    := MultiplyFrac( FracR3,    nCommonDen );
    FracWCos   := MultiplyFrac( FracWCos,   nCommonDen );
    FracW3Cos := MultiplyFrac( FracW3Cos, nCommonDen );
    FracWSin   := MultiplyFrac( FracWSin,   nCommonDen );
    FracW3Sin := MultiplyFrac( FracW3Sin, nCommonDen );

    // K��ʽ��������������
    nFactor := GetFactor( [ FracR.n, FracR3.n, FracWCos.n, FracW3Cos.n,
      FracWSin.n, FracW3Sin.n ] );

    if ( nFactor > 1 ) or ( nFactor < 0 ) then
    begin
      FracR.n      := FracR.n      div nFactor;
      FracR3.n    := FracR3.n    div nFactor;
      FracWCos.n   := FracWCos.n   div nFactor;
      FracW3Cos.n := FracW3Cos.n div nFactor;
      FracWSin.n   := FracWSin.n   div nFactor;
      FracW3Sin.n := FracW3Sin.n div nFactor;
    end;

    // �����ĸΪ�������򷭵�����
    nFactor := GetFactor( [ FracWCos.n, FracW3Cos.n, FracWSin.n, FracW3Sin.n ] );

    if nFactor < 0 then
    begin
      FracR.n      := FracR.n      * -1;
      FracR3.n    := FracR3.n    * -1;
      FracWCos.n   := FracWCos.n   * -1;
      FracW3Cos.n := FracW3Cos.n * -1;
      FracWSin.n   := FracWSin.n   * -1;
      FracW3Sin.n := FracW3Sin.n * -1;
    end;

    // ���������sqrt3�ı����� ���� 3/4 + sqrt3/4 -> sqrt3( 1/4, sqrt3/4 )
    if HasSqrt3Factor( FracR.n, FracR3.n ) and
       HasSqrt3Factor( FracWCos.n, FracW3Cos.n ) and
       HasSqrt3Factor( FracWSin.n, FracW3Sin.n ) then
    begin
      DivSqrt3( FracR, FracR3 );
      DivSqrt3( FracWCos, FracW3Cos );
      DivSqrt3( FracWSin, FracW3Sin );
    end;

    // 3. ��ʾ������
    sCoR := PlusExpressions( GenCoef( FracR.n, False ), GenCoef( FracR3.n, True ) );
    if sCoR = '' then
      sCoR := '1';
    sCoWcos := PlusExpressions( GenCoef( FracWCos.n, False ), GenCoef( FracW3Cos.n, True ) );
    sCoWsin := PlusExpressions( GenCoef( FracWSin.n, False ), GenCoef( FracW3Sin.n, True ) );

    if sCoWsin = '' then  // *coso/*coso
      sEquation :=  RefinedCoef( Format( C_FMT_FRAC, [ sCoR, sCoWcos ] ) )
    else if sCoWcos = '' then
      sEquation := MultiplyExpressions(
        RefinedCoef( Format( C_FMT_FRAC, [ sCoR, sCoWsin ] ) ), 'ctg\o' )
    else
      sEquation := sCoR + '/' + PlusExpressions( sCoWcos,
        MultiplyExpressions( sCoWsin, 'tg\o' ) );

    FEquationK.Add(sEquation);

    if GetWiringError.PhaseType <> ptSingle then
    begin
      // ����K
      CalAnalysisK( [ sCoR, sCoWcos, sCoWsin ], [ FracR.n, FracR3.n, FracWCos.n,
        FracW3Cos.n, FracWSin.n, FracW3Sin.n ] );
    end;
  end;
end;

procedure TWE_EQUATION.CalEquationP3;
var
  sEquation : string;
begin
  // ��ʽ2
  FEquationP.Add('P_1''+P_2''');

  sEquation := GetPhaseEquation(0).Expression + '+' + GetPhaseEquation(1).Expression;
  CleanSigns( sEquation );
  FEquationP.Add( sEquation );

  if sEquation = '0' then
    Exit;

  // �����ʽ1
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result1,
    GetPhaseEquation(1).Result1 ] );
  FEquationP.Add( sEquation );

  // �����ʽ2
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result2,
    GetPhaseEquation(1).Result2 ] );

  if sEquation <> FEquationP[ FEquationP.Count - 1 ] then
    FEquationP.Add( sEquation );

  // �������ս��
  sEquation := FinalEquation;
  if sEquation <> FEquationP[ FEquationP.Count - 1 ] then
  begin
    FEquationP.Add( sEquation );
  end;
end;

procedure TWE_EQUATION.CalEquationP4;
var
  sEquation : string;
begin
  // ��ʽ2
  FEquationP.Add( 'P_1''+P_2''+P_3''' );

  sEquation := GetPhaseEquation(0).Expression + '+' +
    GetPhaseEquation(1).Expression + '+' + GetPhaseEquation(2).Expression;
  CleanSigns( sEquation );
  FEquationP.Add( sEquation );

  if sEquation = '0' then
    Exit;

  // �����ʽ1
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result1,
    GetPhaseEquation(1).Result1, GetPhaseEquation(2).Result1 ] );
  FEquationP.Add( sEquation );

  // �����ʽ2
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result2,
    GetPhaseEquation(1).Result2, GetPhaseEquation(2).Result2 ] );

  if sEquation <> FEquationP[ FEquationP.Count - 1 ] then
    FEquationP.Add( sEquation );

  // �������ս��
  if sEquation <> FinalEquation then
  begin
    sEquation := FinalEquation;
    FEquationP.Add( sEquation );
  end;
end;

procedure TWE_EQUATION.CalEquationP4PT;
var
  sEquation : string;
begin
  // ��ʽ2
  FEquationP.Add( 'P_1''+P_2''+P_3''' );

  sEquation := GetPhaseEquation(0).Expression + '+' +
    GetPhaseEquation(1).Expression + '+' + GetPhaseEquation(2).Expression;
  CleanSigns( sEquation );
  FEquationP.Add( sEquation );

  if sEquation = '0' then
    Exit;

  // �����ʽ1
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result1,
    GetPhaseEquation(1).Result1, GetPhaseEquation(2).Result1 ] );
  FEquationP.Add( sEquation );

  // �����ʽ2
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result2,
    GetPhaseEquation(1).Result2, GetPhaseEquation(2).Result2 ] );

  if sEquation <> FEquationP[ FEquationP.Count - 1 ] then
    FEquationP.Add( sEquation );

  // �������ս��
  if sEquation <> FinalEquation then
  begin
    sEquation := FinalEquation;
    FEquationP.Add( sEquation );
  end;
end;

procedure TWE_EQUATION.CalEquationSingle;
var
  sEquation : string;
begin
  // ��ʽ2
  FEquationP.Add( 'P_1' );

  sEquation := GetPhaseEquation(0).Expression;
  CleanSigns( sEquation );
  FEquationP.Add( sEquation );

  if sEquation = '0' then
    Exit;

  // �����ʽ1
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result1 ] );
  FEquationP.Add( sEquation );

  // �����ʽ2
  sEquation := CombineExpressions( [ GetPhaseEquation(0).Result2] );

  if sEquation <> FEquationP[ FEquationP.Count - 1 ] then
    FEquationP.Add( sEquation );

  // �������ս��
  if sEquation <> FinalEquation then
  begin
    sEquation := FinalEquation;
    FEquationP.Add( sEquation );
  end;
end;

procedure TWE_EQUATION.CleanEquation;
var
  i: Integer;
begin
  for i := 0 to FPhaseEquations.Count - 1 do
    GetPhaseEquation( i ).Clear;

  FEquationP.Clear;
  FEquationK.Clear;
  FAnalysisK.Clear;
end;

constructor TWE_EQUATION.Create;
var
  i: Integer;
begin
  FExpression := TWE_EXPRESSION.Create;
  FEquationP := TStringList.Create;
  FEquationK := TStringList.Create;
  FAnalysisK := TStringList.Create;
  FPhaseEquations := TList.create;

  FFourPower:= TFourPower.create;
  FThreePower:= TThreePower.create;


  for i := 0 to 3 - 1 do
    FPhaseEquations.Add( TWE_PHASE_EXPRESSION.Create );

  FRunTpye := 0;
end;

procedure TWE_EQUATION.CreateExpression3;
  function GetUValue(sValue : string):Double;
  begin
    if sValue = '' then
      Result := -1
    else if Pos(C_EQ_SIGN_1_2, sValue) > 0 then
      Result := 0.5
    else if Pos(C_EQ_SIGN_SQRT3_2, sValue) > 0 then
      Result := 0.866
    else if Pos(C_EQ_SIGN_SQRT3, sValue) > 0 then
      Result := 1.732
    else
      Result := 1;
  end;

  function GetIValue(sValue : string):Double;
  begin
    if sValue = '' then
      Result := -1
    else
      Result := 1;
  end;

  function GetAngle(dA1,dA2 : Double):Double;
  begin
    Result := dA1 - dA2;
    if Result > 360 then
      Result := Result - 360;

    if Result < 0 then
      Result := Result + 360;
  end;
var
  i: Integer;
  AEXPRESSION : TWE_PHASE_EXPRESSION;
  dU1, dU2 : Double;
begin
  FExpression.GetExpressions3( [ GetPhaseEquation( 0 ), GetPhaseEquation( 1 ) ] );

  for i := 0 to 2 - 1 do
    AnalysisExpression( GetPhaseEquation( i ) );

  dU1 := 0;
  dU2 := 0;

  for i := 0 to 3 - 1 do
  begin
    AEXPRESSION := GetPhaseEquation( i );

    FThreePower.Errorcode  := WiringError.IDInStr;
    FThreePower.Errorcount := WiringError.ErrorCount;
    FThreePower.Angle      := FExpression.UIAngle;

    case i of
      0:
      begin
        FThreePower.U12 := GetUValue(AEXPRESSION.ExpressU);
        FThreePower.I1 := GetIValue(AEXPRESSION.ExpressI);
        if (FThreePower.U12 <> -1) and (FThreePower.I1 <> -1) then
          FThreePower.U12i1 := GetAngle(AEXPRESSION.AngleU, AEXPRESSION.AngleI)
        else
          FThreePower.U12i1 := -1;
        dU1 := AEXPRESSION.AngleU;

      end;
      1:
      begin
        FThreePower.U32 := GetUValue(AEXPRESSION.ExpressU);
        FThreePower.I3 := GetIValue(AEXPRESSION.ExpressI);
        if (FThreePower.U32 <> -1) and (FThreePower.I3 <> -1) then
          FThreePower.U32i3 := GetAngle(AEXPRESSION.AngleU, AEXPRESSION.AngleI)
        else
          FThreePower.U32i3 := -1;
        dU2 := AEXPRESSION.AngleU;
      end;
    end;
  end;
  if (FThreePower.U12 <> -1) and (FThreePower.U32 <> -1) then
    FThreePower.U12u32 := GetAngle(dU1, dU2)
  else
    FThreePower.U12u32 := -1;
end;

procedure TWE_EQUATION.CreateExpression4;
  function GetUIValue(sValue : string):Double;
  begin
    if sValue = '' then
      Result := -1
    else
      Result := 1;
  end;

  function GetAngle(dA1,dA2 : Double):Double;
  begin
    Result := dA1 - dA2;
    if Result > 360 then
      Result := Result - 360;

    if Result < 0 then
      Result := Result + 360;
  end;
var
  i: Integer;
  AEXPRESSION : TWE_PHASE_EXPRESSION;
  dU1, dU2, dU3 : Double;
begin
  FExpression.GetExpressions4( [ GetPhaseEquation( 0 ), GetPhaseEquation( 1 ),
    GetPhaseEquation( 2 ) ] );

  for i := 0 to 3 - 1 do
    AnalysisExpression( GetPhaseEquation( i ) );

  dU1 := 0;
  dU2 := 0;
  dU3 := 0;

  for i := 0 to 3 - 1 do
  begin
    AEXPRESSION := GetPhaseEquation( i );

    FFourPower.Errorcode  := WiringError.IDInStr;
    FFourPower.Errorcount  := WiringError.ErrorCount;
    FFourPower.Angle  := FExpression.UIAngle;
    case i of
      0:
      begin
        FFourPower.U1 := GetUIValue(AEXPRESSION.ExpressU);
        FFourPower.I1 := GetUIValue(AEXPRESSION.ExpressI);
        if (FFourPower.U1 <> -1) and (FFourPower.I1 <> -1) then
          FFourPower.U1i1 := GetAngle(AEXPRESSION.AngleU, AEXPRESSION.AngleI)
        else
          FFourPower.U1i1 := -1;

        dU1 := AEXPRESSION.AngleU;

      end;
      1:
      begin
        FFourPower.U2 := GetUIValue(AEXPRESSION.ExpressU);
        FFourPower.I2 := GetUIValue(AEXPRESSION.ExpressI);
        if (FFourPower.U2 <> -1) and (FFourPower.I2 <> -1) then
          FFourPower.U2i2 := GetAngle(AEXPRESSION.AngleU, AEXPRESSION.AngleI)
        else
          FFourPower.U2i2 := -1;
        dU2 := AEXPRESSION.AngleU;
      end;
      2:
      begin
        FFourPower.U3 := GetUIValue(AEXPRESSION.ExpressU);
        FFourPower.I3 := GetUIValue(AEXPRESSION.ExpressI);
        if (FFourPower.U3 <> -1) and (FFourPower.I3 <> -1) then
          FFourPower.U3i3 := GetAngle(AEXPRESSION.AngleU, AEXPRESSION.AngleI)
        else
          FFourPower.U3i3 := -1;
        dU3 := AEXPRESSION.AngleU;
      end;
    end;
  end;
  if (dU1 <> -1) and (dU2 <> -1) then
    FFourPower.U1u2 := GetAngle(dU1, dU2)
  else
    FFourPower.U1u2 := -1;
  if (dU2 <> -1) and (dU3 <> -1) then
    FFourPower.U2u3 := GetAngle(dU2, dU3)
  else
    FFourPower.U2u3 := -1;
  if (dU1 <> -1) and (dU3 <> -1) then
    FFourPower.U1u3 := GetAngle(dU1, dU3)
  else
    FFourPower.U1u3 := -1;
end;

procedure TWE_EQUATION.CreateExpression4PT;
var
  i: Integer;
begin
  FExpression.GetExpressions4PT( [ GetPhaseEquation( 0 ), GetPhaseEquation( 1 ),
    GetPhaseEquation( 2 ) ] );

  for i := 0 to 3 - 1 do
    AnalysisExpression( GetPhaseEquation( i ) );
end;

procedure TWE_EQUATION.CreateExpressionSingle;
begin
  FExpression.GetExpressionsSingle( GetPhaseEquation( 0 ));
  AnalysisExpression( GetPhaseEquation( 0 ) );
end;

destructor TWE_EQUATION.Destroy;
var
  i: Integer;
begin
  for i := 0 to 3 - 1 do
    GetPhaseEquation( i ).Free;

  FPhaseEquations.Free;
  FEquationP.Free;
  FEquationK.Free;
  FAnalysisK.Free;
  FExpression.Free;
  FFourPower.Free;
  FThreePower.Free;
  inherited;
end;

function TWE_EQUATION.FinalEquation : string;
var
  anCos, anSin : array of string;
  sCoCos, sCoSin : string;
  sCoUI : string;
  i: Integer;
  FracCos, FracR3Cos : TWE_FRAC;
  FracSin, FracR3Sin : TWE_FRAC;
  nUIFactor : Integer;
begin
  Result := '';

  SetLength( anCos, 3 );
  SetLength( anSin, 3 );

  for i := 0 to 3 - 1 do
  begin
    anCos[ i ] := GetPhaseEquation( i ).CoCos;
    anSin[ i ] := GetPhaseEquation( i ).CoSin;
  end;

  // �������
  PlusCoefs( anCos, FracCos, FracR3Cos );
  PlusCoefs( anSin, FracSin, FracR3Sin );

  // ��ȡUI��ϵ��
  nUIFactor := GetFactor( [ FracCos.n, FracR3Cos.n, FracSin.n, FracR3Sin.n ] );

  if Abs( nUIFactor ) = 1 then
  begin
    if nUIFactor < 0 then
      sCoUI := '-'
    else
      sCoUI := '';
  end
  else
    sCoUI := IntToStr( nUIFactor );

  // ��ȡ������ϵ��
  if ( nUIFactor > 1 ) or ( nUIFactor < 0 ) then
  begin
    FracCos.n := FracCos.n div nUIFactor;
    FracR3Cos.n := FracR3Cos.n div nUIFactor;
    FracSin.n := FracSin.n div nUIFactor;
    FracR3Sin.n := FracR3Sin.n div nUIFactor;
  end;

  sCoCos := PlusExpressions( GenCoef( FracCos, False ),
    GenCoef( FracR3Cos, True ) );

  sCoSin := PlusExpressions( GenCoef( FracSin, False ),
    GenCoef( FracR3Sin, True ) );

  if ( sCoCos = EmptyStr ) and ( sCoSin <> EmptyStr ) then
  begin
    Result := sCoSin + 'UIsin\o';
  end
  else if ( sCoCos <> EmptyStr ) and ( sCoSin = EmptyStr ) then
  begin
    Result := sCoCos + 'UIcos\o';
  end
  else if ( sCoCos <> EmptyStr ) and ( sCoSin <> EmptyStr ) then
  begin
    Result := Format( '%sUI(%s)', [ scoUI, PlusExpressions(
      MultiplyExpressions(  sCoCos, 'cos\o' ),
      MultiplyExpressions( sCoSin, 'sin\o' ) ) ] );
  end
  else
  begin
    Result := '0';
  end;

  Result := StringReplace( Result, '1U', 'U', [rfIgnoreCase] );
end;

procedure TWE_EQUATION.GenerateEquations( AWE : TWIRING_ERROR; AUIAngle : Double );
begin
  FExpression.UIAngle := AUIAngle;
  FExpression.WiringError := AWE;
  GenerateEquations;
end;

procedure TWE_EQUATION.GenerateEquations;
var
  WErr : TWIRING_ERROR;
begin
  CleanEquation;
  WErr := GetWiringError;

  if Assigned( WErr ) then
    if WErr.PhaseType = ptThree then
    begin
      CreateExpression3;
      CalEquationP3;
    end
    else if WErr.PhaseType = ptFour then
    begin
      CreateExpression4;
      CalEquationP4;
    end
    else if WErr.PhaseType = ptFourPT then
    begin
      CreateExpression4PT;
      CalEquationP4PT;
    end
    else if WErr.PhaseType = ptSingle then
    begin
      CreateExpression4;
      CalEquationSingle;
    end;

  CalEquationK;
end;

function TWE_EQUATION.GetPhaseEquation(
  const AIndex: Integer): TWE_PHASE_EXPRESSION;
begin
  if AIndex in [ 0.. FPhaseEquations.Count - 1 ]then
    Result := TWE_PHASE_EXPRESSION( FPhaseEquations.Items[ AIndex ] )
  else
    Result := nil;
end;

function TWE_EQUATION.GetUIAngle: Double;
begin
  Result := FExpression.UIAngle;
end;

function TWE_EQUATION.GetWiringError: TWIRING_ERROR;
begin
  Result := FExpression.WiringError;
end;

procedure TWE_EQUATION.SetUIAngle(const Value: Double);
begin
  FExpression.UIAngle := Value;
  GenerateEquations;
end;

procedure TWE_EQUATION.SetWiringError(const Value: TWIRING_ERROR);
begin
  FExpression.WiringError := Value;
  GenerateEquations;
end;

procedure TWE_EQUATION.ShowAnalysis(AText: TStrings; AMaxSize: Integer);
  procedure AddString( AStr : string; AIndex : Integer = -1 );
  var
    nPosComma : Integer; // ����λ��
    sFirstStr : string;
  begin
    if AIndex = -1 then
      sFirstStr := '    '
    else
      sFirstStr := IntToStr( AIndex + 1 )+ '. ';

    // �ַ������ȹ�������Ҫ���
    if Length( AStr ) > AMaxSize then
    begin
      nPosComma := AnsiPos( '��', AStr );
      AText.Add( sFirstStr + Copy( AStr, 1, nPosComma + 1 ));
      AddString( Copy( AStr, nPosComma + 2, Length( AStr ) - nPosComma - 1 ) );
    end
    else
      AText.Add( sFirstStr + AStr );
  end;  
var
  i : Integer;
  nPosSemi : Integer; // �ֺ�λ��
  sTemp : string;
begin
  AText.Clear;

  if FAnalysisK.Count = 0 then
    Exit
  else if FAnalysisK.Count = 1 then
    AText.Add( FAnalysisK[ 0 ] )
  else
    for i := 0 to FAnalysisK.Count - 1 do
    begin
      if Pos( '��', FAnalysisK[ i ] ) > 0 then  // �������ŵ� ���
      begin
        nPosSemi := Pos('��', FAnalysisK[ i ] );
        AddString( Copy( FAnalysisK[ i ], 1, nPosSemi + 1), i );
        sTemp := Copy( FAnalysisK[ i ], nPosSemi + 2, Length( FAnalysisK[ i ] ) - nPosSemi );

        while sTemp <> '' do
        begin
          if Pos( '��', sTemp ) > 0 then       // �������ŵ� ���
          begin
            nPosSemi := Pos('��', sTemp);
            AddString( Copy( sTemp, 1, nPosSemi + 1) );
            sTemp := Copy( sTemp, nPosSemi + 2, Length(sTemp) - nPosSemi);
          end
          else
          begin
            AddString( sTemp );
            sTemp := '';
          end;
        end;
      end
      else
        AddString( FAnalysisK[ i ], i );

      AText.Add( EmptyStr );
    end;
end;

end.

