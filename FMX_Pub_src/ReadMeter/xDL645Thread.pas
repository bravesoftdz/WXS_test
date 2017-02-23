unit xDL645Thread;

interface

uses System.Types, xProtocolPacks, System.Classes, system.SysUtils, xDL645Type,
  xFunction, xMeterDataRect, xThreadBase, xProtocolPacksDl645,
  xProtocolPacksDL645_07, xProtocolPacksDL645_97, xProtocolDL645;

type
  TDL645Thread = class(TThreadBase)

  private
    FProrocolType: TDL645_PROTOCOL_TYPE;
    FOnRev645Data: TGet645Data;
    FMeterAddr: string;
    FDL645_97BaudRate: string;
    FDL645_07BaudRate: string;
    FIsWairtForComm: Boolean;
    procedure SetProrocolType(const Value: TDL645_PROTOCOL_TYPE);

    /// <summary>
    /// ��������
    /// </summary>
    procedure Rve645Data( A645data : TStringList );
    procedure SetMeterAddr(const Value: string);
  protected

  public
    constructor Create(CreateSuspended: Boolean);override;
    destructor Destroy; override;



    /// <summary>
    /// ִ������
    /// </summary>
    /// <param name="ACmdType">��������</param>
    /// <param name="ADevice">�������</param>
    /// <param name="bWairtExecute">�Ƿ�ȴ�ִ����������Ƴ�����</param>
    procedure AddOrder( ACmdType: Integer; ADevice: TObject; bWairtExecute : Boolean = True); override;


    /// <summary>
    /// Э������
    /// </summary>
    property ProrocolType : TDL645_PROTOCOL_TYPE read FProrocolType write SetProrocolType;

    /// <summary>
    /// DL645-2007������ Ĭ��2400
    /// </summary>
    property DL645_07BaudRate : string read FDL645_07BaudRate write FDL645_07BaudRate;

    /// <summary>
    /// DL645-1997������ Ĭ��1200
    /// </summary>
    property DL645_97BaudRate : string read FDL645_97BaudRate write FDL645_97BaudRate;
    /// <summary>
    /// �Ƿ�ȴ�ͨѶ��ɲż���
    /// </summary>
    property IsWairtForComm : Boolean read FIsWairtForComm write FIsWairtForComm;


    /// <summary>
    /// ͨѶ��ַ
    /// </summary>
    property MeterAddr : string read FMeterAddr write SetMeterAddr;

    /// <summary>
    /// ������
    /// </summary>
    procedure ReadMeterData( nSign, nLen : Int64; sFormt : string);

    /// <summary>
    /// ����������
    /// </summary>
    procedure ReadMeterDataNext( nSign, nLen : Int64; sFormt : string; nDataPackS : Integer);

    /// <summary>
    /// ��ȡ����ʱ��ĸ��ɼ�¼��
    /// </summary>
    procedure ReadLoadRecord(nSign, nLen : Int64; sFormt : string;
      dtTime: TDateTime; nNum:Integer);

    /// <summary>
    /// �㲥Уʱ
    /// </summary>
    procedure ResetDateTime( dtDateTime : TDateTime );

    /// <summary>
    /// ��ͨ�ŵ�ַ
    /// </summary>
    procedure ReadMeterAddr;

    /// <summary>
    /// д����
    /// </summary>
    procedure WriteData( nSign:Int64; nLen : Integer; sFormt, sValue : string );

    /// <summary>
    /// дͨѶ��ַ
    /// </summary>
    procedure WriteMeterAddr( nAddr : Int64 );

    /// <summary>
    /// ��������
    /// </summary>
    procedure Freeze(dtDateTime: TDateTime; FreezeType: TDL645_07_FREEZE_TYPE);

    /// <summary>
    /// �Ĳ�����
    /// </summary>
    procedure ChangeBaudRate( nBaudRate : Integer );

    /// <summary>
    /// ������
    /// </summary>
    procedure ChangePWD( nNewPWD : Integer );

    /// <summary>
    /// �����������
    /// </summary>
    procedure ClearMaxDemand;

    /// <summary>
    /// �������
    /// </summary>
    procedure ClearData;

    /// <summary>
    /// �¼�����
    /// </summary>
    procedure ClearEvent(nSign: Int64; AEventType: TDL645_07_CLEAREVENT_TYPE);

    /// <summary>
    ///  ���ö๦�ܿ����
    /// </summary>
    procedure SetWOutType(AType : TMOUT_TYPE);

    /// <summary>
    ///  �����֤
    /// </summary>
    procedure IdentityAuthentication( nSign:Int64; nLen : Integer; sFormt, sValue : string );

    /// <summary>
    ///  �ѿز���  ����բ ��    ����բ ���� 20���ֽ�
    /// </summary>
    procedure OnOffControl( nLen : Integer; sValue : string );

    /// <summary>
    /// ���������¼�
    /// </summary>
    property OnRev645Data : TGet645Data read FOnRev645Data write FOnRev645Data;
  end;

implementation

{ TDL645Thread }

procedure TDL645Thread.AddOrder(ACmdType: Integer; ADevice: TObject;
  bWairtExecute: Boolean);
begin
  if Assigned(ADevice) and (ADevice is TDL645_DATA) then
  begin
    TDL645_DATA(ADevice).MeterProtocolType := FProrocolType;
    TDL645_DATA(ADevice).OrderType := ACmdType;
  end;

  inherited;
end;

procedure TDL645Thread.ChangeBaudRate(nBaudRate: Integer);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;

  ARevData.DataSend := IntToStr(nBaudRate);
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_CHANGE_BAUD_RATE, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ChangePWD(nNewPWD: Integer);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.MeterProtocolType := FProrocolType;
  ARevData.DataSend := IntToStr(nNewPWD);
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_CHANGE_PWD, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ClearData;
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.Address := FMeterAddr;
  ARevData.MeterProtocolType := FProrocolType;
  AddOrder( C_645_CLEAR_RDATA, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ClearEvent(nSign: Int64;
  AEventType: TDL645_07_CLEAREVENT_TYPE);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.ClearEventTYPE := AEventType;
  ARevData.Address := FMeterAddr;
  ARevData.DataSign := nSign;
  AddOrder( C_645_CLEAR_REVENT, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ClearMaxDemand;
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.Address := FMeterAddr;
  AddOrder( C_645_CLEAR_MAX_DEMAND, ARevData, FIsWairtForComm);
end;

constructor TDL645Thread.Create(CreateSuspended: Boolean);
begin
  inherited;
  FProtocol := TProtocolDL645.Create;
  SetProrocolType(dl645pt2007);

  TProtocolDL645(FProtocol).OnRev645Data := Rve645Data;

  FMeterAddr := '999999999999';

  FDL645_97BaudRate:= '1200';
  FDL645_07BaudRate:= '2400';
  FIsWairtForComm := True;
end;

destructor TDL645Thread.Destroy;
begin

  inherited;
end;


procedure TDL645Thread.Freeze(dtDateTime: TDateTime;
  FreezeType: TDL645_07_FREEZE_TYPE);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.FreezeType := FreezeType;
  ARevData.DateTimeValue := dtDateTime;
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_FREEZE, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.IdentityAuthentication(nSign: Int64; nLen: Integer;
  sFormt, sValue: string);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSign := nSign;
  ARevData.DataLen := nLen;
  ARevData.DataFormat := sFormt;
  ARevData.DataSend := sValue;
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_IDENTITY, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.OnOffControl(nLen: Integer; sValue: string);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataLen := nLen;
  ARevData.DataSend := sValue;
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_ONOFF_CONTROL, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ReadLoadRecord(nSign, nLen: Int64; sFormt: string;
  dtTime: TDateTime; nNum: Integer);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSign := nSign;
  ARevData.DataLen := nLen;
  ARevData.DataFormat := sFormt;
  ARevData.Address := FMeterAddr;
  ARevData.DateTimeValue := dtTime;
  ARevData.BlockNum := nNum;
  if (ARevData.DateTimeValue > 1) and (ARevData.BlockNum > 0) then
    ARevData.ReadLoadRecord := 2;

  AddOrder( C_645_READ_DATA, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ReadMeterAddr;
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.OrderType := C_645_READ_ADDR;
  AddOrder( C_645_READ_ADDR, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ReadMeterData(nSign, nLen: Int64; sFormt: string);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSign := nSign;
  ARevData.DataLen := nLen;
  ARevData.DataFormat := sFormt;
  ARevData.Address := FMeterAddr;
  AddOrder( C_645_READ_DATA, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ReadMeterDataNext(nSign, nLen: Int64; sFormt: string;
  nDataPackS: Integer);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSign := nSign;
  ARevData.DataLen := nLen;
  ARevData.DataFormat := sFormt;
  ARevData.Address := FMeterAddr;
  ARevData.DataPackSN := nDataPackS;

  AddOrder( C_645_READ_NEXTDATA, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.ResetDateTime(dtDateTime: TDateTime);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DateTimeValue := dtDateTime;
  AddOrder( C_645_RESET_TIME, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.Rve645Data(A645data: TStringList);
var
  i: Integer;
  sReply: string;
begin
  for i := 0 to A645data.Count - 1 do
  begin
    if TDL645_DATA(A645data.Objects[i]).RePlyError = de645_07None then
    begin
      sReply := TDL645_DATA(A645data.Objects[i]).DataReply;

      if Pos('X', TDL645_DATA(A645data.Objects[i]).DataFormat) > 0 then
      begin
        TDL645_DATA(A645data.Objects[i]).DataReply := PacksToStr(StrToBCDPacks(sReply));
      end
      else
      begin
        if sReply <> '' then
        begin
          TDL645_DATA(A645data.Objects[i]).DataReply := sReply;
        end;
      end;
    end;
  end;

  if Assigned(FOnRev645Data) then
    FOnRev645Data(A645data);
end;

procedure TDL645Thread.SetMeterAddr(const Value: string);
var
  i: Integer;
begin
  FMeterAddr := Value;

  if Length(FMeterAddr) > 12 then
    FMeterAddr := Copy(FMeterAddr, 1, 12)
  else if Length(FMeterAddr) < 12 then
  begin
    for i := Length(FMeterAddr) to 12 - 1 do
      FMeterAddr := '0' + FMeterAddr;
  end;
end;

procedure TDL645Thread.SetProrocolType(const Value: TDL645_PROTOCOL_TYPE);
begin
  FProrocolType := Value;
end;

procedure TDL645Thread.SetWOutType(AType: TMOUT_TYPE);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSend := IntToStr(Integer(AType));
  ARevData.Address  := FMeterAddr;
  AddOrder( C_SET_WOUT_TYPE, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.WriteData(nSign: Int64; nLen: Integer; sFormt,
  sValue: string);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSign := nSign;
  ARevData.DataLen := nLen;
  ARevData.DataFormat := sFormt;
  ARevData.DataSend := sValue;
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_WRITE_DATA, ARevData, FIsWairtForComm);
end;

procedure TDL645Thread.WriteMeterAddr(nAddr: Int64);
var
  ARevData:TDL645_DATA;
begin
  ARevData:= TDL645_DATA.Create;
  ARevData.DataSend := IntToStr(nAddr);
  ARevData.Address  := FMeterAddr;
  AddOrder( C_645_WRITE_ADDR, ARevData, FIsWairtForComm);
end;

end.


