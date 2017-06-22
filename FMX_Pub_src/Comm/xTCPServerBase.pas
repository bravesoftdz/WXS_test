unit xTCPServerBase;

interface

uses xCommBase, System.Types, xTypes, System.Classes, xFunction,
  system.SysUtils, IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdGlobal, IdContext;

type
  /// <summary>
  /// �ͻ���״̬�ı��¼�
  /// </summary>
  TTCPClientChangeEvent = procedure( AIP: string; nPort: Integer;
    AConnected: Boolean ) of object;

type
  TTCPServerBase = class(TCommBase)
  private
    FTCPServer: TIdTCPServer;
    FListenPort: Word;
    FOnClientChange: TTCPClientChangeEvent;
    FOnIPSendRev: TIPSendRevPack;

    procedure TCPServerExecute(AContext: TIdContext);
    procedure TCPServerConnect(AContext: TIdContext);
    procedure TCPServerDisConnect(AContext: TIdContext);

    function SendIPData(sIP: string; nPort :Integer; APacks: TArray<Byte>) : Boolean;
  protected

    /// <summary>
    ///��ʵ���� ���ڻ���̫������
    /// </summary>
    function RealSend(APacks: TArray<Byte>; sParam1: string = ''; sParam2 : string=''): Boolean; override;

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
    function SendPacksDataTCP(sIP: string; nPort :Integer; APacks: TArray<Byte>): Boolean; overload; virtual;
    function SendPacksDataTCP(sIP: string; nPort :Integer; sStr: string): Boolean; overload; virtual;


    /// <summary>
    /// �����˿�
    /// </summary>
    property ListenPort : Word read FListenPort write FListenPort;

    /// <summary>
    /// �ͻ���״̬�ı��¼�
    /// </summary>
    property OnClientChange : TTCPClientChangeEvent read FOnClientChange
      write FOnClientChange;

    /// <summary>
    /// ��IP��ַ�Ͷ˿ڵķ��ͺͽ����¼�
    /// </summary>
    property OnIPSendRev : TIPSendRevPack read FOnIPSendRev write FOnIPSendRev;
  end;


implementation

{ TTCPServerBase }


constructor TTCPServerBase.Create;
begin
  inherited;
  FTCPServer:= TIdTCPServer.Create;
  FTCPServer.OnExecute := TCPServerExecute;
  FTCPServer.OnConnect := TCPServerConnect;
  FTCPServer.OnDisconnect := TCPServerDisConnect;

  FListenPort := 10000;
end;

destructor TTCPServerBase.Destroy;
begin
  try
    FTCPServer.Free;
  finally

  end;

  inherited;
end;

function TTCPServerBase.RealConnect: Boolean;
var
  s : string;
begin
  FTCPServer.DefaultPort := FListenPort;
  try
    FTCPServer.Active := True;
  finally
    Result := FTCPServer.Active;

    if Result then
      s := '�ɹ�'
    else
      s := 'ʧ��';
    Log(FormatDateTime('hh:mm:ss:zzz', Now) + ' ���������˿�'+inttostr(FListenPort)+s);
  end;


end;

procedure TTCPServerBase.RealDisconnect;
begin
  inherited;
  FTCPServer.Active := False;
  Log(FormatDateTime('hh:mm:ss:zzz', Now) + ' ֹͣ�����˿�'+inttostr(FListenPort));
end;

function TTCPServerBase.RealSend(APacks: TArray<Byte>; sParam1, sParam2 : string): Boolean;
var
  sIP : string;
  nPort : Integer;
begin
  sIP := sParam1;
  TryStrToInt(sParam2, nPort);

  Result := SendIPData(sIP, nPort, APacks);
end;

procedure TTCPServerBase.RevPacksData(sIP: string; nPort: Integer;
  aPacks: TArray<Byte>);
begin
  RevPacksData(aPacks);

  if Assigned(FOnIPSendRev) then
    FOnIPSendRev(sIP, nPort, APacks, False);
end;

procedure TTCPServerBase.RevStrData(sIP: string; nPort: Integer; sStr: string);
begin
  RevStrData( sStr);
end;

function TTCPServerBase.SendPacksDataTCP(sIP: string; nPort: Integer;
  APacks: TArray<Byte>): Boolean;
begin
  Result := SendPacksDataBase(APacks, sIP, IntToStr(nPort));
end;

function TTCPServerBase.SendIPData(sIP: string; nPort: Integer;
  APacks: TArray<Byte>) : Boolean;
var
  i : Integer;
  Context : TIdContext;
begin
  Result := False;

  if (sIP <> '') and (nPort > 10) then
  begin
    try
      for i := 0 to FTCPServer.Contexts.LockList.Count - 1 do
      begin
        with TIdContext(FTCPServer.Contexts.LockList.Items[i]).Connection do
        begin
          if (Socket.Binding.PeerIP = sIP) and (Socket.Binding.PeerPort = nPort) then
          begin
            try
              if Connected then
              begin
                IOHandler.Write(PacksToStr(APacks));
                Result := True;

                if Assigned(FOnIPSendRev) then
                  FOnIPSendRev(sIP, nPort, APacks, True);
              end;
            except

            end;
            Break;
          end;
        end;
      end;
    finally
      FTCPServer.Contexts.UnlockList;
    end;
  end
  else
  begin
    try
      with FTCPServer.Contexts.LockList do
      begin
        for i := 0 to Count -1 do
        begin
          Context := TIdContext(Items[i]);
          Context.Connection.IOHandler.Write(PacksToStr(APacks));
          Result := True;

          if Assigned(FOnIPSendRev) then
            FOnIPSendRev(Context.Connection.Socket.Binding.PeerIP,
              Context.Connection.Socket.Binding.PeerPort, APacks, True);
        end;
      end;
    finally
      FTCPServer.Contexts.UnlockList;
    end;
  end;
end;

function TTCPServerBase.SendPacksDataTCP(sIP: string; nPort: Integer;
  sStr: string): Boolean;
begin
  Result := SendPacksDataTCP(sIP, nPort, StrToPacks(sStr));
end;

procedure TTCPServerBase.TCPServerConnect(AContext: TIdContext);
begin
  if Assigned(FOnClientChange) then
  begin
    with AContext.Connection.Socket.Binding do
    begin
      FOnClientChange(PeerIP, PeerPort, True);
    end;
  end;
end;

procedure TTCPServerBase.TCPServerDisConnect(AContext: TIdContext);
begin
  if Assigned(FOnClientChange) then
  begin
    with AContext.Connection.Socket.Binding do
    begin
      FOnClientChange(PeerIP, PeerPort, False);
    end;
  end;
end;

procedure TTCPServerBase.TCPServerExecute(AContext: TIdContext);
var
  aBuf : TIdBytes;
  s : string;
  i : Integer;
  sIP : string;
  nPort : Integer;
begin
  AContext.Connection.IOHandler.CheckForDisconnect(True, True);
  if not AContext.Connection.Socket.InputBufferIsEmpty then
  begin
    AContext.Connection.Socket.ReadBytes(aBuf,
      AContext.Connection.Socket.InputBuffer.Size);

    s := '';
    for i := 0 to  Length(aBuf) - 1 do
      s := s + Char(aBuf[i]);

    if s <> '' then
    begin
      sIP := AContext.Connection.Socket.Binding.PeerIP;
      nPort := AContext.Connection.Socket.Binding.PeerPort;
      RevStrData(sIP, nPort, s);
      RevPacksData(sIP, nPort,StrToPacks( s))
    end;
  end;
end;

end.

