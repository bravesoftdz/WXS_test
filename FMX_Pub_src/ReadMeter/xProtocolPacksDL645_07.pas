unit xProtocolPacksDL645_07;

interface

uses System.Types, xProtocolPacks, System.Classes, system.SysUtils, xDL645Type,
  xFunction, xMeterDataRect, xProtocolPacksDl645;

type
  TProtocolPacksDl645_07 = class(TProtocolPacksDl645)
  private

    procedure CovStrToBCD( const s : string; const nLen, nFormatLen : Integer;
      var aBCD : TBytes );

    function GetDateTimeValue(sFormat: string;
      dtDatetime: TDateTime): TBytes;



  protected

    function CreatePackRsetTime: TBytes;override;       //  �㲥Уʱ
    function CreatePackReadData: TBytes;override;       //  ������
    function CreatePackReadNextData: TBytes;override;   //  ����������
    function CreatePackReadAddr: TBytes;override;       //  ��ͨ�ŵ�ַ
    function CreatePackWriteData: TBytes;override;      //  д����
    function CreatePackFreeze: TBytes;override;         //  ��������
    function CreatePackChangePWD: TBytes;override;      //  ������
    function CreatePackClearMaxDemand: TBytes;override; //  �����������
    function CreatePackClearData: TBytes;override;      //  �������
    function CreatePackClearEvent: TBytes;override;     //  �¼�����
    function CreatePackSetWOutType: TBytes;override;    //  ���ö๦�ܿ�
    function CreatePackIdentity: TBytes;override;       //  �����֤
    function CreatePackOnOffControl: TBytes;override;   //  �ѿ� ����բ
    function GetBaudRateCode( sBaudRate : string ) : Integer; override;

    /// <summary>
    /// ��ȡ������
    /// </summary>
    function GetControlCode(ADL645Data : TDL645_DATA) : Integer; override;

    /// <summary>
    /// ��ȡ�������������
    /// </summary>
    function GetSendCodeLen : Integer; override;

    /// <summary>
    /// ��ȡ��ʶ
    /// </summary>
    function GetSignCode( nDataSign : Int64) : TBytes; override;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure ParseRevPack( APack : TBytes ); override;
    procedure ParsePackReadData(APack : TBytes); // ����������
    procedure ParsePackNextData(APack : TBytes); // ��������������
    procedure ParsePackReadAddr(APack : TBytes); // ��������ַ
    procedure ParsePackClearData(APack : TBytes);
    procedure ParsePackIdentity(APack : TBytes); // ���������֤

  end;


implementation

{ TProtocolPacksDl645_07 }

procedure TProtocolPacksDl645_07.CovStrToBCD(const s: string; const nLen,
  nFormatLen: Integer; var aBCD: TBytes);
var
  i : Integer;
  sValue : string;
  sDataValue : string;
  nTemp  : Integer;
  j: Integer;
begin
  SetLength( aBCD, nLen );

  sValue := StringReplace(s,'.','',[rfReplaceAll]);

  if Length( sValue ) < nLen * 2 then
  begin
    for i := 1 to nLen * 2 - Length( sValue ) do
      sValue := '0' + sValue;
  end;

  if nFormatLen > 0 then
  begin
    for j := 0 to round( nLen / nFormatLen ) - 1   do
    begin
      sDataValue := Copy(sValue, j * nFormatLen * 2 + 1, nFormatLen *2 );
      for i := 0 to nFormatLen - 1 do
      begin
        TryStrToInt( '$' + Copy( sDataValue, i * 2 + 1, 2 ), nTemp );
        aBCD[ nFormatLen * j  + nFormatLen - 1 - i ] := nTemp;
      end;
    end;
  end;
end;

function TProtocolPacksDl645_07.CreatePackChangePWD: TBytes;
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
  Result[14] := PWDLevel + $33;
  for i := 0 to 2 do
    Result[15+i] := (ShortPWD shr ((2-i)*8) + $33) and $FF;

  //  �����ߴ���
  for i := 0 to 3 do
    Result[18+i] := (UserCode shr ((3-i)*8) + $33) and $FF;

  //  ����
  for i := 0 to Length(FDevice.BytesDataValue) - 1 do
    Result[22 + i] := (UserCode shr ((Length(FDevice.BytesDataValue)-i-1)*8) +
      $33) and $FF;
end;

function TProtocolPacksDl645_07.CreatePackClearData: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  //  Ȩ��
  Result[10] := (PWDLevel + $33) and $FF;
//  ����
  for i := 0 to 2 do
    Result[11+i] := (ShortPWD shr ((2-i)*8) + $33) and $FF;

  //  �����ߴ���
  for i := 0 to 3 do
    Result[14+i] := (UserCode shr ((3-i)*8) + $33) and $FF;
end;

function TProtocolPacksDl645_07.CreatePackClearEvent: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  //  ����
  Result[10] := (PWDLevel + $33) and $FF;
  for i := 0 to 2 do
    Result[11+i] := (ShortPWD shr ((2-i)*8) + $33) and $FF;

  //  �����ߴ���
  for i := 0 to 3 do
    Result[14+i] := (UserCode shr ((3-i)*8) + $33) and $FF;

  case FDevice.ClearEventTYPE of
    dct_07All :
    begin
      for i := 0 to 3 do
        Result[18+i] := ($FF + $33) and $FF;
    end;
    dct_07Item :
    begin
      Result[18] := ($FF + $33) and $FF;
      ACodes := GetSignCode(FDevice.DataSign);

      //  ��ʶ
      for i := 1 to Length(ACodes) - 1 do
        Result[18 + i] := (ACodes[i] + $33) and $FF;
    end;
  end;
end;

function TProtocolPacksDl645_07.CreatePackClearMaxDemand: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  //  Ȩ��
  Result[10] := (PWDLevel + $33) and $FF;
  //  ����
  for i := 0 to 2 do
    Result[11+i] := (ShortPWD shr ((2-i)*8) + $33) and $FF;

  //  �����ߴ���
  for i := 0 to 3 do
    Result[14+i] := (UserCode shr ((3-i)*8) + $33) and $FF;
end;

function TProtocolPacksDl645_07.CreatePackFreeze: TBytes;
begin
  SetLength(Result, GetSendCodeLen);
  case FDevice.FreezeType of
    dft_07Month:
    begin
      Result[10] := (GetDateTimeValue('nn',FDevice.DateTimeValue)[0] + $33) and $FF;
      Result[11] := (GetDateTimeValue('hh',FDevice.DateTimeValue)[0] + $33) and $FF;
      Result[12] := (GetDateTimeValue('DD',FDevice.DateTimeValue)[0] + $33) and $FF;
      Result[13] := $99 + $33;
    end;
    dft_07Day:
    begin
      Result[10] := (GetDateTimeValue('nn',FDevice.DateTimeValue)[0] + $33) and $FF;
      Result[11] := (GetDateTimeValue('hh',FDevice.DateTimeValue)[0] + $33) and $FF;
      Result[12] := $99 + $33;
      Result[13] := $99 + $33;
    end;
    dft_07Hour:
    begin
      Result[10] := (GetDateTimeValue('nn',FDevice.DateTimeValue)[0] + $33) and $FF;
      Result[11] := $99 + $33;
      Result[12] := $99 + $33;
      Result[13] := $99 + $33;
    end;
    dft_07Now:
    begin
      Result[10] := $99 + $33;
      Result[11] := $99 + $33;
      Result[12] := $99 + $33;
      Result[13] := $99 + $33;
    end;
  end;
end;

function TProtocolPacksDl645_07.CreatePackIdentity: TBytes;
var
  i : Integer;
  ACodes : TBytes;
  sTemp : string;
  nFormatLen : Integer;
  aBCD : TBytes;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  //  ��ʶ
  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := (ACodes[i] + $33) and $FF;
  //  �����֤û��Ȩ������
  //  �����ߴ���
  for i := 0 to 3 do
    Result[14+i] := (UserCode shr ((3-i)*8) + $33) and $FF;

  //  Ҫд������
  sTemp := Copy( FDevice.DataSend, 1, FDevice.DataLen*2 );
  nFormatLen := Round(Length( FDevice.DataFormat ) / 2);
  CovStrToBCD(sTemp, FDevice.DataLen,nFormatLen, aBCD);
  for i := 0 to FDevice.DataLen - 1 do
  begin
    Result[ 18 + i ] := (aBCD[ i ] + $33) and $FF ;
  end;
end;

function TProtocolPacksDl645_07.CreatePackOnOffControl: TBytes;
var
  i: Integer;
  sTemp : string;
  aBCD : TBytes;
begin
  SetLength( Result, GetSendCodeLen );

  //  ����   98��
  Result[10] := $98 + $33;
  for i := 0 to 2 do
    Result[11+i] := (ShortPWD shr ((2-i)*8) + $33) and $FF;

  //  �����ߴ���
  for i := 0 to 3 do
    Result[14+i] := (UserCode shr ((3-i)*8) + $33) and $FF;

  //  Ҫд������
  sTemp := Copy( FDevice.DataSend, 1, FDevice.DataLen*2 );
  // ����բ���ĵĳ��� Ϊ 20 �ֽ�

  CovStrToBCD(sTemp, FDevice.DataLen,20, aBCD);
  for i := 0 to FDevice.DataLen - 1 do
  begin
    Result[ 18 + i ] := (aBCD[ i ] + $33) and $FF;
  end;
end;

function TProtocolPacksDl645_07.CreatePackReadAddr: TBytes;
begin
  SetLength(Result, GetSendCodeLen);
end;

function TProtocolPacksDl645_07.CreatePackReadData: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := (ACodes[i] + $33) and $FF;

  if (Length(Result) = 22) and (FDevice.ReadLoadRecord = 2) then
  begin
    Result[14]  := (FDevice.BlockNum + $33) and $FF;
    Result[15] := (GetDateTimeValue('mm', FDevice.DateTimeValue)[0] + $33) and $FF;
    Result[16] := (GetDateTimeValue('hh', FDevice.DateTimeValue)[0] + $33) and $FF;
    Result[17] := (GetDateTimeValue('DD', FDevice.DateTimeValue)[0] + $33) and $FF;
    Result[18] := (GetDateTimeValue('MM', FDevice.DateTimeValue)[0] + $33) and $FF;
    Result[19] :=( GetDateTimeValue('YY', FDevice.DateTimeValue)[0] + $33) and $FF;
  end;
end;

function TProtocolPacksDl645_07.CreatePackReadNextData: TBytes;
var
  ACodes : TBytes;
  i: Integer;
begin
  SetLength( Result, GetSendCodeLen );
  ACodes := GetSignCode(FDevice.DataSign);

  for i := 0 to Length(ACodes) - 1 do
    Result[10 + i] := (ACodes[i] + $33) and $FF;

  Result[14] := (FDevice.DataPackSN + $33) and $FF;
end;

function TProtocolPacksDl645_07.CreatePackRsetTime: TBytes;
begin
  // 68 99 99 99 99 99 99 68 08 06 ss mm hh DD MM YY CS 16
  SetLength( Result, GetSendCodeLen );
  Result[10]  := (GetDateTimeValue('ss', FDevice.DateTimeValue)[0] + $33) and $FF;
  Result[11] := (GetDateTimeValue('mm', FDevice.DateTimeValue)[0] + $33) and $FF;
  Result[12] := (GetDateTimeValue('hh', FDevice.DateTimeValue)[0] + $33) and $FF;
  Result[13] := (GetDateTimeValue('DD', FDevice.DateTimeValue)[0] + $33) and $FF;
  Result[14] := (GetDateTimeValue('MM', FDevice.DateTimeValue)[0] + $33) and $FF;
  Result[15] := (GetDateTimeValue('YY', FDevice.DateTimeValue)[0] + $33) and $FF;
end;

function TProtocolPacksDl645_07.CreatePackSetWOutType: TBytes;
begin
  SetLength( Result, GetSendCodeLen );
  Result[ 10 ]:= (StrToInt( '$' + FDevice.DataSend ) + $33) and $FF;
end;

function TProtocolPacksDl645_07.CreatePackWriteData: TBytes;
begin

end;

function TProtocolPacksDl645_07.GetBaudRateCode(sBaudRate: string): Integer;
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

function TProtocolPacksDl645_07.GetControlCode(ADL645Data : TDL645_DATA): Integer;
begin
  //  ���ͷ��򡢴�վӦ�𡢺���֡��־ ֱ�Ӹ�ֵ0
  case FDevice.OrderType of
    C_645_RESET_TIME:      Result := $08;
    C_645_READ_DATA:       Result := $11;
    C_645_READ_NEXTDATA:   Result := $12;
    C_645_READ_ADDR:       Result := $13;
    C_645_WRITE_DATA:      Result := $14;
    C_645_WRITE_ADDR:      Result := $15;
    C_645_FREEZE:         Result := $16;
    C_645_CHANGE_BAUD_RATE: Result := $17;
    C_645_CHANGE_PWD:      Result := $18;
    C_645_CLEAR_MAX_DEMAND: Result := $19;
    C_645_CLEAR_RDATA:      Result := $1A;
    C_645_CLEAR_REVENT:     Result := $1B;
    C_SET_WOUT_TYPE:       Result := $1D;
    C_645_IDENTITY:       Result := $03;
    C_645_ONOFF_CONTROL:   Result := $1C;

  else
    Result := 0;
  end;
end;

function TProtocolPacksDl645_07.GetDateTimeValue(sFormat: string;
  dtDatetime: TDateTime): TBytes;
begin
  Result := StrToPacks( FormatDateTime(sFormat, dtDatetime) )
end;

function TProtocolPacksDl645_07.GetSendCodeLen: Integer;
begin
  case FDevice.OrderType of
    C_645_RESET_TIME:      Result := 18;
    C_645_READ_NEXTDATA:   Result := 17;
    C_645_READ_ADDR:       Result := 12;
    C_645_READ_DATA:
    begin
      if FDevice.ReadLoadRecord = 1 then
        Result := 17
      else if FDevice.ReadLoadRecord = 2 then
        Result := 22
      else
        Result := 16;
    end;
    C_645_WRITE_DATA:      Result := 24 + FDevice.DataLen;
    C_645_WRITE_ADDR:      Result := 18;
    C_645_FREEZE:         Result := 16;
    C_645_CHANGE_BAUD_RATE: Result := 13;
    C_645_CHANGE_PWD:      Result := 24;
    C_645_CLEAR_MAX_DEMAND: Result := 20;
    C_645_CLEAR_RDATA:      Result := 20;
    C_645_CLEAR_REVENT:     Result := 24;
    C_SET_WOUT_TYPE :      result := 13;
    C_645_IDENTITY :      Result := 20 + FDevice.DataLen;
    C_645_ONOFF_CONTROL  : result := 20 + FDevice.DataLen;

  else
  	Result := 16;
  end;
end;

function TProtocolPacksDl645_07.GetSignCode(nDataSign: Int64): TBytes;
begin
  SetLength(Result,4);
  Result[0] := nDataSign and $FF;
  Result[1] := nDataSign shr 8 and $FF;
  Result[2] := nDataSign shr 16 and $FF;
  Result[3] := nDataSign shr 24 and $FF;
end;

procedure TProtocolPacksDl645_07.ParseRevPack(APack: TBytes);
  function IsError : Boolean;
  var
    A645Data : TDL645_DATA;
  begin
    Result := False;

    if APack[8] in [$D1, $D2, $D4, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $C3] then
    begin
      ClearStringList(FRevList);
      A645Data := TDL645_DATA.Create;
      A645Data.Assign(FDevice);
      Result := True;

      // һ���ֽڵĴ�����
      if APack[9] = 01 then
      begin
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
      end
      // �����ֽڵĴ�����
      else if APack[9] = 02 then
      begin
        if APack[11] and $01 = $01 then
          A645Data.RePlyError := de645_07OtherError
        else if APack[11] and $02 = $02 then
          A645Data.RePlyError := de645_07RepeatTopUp
        else if APack[11] and $04 = $04 then
          A645Data.RePlyError := de645_07ESAMError
        else if APack[11] and $08 = $08 then
          A645Data.RePlyError := de645_07IdentityError
        else if APack[11] and $10 = $10 then
          A645Data.RePlyError := de645_07ClientSNError
        else if APack[11] and $20 = $20 then
          A645Data.RePlyError := de645_07TopUpTimesError
        else if APack[11] and $40 = $40 then
          A645Data.RePlyError := de645_07BuyOverError;
      end;

      FRevList.AddObject('',A645Data);
    end
  end;
begin
  inherited;
  // �Ƿ��쳣
  if not IsError then
  begin
    ClearStringList(FRevList);
    case FDevice.OrderType of
      C_645_READ_DATA: ParsePackReadData(APack);
      C_645_READ_NEXTDATA: ParsePackNextData(APack);
      C_645_READ_ADDR: ParsePackReadAddr(APack);
      C_645_IDENTITY: ParsePackIdentity(APack);
      //  д���ݣ� ������ ��������
      C_645_WRITE_DATA,
      C_645_CLEAR_RDATA,
      C_645_CHANGE_BAUD_RATE,
      C_645_CLEAR_REVENT ,
      C_645_ONOFF_CONTROL:ParsePackClearData(APack);
    end;
  end;

  if Assigned(OnRev645Data) then
    OnRev645Data(FRevList);
end;

procedure TProtocolPacksDl645_07.ParsePackClearData(APack: TBytes);
var
  A645Data : TDL645_DATA;
begin
  A645Data := TDL645_DATA.Create;
  A645Data.Assign( FDevice );
  A645Data.DataReply := '';

  FRevList.AddObject( '',A645Data );
end;

procedure TProtocolPacksDl645_07.ParsePackIdentity(APack: TBytes);
var
  ARev : TBytes;
  nIndex : Integer;
  i: Integer;
  A645Data : TDL645_DATA;
  nRvdDataLen : Integer;
begin
  // 68 49 00 30 07 21 20 68 91 08 33 33 34 33 33 33 33 33 C3 16
  nIndex := 14;

  FDevice.DataReply := '';

  // ����У��λ�ͽ�����
  if length(APack) > 16 then
  begin
    nRvdDataLen := APack[9] - 4;
    SetLength(ARev, nRvdDataLen);

    if nIndex + nRvdDataLen <= Length(APack) - 2 then
    begin
      for i := 0 to nRvdDataLen - 1 do
        ARev[i] := (APack[nIndex + i] - $33) and $FF;

      FDevice.BytesDataValue := ARev;

      for i := 0 to Length(ARev) - 1 do
        FDevice.DataReply := IntToHex(ARev[i], 2) + FDevice.DataReply;

      A645Data := TDL645_DATA.Create;
      A645Data.Assign( FDevice );

      FRevList.AddObject( '',A645Data );
    end;
  end;
end;

procedure TProtocolPacksDl645_07.ParsePackNextData(APack: TBytes);
var
  ARev : TBytes;
  nIndex : Integer;
  i: Integer;
  A645Data : TDL645_DATA;
  nRvdDataLen : Integer;
begin
//  �ж������д��� �����ʺ�����ѭ��
  // 68 49 00 30 07 21 20 68 91 08 33 33 34 33 33 33 33 33 C3 16
  SetLength(ARev, FDevice.DataLen);
  nIndex := 14;
  FDevice.DataReply := '';
  // ����У��λ�ͽ�����
  if length(APack) > 16 then
  begin
    nRvdDataLen := APack[9] - 4;
    SetLength(ARev, nRvdDataLen);
    if nIndex + nRvdDataLen <= Length(APack) - 2 then
    begin
      for i := 0 to nRvdDataLen - 1 do
      begin
        ARev[i] := (APack[nIndex + i] - $33) and $FF;
      end;
      FDevice.BytesDataValue := ARev;
      GetRvdPackData;

      A645Data := TDL645_DATA.Create;
      A645Data.Assign( FDevice );

      FRevList.AddObject( '',A645Data );
    end;
  end;
end;

procedure TProtocolPacksDl645_07.ParsePackReadAddr(APack: TBytes);
var
  i: Integer;
  A645Data : TDL645_DATA;
begin
//���ͣ�68 AA AA AA AA AA AA 68 13 00 DF 16
//      68 01 00 00 00 00 00 68 93 06 34 33 33 33 33 33 9D 16

  A645Data := TDL645_DATA.Create;
  A645Data.Assign( FDevice );
  A645Data.DataReply := '';

  for i := 0 to 5 do
    A645Data.DataReply := IntToHex((APack[i+10]-$33)and $FF,2)  + A645Data.DataReply;

  FRevList.AddObject( '',A645Data );
end;

procedure TProtocolPacksDl645_07.ParsePackReadData(APack: TBytes);
var
  ARev : TBytes;
  nIndex : Integer;
  i: Integer;
  A645Data : TDL645_DATA;
  nRvdDataLen : Integer;
begin
//  �ж������д��� �����ʺ�����ѭ��
  // 68 49 00 30 07 21 20 68 91 08 33 33 34 33 33 33 33 33 C3 16
  SetLength(ARev, FDevice.DataLen);
  nIndex := 14;
  FDevice.DataReply := '';
  // ����У��λ�ͽ�����
  if length(APack) > 16 then
  begin
    nRvdDataLen := APack[9] - 4;
    SetLength(ARev, nRvdDataLen);
    if nIndex + nRvdDataLen <= Length(APack) - 2 then
    begin
      for i := 0 to nRvdDataLen - 1 do
      begin
        ARev[i] := (APack[nIndex + i] - $33) and $FF;
      end;
      FDevice.BytesDataValue := ARev;
      GetRvdPackData;

      A645Data := TDL645_DATA.Create;
      A645Data.Assign( FDevice );
      A645Data.DataPackSN := -1;

      FRevList.AddObject( '',A645Data );
    end;
  end;
end;

end.



