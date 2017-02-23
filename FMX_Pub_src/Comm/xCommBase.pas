{===============================================================================
  ͨѶ����

===============================================================================}
unit xCommBase;

interface

uses System.Types, xTypes, System.Classes, xFunction;

type
  TCommBase = class
  private
    FOnSendRevPack: TSendRevPack;
    FOnError: TGetStrProc;
    FCommBusy: Boolean;
    FActive: Boolean;
    FOnRevPacks: TEnventPack;
    FOnLog: TGetStrProc;
  protected
    /// <summary>
    /// ͨѶ����
    /// </summary>
    procedure CommError( sError : string ); virtual;

    /// <summary>
    /// ����֮ǰ����
    /// </summary>
    procedure BeforeConn; virtual;

    /// <summary>
    /// ����֮����
    /// </summary>
    procedure AfterConn; virtual;

    /// <summary>
    /// �Ͽ�����֮ǰ����
    /// </summary>
    procedure BeforeDisConn; virtual;

    /// <summary>
    /// �Ͽ�����֮����
    /// </summary>
    procedure AfterDisConn; virtual;

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
    /// ��������
    /// </summary>
    procedure RevPacksData(aPacks: TArray<Byte>); overload; virtual;
    procedure RevStrData(sStr: string); overload; virtual;

    /// <summary>
    ///��ʵ���� ���ڻ���̫������
    /// </summary>
    function RealSend(APacks: TArray<Byte>): Boolean; virtual;

    /// <summary>
    /// ��ʵ����
    /// </summary>
    function RealConnect : Boolean; virtual;

    /// <summary>
    /// ��ʵ�Ͽ�����
    /// </summary>
    procedure RealDisconnect; virtual;

    procedure Log(s : string);

  public
    constructor Create; virtual;
    destructor Destroy; override;

    /// <summary>
    /// ��������
    /// </summary>
    function SendPacksData(APacks: TArray<Byte>): Boolean; overload; virtual;
    function SendPacksData(sStr: string): Boolean; overload; virtual;

    /// <summary>
    /// ����
    /// </summary>
    procedure Connect;

    /// <summary>
    /// �Ͽ�����
    /// </summary>
    procedure Disconnect;
  public
    /// <summary>
    /// �Ƿ�æ
    /// </summary>
    property CommBusy : Boolean read FCommBusy write FCommBusy;

    /// <summary>
    /// �����Ƿ�� TCP�Ƿ�������
    /// </summary>
    property Active : Boolean read FActive;

    /// <summary>
    /// �������ݰ��¼�
    /// </summary>
    property OnRevPacks : TEnventPack read FOnRevPacks write FOnRevPacks;

    /// <summary>
    /// �շ����ݰ��¼�
    /// </summary>
    property OnSendRevPack : TSendRevPack read FOnSendRevPack write FOnSendRevPack;

    /// <summary>
    /// �����¼�
    /// </summary>
    property OnError: TGetStrProc read FOnError write FOnError;

    /// <summary>
    /// �¼���¼
    /// </summary>
    property OnLog : TGetStrProc read FOnLog write FOnLog;

  end;

implementation

{ TCommBase }

procedure TCommBase.AfterConn;
begin

end;

procedure TCommBase.AfterDisConn;
begin

end;

procedure TCommBase.AfterRev;
begin

end;

procedure TCommBase.AfterSend;
begin
  FCommBusy := False;
end;

procedure TCommBase.BeforeConn;
begin

end;

procedure TCommBase.BeforeDisConn;
begin

end;

procedure TCommBase.BeforeRev;
begin

end;

procedure TCommBase.BeforeSend;
begin
  FCommBusy := True;
end;

procedure TCommBase.CommError(sError: string);
begin
  if Assigned(FOnError) then
    FOnError(sError);
end;

procedure TCommBase.Connect;
begin
  BeforeConn;

  try
    FActive := RealConnect;
  except

  end;

  AfterConn;
end;

constructor TCommBase.Create;
begin
  FCommBusy := False;
  FActive := False;
end;

destructor TCommBase.Destroy;
begin

  inherited;
end;

procedure TCommBase.Disconnect;
begin
  BeforeDisConn;

  RealDisconnect;

  AfterDisConn;
end;

procedure TCommBase.Log(s: string);
begin
  if Assigned(FOnLog) then
    FOnLog(s);
end;

function TCommBase.RealConnect : Boolean;
begin
  Result := True;
end;

procedure TCommBase.RealDisconnect;
begin
  FActive := False;
end;

function TCommBase.RealSend(APacks: TArray<Byte>): Boolean;
begin
  Result := True;
end;

procedure TCommBase.RevPacksData(aPacks: TArray<Byte>);
begin
  if Assigned(FOnSendRevPack) then
    FOnSendRevPack(APacks, False);

  if Assigned(FOnRevPacks) then
    FOnRevPacks(aPacks);
end;

procedure TCommBase.RevStrData(sStr: string);
begin

end;

function TCommBase.SendPacksData(sStr: string): Boolean;
begin
  Result := SendPacksData(StrToPacks(sStr));
end;

function TCommBase.SendPacksData(APacks: TArray<Byte>): Boolean;
begin
  BeforeSend;

  Result := RealSend(APacks);

  if Result and Assigned(FOnSendRevPack) then
    FOnSendRevPack(APacks, True);

  AfterSend;
end;

end.
