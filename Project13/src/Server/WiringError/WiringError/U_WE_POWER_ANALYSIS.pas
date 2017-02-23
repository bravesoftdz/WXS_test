{===============================================================================
  Copyright(c) 2007-2009, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ������ߣ����ߴ��󷴲�ģ��
    ���ݹ���״̬����ѯU1�Ƕȣ��Ϳ��ܵĴ���
  + TWE_POWER_ANALYSIS     ���󷴲�ģ��

===============================================================================}

unit U_WE_POWER_ANALYSIS;

interface

uses SysUtils, Classes;

type
  /// <summary>
  /// ����״̬
  /// </summary>
  TWE_POWER_STATUS = record
    U : Double;       // ���U
    I : Double;       // ���I
    UIAngle : Double; // ���UI�Ƕ�
    U1 : Double;
    I1 : Double;
    O1 : Double;
    U2 : Double;
    I2 : Double;
    O2 : Double;
    OU1U2 : Double;
  end;

type
  /// <summary>
  /// �����빦��״̬��
  /// </summary>
  TWE_PCODE_ERROR = record
    Code : Integer;
    UAngle : Integer;
    ErrID : Integer;
  end;

  TAWE_PCODE_ERROR = array of TWE_PCODE_ERROR;

type
  TIntArray = array of Integer;

type
  /// <summary>
  /// ���ߴ��󷴲�ģ��
  /// </summary>
  TWE_POWER_ANALYSIS = class( TComponent )
  private
    /// <summary>
    /// �����빦��״̬���б�
    /// </summary>
    PCodeErrList : TAWE_PCODE_ERROR;

    /// <summary>
    /// ����״̬��Ӵ����빦��״̬���б�ȡ����
    /// </summary>
    procedure GetUAnglesFromList( ACode : Integer; var AUAngles : TIntArray );

    /// <summary>
    /// ����״̬��Ӵ����빦��״̬���б�ȡ����
    /// </summary>
    procedure GetErrIDsFromList( ACode : Integer; var AErrIDs : TIntArray );

    /// <summary>
    /// �������в�ѯ��ӽ�������
    /// </summary>
    function GetMostCloseIndex( AList : array of Double; AValue : Double ) : Integer;

    /// <summary>
    /// ת���Ƕ�, ת��Ϊ0-359
    /// </summary>
    function CovAngle( AValue : Integer ) : Integer; overload;
    function CovAngle( AValue : Double ) : Integer; overload;

    /// <summary>
    /// ת��U�Ƕ�
    /// </summary>
    function CovU( AU : Double; APU : Double ) : Integer;

    /// <summary>
    /// ת��I�Ƕ�
    /// </summary>
    function CovI( AI : Double; API : Double ) : Integer;

    /// <summary>
    /// ת��UI�Ƕ�
    /// </summary>
    function CovO( AO : Double ) : Integer;

    /// <summary>
    /// ����״̬��
    /// </summary>
    function GetStatusCode( AStatus : TWE_POWER_STATUS ) : Integer;
  public
    /// <summary>
    /// ����U1�Ƕ�
    /// </summary>
    function GetUAngle( AStatus : TWE_POWER_STATUS ) : Integer;

    /// <summary>
    /// ��ȡ�����빦��״̬���б�
    /// </summary>
    procedure LoadPCodeErrList( AFileName : string );

    /// <summary>
    /// �������
    /// </summary>
    function GetErrIDs( AStatus : TWE_POWER_STATUS ) : TIntArray;
  end;

var
  PowerAnalysis : TWE_POWER_ANALYSIS;

implementation

{ TWE_POWER_ANALYSIS }

function TWE_POWER_ANALYSIS.CovAngle(AValue: Integer): Integer;
begin
  if AValue >= 360 then
    Result := AValue - 360
  else if AValue < 0 then
    Result := AValue + 360
  else
    Result := AValue;
end;

function TWE_POWER_ANALYSIS.CovAngle(AValue: Double): Integer;
var
  n : Integer;
begin
  n := Round( AValue );
  Result := CovAngle( n );
end;

function TWE_POWER_ANALYSIS.CovI(AI, API: Double): Integer;
var
  d : Double;
begin
  // ��׼����ѹ
  try
    d := AI / API;
  except
    d := AI;
  end;

  Result := GetMostCloseIndex( [ 0, 1, 0.5, 0.866, 1.732 ], d );
end;

function TWE_POWER_ANALYSIS.CovO( AO : Double ): Integer;
var
  d : Double;
begin
  d := CovAngle( Round( AO ) );

  Result := GetMostCloseIndex(
    [ 0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330 ], d );
end;

function TWE_POWER_ANALYSIS.CovU(AU, APU: Double): Integer;
var
  d : Double;
begin
  // ��׼����ѹ
  try
    d := AU / APU;
  except
    d := AU;
  end;

  Result := GetMostCloseIndex( [ 0, 1, 0.5, 0.866, 1.732 ], d );
end;

function TWE_POWER_ANALYSIS.GetErrIDs(AStatus: TWE_POWER_STATUS): TIntArray;
var
  nCode : Integer;
begin
  nCode := GetStatusCode( AStatus );
  GetErrIDsFromList( nCode, Result );
end;

procedure TWE_POWER_ANALYSIS.GetErrIDsFromList( ACode : Integer;
  var AErrIDs : TIntArray );
var
  i : Integer;
begin
  SetLength( AErrIDs, 0 );

  for i := 0 to Length( PCodeErrList ) - 1 do
    if PCodeErrList[ i ].Code = ACode then
    begin
      SetLength( AErrIDs, Length( AErrIDs ) + 1 );
      AErrIDs[ High( AErrIDs ) ] := PCodeErrList[ i ].ErrID;
    end;
end;

function TWE_POWER_ANALYSIS.GetMostCloseIndex(AList: array of Double;
  AValue: Double): Integer;
var
  i: Integer;
  dMin : Double;
begin
  Result := 0;
  dMin := Abs( AValue - AList[ 0 ] );

  for i := 1 to Length( AList ) - 1 do
  begin
    if Abs( AValue - AList[ i ] ) < dMin then
    begin
      dMin := Abs( AValue - AList[ i ] );
      Result := i;
    end;
  end;
end;

procedure TWE_POWER_ANALYSIS.GetUAnglesFromList( ACode : Integer;
  var AUAngles : TIntArray );
var
  i : Integer;
begin
  SetLength( AUAngles, 0 );

  for i := 0 to Length( PCodeErrList ) - 1 do
    if PCodeErrList[ i ].Code = ACode then
    begin
      SetLength( AUAngles, Length( AUAngles ) + 1 );
      AUAngles[ High( AUAngles ) ] := PCodeErrList[ i ].UAngle;
    end;
end;

procedure TWE_POWER_ANALYSIS.LoadPCodeErrList(AFileName: string);
var
  ms : TFileStream;
  rd : TReader;
  n : Integer;
begin
  if not FileExists( AFileName ) then
    Exit;

  try
    ms := TFileStream.Create( AFileName, fmOpenRead );
    rd := TReader.Create( ms, 1024 );
    SetLength( PCodeErrList, 0 );
    rd.ReadListBegin;

    while not rd.EndOfList do
    begin
      SetLength( PCodeErrList, Length( PCodeErrList ) + 1 );

      with PCodeErrList[ High( PCodeErrList ) ] do
      begin
        n := rd.ReadInteger;
        Code := n and $FFFFFFF0;
        UAngle := ( n and $F ) * 30;
        ErrID := rd.ReadInteger;
      end;
    end;
    rd.ReadListEnd;
    rd.Free;
    ms.Free;
  except
  end;
end;

function TWE_POWER_ANALYSIS.GetStatusCode(AStatus: TWE_POWER_STATUS): Integer;
begin
  with AStatus do
  begin
    Result := ( CovU( U1, U ) shl 4 + CovI( I1, I ) ) shl 24 +
      ( CovU( U2, U ) shl 4 + CovI( I2, I ) ) shl 16 +
      ( CovO( O1 - UIAngle ) shl 4 + CovO( O2 - UIAngle ) ) shl 8 +
      CovO( OU1U2 ) shl 4;
  end;
end;

function TWE_POWER_ANALYSIS.GetUAngle(AStatus: TWE_POWER_STATUS): Integer;
var
  nCode : Integer;
  UOList : TIntArray;
  n : Integer;
  i: Integer;
begin
  nCode := GetStatusCode( AStatus );
  GetUAnglesFromList( nCode, UOList );
  n := Length( UOList );

  if n = 0 then
  begin
    i := GetMostCloseIndex( [ 30, 60, 180, 330, 300 ], CovAngle( AStatus.OU1U2 ) );

    case i of
      0 : Result := 330;
      1, 2 : Result := 60;
      3 : Result := 150;
    else
      Result := 120;
    end;
  end
  else if n = 1 then
    Result := UOList[ 0 ]
  else
  begin  // ���ڶ��ֿ�����
    Result := UOList[ 0 ]; // Ĭ��ʹ�õ�һ��

    // ������ڽǶ�Ϊ120�� ��ʹ�øýǶ�
    for i := 0 to n - 1 do
      if UOList[ i ] = 120 then
      begin
        Result := 120;
        Break;
      end;
  end;
end;

end.
