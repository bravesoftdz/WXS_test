{===============================================================================
  ͨѶ�̻߳���

===============================================================================}
unit xThreadBase;

interface

uses System.SysUtils, System.Classes, xProtocolBase,xFunction, xVCL_FMX,
  xCommBase, xSerialBase, xTCPClientBase, xTCPServerBase, xUDPServerBase;

type
  /// <summary>
  /// ��·����
  /// </summary>
  TCommType = (ctNot,
               ctSerial,    // ����
               ctTCPClient, // TCP�ͻ���
               ctTCPServer, // TCP������
               ctUDPServer  // UDP������
               );

type
  TTIME_ORDER_INFO = class
  private
    FCmdType: Integer;
    FCmdObject: TObject;

  public
    /// <summary>
    /// ��������
    /// </summary>
    property CmdType : Integer read FCmdType write FCmdType;

    /// <summary>
    /// �������
    /// </summary>
    property CmdObject : TObject read FCmdObject write FCmdObject;
  end;

type
  /// <summary>
  /// ͨѶ�̻߳���
  /// </summary>
  TThreadBase = class(TThread)
  private
    FTOWaitForSeconds: Cardinal;
    FOrderReplayed: Boolean;
    FProType: TCommType;
    FTimerOrderEnable: Boolean;
    FTimeOrderList: TStringList;
    FTempIndex : Integer;
    FMSeconds : Cardinal;      // ���ö�ʱ������Ч���ʱ��

    FOrderList : TStringList;  // �����б�

    procedure SetProType(const Value: TCommType);
    procedure SetTimerOrderEnable(const Value: Boolean);
    procedure SetCommBase(const Value: TCommBase);
  protected
    FIsStop : Boolean;  // �Ƿ�ֹͣ����
    FProtocol : TProtocolBase;
    FCommBase : TCommBase;     // ͨѶ��·


    procedure Execute; override;

    /// <summary>
    /// ִ��ʵʱ����
    /// </summary>
    procedure ExecuteOrder(ACmdType: Integer; ADevice: TObject); virtual;

    /// <summary>
    /// ִ�ж�ʱ���� �������ʱ����Ҫִ���б���Ҫ�ж� FIsStop �Ƿ�ֹͣ���У����ͦʬ������Ҫ����ѭ����
    /// </summary>
    procedure ExecuteTimerOrder; virtual;

    /// <summary>
    /// �˳�
    /// </summary>
    procedure SetExit;
  public
    constructor Create(CreateSuspended: Boolean); virtual;
    destructor Destroy; override;

    /// <summary>
    /// �߳�����
    /// </summary>
    function TheardName : string; virtual;

    /// <summary>
    /// ͨѶ��·����
    /// </summary>
    property ProType : TCommType read FProType write SetProType;

    /// <summary>
    /// ͨѶ��·
    /// </summary>
    property CommBase : TCommBase read FCommBase write SetCommBase;

    /// <summary>
    /// ִ������
    /// </summary>
    /// <param name="ACmdType">��������</param>
    /// <param name="ADevice">�������</param>
    /// <param name="bWairtExecute">�Ƿ�ȴ�ִ����������Ƴ�����</param>
    procedure AddOrder( ACmdType: Integer; ADevice: TObject; bWairtExecute : Boolean = True); virtual;

    /// <summary>
    /// �����Ƿ�ִ����
    /// </summary>
    function OrdersFinished : Boolean;

    /// <summary>
    /// �ȴ�����ִ����
    /// </summary>
    function IsWaitReplied( nCmdTimeOut : Cardinal = 1000 ): Boolean;

    /// <summary>
    /// ��ʱ�����Ƿ���Ч
    /// </summary>
    property TimerOrderEnable: Boolean read FTimerOrderEnable write SetTimerOrderEnable;

    /// <summary>
    /// ��ʱ������Ч֮��ȴ�ʱ�� ����
    /// </summary>
    property TOWaitForSeconds : Cardinal read FTOWaitForSeconds write FTOWaitForSeconds;

    /// <summary>
    /// ��ʱ�����б�
    /// </summary>
    property TimeOrderList : TStringList read FTimeOrderList write FTimeOrderList;

    /// <summary>
    /// �����Ƿ�ͨѶ����
    /// </summary>
    property OrderReplayed : Boolean read FOrderReplayed write FOrderReplayed;

    /// <summary>
    /// �Ƿ�򿪴��� ���ӵ��������������˿�
    /// </summary>
    function IsConned : Boolean;
  end;

implementation

{ TThreadBase }

procedure TThreadBase.AddOrder(ACmdType: Integer; ADevice: TObject;
  bWairtExecute: Boolean);
var
  nTimeOut : Integer;
begin
  if IsConned then
  begin
    FOrderList.AddObject( IntToStr( Integer(ACmdType) ), ADevice);

    if bWairtExecute then
    begin
      if Assigned(FProtocol) then
      begin
        nTimeOut := FProtocol.OrderTimeOut;
        IsWaitReplied(nTimeOut);
      end;
    end;
  end;
end;

constructor TThreadBase.Create(CreateSuspended: Boolean);
begin
  inherited;
  FOrderList := TStringList.Create;
  FTimerOrderEnable := False;
  FTOWaitForSeconds := 3000;
  FIsStop := False;

end;

destructor TThreadBase.Destroy;
begin
  FOrderList.Free;

  if Assigned(FCommBase) then
    FCommBase.Free;

  inherited;
end;

procedure TThreadBase.Execute;
var
  nOrderType : Integer;
begin
  inherited;
  while not Terminated do
  begin
    if FMSeconds > 0 then
    begin
      if GetTickCount - FMSeconds > FTOWaitForSeconds then
      begin
        FTimerOrderEnable := True;
        FMSeconds := 0;
      end;
    end;

    Sleep(1);
    MyProcessMessages;

    //  ��������ʵʱ����
    while FOrderList.Count > 0 do
    begin
      if FIsStop then
        Break;

      if Assigned( FOrderList.Objects[ 0 ] ) then
      begin
        TryStrToInt(FOrderList[ 0 ], nOrderType);
        ExecuteOrder(nOrderType, FOrderList.Objects[ 0 ] );

        if FOrderList.Count > 0 then
          FOrderList.Delete( 0 );
      end;
    end;

    //  ����ʱ����
    if FTimerOrderEnable and not FIsStop then
      ExecuteTimerOrder;

//    Sleep(1);
//    MyProcessMessages;
  end;
end;

procedure TThreadBase.ExecuteOrder(ACmdType: Integer; ADevice: TObject);
begin
  if Assigned(FProtocol) then
    FOrderReplayed := FProtocol.SendData(ACmdType, ADevice)
  else
    FOrderReplayed := False;
end;

procedure TThreadBase.ExecuteTimerOrder;
begin
  if TimeOrderList.Count > FTempIndex then
  begin
    with TTIME_ORDER_INFO(TimeOrderList.Objects[FTempIndex]) do
    begin
      if Assigned(FProtocol) and not FIsStop then
        FProtocol.SendData(CmdType, CmdObject);
    end;
  end;

  Inc(FTempIndex);

  if FTempIndex >= TimeOrderList.Count then
  begin
    FTempIndex := 0;
  end;
end;

function TThreadBase.IsConned: Boolean;
begin
  if Assigned(FCommBase) then
    Result := FCommBase.Active
  else
    Result := False;
end;

function TThreadBase.IsWaitReplied(nCmdTimeOut: Cardinal): Boolean;
var
  nTick : Cardinal;
begin
  nTick := GetTickCount;

  repeat
    MyProcessMessages;
    Result := OrdersFinished;
    Sleep(1);
  until Result or ( GetTickCount - nTick  > nCmdTimeOut );
end;

function TThreadBase.OrdersFinished: Boolean;
begin
  Result := True;
end;

procedure TThreadBase.SetCommBase(const Value: TCommBase);
begin
  FCommBase := Value;
end;

procedure TThreadBase.SetExit;
begin
  FIsStop := True;
  if Assigned(FProtocol) then
    FProtocol.SetExit;
end;

procedure TThreadBase.SetProType(const Value: TCommType);
begin
  FProType := Value;
  case FProType of
    ctSerial :
    begin
      if Assigned(FCommBase) then
      begin
        if FCommBase.ClassName <> TSerialBase.ClassName then
        begin
          FCommBase.OnRevPacks := nil;
          FCommBase.Free;
          FCommBase := TSerialBase.Create;
        end;
      end
      else
      begin
        FCommBase := TSerialBase.Create;
      end;

      FProtocol.OnSendData := FCommBase.SendPacksData;
      FCommBase.OnRevPacks := FProtocol.ReceivedData;

    end;
    ctTCPClient:
    begin
      if Assigned(FCommBase) then
      begin
        if FCommBase.ClassName <> TTCPClientBase.ClassName then
        begin
          FCommBase.OnRevPacks := nil;
          FCommBase.Free;
          FCommBase := TTCPClientBase.Create;
        end;
      end
      else
      begin
        FCommBase := TTCPClientBase.Create;
      end;

      FProtocol.OnSendData := FCommBase.SendPacksData;
      FCommBase.OnRevPacks := FProtocol.ReceivedData;





    end;
    ctTCPServer:
    begin
      if Assigned(FCommBase) then
      begin
        if FCommBase.ClassName <> TTCPServerBase.ClassName then
        begin
          FCommBase.OnRevPacks := nil;
          FCommBase.Free;
          FCommBase := TTCPServerBase.Create;
        end;
      end
      else
      begin
        FCommBase := TTCPServerBase.Create;
      end;

      FProtocol.OnSendData := FCommBase.SendPacksData;
      FCommBase.OnRevPacks := FProtocol.ReceivedData;


    end;
    ctUDPServer:
    begin
      if Assigned(FCommBase) then
      begin
        if FCommBase.ClassName <> TUDPServerBase.ClassName then
        begin
          FCommBase.OnRevPacks := nil;
          FCommBase.Free;
          FCommBase := TUDPServerBase.Create;
        end;
      end
      else
      begin
        FCommBase := TUDPServerBase.Create;
      end;

      FProtocol.OnSendData := FCommBase.SendPacksData;
      FCommBase.OnRevPacks := FProtocol.ReceivedData;
    end;
  end;
end;

procedure TThreadBase.SetTimerOrderEnable(const Value: Boolean);
begin
  if Value then
  begin
    FMSeconds := GetTickCount;
  end
  else
  begin
    FMSeconds :=0;
    FTimerOrderEnable := Value;
  end;
end;

function TThreadBase.TheardName: string;
begin
  Result := '�����߳�';
end;

end.
