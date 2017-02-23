unit xProtocolPacksDL645_97;

interface

uses System.Types, xProtocolPacks, System.Classes, system.SysUtils, xDL645Type,
  xFunction, xMeterDataRect, xProtocolPacksDl645;

type
  TProtocolPacksDl645_97 = class(TProtocolPacksDl645)
  private
  protected
    function CreatePackReadNextData: TBytes;override;   //  ����������
    function CreatePackReadAddr: TBytes;override;       //  ��ͨ�ŵ�ַ
    function CreatePackWriteData: TBytes;override;      //  д����
    function CreatePackChangePWD: TBytes;override;      //  ������
    function CreatePackClearMaxDemand: TBytes;override; //  �����������
    function CreatePackSetWOutType: TBytes;override;    //  ���ö๦�ܿ�
    function CreatePackIdentity: TBytes;override;       //  �����֤
    function CreatePackOnOffControl: TBytes;override;   //  �ѿ� ����բ

    /// <summary>
    /// �������յ������ݰ�
    /// </summary>
    procedure ParseRevPack( APack : TBytes ); override;
    procedure ParsePackReadData(APack : TBytes); // ����������
    procedure ParsePackNextData(APack : TBytes); // ��������������
    procedure ParsePackReadAddr(APack : TBytes); // ��������ַ

    function GetBaudRateCode( sBaudRate : string ) : Integer; override;

    /// <summary>
    /// ��ȡ��ʶ
    /// </summary>
    function GetSignCode( nDataSign : Int64) : TBytes; override;

    /// <summary>
    /// ��ȡ������
    /// </summary>
    function GetControlCode(ADL645Data : TDL645_DATA) : Integer; override;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure CreatePacks(var aDatas: TBytes; nCmdType: Integer; ADevice: TObject);override;
  public
    constructor Create; override;
    destructor Destroy; override;

  public


  end;

implementation

{ TProtocolPacksDl645_97 }

constructor TProtocolPacksDl645_97.Create;
begin
  inherited;

end;

function TProtocolPacksDl645_97.CreatePackChangePWD: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  //  ��ʶ
  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := ACodes[i] + $33;

  //  ����
  Result[14] := PWDLevel;
  for i := 0 to 2 do
    Result[15+i] := (ShortPWD shr ((2-i)*8) + $33) and $FF;

  //  ����
  for i := 0 to Length(FDevice.BytesDataValue) - 1 do
    Result[18 + i] := (UserCode shr ((Length(FDevice.BytesDataValue)-i-1)*8) +
      $33) and $FF;
end;

function TProtocolPacksDl645_97.CreatePackClearMaxDemand: TBytes;
begin
  SetLength( Result, GetSendCodeLen );
end;

function TProtocolPacksDl645_97.CreatePackIdentity: TBytes;
begin

end;

function TProtocolPacksDl645_97.CreatePackOnOffControl: TBytes;
begin

end;

function TProtocolPacksDl645_97.CreatePackReadAddr: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode($9010);

  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := ACodes[i] + $33;
end;

function TProtocolPacksDl645_97.CreatePackReadNextData: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := ACodes[i] + $33;
end;

procedure TProtocolPacksDl645_97.CreatePacks(var aDatas: TBytes; nCmdType: Integer;
  ADevice: TObject);
begin
  inherited;

end;

function TProtocolPacksDl645_97.CreatePackSetWOutType: TBytes;
begin

end;

function TProtocolPacksDl645_97.CreatePackWriteData: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  //  ��ʶ
  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := ACodes[i] + $33;

  //  ����
  for i := 0 to Length(FDevice.BytesDataValue) - 1 do
    Result[14 + i] := (UserCode shr ((Length(FDevice.BytesDataValue)-i-1)*8)
      + $33) and $FF;
end;

destructor TProtocolPacksDl645_97.Destroy;
begin

  inherited;
end;

function TProtocolPacksDl645_97.GetBaudRateCode(sBaudRate: string): Integer;
var
  nTemp : Integer;
begin
  TryStrToInt( sBaudRate, nTemp );
  case nTemp of
    600 : Result := 2;
    1200 : Result := 4;
    4800 : Result := 16;
    9600 : Result := 32;
    19200 : Result := 64
  else
    Result := 8;
  end;
end;

function TProtocolPacksDl645_97.GetControlCode(ADL645Data: TDL645_DATA): Integer;
begin
  case FDevice.OrderType of
    C_645_RESET_TIME:      Result := $08;
    C_645_READ_DATA:       Result := $01;
    C_645_READ_NEXTDATA:   Result := $02;
    C_645_READ_ADDR:       Result := $01;
    C_645_WRITE_DATA:      Result := $04;
    C_645_WRITE_ADDR:      Result := $0A;
    C_645_CHANGE_BAUD_RATE: Result := $0C;
    C_645_CHANGE_PWD:      Result := $0F;
    C_645_CLEAR_MAX_DEMAND: Result := $10;
  else
    Result := 0;
  end;
end;

function TProtocolPacksDl645_97.GetSignCode(nDataSign: Int64): TBytes;
begin
  SetLength( Result, 2 );
  Result[1] := nDataSign shr 8;
  Result[0] := nDataSign and $FF;
end;

procedure TProtocolPacksDl645_97.ParseRevPack(APack: TBytes);
  function IsError : Boolean;
  var
    A645Data : TDL645_DATA;
  begin
    Result := False;

    if (APack[8] and $40) = $40 then
    begin
      A645Data := TDL645_DATA.Create;
      A645Data.Assign(FDevice);
      Result := True;

      if APack[10] and $01 = $01 then
        A645Data.RePlyError := de645_07OtherError
      else if APack[10] and $02 = $02 then
        A645Data.RePlyError := de645_07NoneData
      else if APack[10] and $04 = $04 then
        A645Data.RePlyError := de645_07PwdError
      else if APack[10] and $08 = $08 then
        A645Data.RePlyError := de645_07BaudNotChange
      else if APack[10] and $10 = $10 then
        A645Data.RePlyError := de645_07OverYearTme
      else if APack[10] and $20 = $20 then
        A645Data.RePlyError := de645_07OverDayTime
      else if APack[10] and $40 = $40 then
        A645Data.RePlyError := de645_07OverRate;

      FRevList.AddObject('',A645Data);
    end
  end;
begin
  inherited;
  // �Ƿ��쳣
  if not IsError then
  begin
    case FDevice.OrderType of
      C_645_READ_DATA: ParsePackReadData(APack);
      C_645_READ_NEXTDATA: ParsePackNextData(APack);
      C_645_READ_ADDR: ParsePackReadAddr(APack);
    end;
  end;

  if Assigned(OnRev645Data) then
    OnRev645Data(FRevList);

  ClearStringList(FRevList);
end;

procedure TProtocolPacksDl645_97.ParsePackNextData(APack: TBytes);
begin

end;

procedure TProtocolPacksDl645_97.ParsePackReadAddr(APack: TBytes);
var
  i: Integer;
  A645Data : TDL645_DATA;
begin
  A645Data := TDL645_DATA.Create;
  A645Data.Assign( FDevice );
  A645Data.DataReply := '';

  for i := 0 to 5 do
    A645Data.DataReply := IntToHex(APack[i+1],2) + A645Data.DataReply;

  FRevList.AddObject( '',A645Data );
end;

procedure TProtocolPacksDl645_97.ParsePackReadData(APack: TBytes);
var
  ARev : TBytes;
  nIndex : Integer;
  i: Integer;
  A645Data : TDL645_DATA;
begin
  // 68 49 00 30 07 21 20 68 91 08 33 33 34 33 33 33 33 33 C3 16
  SetLength(ARev, FDevice.DataLen);
  nIndex := 12;
  while nIndex + FDevice.DataLen < Length(APack) do
  begin
    for i := 0 to Length(ARev) - 1 do
      ARev[i] := APack[nIndex + i] - $33;

    FDevice.BytesDataValue := ARev;
    GetRvdPackData;
    A645Data := TDL645_DATA.Create;
    A645Data.Assign( FDevice );

    FRevList.AddObject( '',A645Data );
    nIndex := nIndex + FDevice.DataLen;

    //  ���ݿ���AA�ָ�
    if APack[nIndex] = $AA then
      Inc(nIndex);
  end;
end;

end.



