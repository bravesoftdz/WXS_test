unit xProtocolBase;

interface

uses System.Types, xTypes, xConsts, System.Classes, xFunction, xVCL_FMX,
  system.SysUtils;

type
  /// <summary>
  /// �豸ͨ��Э��
  /// </summary>
  TProtocolBase = class
  private
    FOnRevData: TEnventPack;
    FOnSendData: TSendPack;
    FOnLog: TSendRevPack;
    FOrderTimeOut: Cardinal;
    FOnError: TGetStrProc;
    FIsReplay: Boolean;
    FOnGetOrderObject: TOrderObject;
  protected
    FIsStop : Boolean;  // �Ƿ�ֹͣ����
    FOrderType : Integer;  // ��������
    FDev       : TObject;  // �������
    FRevDataLen    : Integer;  // �������ݳ���
    FRvdPacks  : TBytes;   // �������ݰ�
    FReplySate : Integer;  // ���ݽ���״̬

    /// <summary>
    /// ���ͽ���
    /// </summary>
    procedure CommSenRev( aPacks : TBytes; bSend : Boolean );

    /// <summary>
    /// ����֮ǰ����
    /// </summary>
    procedure BeforeSend; virtual;

    /// <summary>
    /// ����֮����
    /// </summary>
    procedure AfterSend; virtual;

    /// <summary>
    /// ����֮ǰ����
    /// </summary>
    procedure BeforeRev; virtual;

    /// <summary>
    /// ����֮����
    /// </summary>
    procedure AfterRev; virtual;

    /// <summary>
    /// ����Ƿ��з���
    /// </summary>
    /// <returns></returns>
    function IsReplied : Boolean;

    /// <summary>
    /// �Ƿ���Ҫ��������
    /// </summary>
    property IsReplay : Boolean read FIsReplay write FIsReplay;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    function CreatePacks: TBytes; virtual;

    /// <summary>
    /// �������յ������ݰ�
    /// </summary>
    procedure ParseData(RvdPack : TBytes); virtual;

    /// <summary>
    /// �����յ����ݰ��Ƿ�Ϸ�
    /// </summary>
    function CheckData(RvdPack : TBytes): Boolean; virtual;

    /// <summary>
    /// ͨѶ����
    /// </summary>
    procedure ProtocolError( sError : string );

    /// <summary>
    /// ���ʱ
    /// </summary>
    procedure OrderOutTime; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure ReceivedData(aPacks: TBytes; sParam1, sParam2 : string); virtual;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    function SendData(nOrderType: Integer; ADev: TObject) : Boolean; virtual;

    /// <summary>
    /// �˳�
    /// </summary>
    procedure SetExit;

  public
    /// <summary>
    /// ���ʱʱ��
    /// </summary>
    property OrderTimeOut : Cardinal read FOrderTimeOut write FOrderTimeOut;

    /// <summary>
    /// �������ݰ��¼�
    /// </summary>
    property OnSendData: TSendPack read FOnSendData write FOnSendData;

    /// <summary>
    /// �������ݰ��¼�
    /// </summary>
    property OnRevData: TEnventPack read FOnRevData write FOnRevData;

    /// <summary>
    /// ͨѶ��¼
    /// </summary>
    property OnLog : TSendRevPack read FOnLog write FOnLog;

    /// <summary>
    /// �����¼�
    /// </summary>
    property OnError: TGetStrProc read FOnError write FOnError;

    /// <summary>
    /// ���������ȡ����(�豸�������Ӧ������� ���븳ֵ����¼�)
    /// </summary>
    property OnGetOrderObject : TOrderObject read FOnGetOrderObject write FOnGetOrderObject;
  end;

implementation



procedure TProtocolBase.AfterRev;
begin
  // nothing
//  WaitForSeconds(20);
end;

procedure TProtocolBase.AfterSend;
begin
  // nothing
end;

procedure TProtocolBase.BeforeRev;
begin
  // nothing
end;

procedure TProtocolBase.BeforeSend;
begin
  FRevDataLen    := 0;
  FReplySate := C_REPLY_NORESPONSE;
  SetLength(FRvdPacks, 0);
end;

function TProtocolBase.CheckData(RvdPack: TBytes): Boolean;
begin
  Result := False;
  // nothing
end;

procedure TProtocolBase.CommSenRev(aPacks: TBytes; bSend: Boolean);
begin
  if Length(aPacks) > 0 then
  begin
    if Assigned(FOnLog) then
      FOnLog( aPacks, bSend);

    if bSend then
    begin
      if Assigned(FOnSendData) then
        FOnSendData(aPacks);
    end
    else
    begin
      if Assigned(FOnRevData) then
        FOnRevData(aPacks);
    end;
  end;
end;

constructor TProtocolBase.Create;
begin
  FOrderTimeOut := 1500;
  FIsReplay := True;

end;

function TProtocolBase.CreatePacks: TBytes;
begin
  // nothing
end;

destructor TProtocolBase.Destroy;
begin

  inherited;
end;

function TProtocolBase.IsReplied: Boolean;
var
  nTick : Cardinal;
begin
  nTick := TThread.GetTickCount;

  repeat
    Sleep(3);
    MyProcessMessages;
  until ( FReplySate > C_REPLY_NORESPONSE ) or
        ( TThread.GetTickCount - nTick  > FOrderTimeOut );

  if FReplySate > C_REPLY_NORESPONSE then
    Result := True
  else
    Result := False;

  if not Result then
    OrderOutTime;
end;

procedure TProtocolBase.OrderOutTime;
begin

end;

procedure TProtocolBase.ParseData(RvdPack: TBytes);
begin
  // nothing
end;

procedure TProtocolBase.ProtocolError(sError: string);
begin
  if Assigned(FOnError) then
    FOnError(sError);
end;

procedure TProtocolBase.ReceivedData(aPacks: TBytes; sParam1, sParam2 : string);
begin
  BeforeRev;
  ParseData(aPacks);
  CommSenRev(aPacks, False);

  AfterRev;
end;

function TProtocolBase.SendData(nOrderType: Integer; ADev: TObject): Boolean;
begin
  FOrderType := nOrderType;
  FDev := ADev;

  BeforeSend;
  CommSenRev(CreatePacks, True);
  AfterSend;

  if FIsReplay then
    Result := IsReplied
  else
    Result := True;
end;

procedure TProtocolBase.SetExit;
begin
  FIsStop := True;
end;

end.

