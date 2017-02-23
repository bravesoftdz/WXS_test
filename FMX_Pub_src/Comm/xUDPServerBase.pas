unit xUDPServerBase;

interface

uses xCommBase, System.Types, xTypes, System.Classes, xFunction,
  system.SysUtils, IdBaseComponent, IdComponent, IdUDPServer, IdUDPBase,
  IdUDPClient, IdSocketHandle, IdGlobal, IdContext;

type
  /// <summary>
  /// UDP ͨѶ���� ������ֱ�ӿ��Է��ͣ�Ҫ���ձ������
  /// </summary>
  TUDPServerBase = class(TCommBase)
  private
    FUDPServer: TIdUDPServer;
    FListenPort: Word;
    FIP : string;
    FPort : Integer;
    FOnIPSendRev: TIPSendRevPack;

    procedure UDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes;
      ABinding: TIdSocketHandle);
  protected

    /// <summary>
    ///��ʵ���� ���ڻ���̫������
    /// </summary>
    function RealSend(APacks: TArray<Byte>): Boolean; override;

    /// <summary>
    /// ��ʵ����
    /// </summary>
    function RealConnect : Boolean; override;

    /// <summary>
    /// ��ʵ�Ͽ�����
    /// </summary>
    procedure RealDisconnect; override;

    /// <summary>
    /// ��������
    /// </summary>
    procedure RevPacksData(sIP: string; nPort :Integer;aPacks: TArray<Byte>); overload;virtual;
    procedure RevStrData(sIP: string; nPort :Integer; sStr: string); overload;virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// ��������
    /// </summary>
    function SendPacksData(sIP: string; nPort :Integer; APacks: TArray<Byte>): Boolean; overload; virtual;
    function SendPacksData(sIP: string; nPort :Integer; sStr: string): Boolean; overload; virtual;

    /// <summary>
    /// �����˿�
    /// </summary>
    property ListenPort : Word read FListenPort write FListenPort;

    /// <summary>
    /// ��IP��ַ�Ͷ˿ڵķ��ͺͽ����¼�
    /// </summary>
    property OnIPSendRev : TIPSendRevPack read FOnIPSendRev write FOnIPSendRev;
  end;

implementation

{ TUDPServerBase }

constructor TUDPServerBase.Create;
begin
  inherited;
  FUDPServer:= TIdUDPServer.Create;
  FUDPServer.OnUDPRead := UDPRead;
  FUDPServer.BroadcastEnabled := True;
  FIP := '';

  FListenPort := 11000;
end;

destructor TUDPServerBase.Destroy;
begin
  FUDPServer.Free;
  inherited;
end;

function TUDPServerBase.RealConnect: Boolean;
var
  s : string;
begin
  FUDPServer.DefaultPort := FListenPort;
  FIP := '255.255.255.255';
  FPort := FUDPServer.DefaultPort;
  FUDPServer.Active := True;

  Result := FUDPServer.Active;

  if Result then
    s := '�ɹ�'
  else
    s := 'ʧ��';
  Log(FormatDateTime('hh:mm:ss:zzz', Now) + ' ���������˿�'+inttostr(FListenPort)+s);

end;

procedure TUDPServerBase.RealDisconnect;
begin
  inherited;
  FUDPServer.Active := False;
  Log(FormatDateTime('hh:mm:ss:zzz', Now) + ' �ر������˿�'+inttostr(FListenPort));
end;

function TUDPServerBase.RealSend(APacks: TArray<Byte>): Boolean;
var
  i : Integer;
  ABuffer: TIdBytes;
begin
  try
    SetLength(ABuffer, Length(APacks));

    for i := 0 to Length(APacks) - 1 do
      ABuffer[i] := APacks[i];

    if FIP = '' then
      FIP := '255.255.255.255';

//    if FPort >= 0 then
//      FPort := 11000;

    FUDPServer.SendBuffer(FIP, FPort, ABuffer);

    if Assigned(FOnIPSendRev) then
      FOnIPSendRev(FIP,FPort, APacks, True);

    Result := True;
  finally
  end;
end;

procedure TUDPServerBase.RevPacksData(sIP: string; nPort: Integer;
  aPacks: TArray<Byte>);
begin
  if Assigned(FOnIPSendRev) then
    FOnIPSendRev(FIP,FPort, APacks, false);
  RevPacksData(aPacks);
end;

procedure TUDPServerBase.RevStrData(sIP: string; nPort: Integer; sStr: string);
begin
  RevStrData( sStr);
end;

function TUDPServerBase.SendPacksData(sIP: string; nPort: Integer;
  APacks: TArray<Byte>): Boolean;
begin
  FIP := sIP;
  FPort := nPort;
  Result := SendPacksData(APacks);
end;

function TUDPServerBase.SendPacksData(sIP: string; nPort: Integer;
  sStr: string): Boolean;
begin
  FIP := sIP;
  FPort := nPort;
  Result := SendPacksData(sStr);
end;

procedure TUDPServerBase.UDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
var
  s : string;
  i : Integer;
  sIP : string;
  nPort : Integer;
begin
  s := '';

  for i := 0 to Length(AData) - 1 do
    s := s + Char(AData[i]);

  if s <> '' then
  begin
    sIP := ABinding.PeerIP;
    nPort := FPort;
    RevStrData(sIP, nPort, s);
    RevPacksData(sIP, nPort,StrToPacks( s))

  end;
end;

end.

