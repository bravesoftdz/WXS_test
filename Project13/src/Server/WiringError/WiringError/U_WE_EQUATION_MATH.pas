{==============================================================================}
//  Copyright(c) 2009, ���������˵����Ǳ��������ι�˾
//  All rights reserved.

//  �����ĸ�ʽ  {1,8}
//  �����ĸ�ʽ  X
//  �±�ĸ�ʽ  _x, _1
//  �������    .X

// �������
//  sqrt3       #
//  ��           \o
//  ��           \a
//  ��           \b
//  ��           \q
//  ���ʽ      /

{==============================================================================}

unit U_WE_EQUATION_MATH;

interface

uses SysUtils, Classes, StrUtils;

const
  C_FMT_FRAC = '{%s,%s}';

const
  C_FMT_SUFFIX = '_%s';

const
  C_FMT_DOTVAR = '.%s';

type
  /// <summary>
  /// ����
  /// </summary>
  TWE_FRAC = record
    n : Integer;
    d : Integer;
  end;

type
  /// <summary>
  /// Ԫ������
  /// </summary>
  TWE_ELEMENT_TYPE = ( etNone,
                       etFrac,     //  �����ĸ�ʽ  {1,8}
                       etVar,      //  �����ĸ�ʽ  X
                       etSuffix,   //  �±�ĸ�ʽ  _x, _1
                       etDot,      //  �������    .X
                       etSpc       //  ���ʽ      /
                       );

/// <summary>
/// ȥ����ʽ�е�cos, sin
/// </summary>
procedure ReplaceCosSinWithFrac( var ACoef : string );

/// <summary>
/// �ӱ��ʽ��ȡ��Ԫ��
/// </summary>
/// <param name="AStr">���ʽ</param>
/// <param name="APos">��ʼλ��, ��1��ʼ</param>
/// <returns>Ԫ��</returns>
function GetElementsFromExpression( AStr : string; var APos : Integer ) : string;

/// <summary>
/// Ԫ������
/// </summary>
function ElementType( s : string ) : TWE_ELEMENT_TYPE;

/// <param name="ASpc"></param>
/// <summary>
/// �ӷ����л�÷��ӣ���ĸ���������ַ���
/// </summary>
/// <param name="AStr">�����ַ���</param>
/// <param name="AFrac">����</param>
/// <param name="ASpc">�����ַ�, ����sqrt3</param>
procedure ParseFrac( AStr : string; out AFrac : TWE_FRAC; out ASpc : string );

/// <summary>
/// ����ϵ�� -1/2Cos, sqrt3/2, 1/2 * sqrt3/2, etc.
/// </summary>
/// <param name="ACoef">ϵ��</param>
/// <param name="AFrac">����</param>
/// <param name="IsSqrt3">�Ƿ�Ϊsqrt3</param>
procedure CalCoef( ACoef : string; out AFrac : TWE_FRAC; out IsSqrt3 : Boolean );

/// <summary>
/// ϵ�����
/// </summary>
/// <param name="ACoefs">ϵ��</param>
/// <param name="AFrac">����</param>
/// <param name="AFracSqrt3">��Sqrt3�ķ���</param>
procedure PlusCoefs( ACoefs : array of string; out AFrac, AFracSqrt3 : TWE_FRAC );

/// <summary>
/// ����ϵ��
/// </summary>
function GenCoef( AFrac : TWE_FRAC; IsSqrt3 : Boolean ) : string; overload;

/// <summary>
/// ����ϵ��
/// </summary>
function GenCoef( AVal : Integer; IsSqrt3 : Boolean ) : string; overload;

/// <summary>
/// �ָ��ַ���
/// </summary>
procedure DivStr( AStr, ADivStr : string; out AStr1, AStr2 : string );

/// <summary>
/// ����ϵ��
/// </summary>
function RefinedCoef( ACoef : string ) : string;

/// <summary>
/// ������ʽ+-�������
/// </summary>
/// <param name="AWithPlusSign">�Ƿ���+��</param>
procedure CleanSigns( var s : string; AWithPlusSign : Boolean = True );

/// <summary>
/// ���ʽ������ϵ��, �ޱ��ʽʱΪ 0
/// </summary>
function ExtractExpressionIntCoef( const AStr : string; out AExpressionWithoutSign : string ) : Integer;

/// <summary>
/// ���ʽ���
/// </summary>
function PlusExpressions( const AStr1, AStr2 : string ) : string;

/// <summary>
/// ϵ�����
/// </summary>
function MultiplyExpressions( AStr1, AStr2 : string ) : string;

/// <summary>
/// �ϲ����ʽ
/// </summary>
function CombineExpressions( AExpressions : array of string ) : string;

/// <summary>
/// ��ȡ���������� ���� 2, 4, -2, 2 �Ĺ���������2
/// </summary>
function GetFactor( ANum : array of Integer ) : Integer;

/// <summary>
/// �Ƿ���sqrt3�ı���
/// </summary>
function HasSqrt3Factor( ANum1, ANum2 : Integer ) : Boolean;

/// <summary>
/// ����sqrt3
/// </summary>
procedure DivSqrt3( var AFrac, AFracSqrt3 : TWE_FRAC );

/// <summary>
/// �±����
/// </summary>
function SuffixVar( s : string ) : string;

/// <summary>
/// ʸ������
/// </summary>
function DotVar( s : string ) : string;

/// <summary>
/// �������
/// </summary>
function MultiplyFrac( AFrac1, AFrac2 : TWE_FRAC ) : TWE_FRAC; overload;
function MultiplyFrac( AFrac : TWE_FRAC; AVal : Integer ) : TWE_FRAC; overload;

/// <summary>
/// �������
/// </summary>
function PlusFrac( AFrac1, AFrac2 : TWE_FRAC ) : TWE_FRAC;

/// <summary>
/// �������
/// </summary>
function DivFrac( AFracNum, AFracDiv : TWE_FRAC ) : TWE_FRAC;

/// <summary>
/// ��ȡ��С����ĸ
/// </summary>
function GetCommonDen( AFracs : array of TWE_FRAC ) : Integer;

/// <summary>
/// �������
/// </summary>
procedure RefineFrac( var AFrac : TWE_FRAC );

/// <summary>
/// ��ȡ���ַ������ַ����еĸ���
/// </summary>
function SubStrCount( substr, str : string ) : Integer;

implementation

procedure DivStr( AStr, ADivStr : string; out AStr1, AStr2 : string );
var
  nPos : Integer;
begin
  nPos := Pos( ADivStr, AStr );

  if nPos > 1 then
  begin
    AStr1 := Copy( AStr, 1, nPos - 1 );
    AStr2 := Copy( AStr, nPos, Length( AStr ) - nPos + 1 );
  end
  else   // �ָ�ʧ��
  begin
    AStr1 := '';
    AStr2 := AStr;
  end;
end;

procedure CleanSigns( var s : string; AWithPlusSign : Boolean );
begin
  if ( Pos( '-', s ) > 0 ) or ( Pos( '+', s ) > 0 ) then
  begin
    // ȥ��+-��-+��--
    s := StringReplace( s, '+-', '-', [rfReplaceAll] );
    s := StringReplace( s, '-+', '-', [rfReplaceAll] );
    s := StringReplace( s, '--', '+', [rfReplaceAll] );
    s := StringReplace( s, '++', '+', [rfReplaceAll] );
  end;

  if not AWithPlusSign then
    s := StringReplace( s, '+', '', [rfReplaceAll] );
end;

function RefinedCoef( ACoef : string ) : string;
var
  frac : TWE_FRAC;
  bIsSqrt3 : Boolean;
begin
  CalCoef( ACoef, frac, bIsSqrt3 );
  Result := GenCoef( frac, bIsSqrt3 );
end;

function PlusExpressions( const AStr1, AStr2 : string ) : string;
begin
  if ( AStr1 = '' ) or ( AStr1 = '0' ) then
    Result := AStr2
  else if ( AStr2 = '' ) or ( AStr2 = '0' ) then
    Result := AStr1
  else
  begin
    Result := AStr1 + '+' + AStr2;
    CleanSigns( Result );  // ȥ�����ܳ��ֵ� +-
  end;  
end;

function ExtractExpressionIntCoef( const AStr : string; out AExpressionWithoutSign : string ) : Integer;
var
  i: Integer;
  sCof : string;
  p : PChar;
begin
  if ( AStr = '' ) or ( AStr = '0' )then
  begin
    AExpressionWithoutSign := AStr;
    Result := 0;
  end
  else
  begin
    p := PChar( AStr );
    sCof := '';

    // ȡϵ��
    for i := 1 to Length( AStr ) do
    begin
      if CharInSet(p^, [ '-', '+', '0'..'9' ])  then
      begin
        sCof := sCof + p^;
        Inc( p );
      end
      else
      begin
        AExpressionWithoutSign := Copy( AStr, i, Length( AStr ) - i + 1 );
        Break;
      end
    end;

    if ( sCof = '+' ) or ( sCof = '-' ) or ( sCof = '' ) then
      sCof := sCof + '1';

    TryStrToInt( sCof, Result );
  end;
end;

function CombineExpressions( AExpressions : array of string ) : string;
var
  i, j, nLen : Integer;
  aExpr : array of string;
  aExprSign : array of Integer;
  s : string;
begin
  nLen := Length( AExpressions );
  SetLength( aExpr, nLen );
  SetLength( aExprSign, nLen );

  for i := 0 to nLen - 1 do
    aExprSign[ i ] := ExtractExpressionIntCoef( AExpressions[ i ], aExpr[ i ] );

  for i := 0 to nLen - 2 do
    for j := i + 1 to nLen - 1 do
    begin
      if ( aExpr[ i ] = aExpr[ j ] ) and
        ( aExprSign[ i ] <> 0 ) and ( aExprSign[ j ] <> 0 ) then
      begin
        aExprSign[ i ] := aExprSign[ i ] + aExprSign[ j ];
        aExprSign[ j ] := 0;
        aExpr[ j ] := '';
      end;
    end;

  Result := '';

  for i := 0 to nLen - 1 do
    if aExprSign[ i ] <> 0 then
    begin
      s := '';

      if aExprSign[ i ] < 0 then
        s := '-';

      if ( Abs( aExprSign[ i ] ) <> 1 ) or ( aExpr[ i ] = '' ) then
        s := s + IntToStr( Abs( aExprSign[ i ] ) );

      Result := PlusExpressions( Result, s + aExpr[ i ] );
    end;

  CleanSigns( Result ); // ȥ�����ܲ�����+-��

  if Result = '' then
    Result := '0';
end;

procedure ParseFrac( AStr : string; out AFrac : TWE_FRAC; out ASpc : string );
var
  sFrac : string;
  pFrac : PChar;
  nPos : Integer;
  sNum, sDen : string;
  s : string;
begin
  // �����ĸ�ʽ  {1,8}
  sFrac := Trim( AStr );
  pFrac := PChar( sFrac );

  // ȥ��{}
  if ( pFrac^ = '{' ) and ( ( pFrac + Length( sFrac ) - 1 )^ = '}' ) then
    sFrac := Copy( sFrac, 2, Length( sFrac ) - 2 );

  nPos := Pos( ',', sFrac );
  sNum := Trim( Copy( sFrac, 1, nPos - 1 ) );
  sDen := Trim( Copy( sFrac, nPos + 1, Length( sFrac ) - nPos ) );

  // ������ӷ�ĸ
  AFrac.n := ExtractExpressionIntCoef( sNum, ASpc );
  AFrac.d := ExtractExpressionIntCoef( sDen, s );

  if AFrac.d = 0 then
    AFrac.d := 1;

  // ������ӣ���ĸͬʱ���� #, �򻯼�
  if ( Pos( '#', ASpc ) > 0 ) and ( Pos( '#', s ) > 0) then
  begin
    ASpc := StringReplace( ASpc, '#', '', [] );
    s := StringReplace( s, '#', '', [] );
  end;
  if (Trim(ASpc)='') and (Trim(S)='#') then
  begin
    AFrac.d:=AFrac.d * 3;
    ASpc:='#';
  end;
end;

function GetElementsFromExpression( AStr : string; var APos : Integer ) : string;
var
  p : PChar;
  i, n, nGet : Integer;
begin
  n := Length( AStr );
  Result := '';

  if ( APos > n ) or ( APos < 1 ) then
  begin
    APos := -1;
    Exit;
  end;

  p := PChar( AStr )+ APos - 1;
  n := n - APos; // ����ǰ�ֽ��⣬��ʣ���ֽڳ���
  nGet := 0;  // ��ȡ�ĳ���

  if  CharInSet(p^, [ '{', '_', '.', '\', '+', '-' ]) then
  begin
    case p^ of
      '{' :     //  �����ĸ�ʽ  {1,8}
      begin
        for i := 1 to n do
          if ( p + i )^ = '}' then
          begin
            Result := Copy( AStr, APos, i + 1 );
            nGet:= i + 1;
            Break;
          end;

        if Result = '' then
          raise Exception.Create( '����������' );
      end;

      //  �±�ĸ�ʽ  _x, _1  //  �������    .X
      // ������� \o  ��   \a  ��   \b  ��   \q  ��
      '_', '.', '\' :
      begin
        if n > 0 then
        begin
          Result := Copy( AStr, APos, 2 );
          nGet := 2;
        end;
      end;

      '+', '-' :
      begin
        Result := p^;
        Inc( nGet );
      end;
    end;
  end
  else  // ����Ǳ�������ֵ, ȡһ���ַ�
  begin
    Result := p^;
    Inc( nGet );
  end;

  if nGet < n + 1 then
    APos := APos + nGet
  else
    APos := -1;  // û�к���������
end;

function ElementType( s : string ) : TWE_ELEMENT_TYPE;
var
  p : PChar;
begin
  if Length( s ) = 0 then
  begin
    Result := etNone;
    Exit;
  end;  

  p := PChar( s );

  case p^ of
    '{' : Result := etFrac;
    '_' : Result := etSuffix;
    '.' : Result := etDot;
    '\' : Result := etSpc;
  else
    Result := etVar
  end;
end;  

procedure CalCoef( ACoef : string; out AFrac : TWE_FRAC; out IsSqrt3 : Boolean );
var
  nPos : Integer;
  s, sTemp : string;
  frac : TWE_FRAC;
begin
  if ACoef <> '' then
  begin
    // ��ʼ���� 1/1
    AFrac.n := 1;
    AFrac.d := 1;
    IsSqrt3 := False;

    nPos := 1;

    repeat
      s := GetElementsFromExpression( ACoef, nPos );

      if s = '-' then
        AFrac.n := AFrac.n * -1
      else if s = '#' then
      begin
        if IsSqrt3 then
        begin              // sqrt3 * sqrt3 = 3
          AFrac.n := AFrac.n * 3;
          IsSqrt3 := False;
        end
        else
          IsSqrt3 := True;
      end
      else if CharInSet(PChar(s)^, [ '1'..'9' ]) then
        AFrac.n := AFrac.n * ( ord ( PChar( s )^ ) - ord( '0' ) )
      else if ElementType( s ) = etFrac then
      begin
        // ����Ƿ���������
        ParseFrac( s, frac, sTemp );

        // �������
        AFrac := MultiplyFrac( AFrac, frac );

        if sTemp = '#' then
        begin
          if IsSqrt3 then
          begin              // sqrt3 * sqrt3 = 3
            AFrac.n := AFrac.n * 3;
            IsSqrt3 := False;
          end
          else
            IsSqrt3 := True;
        end;
      end;
    until nPos = -1;

    RefineFrac( AFrac );  // �������
  end
  else
  begin
    AFrac.n := 0;
    AFrac.d := 1;
    IsSqrt3 := False;
  end;  
end;

procedure PlusCoefs( ACoefs : array of string; out AFrac, AFracSqrt3 : TWE_FRAC );
var
  i: Integer;
  frac : TWE_FRAC;
  bSqrt : Boolean;
begin
  AFrac.n := 0;
  AFrac.d := 1;
  AFracSqrt3.n := 0;
  AFracSqrt3.d := 1;

  for i := 0 to Length( ACoefs ) - 1 do
  begin
    if ACoefs[ i ] = '' then
      Continue;
    
    CalCoef( ACoefs[ i ], frac, bSqrt );

    if bSqrt then
      AFracSqrt3 := PlusFrac( AFracSqrt3, frac )
    else
      AFrac := PlusFrac( AFrac, frac );
  end;
end;

function MultiplyExpressions( AStr1, AStr2 : string ) : string;
var
  n1, n2 : Integer;
  s1, s2 : string;
  n : Integer;
begin
  n1 := ExtractExpressionIntCoef( AStr1, s1 );
  n2 := ExtractExpressionIntCoef( AStr2, s2 );
  n := n1 * n2;
  if n < 0 then
    Result := '-'
  else
    Result := '';

  if Abs( n ) <> 1 then
    Result := Result + IntToStr( Abs( n ) );

  Result := Result + s1 + s2;
end;  

function PlusFrac( AFrac1, AFrac2 : TWE_FRAC ) : TWE_FRAC;
begin
  Result.n := AFrac1.n * AFrac2.d + AFrac2.n * AFrac1.d;
  Result.d := AFrac1.d * AFrac2.d;
  RefineFrac( Result );
end;

function DivFrac( AFracNum, AFracDiv : TWE_FRAC ) : TWE_FRAC;
var
  frac : TWE_FRAC;
begin
  frac.n := AFracDiv.d;                 // ȡ����
  frac.d := AFracDiv.n;
  Result := MultiplyFrac( AFracNum, frac );
end;

procedure RefineFrac( var AFrac : TWE_FRAC );
var
  nFactor : Integer;
begin
  if AFrac.d < 0 then     // �����ĸΪ -
  begin
    AFrac.n := AFrac.n * -1;
    AFrac.d := AFrac.d * -1;
  end;

  nFactor := GetFactor( [ AFrac.n, AFrac.d ] );

  if ( nFactor > 1 ) or ( nFactor < 0 ) then
  begin
    AFrac.n := AFrac.n div nFactor;
    AFrac.d := AFrac.d div nFactor;
  end;  
end;

function GenCoef( AFrac : TWE_FRAC; IsSqrt3 : Boolean ) : string;
begin
  if AFrac.n = 0 then
    Result := ''
  else
  begin
    if AFrac.d < 0 then // ��ĸΪ -
    begin
      AFrac.n := AFrac.n * -1;
      AFrac.d := AFrac.d * -1;
    end;

    if AFrac.d = 1 then   // ��ĸΪ 1
      Result := GenCoef( AFrac.n, IsSqrt3 )
    else
    begin
      if AFrac.n < 0 then
        Result := '-'
      else
        Result := '';

      Result := Result + Format( C_FMT_FRAC,
        [ GenCoef( Abs( AFrac.n ), IsSqrt3 ), IntToStr( AFrac.d ) ] );
    end;
  end;
end;

function GenCoef( AVal : Integer; IsSqrt3 : Boolean ) : string;
begin
  if AVal = 0 then
    Result := ''
  else
  begin
    if IsSqrt3 then
    begin
      if AVal < 0 then
        Result := '-'
      else
        Result := '';

      if Abs( AVal ) = 1 then
        Result := Result + '#'
      else
        Result := Result + IntToStr( Abs( AVal ) ) + '#';
    end
    else
      Result := IntToStr( AVal );
  end;
end;  

procedure ReplaceCosSinWithFrac( var ACoef : string );
begin
  if Pos( 'cos', ACoef ) > 0 then
  begin
    ACoef := StringReplace( ACoef, 'cos30`',  '{#,2}',  []);
    ACoef := StringReplace( ACoef, 'cos60`',  '{1,2}',  []);
    ACoef := StringReplace( ACoef, 'cos120`', '-{1,2}', []);
    ACoef := StringReplace( ACoef, 'cos150`', '-{#,2}', []);
  end
  else if Pos( 'sin', ACoef ) > 0 then
  begin
    ACoef := StringReplace( ACoef, 'sin30`',  '{1,2}',  []);
    ACoef := StringReplace( ACoef, 'sin60`',  '{#,2}',  []);
    ACoef := StringReplace( ACoef, 'sin120`', '{#,2}',  []);
    ACoef := StringReplace( ACoef, 'sin150`', '{1,2}',  []);
  end;  
end;

function GetFactor( ANum : array of Integer ) : Integer;
  function CanMod( ANum : array of Integer; AFactor : Integer ) : Boolean;
  var
    i: Integer;
  begin
    Result := True;

    for i := 0 to Length( ANum ) - 1 do
      if ANum[ i ] mod AFactor <> 0 then
      begin
        Result := False;
        Break;
      end;
  end;

  function UnZeroCount( ANum : array of Integer ) : Integer;
  var
    i: Integer;
  begin
    Result := 0;

    for i := 0 to Length( ANum ) - 1 do
      if Abs( ANum[ i ] ) <> 0 then
        Inc( Result );
  end;

  function AllMinus( ANum : array of Integer ) : boolean;
  var
    i: Integer;
  begin
    Result := True;

    for i := 0 to Length( ANum ) - 1 do
      if ANum[ i ] > 0 then
      begin
        Result := False;
        Break;
      end;
  end;
var
  i, j : Integer;
begin
  Result := 1;

  if UnZeroCount( ANum ) < 2 then
    Exit;

  for i := 2 to 3 do
    while CanMod( ANum, i ) do
    begin
      Result := Result * i;

      for j := 0 to Length( ANum ) - 1 do
        ANum[ j ] := ANum[ j ] div i;
    end;

  if AllMinus( ANum ) then
    Result := Result * -1;
end;

function SuffixVar( s : string ) : string;
begin
  Result := Format( C_FMT_SUFFIX, [ s ] );
end;

function DotVar( s : string ) : string;
begin
  Result := Format( C_FMT_DOTVAR, [ s ] );
end;  

function HasSqrt3Factor( ANum1, ANum2 : Integer ) : Boolean;
begin
  Result := ( Abs( ANum1 ) = 3 ) or ( ( Abs( ANum2 ) > 0 ) and ( ANum1 = 0 ) );
end;

procedure DivSqrt3( var AFrac, AFracSqrt3 : TWE_FRAC );
var
  frac : TWE_FRAC;
begin
  frac.n := AFrac.n div 3;
  frac.d := AFrac.d;

  AFrac := AFracSqrt3;
  AFracSqrt3 := frac;
end;

function MultiplyFrac( AFrac1, AFrac2 : TWE_FRAC ) : TWE_FRAC;
begin
  Result.n := AFrac1.n * AFrac2.n;
  Result.d := AFrac1.d * AFrac2.d;
  RefineFrac( Result );
end;

function MultiplyFrac( AFrac : TWE_FRAC; AVal : Integer ) : TWE_FRAC; overload;
begin
  Result.n := AFrac.n * AVal;
  Result.d := AFrac.d;
  RefineFrac( Result );
end;  

function GetCommonDen( AFracs : array of TWE_FRAC ) : Integer;
  function CanMod( var AFracs : array of TWE_FRAC; AFactor : Integer ) : Boolean;
  var
    i: Integer;
  begin
    Result := False;

    for i := 0 to Length( AFracs ) - 1 do
      if AFracs[ i ].d mod AFactor = 0 then
      begin
        Result := True;
        AFracs[ i ].d := AFracs[ i ].d div AFactor;
      end;
  end;
var
  i : Integer;
begin
  Result := 1;

  for i := 2 to 3 do
    while CanMod( AFracs, i ) do
      Result := Result * i;
end;

function SubStrCount(substr, str: string): Integer;
var
  nOffset : Integer;
begin
  nOffset := 1;
  Result  := 0;

  while PosEx( substr, str, nOffset ) > 0 do
  begin
    Inc( Result );
    nOffset := PosEx( substr, str, nOffset ) + 1;
  end;
end;



end.
