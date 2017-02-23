{===============================================================================
  Copyright(c) 2007-2009, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ������ߣ����ʽ���ɵ�Ԫ
  + TWE_PHASE_EXPRESSION     ���ʽ����

===============================================================================}

unit U_WE_EXPRESSION;

interface

uses SysUtils, Classes, U_WIRING_ERROR,U_WE_EQUATION_MATH, IniFiles, Forms, Math;

const
  C_EQ_SIGN_A = 'a';
  C_EQ_SIGN_B = 'b';
  C_EQ_SIGN_C = 'c';

const
  C_EQ_SIGN_1_2 = '{1,2}';     // 1/2
  C_EQ_SIGN_SQRT3 = '#';       // Sqrt3
  C_EQ_SIGN_SQRT3_2 = '{#,2}'; // Sqrt3/2

type
  /// <summary>
  /// ĳһԪ���ı��ʽ��Ϣ
  /// </summary>
  TWE_PHASE_EXPRESSION = class( TObject )
    ExpressionT : string; // ��ʽ���ʽ ���� U' / I'
    ExpressUT : string; // ��ѹ���ʽ  ���� U'
    ExpressIT : string; // �������ʽ  ���� I'

    Expression : string;  // ��ʽ���ʽ
    ExpressU : string;  // ��ѹ���ʽ
    ExpressI : string;  // �������ʽ
    ExpressO : string;  // �Ƕȱ��ʽ
    AngleU   : Integer;   // U�Ƕ�
    AngleI   : Integer;   // I�Ƕ�
    AngleO   : Integer;   // O�Ƕ�
    SignO    : Boolean;   // O�Ƕ�����

    Result1  : string; // ������ʽ_1  ���ϲ�UI��ϵ��
    Result2  : string; // ������ʽ_2  �滻cos120`...
    CoCos    : string; // Cosϵ��
    CoSin    : string; // Sinϵ��
  public
    procedure Clear;
  end;

type
  /// <summary>
  /// ���ʽ����
  /// </summary>
  TWE_EXPRESSION = class( TObject )
  private
    FUIAngle: Double;
    FWiringError: TWIRING_ERROR;
    procedure SetWiringError(const Value: TWIRING_ERROR);

    /// <summary>
    /// ���ɶ���Ԫ���ı��ʽ
    /// </summary>
    procedure GenerateSingleExpression( APhaseEpr : TWE_PHASE_EXPRESSION );

    /// <summary>
    /// ��ȡ���ߵ�ѹ
    /// </summary>
    procedure GetP4USign( var AUOrder : array of string );

    /// <summary>
    /// ��ȡ���ߵ�ѹ��PT����
    /// </summary>
    procedure GetP4USignPT( var AUOrder : array of string );

    /// <summary>
    /// ��ȡ���ߵ���
    /// </summary>
    procedure GetP4ISign( var AIOrder : array of string );

    /// <summary>
    /// ��ȡ���ߵ�ѹ
    /// </summary>
    procedure GetP3USign( out AU1, AU2 : string );

    /// <summary>
    /// ��ȡ���ߵ�ѹ�ĽǶ�
    /// </summary>
    function GetP3UAngle( const sU : string ) : Integer;

    /// <summary>
    /// ��ȡ���ߵ���
    /// </summary>
    procedure GetP3ISign( out AI1, AI2 : string );

    /// <summary>
    /// ��ȡ���ߵ����ĽǶ�
    /// </summary>
    procedure GetP3IAngle( var sI, sO : string; out nI : Integer; const sU : string );

    /// <summary>
    /// ��ȡ��ѹ�����ĽǶ�
    /// </summary>
    procedure GetUIO( const dAngle : Double; const nU, nI : Integer;
      var sO : string; var nO : Integer; var bO : Boolean );

    /// <summary>
    /// �ı��ʶ������
    /// </summary>
    procedure ChangeSignSequence( var ASignList : array of string;
      ASequence : TWE_SEQUENCE_TYPE );
    function GetUIAngle: Double;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// UI�н�
    /// </summary>
    property UIAngle : Double read GetUIAngle write FUIAngle;

    /// <summary>
    /// �������
    /// </summary>
    property WiringError : TWIRING_ERROR read FWiringError write SetWiringError;

    /// <summary>
    /// �������߱��ʽ
    /// </summary>
    procedure GetExpressions3( APhaseEprs : array of TWE_PHASE_EXPRESSION );

    /// <summary>
    /// �������߱��ʽ
    /// </summary>
    procedure GetExpressions4( APhaseEprs : array of TWE_PHASE_EXPRESSION );

    /// <summary>
    /// �������߱��ʽ����PT����
    /// </summary>
    procedure GetExpressions4PT( APhaseEprs : array of TWE_PHASE_EXPRESSION );

    /// <summary>
    /// ���ɵ�����ʽ
    /// </summary>
    procedure GetExpressionsSingle( APhaseEprs : TWE_PHASE_EXPRESSION );
  end;
var
  /// <summary>
  /// �Ƿ��Ǹ��ԽǶ�
  /// </summary>
  bPubIsVectorAngle : Boolean;

implementation

{ TWE_EXPRESSION }

procedure TWE_EXPRESSION.GetP3IAngle(var sI, sO: string; out nI: Integer;
  const sU: string);
var
  bWithHalf : Boolean;
begin
  bWithHalf := Pos( C_EQ_SIGN_1_2, sI ) > 0;

  if bWithHalf then
    sI := StringReplace( sI, C_EQ_SIGN_1_2, '', [] );

  if sI = '+a' then
  begin
    nI := 90;
    sI := 'I' + SuffixVar( C_EQ_SIGN_A );
    sO := '\o' + SuffixVar( C_EQ_SIGN_A );
  end
  else if sI = '-a' then
  begin
    nI := -90;
    sI := '-I' + SuffixVar( C_EQ_SIGN_A );
    sO := '\o' + SuffixVar( C_EQ_SIGN_A );
  end
  else if sI = '+c' then
  begin
    nI := -150;
    sI := 'I' + SuffixVar( C_EQ_SIGN_C );
    sO := '\o' + SuffixVar( C_EQ_SIGN_C );
  end
  else if sI = '-c' then
  begin
    nI := 30;
    sI := '-I' + SuffixVar( C_EQ_SIGN_C );
    sO := '\o' + SuffixVar( C_EQ_SIGN_C );
  end
  else if ( sI = '+a+c' ) or ( sI = '+c+a' ) then
  begin
    nI := 150;
    sI := '-I' + SuffixVar( C_EQ_SIGN_B );
    sO := '\o' + SuffixVar( C_EQ_SIGN_B );
  end
  else if ( sI = '+a-c' ) or ( sI = '-c+a' ) then
  begin
    nI := 60;
    sI := 'I' + SuffixVar( C_EQ_SIGN_A ) + SuffixVar( C_EQ_SIGN_C );

    if Pos( 'a', sU ) > 0 then
      sO := '\o' + SuffixVar( C_EQ_SIGN_A )
    else
      sO := '\o' + SuffixVar( C_EQ_SIGN_C );
  end
  else if ( sI = '-a+c' ) or ( sI = '+c-a' ) then
  begin
    nI := -120;
    sI := 'I' + SuffixVar( C_EQ_SIGN_C ) + SuffixVar( C_EQ_SIGN_A );

    if Pos( 'a', sU ) > 0 then
      sO := '\o' + SuffixVar( C_EQ_SIGN_A )
    else
      sO := '\o' + SuffixVar( C_EQ_SIGN_C );
  end
  else if ( sI = '-a-c' ) or ( sI = '-c-a' ) then
  begin
    nI := -30;
    sI := 'I' + SuffixVar( C_EQ_SIGN_B );
    sO := '\o' + SuffixVar( C_EQ_SIGN_B );
  end
  else
  begin
    nI := 0;
    sI := '';
    sO := '';
  end;

  if bWithHalf and ( sI <> '' ) then
    sI := StringReplace( sI, 'I', C_EQ_SIGN_1_2+ 'I', [] );
end;

procedure TWE_EXPRESSION.GetExpressions4( APhaseEprs : array of TWE_PHASE_EXPRESSION );



var
  sU_Order : array[0..2] of string;        // ��ѹ
  sI_Order : array[0..2] of string;        // ����
  sO_Order : array[0..2] of string;        // �Ƕ�

  nU_Angle : array[0..2] of Integer;       // U�Ƕ�
  nI_Angle : array[0..2] of Integer;       // I�Ƕ�
  nO_Angle : array[0..2] of Integer;       // O�Ƕ�
  bOI_Angle : array[0..2] of Boolean;      // ������ʶ

  i : Integer;
begin
  GetP4USign( sU_Order );
  GetP4ISign( sI_Order );


  // �����Ƕ�
  for i := 0 to 2 do
  begin
    IntToStr(i);
    // ��ѹ
    if Pos( C_EQ_SIGN_A, sU_Order[i] ) > 0 then
      nU_Angle[i] := 90
    else if Pos( C_EQ_SIGN_B, sU_Order[i] ) > 0 then
      nU_Angle[i] := -30
    else if Pos( C_EQ_SIGN_C, sU_Order[i]) > 0 then
      nU_Angle[i] := -150
    else
      nU_Angle[i] := 0;



    // ����
    if Pos( C_EQ_SIGN_A, sI_Order[i]) > 0 then
      nI_Angle[i] := 90
    else if Pos( C_EQ_SIGN_B, sI_Order[i]) > 0 then
      nI_Angle[i] := -30
    else if Pos( C_EQ_SIGN_C, sI_Order[i]) > 0 then
      nI_Angle[i] := -150
    else
      nI_Angle[i] := 0;

    if Pos('-', sI_Order[i]) > 0 then
    begin
//      if nI_Angle[i] > 0 then
//      begin
        nI_Angle[i] := nI_Angle[i] - 180;
//      end
//      else
//      begin
//        nI_Angle[i] := nI_Angle[i] + 180;
//      end;
    end;

    // o �Ƕ� �����Ը��ԣ�
    if GetUIAngle < 0 then
      bOI_Angle[i] := false
    else
      bOI_Angle[i] := true;
    // ������ѹ�����н�
    nO_Angle[i] := nU_Angle[i] - nI_Angle[i];

    sI_Order[i] := StringReplace( sI_Order[i], '-', '', [] );

    // ����Ƕ�
    sO_Order[i] := StringReplace( sI_Order[i], '-', '', [] );
    sO_Order[i] := StringReplace( sO_Order[i], 'I', '\o', [] );

    GetUIO( GetUIAngle, nU_Angle[i], nI_Angle[i], sO_Order[i], nO_Angle[i], bOI_Angle[i] );
  end;

  //----------------------------------------------------------------------------
  // ��ʽ��ʼ��
  //----------------------------------------------------------------------------
  for i := 0 to 2 do
  begin
    with APhaseEprs[ i ] do
    begin
      ExpressU := sU_Order[ i ];
      ExpressI := sI_Order[ i ];
      ExpressO := sO_Order[ i ];
      AngleU   := nU_Angle[ i ];
      AngleI   := nI_Angle[ i ];
      AngleO   := nO_Angle[ i ];
      SignO    := bOI_Angle[ i ];
    end;

    GenerateSingleExpression( APhaseEprs[ i ] );
  end;
end;

procedure TWE_EXPRESSION.GetExpressions4PT(
  APhaseEprs: array of TWE_PHASE_EXPRESSION);
  function GetIsExist(aList : array of string; s : string) : Boolean;
  var
    j: Integer;
  begin
    Result := True;
    for j := 0 to Length(aList) - 1 do
    begin
      if Pos(aList[j], s) = 0 then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

  // ��ȡs1��s2�г��ִ���
  function stringn(s1,s2:string):integer;
  begin
    result:=0;
    while pos(s1,s2)>0 do
    begin
     s2:=copy(s2,pos(s1,s2)+1,9999);   //����s2��󳤶�Ϊ9999���ַ�
     result:=result+1 ;
   end;
  end;
var
  sU_Order : array[0..2] of string;        // ��ѹ
  sI_Order : array[0..2] of string;        // ����
  sO_Order : array[0..2] of string;        // �Ƕ�

  nU_Angle : array[0..2] of Integer;       // U�Ƕ�
  nI_Angle : array[0..2] of Integer;       // I�Ƕ�
  nO_Angle : array[0..2] of Integer;       // O�Ƕ�
  bOI_Angle : array[0..2] of Boolean;      // ������ʶ

  i : Integer;
  sIa, sIb, sIc : string;
begin
  sIa := 'I' + SuffixVar( C_EQ_SIGN_A );
  sIb := 'I' + SuffixVar( C_EQ_SIGN_B );
  sIc := 'I' + SuffixVar( C_EQ_SIGN_C );

  GetP4USignPT( sU_Order );
  GetP4ISign( sI_Order );


  // �����Ƕ�
  for i := 0 to 2 do
  begin
    IntToStr(i);
    // ��ѹ
    if Pos( C_EQ_SIGN_A, sU_Order[i] ) > 0 then
      nU_Angle[i] := 90
    else if Pos( C_EQ_SIGN_B, sU_Order[i] ) > 0 then
      nU_Angle[i] := -30
    else if Pos( C_EQ_SIGN_C, sU_Order[i]) > 0 then
      nU_Angle[i] := -150
    else
      nU_Angle[i] := 0;

    if Pos('-', sU_Order[i]) > 0 then
      nU_Angle[i] := nU_Angle[i] - 180;

    sU_Order[i] := StringReplace( sU_Order[i], '-', '', [] );



    if stringn('I',sI_Order[i]) = 3 then
    begin
      if sI_Order[i] = '-' + sIa + '-' + sIb + '-' + sIc then
      begin
        sI_Order[i] := '';
        nO_Angle[i] := 0;
      end
      else if sI_Order[i] = '-' + sIa + sIb + '-' + sIc then
      begin
        sI_Order[i] := '2'+sIb;
      end
      else if sI_Order[i] = '-' + sIa+ '-' + sIb  + sIc then
      begin
        sI_Order[i] := '2'+sIc;
      end
      else if sI_Order[i] = sIa+ '-' + sIb  + '-' + sIc then
      begin
        sI_Order[i] := '2'+sIa;
      end
      else if sI_Order[i] = sIa+ sIb  + '-' + sIc then
      begin
        sI_Order[i] := '-2'+sIc;
      end
      else if sI_Order[i] = sIa+ '-' + sIb  + sIc then
      begin
        sI_Order[i] := '-2'+sIb;
      end
      else if sI_Order[i] = sIa + sIb + sIc then
      begin
        sI_Order[i] := '';
      end
    end
    else if stringn('I',sI_Order[i]) = 2 then
    begin
      if sI_Order[i] = sIa + sIb then
      begin
        sI_Order[i] := '-' + sIc;
      end
      else if sI_Order[i] = sIa + sIc then
      begin
        sI_Order[i] := '-' + sIb;
      end
      else if sI_Order[i] = sIb + sIc then
      begin
        sI_Order[i] := '-' + sIa;
      end
      else if sI_Order[i] = '-' +sIa + '-' +sIb then
      begin
        sI_Order[i] := sIc;
      end
      else if sI_Order[i] = '-' +sIa + '-' +sIc then
      begin
        sI_Order[i] := sIb;
      end
      else if sI_Order[i] = '-' +sIb + '-' +sIc then
      begin
        sI_Order[i] := sIa;
      end
    end;


    // ����
    if Pos( C_EQ_SIGN_A, sI_Order[i]) > 0 then
      nI_Angle[i] := 90
    else if Pos( C_EQ_SIGN_B, sI_Order[i]) > 0 then
      nI_Angle[i] := -30
    else if Pos( C_EQ_SIGN_C, sI_Order[i]) > 0 then
      nI_Angle[i] := -150
    else
      nI_Angle[i] := 0;

    if Pos('-', sI_Order[i]) > 0 then
    begin
//      if nI_Angle[i] > 0 then
//      begin
        nI_Angle[i] := nI_Angle[i] - 180;
//      end
//      else
//      begin
//        nI_Angle[i] := nI_Angle[i] + 180;
//      end;
    end;
    // o �Ƕ�
    if GetUIAngle < 0 then
      bOI_Angle[i] := True
    else
      bOI_Angle[i] := False;

    nO_Angle[i] := nU_Angle[i] - nI_Angle[i];
    bOI_Angle[i] := not bOI_Angle[i];

    sI_Order[i] := StringReplace( sI_Order[i], '-', '', [] );


    // ����Ƕ�
    sO_Order[i] := StringReplace( sI_Order[i], '-', '', [] );
    sO_Order[i] := StringReplace( sO_Order[i], 'I', '\o', [] );
    GetUIO( GetUIAngle, nU_Angle[i], nI_Angle[i], sO_Order[i], nO_Angle[i], bOI_Angle[i] );
  end;

  //----------------------------------------------------------------------------
  // ��ʽ��ʼ��
  //----------------------------------------------------------------------------
  for i := 0 to 2 do
  begin
    with APhaseEprs[ i ] do
    begin
      ExpressU := sU_Order[ i ];
      ExpressI := sI_Order[ i ];
      ExpressO := sO_Order[ i ];
      AngleU   := nU_Angle[ i ];
      AngleI   := nI_Angle[ i ];
      AngleO   := nO_Angle[ i ];
      SignO    := bOI_Angle[ i ];
    end;

    GenerateSingleExpression( APhaseEprs[ i ] );
  end;
end;

procedure TWE_EXPRESSION.GetExpressionsSingle(APhaseEprs: TWE_PHASE_EXPRESSION);
var
  sU_Order : array[0..2] of string;        // ��ѹ
  sI_Order : array[0..2] of string;        // ����
  sO_Order : array[0..2] of string;        // �Ƕ�

  nU_Angle : array[0..2] of Integer;       // U�Ƕ�
  nI_Angle : array[0..2] of Integer;       // I�Ƕ�
  nO_Angle : array[0..2] of Integer;       // O�Ƕ�
  bOI_Angle : array[0..2] of Boolean;      // ������ʶ

  i : Integer;
begin
  GetP4USign( sU_Order );
  GetP4ISign( sI_Order );


  // �����Ƕ�
  for i := 0 to 0 do
  begin
    IntToStr(i);
    // ��ѹ
    if Pos( C_EQ_SIGN_A, sU_Order[i] ) > 0 then
      nU_Angle[i] := 90
    else if Pos( C_EQ_SIGN_B, sU_Order[i] ) > 0 then
      nU_Angle[i] := -30
    else if Pos( C_EQ_SIGN_C, sU_Order[i]) > 0 then
      nU_Angle[i] := -150
    else
      nU_Angle[i] := 0;


    // ����
    if Pos( C_EQ_SIGN_A, sI_Order[i]) > 0 then
      nI_Angle[i] := 90
    else if Pos( C_EQ_SIGN_B, sI_Order[i]) > 0 then
      nI_Angle[i] := -30
    else if Pos( C_EQ_SIGN_C, sI_Order[i]) > 0 then
      nI_Angle[i] := -150
    else
      nI_Angle[i] := 0;

    if Pos('-', sI_Order[i]) > 0 then
    begin
      nI_Angle[i] := nI_Angle[i] - 180;
    end;

    // o �Ƕ� �����Ը��ԣ�
    if GetUIAngle < 0 then
      bOI_Angle[i] := false
    else
      bOI_Angle[i] := true;
    // ������ѹ�����н�
    nO_Angle[i] := nU_Angle[i] - nI_Angle[i];

    sI_Order[i] := StringReplace( sI_Order[i], '-', '', [] );

    // ����Ƕ�
    sO_Order[i] := StringReplace( sI_Order[i], '-', '', [] );
    sO_Order[i] := StringReplace( sO_Order[i], 'I', '\o', [] );
    GetUIO( GetUIAngle, nU_Angle[i], nI_Angle[i], sO_Order[i], nO_Angle[i], bOI_Angle[i] );
  end;

  //----------------------------------------------------------------------------
  // ��ʽ��ʼ��
  //----------------------------------------------------------------------------

    with APhaseEprs do
    begin
      ExpressU := sU_Order[ 0 ];
      ExpressI := sI_Order[ 0 ];
      ExpressO := sO_Order[ 0 ];
      AngleU   := nU_Angle[ 0 ];
      AngleI   := nI_Angle[ 0 ];
      AngleO   := nO_Angle[ 0 ];
      SignO    := bOI_Angle[ 0 ];
    end;

    GenerateSingleExpression( APhaseEprs );
end;

constructor TWE_EXPRESSION.Create;
begin
  FWiringError := TWIRING_ERROR.Create;
  FUIAngle := 20;
end;

destructor TWE_EXPRESSION.Destroy;
begin
  FWiringError.Free;
  inherited;
end;

procedure TWE_EXPRESSION.GenerateSingleExpression(
  APhaseEpr: TWE_PHASE_EXPRESSION);

  function JointEpr( AU, AI, AO : string ) : string;
  begin
    if ( AU = EmptyStr ) or ( AI = EmptyStr ) then
    begin
      Result := '0';
      Exit;
    end;  

    Result := AU;

    if Pos( '-', AI ) > 0 then
      Result := Result + '(' + AI + ')'
    else
      Result := Result + AI;

    if Pos( '`', AO ) > 0 then
      Result := Result + 'cos(' + AO + ')'
    else
      Result := Result + 'cos' + AO;
  end;
begin
  if not Assigned( APhaseEpr ) then
    Exit;

  with APhaseEpr do
  begin
    Expression := JointEpr( ExpressU, ExpressI, ExpressO );

    ExpressUT := ExpressU;
    if ( Pos( C_EQ_SIGN_SQRT3, ExpressUT ) > 0 ) or
       ( Pos( C_EQ_SIGN_1_2, ExpressUT ) > 0 ) or
       ( Pos( C_EQ_SIGN_SQRT3_2, ExpressUT ) > 0 ) then
    begin
      ExpressUT := StringReplace( ExpressUT, C_EQ_SIGN_1_2, '', [rfIgnoreCase]);
      ExpressUT := StringReplace( ExpressUT, C_EQ_SIGN_SQRT3_2, '', [rfIgnoreCase]);
      ExpressUT := StringReplace( ExpressUT, C_EQ_SIGN_SQRT3, '', [rfIgnoreCase] );
      ExpressUT := ExpressUT + '''';
    end;

    ExpressIT := ExpressI;
    if ( Pos( C_EQ_SIGN_SQRT3, ExpressIT ) > 0 ) or
       ( Pos( C_EQ_SIGN_1_2, ExpressIT ) > 0 ) or
       ( Pos( C_EQ_SIGN_SQRT3_2, ExpressIT ) > 0 ) then
    begin
      ExpressIT := StringReplace( ExpressIT, C_EQ_SIGN_1_2, '', [rfIgnoreCase]);
      ExpressIT := StringReplace( ExpressIT, C_EQ_SIGN_SQRT3_2, '', [rfIgnoreCase]);
      ExpressIT := StringReplace( ExpressIT, C_EQ_SIGN_SQRT3, '', [rfIgnoreCase] );
      ExpressIT := ExpressIT + '''';
    end;

    ExpressionT := JointEpr( ExpressUT, ExpressIT, ExpressO );
  end;
end;

procedure TWE_EXPRESSION.GetExpressions3( APhaseEprs : array of TWE_PHASE_EXPRESSION );
var
  sU1, sU2 : string;
  sI1, sI2 : string;
  sO1, sO2 : string;

  nU1, nU2 : Integer;   // U�Ƕ�
  nI1, nI2 : Integer;   // I�Ƕ�
  nO1, nO2 : Integer;   // O�Ƕ�
  bO1, bO2 : Boolean;   // ������ʶ
begin
  // ��ȡ��ѹ�͵���
  GetP3USign( sU1, sU2 );
  GetP3ISign( sI1, sI2 );

  // �����ѹ�Ƕ�
  nU1 := GetP3UAngle( sU1 );
  nU2 := GetP3UAngle( sU2 );

  // �������Ƕ�
  GetP3IAngle( sI1, sO1, nI1, sU1 );
  GetP3IAngle( sI2, sO2, nI2, sU2 );

  // �Ƕ�
  GetUIO( GetUIAngle, nU1, nI1, sO1, nO1, bO1 );
  GetUIO( GetUIAngle, nU2, nI2, sO2, nO2, bO2 );

  //----------------------------------------------------------------------------
  // ��ʽ��ʼ��
  //----------------------------------------------------------------------------
    sI1 := StringReplace( sI1, '-', '', [] );
    sI2 := StringReplace( sI2, '-', '', [] );
  // ��ʽһ
  with APhaseEprs[ 0 ] do
  begin

    ExpressU := sU1;
    ExpressI := sI1;
    ExpressO := sO1;
    AngleU   := nU1;
    AngleI   := nI1;
    AngleO   := nO1;
    SignO    := bO1;
  end;

  // ��ʽ��
  with APhaseEprs[ 1 ] do
  begin
    ExpressU := sU2;
    ExpressI := sI2;
    ExpressO := sO2;
    AngleU   := nU2;
    AngleI   := nI2;
    AngleO   := nO2;
    SignO    := bO2;
  end;

  GenerateSingleExpression( APhaseEprs[ 0 ] );
  GenerateSingleExpression( APhaseEprs[ 1 ] );
end;


procedure TWE_EXPRESSION.ChangeSignSequence(var ASignList: array of string;
  ASequence: TWE_SEQUENCE_TYPE);
var
  aNewSignList : array of string;
  i: Integer;
begin
  if Length( ASignList ) <> 3 then
    Exit;
  
  SetLength( aNewSignList, 3 );

  case ASequence of
    stABC:
    begin
      aNewSignList[0] := ASignList[0];
      aNewSignList[1] := ASignList[1];
      aNewSignList[2] := ASignList[2];
    end;

    stACB:
    begin
      aNewSignList[0] := ASignList[0];
      aNewSignList[1] := ASignList[2];
      aNewSignList[2] := ASignList[1];
    end;

    stBAC:
    begin
      aNewSignList[0] := ASignList[1];
      aNewSignList[1] := ASignList[0];
      aNewSignList[2] := ASignList[2];
    end;

    stBCA:
    begin
      aNewSignList[0] := ASignList[1];
      aNewSignList[1] := ASignList[2];
      aNewSignList[2] := ASignList[0];
    end;

    stCAB:
    begin
      aNewSignList[0] := ASignList[2];
      aNewSignList[1] := ASignList[0];
      aNewSignList[2] := ASignList[1];
    end;

    stCBA:
    begin
      aNewSignList[0] := ASignList[2];
      aNewSignList[1] := ASignList[1];
      aNewSignList[2] := ASignList[0];
    end;
  end;

  for i := 0 to 3 - 1 do
    ASignList[ i ] := aNewSignList[ i ];
end;

procedure TWE_EXPRESSION.GetP3ISign(out AI1, AI2: string);
var
  i : Integer;
  sI : array[0..3] of string;   // ��������
  nI : array[0..3] of Integer;  // ������� a-1 b-2 c-3 ����-0
  sIa, sIb, sIc : string;
  sI1, sI2 : string;
  bHalf : Boolean;  // �Ƿ����

  function GetIOrder( ALineType : TWE_PHASE_LINE_TYPE ) : string;
  begin
    case ALineType of
      plA: Result := sIa;
      plC: Result := sIc;
      plN: Result := sIb;
    else
      Result := EmptyStr;
    end;
  end;

  procedure CleanIStr( var s : string );
  begin
    if Pos( C_EQ_SIGN_B, s ) > 0 then
      s := StringReplace( s, C_EQ_SIGN_B, '', [] );

    if Pos( '-', s ) > 0 then
    begin
      // ȥ��+-��-+��--
      s := StringReplace( s, '+-', '-', [rfReplaceAll] );
      s := StringReplace( s, '-+', '-', [rfReplaceAll] );
      s := StringReplace( s, '--', '+', [rfReplaceAll] );
    end;
  end;

  /// <summary>
  /// Ԫ������״̬
  /// </summary>
  function IStatus( AID : Integer ) : Integer;
  var
    ID1, ID2 : Integer;
  begin
    // 1. ����������( Iin = Iout ), I = ''
    // 2. �����������һ����( Iin = X or Iout = X ), I = '' �� �������Ӻͷ���
    // 3. �����������һ����In( Iin = In or Iout = In )������һ���� Ia, Ic,
    //    ���ܻ�����������Ӻͷ���
    // 4. ���������û��In������Ia��Ic, ���ܻ�����������Ӻͷ���
    if AID in [ 1, 2 ] then
    begin
      ID1 := ( AID - 1 ) * 2;
      ID2 := ( AID - 1 ) * 2 + 1;

      if nI[ ID1 ] = nI[ ID2 ] then
        Result := 1
      else if ( nI[ ID1 ] = 0 ) or ( nI[ ID2 ] = 0 ) then
        Result := 2
      else if ( nI[ ID1 ] = 2 ) or ( nI[ ID2 ] = 2 ) then
        Result := 3
      else
        Result := 4;
    end
    else
      raise Exception.Create( '������Ŵ�' );
  end;

  /// <summary>
  /// ��������Ԫ������
  /// </summary>
  procedure ProcI1I2;
  begin
    // ���Ԫ��������ͬ�ĵ���
    // һԪ������
    if nI[ 0 ] = nI[ 1 ] then
      sI1 := ''
    else if ( nI[ 0 ] = 0 ) or ( nI[ 1 ] = 0 ) then  // ���Ϊ����, �ᱨ��
      sI1 := ''
    else if ( sI[ 1 ] = '' ) or ( sI[ 1 ] = C_EQ_SIGN_B ) then
      sI1 := sI[ 0 ]
    else
    begin
      sI1 := sI[ 0 ] + '-' + sI[ 1 ];
      CleanIStr( sI1 );
    end;  

    // ��Ԫ������
    if nI[ 2 ] = nI[ 3 ] then
      sI2 := ''
    else if ( nI[ 2 ] = 0 ) or ( nI[ 3 ] = 0 ) then  // ���Ϊ����, �ᱨ��
      sI2 := ''
    else if ( sI[ 3 ] = '' ) or ( sI[ 3 ] = C_EQ_SIGN_B ) then
      sI2 := sI[ 2 ]
    else
    begin
      sI2 := sI[ 2 ] + '-' + sI[ 3 ];
      CleanIStr( sI2 );
    end;  

    if bHalf then   // �������
    begin
      if sI1 <> '' then
        sI1 := C_EQ_SIGN_1_2 + sI1;

      if sI2 <> '' then
        sI2 := C_EQ_SIGN_1_2 + sI2;
    end;
  end;

  /// <summary>
  /// ��������Ԫ�����ж�������
  /// </summary>
  procedure ProcAllBroken;
  begin
    // �����Ԫ�����ж���
    if ( nI[ 0 ] = 0 ) and ( nI[ 2 ] = 0 ) then  // I1in <-> I2in
    begin
      nI[ 0 ] := nI[ 3 ];
      nI[ 2 ] := nI[ 1 ];
      sI[ 0 ] := sI[ 3 ];
      sI[ 2 ] := sI[ 1 ];
    end
    else if ( nI[ 0 ] = 0 ) and ( nI[ 3 ] = 0 ) then  // I1in <-> I2out
    begin
      nI[ 0 ] := nI[ 2 ];
      nI[ 3 ] := nI[ 1 ];
      sI[ 0 ] := sI[ 3 ];
      sI[ 3 ] := sI[ 1 ];
    end
    else if ( nI[ 1 ] = 0 ) and ( nI[ 2 ] = 0 ) then  // I1out <-> I2in
    begin
      nI[ 1 ] := nI[ 3 ];
      nI[ 2 ] := nI[ 0 ];
      sI[ 1 ] := sI[ 3 ];
      sI[ 2 ] := sI[ 0 ];
    end
    else // I1out <-> I2out
    begin
      // �����In�ϣ������
      bHalf := True;

      nI[ 1 ] := nI[ 2 ];
      nI[ 3 ] := nI[ 0 ];
      sI[ 1 ] := sI[ 2 ];
      sI[ 3 ] := sI[ 0 ];
    end;
  end;

  /// <summary>
  /// ������һ��In�����, ��һ����In�����
  /// </summary>
  procedure ProcOneIn;
  begin
    // 1Ԫ��û��In, 2Ԫ����In
    if IStatus( 1 ) = 4 then
    begin
      if ( nI[ 0 ] = nI[ 2 ] ) or ( nI[ 0 ] = nI[ 3 ] ) then // I1������2Ԫ��
      begin
        // I1��->I2��, I2���ӵ�
        if nI[ 0 ] = nI[ 2 ] then
        begin
          sI[ 3 ] := '-' + sI[ 1 ];
          CleanIStr( sI[ 3 ] );
          nI[ 3 ] := nI[ 1 ];
        end
        else  // I1��->I2��, I2���ӵ�
        begin
          sI[ 2 ] := '-' + sI[ 1 ];
          CleanIStr( sI[ 2 ] );
          nI[ 2 ] := nI[ 1 ];
        end;

        nI[ 0 ] := 2;
        sI[ 0 ] := sIb;
      end
      else // I1������2Ԫ��
      begin
        // I1��->I2��, I2���ӵ�
        if nI[ 1 ] = nI[ 2 ] then
        begin
          sI[ 3 ] := '-' + sI[ 0 ];
          CleanIStr( sI[ 3 ] );
          nI[ 3 ] := nI[ 0 ];
        end
        else  // I1��->I2��, I2���ӵ�
        begin
          sI[ 2 ] := '-' + sI[ 0 ];
          CleanIStr( sI[ 2 ] );
          nI[ 2 ] := nI[ 0 ];
        end;

        nI[ 1 ] := 2;
        sI[ 1 ] := sIb;
      end;
    end
    else // 2Ԫ��û��In, 1Ԫ����In
    begin
      if ( nI[ 2 ] = nI[ 0 ] ) or ( nI[ 2 ] = nI[ 1 ] ) then // I2������1Ԫ��
      begin
        // I2��->I1��, I1���ӵ�
        if nI[ 2 ] = nI[ 0 ] then
        begin
          sI[ 1 ] := '-' + sI[ 3 ];
          CleanIStr( sI[ 1 ] );
          nI[ 1 ] := nI[ 3 ];
        end
        else  // I2��->I1��, I1���ӵ�
        begin
          sI[ 0 ] := '-' + sI[ 3 ];
          CleanIStr( sI[ 0 ] );
          nI[ 0 ] := nI[ 3 ];
        end;

        nI[ 2 ] := 2;
        sI[ 2 ] := sIb;
      end
      else
      begin
        // I2��->I1��, I1���ӵ�
        if nI[ 3 ] = nI[ 0 ] then
        begin
          sI[ 1 ] := '-' + sI[ 2 ];
          CleanIStr( sI[ 1 ] );
          nI[ 1 ] := nI[ 2 ];
        end
        else  // I2��->I1��, I1���ӵ�
        begin
          sI[ 0 ] := '-' + sI[ 2 ];
          CleanIStr( sI[ 0 ] );
          nI[ 0 ] := nI[ 2 ];
        end;

        nI[ 3 ] := 2;
        sI[ 3 ] := sIb;
      end;
    end;  
  end;
begin
  bHalf := False;
  sIa := C_EQ_SIGN_A;
  sIb := C_EQ_SIGN_B;
  sIc := C_EQ_SIGN_C;

  // �������߷�
  if sIa <> EmptyStr then
    if FWiringError.CT1Reverse then     // Ia ��
      sIa := '-' + sIa
    else
      sIa := '+' + sIa;

  if sIc <> EmptyStr then
    if FWiringError.CT2Reverse then     // Ic ��
      sIc := '-' + sIc
    else
      sIc := '+' + sIc;

  // ���ε�����·
  if FWiringError.CT1Short then
    sIa := sIb;

  if FWiringError.CT2Short then
    sIc := sIb;

  // ���ε�����·
  if FWiringError.InBroken then    // In ��·
    sIb := '';

  if FWiringError.IaBroken then
    sIa := '';

  if FWiringError.IcBroken then
    sIc := '';

  // ��������
  sI[ 0 ] := GetIOrder( FWiringError.I1In );
  sI[ 1 ] := GetIOrder( FWiringError.I1Out );
  sI[ 2 ] := GetIOrder( FWiringError.I2In );
  sI[ 3 ] := GetIOrder( FWiringError.I2Out );

  // �������
  for i := 0 to 3 do
  begin
    if Pos( C_EQ_SIGN_A, sI[ i ] ) > 0 then
      nI[ i ] := 1
    else if Pos( C_EQ_SIGN_C, sI[ i ] ) > 0 then
      nI[ i ] := 3
    else if Pos( C_EQ_SIGN_B, sI[ i ] ) > 0 then
      nI[ i ] := 2
    else  // ����
      nI[ i ] := 0;
  end;

  // ÿ��Ԫ����������״̬
  // 1. ����������( Iin = Iout ), I = ''
  // 2. �����������һ����( Iin = X or Iout = X ), I = '' �� ���ܻ�����������Ӻͷ���
  // 3. �����������һ����In( Iin = In or Iout = In )������һ���� Ia, Ic, ���ܻ�����������Ӻͷ���
  // 4. ���������û��In������Ia��Ic, ���ܻ�����������Ӻͷ���

  // ����Ԫ�����ܻ����16�����
  case IStatus( 1 ) * 10 + IStatus( 2 ) of
    11, 12, 21, 13, 31, 23, 32 : ProcI1I2;
    14, 41 :
    begin
      bHalf := True; // �����
      ProcI1I2;
    end;

    22 :
    begin
      ProcAllBroken;
      ProcI1I2;
    end;  

    33 :
    begin
      // �������ͬ�ĵ���, �����
      if ( ( nI[ 0 ] = nI[ 2 ] ) and ( nI[ 1 ] = nI[ 3 ] ) ) or
         ( ( nI[ 1 ] = nI[ 2 ] ) and ( nI[ 2 ] = nI[ 3 ] ) ) then
        bHalf := True;

      ProcI1I2;
    end;

    34, 43 :
    begin
      ProcOneIn;
      ProcI1I2;
    end;

    42, 24 :
    begin
      // ֻ�ж�n���������������
      bHalf := True;
      ProcI1I2;
    end;

    44 :
    begin
      bHalf := True;
      ProcI1I2;
    end;  
  end;

  AI1 := sI1;
  AI2 := sI2;
end;

procedure TWE_EXPRESSION.GetUIO(const dAngle: Double; const nU, nI: Integer;
  var sO: string; var nO: Integer; var bO: Boolean);
begin
  if bPubIsVectorAngle then
  begin
    bO := False;
  end
  else
  begin
    // Ĭ��Ϊ���ţ� �����ڵ�ѹ�ұߣ�����Ϊ��
    if dAngle < 0 then
      bO := True
    else
      bO := False;
  end;

  // ����н�
  nO := nU - nI;
  if nO > 360 then
    nO := nO - 360;

  bO := not bO;

  if nO > 180 then
  begin
    nO := 360 - nO;
    bO := not bO;
  end
  else if nO < - 180 then
  begin
    nO := 360 + nO;
  end
  else if nO < 0 then
  begin
    nO := -nO;
    bO := not bO;
  end;

  // ���ɽǶ�
  if bO then
  begin
    if nO <> 0 then
    begin
      if (nO = 180) and (dAngle > 0) then
      begin
        sO := IntToStr(nO) + '`' + '-' + sO;
      end
      else
      begin
        sO := IntToStr(nO) + '`' + '+' + sO;
      end;
    end;
  end
  else
  begin
    if nO <> 0 then
      sO := IntToStr(nO) + '`' + '-' + sO;
  end;
end;

function TWE_EXPRESSION.GetUIAngle: Double;
  function GetAngle(sCos : string) : Double;
  var
    dFi : Double;
    s : string;
    bC : Boolean;
  begin

    bC := Pos('C',sCos) > 0;
    if not bC then
      bC := Pos('c',sCos) > 0;

    s := StringReplace(sCos, 'L', '', [rfReplaceAll]);
    s := StringReplace(s, 'C', '', [rfReplaceAll]);
    s := StringReplace(s, 'l', '', [rfReplaceAll]);
    s := StringReplace(s, 'c', '', [rfReplaceAll]);

    TryStrToFloat(s, dFi);
    if dFi > 1 then
      dFi := 1;

    Result := ArcCos(dFi)/pi*180;

    if bC then
      Result := -Result;
  end;
begin
  with TIniFile.Create( ChangeFileExt( Application.ExeName, '.ini' ) ) do
  begin
    if ReadInteger( 'Like', 'CalcKType', 1) = 1 then
    begin
      Result := FUIAngle;
    end
    else
    begin
      Result := GetAngle(ReadString('Like', 'CalcKCos', '0.866'));
    end;

    Free;
  end;
end;

procedure TWE_EXPRESSION.SetWiringError(const Value: TWIRING_ERROR);
begin
  FWiringError.Assign( Value );
end;

function TWE_EXPRESSION.GetP3UAngle(const sU: string): Integer;
begin
  if sU = EmptyStr then
    Result := 0
  else if Pos('_a_b', sU) > 0 then
    Result := 120
  else if Pos('_a_c', sU) > 0 then
  begin
    // ���ϵ����sqrt3������PT�������
    if ( pos( C_EQ_SIGN_SQRT3, sU ) > 0 ) then
    begin
      if FWiringError.PT1Reverse and ( not FWiringError.PT2Reverse ) then
        Result := -30
      else if ( not FWiringError.PT1Reverse ) and FWiringError.PT2Reverse then
        Result := 150
      else if FWiringError.PT1Reverse and FWiringError.PT2Reverse then
        Result := 60 // Ӧ�ò�������������������������������Ӧ��U.c.a
      else
        Result := 60;
    end
    else
      Result := 60;
  end
  else if Pos('_b_a', sU) > 0 then
    Result := -60
  else if Pos('_b_c', sU) > 0 then
    Result := 0
  else if Pos('_c_a', sU) > 0 then
  begin
    // ���ϵ����sqrt3������PT�������
    if ( pos( C_EQ_SIGN_SQRT3, sU ) > 0 ) then
    begin
      if FWiringError.PT1Reverse and ( not FWiringError.PT2Reverse ) then
        Result := 150
      else if ( not FWiringError.PT1Reverse ) and FWiringError.PT2Reverse then
        Result := -30
      else if FWiringError.PT1Reverse and FWiringError.PT2Reverse then
        Result := -120
      else
        Result := -120;
    end
    else
      Result := -120;
  end
  else   // Ucb
    Result := 180;
end;

procedure TWE_EXPRESSION.GetP3USign(out AU1, AU2: string);
  /// <summary>
  /// ��ȡ��ѹ���ʽ
  /// </summary>
  function GetU( sUO1, sUO2 : string ) : string;
  begin
    case SubStrCount( '-', sUO1 + sUO2 ) of
      0 : // û�е�ѹ��
        Result := 'U' + SuffixVar( sUO1 ) + SuffixVar( sUO2 );

      1 : // һ����ѹ��
        if ( Pos( C_EQ_SIGN_A, sUO1 + sUO2 ) > 0 ) and
           ( Pos( C_EQ_SIGN_C, sUO1 + sUO2 ) > 0 ) then
          Result := C_EQ_SIGN_SQRT3 + 'U' + SuffixVar( sUO1 ) + SuffixVar( sUO2 )
        else
          Result := 'U' + SuffixVar( sUO2 ) + SuffixVar( sUO1 );

      2 : // ������ѹ��
        Result := 'U' + SuffixVar( sUO2 ) + SuffixVar( sUO1 );
    end;

    Result := StringReplace( Result, '-', '', [ rfReplaceAll ] );
  end;
var
  sU_Order : array[0..2] of string;   // ��ѹ����
  sU1, sU2 : string;
begin
  sU_Order[0] := C_EQ_SIGN_A;
  sU_Order[1] := C_EQ_SIGN_B;
  sU_Order[2] := C_EQ_SIGN_C;

  // һ�ζ���
  if FWiringError.UaBroken or FWiringError.UsaBroken then
    sU_Order[0] := EmptyStr;

  if FWiringError.UbBroken or FWiringError.UsbBroken then
    sU_Order[1] := EmptyStr;

  if FWiringError.UcBroken or FWiringError.UscBroken then
    sU_Order[2] := EmptyStr;

  // ��ѹ���� ����
  if FWiringError.PT1Reverse and ( sU_Order[0] <> EmptyStr ) then
    sU_Order[0] := '-' + sU_Order[0];  // PT1��

  if FWiringError.PT2Reverse and ( sU_Order[2] <> EmptyStr ) then
    sU_Order[2] := '-' + sU_Order[2];  // PT2��

  // ��ѹ���� ����
  ChangeSignSequence( sU_Order, FWiringError.USequence );

  // �ϳ�U1/U2
  if ( sU_Order[ 0 ] <> EmptyStr ) and
     ( sU_Order[ 1 ] <> EmptyStr ) then
  begin
    sU1 := GetU( sU_Order[0], sU_Order[1] );
  end;

  if ( sU_Order[ 2 ] <> EmptyStr ) and
     ( sU_Order[ 1 ] <> EmptyStr ) then
  begin
    sU2 := GetU( sU_Order[2], sU_Order[1] );
  end;

  // ��2������ʱ
  if ( ( sU_Order[ 0 ] = EmptyStr ) and ( sU_Order[ 1 ] = EmptyStr ) ) or
     ( ( sU_Order[ 0 ] = EmptyStr ) and ( sU_Order[ 2 ] = EmptyStr ) ) or
     ( ( sU_Order[ 1 ] = EmptyStr ) and ( sU_Order[ 2 ] = EmptyStr ) ) then
  begin
    sU1 := EmptyStr;
    sU2 := EmptyStr;
  end
  else if sU_Order[ 0 ] = EmptyStr then
  begin
    sU1 := EmptyStr;
  end
  else if sU_Order[ 2 ] = EmptyStr then
  begin
    sU2 := EmptyStr;
  end
  else if sU_Order[ 1 ] = EmptyStr then    // B ����
  begin
    sU1 := C_EQ_SIGN_1_2 + GetU( sU_Order[0], sU_Order[2] );
    sU2 := C_EQ_SIGN_1_2 + GetU( sU_Order[2], sU_Order[0] );

    if FWiringError.UbBroken then   // һ�ζ���
      if FWiringError.PT1Reverse then
      begin
        sU2 := StringReplace( sU2, C_EQ_SIGN_SQRT3, '', [] );
        sU1 := sU2;
      end
      else if FWiringError.PT2Reverse  then
      begin
        sU1 := StringReplace( sU1, C_EQ_SIGN_SQRT3, '', [] );
        sU2 := sU1;
      end;
  end;

  // ��������, ����ֵ
  CleanSigns( sU1 );
  CleanSigns( sU2 );

  if Pos( C_EQ_SIGN_1_2 + C_EQ_SIGN_SQRT3, sU1 ) > 0 then
    AU1 := StringReplace( sU1, C_EQ_SIGN_1_2 + C_EQ_SIGN_SQRT3, C_EQ_SIGN_SQRT3_2, [] )
  else
    AU1 := sU1;

  if Pos( C_EQ_SIGN_1_2 + C_EQ_SIGN_SQRT3, sU2 ) > 0 then
    AU2 := StringReplace( sU2, C_EQ_SIGN_1_2 + C_EQ_SIGN_SQRT3, C_EQ_SIGN_SQRT3_2, [] )
  else
    AU2 := sU2;
end;

procedure TWE_EXPRESSION.GetP4ISign(var AIOrder: array of string);
  function GetValue(sI : string; bIsReverse : Boolean) : string;
  begin
    if sI = 'A' then
    begin
      Result := AIOrder[ 0 ];
      if bIsReverse then
        Result := '-' + Result;
    end
    else if sI = 'B' then
    begin
      Result := AIOrder[ 1 ];
      if bIsReverse then
        Result := '-' + Result;
    end
    else if sI = 'C' then
    begin
      Result := AIOrder[ 2 ];
      if bIsReverse then
        Result := '-' + Result;
    end
    else
    begin
      if bIsReverse then
      begin
        Result := AIOrder[ 0 ] + AIOrder[ 1 ] +AIOrder[ 2 ];
      end
      else
      begin
        if AIOrder[ 0 ] <> '' then
          Result := Result + '-'+AIOrder[ 0 ];
        if AIOrder[ 1 ] <> '' then
          Result := Result + '-'+AIOrder[ 1 ];
        if AIOrder[ 2 ] <> '' then
          Result := Result + '-'+AIOrder[ 2 ];
      end;
    end;
  end;
var
  sI1, sI2, sI3 : string;
  bI1Reverse, bI2Reverse, bI3Reverse : Boolean;
begin
  if Length( AIOrder ) <> 3 then
    Exit;

  AIOrder[ 0 ] := 'I' + SuffixVar( C_EQ_SIGN_A );
  AIOrder[ 1 ] := 'I' + SuffixVar( C_EQ_SIGN_B );
  AIOrder[ 2 ] := 'I' + SuffixVar( C_EQ_SIGN_C );

//  // ����������
//  if (FWiringError.CT1Reverse and not FWiringError.I1Reverse) or
//    (not FWiringError.CT1Reverse and FWiringError.I1Reverse) then
//    AIOrder[ 0 ] := '-' + AIOrder[ 0 ];
//  if (FWiringError.CT2Reverse and not FWiringError.I2Reverse) or
//    (not FWiringError.CT2Reverse and FWiringError.I2Reverse) then
//    AIOrder[ 1 ] := '-' + AIOrder[ 1 ];
//  if (FWiringError.CT3Reverse and not FWiringError.I3Reverse) or
//    (not FWiringError.CT3Reverse and FWiringError.I3Reverse)  then
//    AIOrder[ 2 ] := '-' + AIOrder[ 2 ];

  // ����������
  if FWiringError.CT1Reverse then
    AIOrder[ 0 ] := '-' + AIOrder[ 0 ];
  if FWiringError.CT2Reverse then
    AIOrder[ 1 ] := '-' + AIOrder[ 1 ];
  if FWiringError.CT3Reverse then
    AIOrder[ 2 ] := '-' + AIOrder[ 2 ];

  // ���ε�����·
  // ���ε�����·
  if FWiringError.IaBroken or FWiringError.CT1Short then
    AIOrder[ 0 ] := '';

  if FWiringError.IbBroken or FWiringError.CT2Short then
    AIOrder[ 1 ] := '';

  if FWiringError.IcBroken or FWiringError.CT3Short then
    AIOrder[ 2 ] := '';


  if FWiringError.IsCanSetClearLinkeError and FWiringError.IsClearLinke then
  begin
    FWiringError.GetClearLinkeISequence(sI1, sI2, sI3,bI1Reverse, bI2Reverse, bI3Reverse);

    sI1 := GetValue(sI1, bI1Reverse);
    sI2 := GetValue(sI2, bI2Reverse);
    sI3 := GetValue(sI3, bI3Reverse);


    AIOrder[ 0 ] := sI1;
    AIOrder[ 1 ] := sI2;
    AIOrder[ 2 ] := sI3;

//    // ����������
//    if  bI1Reverse then
//      AIOrder[ 0 ] := '-' + AIOrder[ 0 ];
//    if bI2Reverse then
//      AIOrder[ 1 ] := '-' + AIOrder[ 1 ];
//    if bI3Reverse then
//      AIOrder[ 2 ] := '-' + AIOrder[ 2 ];


//    s := sI1 + sI2 + sI3;
//    if (s = 'ABC') or (s = 'ACB') or (s = 'BAC') or (s = 'BCA') or (s = 'CBA') or (s = 'CAB') then
//    begin
//      if s ='ABC' then FWiringError.ISequence := stABC;
//      if s ='ACB' then FWiringError.ISequence := stACB;
//      if s ='BAC' then FWiringError.ISequence := stBAC;
//      if s ='BCA' then FWiringError.ISequence := stBCA;
//      if s ='CBA' then FWiringError.ISequence := stCBA;
//      if s ='CAB' then FWiringError.ISequence := stCAB;
//
//      // ���� ����
//      ChangeSignSequence( AIOrder, FWiringError.ISequence );
//
//
//    end
//    else
//    begin
//
//    end;


  end
  else
  begin
    // ���� ����
    ChangeSignSequence( AIOrder, FWiringError.ISequence );

    // ����������
    if  FWiringError.I1Reverse then
      AIOrder[ 0 ] := '-' + AIOrder[ 0 ];
    if FWiringError.I2Reverse then
      AIOrder[ 1 ] := '-' + AIOrder[ 1 ];
    if FWiringError.I3Reverse then
      AIOrder[ 2 ] := '-' + AIOrder[ 2 ];
  end;

  AIOrder[ 0 ] := StringReplace(AIOrder[ 0 ], '--', '', [rfReplaceAll]);
  AIOrder[ 1 ] := StringReplace(AIOrder[ 1 ], '--', '', [rfReplaceAll]);
  AIOrder[ 2 ] := StringReplace(AIOrder[ 2 ], '--', '', [rfReplaceAll]);
end;

procedure TWE_EXPRESSION.GetP4USign( var AUOrder : array of string );
begin
  if Length( AUOrder ) <> 3 then
    Exit;

  AUOrder[0] := 'U' + SuffixVar( C_EQ_SIGN_A );
  AUOrder[1] := 'U' + SuffixVar( C_EQ_SIGN_B );
  AUOrder[2] := 'U' + SuffixVar( C_EQ_SIGN_C );

  // ����
  if FWiringError.UaBroken then
    AUOrder[0] := '';

  if FWiringError.UbBroken then
    AUOrder[1] := '';

  if FWiringError.UcBroken then
    AUOrder[2] := '';

  // ����
  ChangeSignSequence( AUOrder, FWiringError.USequence );
end;

procedure TWE_EXPRESSION.GetP4USignPT(var AUOrder: array of string);
begin
  if Length( AUOrder ) <> 3 then
    Exit;

  AUOrder[0] := 'U' + SuffixVar( C_EQ_SIGN_A );
  AUOrder[1] := 'U' + SuffixVar( C_EQ_SIGN_B );
  AUOrder[2] := 'U' + SuffixVar( C_EQ_SIGN_C );

  //PT����
  if FWiringError.PT1Reverse then
    AUOrder[0] := '-' + AUOrder[0];
  if FWiringError.PT2Reverse then
    AUOrder[1] := '-' + AUOrder[1];
  if FWiringError.PT3Reverse then
    AUOrder[2] := '-' + AUOrder[2];

  // ����
  if (FWiringError.UaBroken) or (FWiringError.UsaBroken) then
    AUOrder[0] := '';

  if (FWiringError.UbBroken) or (FWiringError.UsbBroken) then
    AUOrder[1] := '';

  if (FWiringError.UcBroken) or (FWiringError.UscBroken) then
    AUOrder[2] := '';

  // ����
  ChangeSignSequence( AUOrder, FWiringError.USequence );
end;

{ TWE_PHASE_EXPRESSION }

procedure TWE_PHASE_EXPRESSION.Clear;
begin
  ExpressionT := EmptyStr;
  ExpressUT := EmptyStr;
  ExpressIT := EmptyStr;

  Expression := EmptyStr;
  ExpressU := EmptyStr;  
  ExpressI := EmptyStr;  
  ExpressO := EmptyStr;
  AngleU   := 0;  
  AngleI   := 0;  
  AngleO   := 0;
  SignO    := True;

  Result1  := EmptyStr; 
  Result2  := EmptyStr; 
  CoCos    := EmptyStr; 
  CoSin    := EmptyStr;
end;

end.
