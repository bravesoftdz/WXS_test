unit xUDPClient1;

interface

uses System.Types,System.Classes, xFunction, system.SysUtils, xUDPServerBase,
  xConsts, System.IniFiles, xVCL_FMX, FrmSelectTCPServer,
  {$IFDEF MSWINDOWS}
  Winapi.Windows, ShlObj, CommCtrl, Messages, Winapi.WinSock,
  {$ENDIF}
  xClientType, xClientControl;

type
  TUDPClient = class(TUDPServerBase)

  private
    FList : TStringlist;
    bGetInfo : Boolean;
    FOnConnServer: TNotifyEvent;
    FLogInIP : string; // ����û��Ƿ��¼ʱ���û���¼��IP��ַ

    procedure ReadINI;
    procedure WriteINI;

  protected
    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure RevStrData(sIP: string; nPort :Integer; sStr: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// ��ȡTCP������IP�˿�
    /// </summary>
    function GetTCPServerIPPort(var sIP: string; var nPort : Integer; nTimeOut : Cardinal = 1000): Boolean;

    /// <summary>
    /// ����û��Ƿ��Ѿ���¼  ���ص�¼��IP��ַ
    /// </summary>
    function CheckLogin(nLoginNum : Integer; nTimeOut: Cardinal = 1000):string;

    /// <summary>
    /// ���ӷ������¼�
    /// </summary>
    property OnConnServer : TNotifyEvent read FOnConnServer write FOnConnServer;
  end;
var
  UDPClient : TUDPClient;

implementation
function TUDPClient.CheckLogin(nLoginNum : Integer; nTimeOut: Cardinal): string;
var
  nTick : Cardinal;
begin
  FLogInIP := '';

  SendPacksDataUDP('255.255.255.255', ListenPort, 'CheckLogin,' + IntToStr(nLoginNum));
  nTick := GetTickCount;
  repeat
    MyProcessMessages;
    Sleep(1);
  until (GetTickCount - nTick  > nTimeOut) or (FLogInIP <> '');

  Result := FLogInIP;
end;

constructor TUDPClient.Create;
begin
  inherited;
  FList := TStringlist.Create;
  ListenPort := 16001;
  bGetInfo := False;
  ReadINI;
end;

destructor TUDPClient.Destroy;
begin
  WriteINI;

  FList.free;
  inherited;
end;

function TUDPClient.GetTCPServerIPPort(var sIP: string; var nPort: Integer;
  nTimeOut: Cardinal): Boolean;
var
  nTick : Cardinal;
begin
  nTick := GetTickCount;
  sIP := '';
  nPort := 0;
  FList.Clear;
  bGetInfo := True;
  SendPacksDataUDP('255.255.255.255', 16000, 'GetServerInfo');
  repeat
    MyProcessMessages;
    Sleep(1);
  until GetTickCount - nTick  > nTimeOut;

  if FList.Count = 1 then
  begin
    GetTCPIPPort(FList[0], sIP, nPort);

  end
  else if FList.Count = 0 then
  begin

  end
  else
  begin
    with TfSelectTCPServer.Create(nil) do
    begin
      SelectTCPServer(FList, sIP, nPort);
    end;
  end;
  bGetInfo := True;
  Result := sIP <> '';
end;

procedure TUDPClient.ReadINI;
begin

end;

procedure TUDPClient.RevStrData(sIP: string; nPort: Integer; sStr: string);
Function GetIPAddress:String;
type
  pu_long = ^u_long;
var
  varTWSAData: TWSAData;
  varPHostEnt: PHostEnt;
  varTInAddr: TInAddr;
  namebuf: Array[0..255] of AnsiChar;
begin
  if WSAStartup($101, varTWSAData) <> 0 then
    Result := '127.0.0.1'
  else
  begin
    gethostname(namebuf, sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := '' + inet_ntoa(varTInAddr);
  end;
  WSACleanup;
end;

var
  nIndex : Integer;
  nNum : Integer;
begin
  inherited;
  if bGetInfo then
  begin
    nIndex := Pos(',', sStr);

    if nIndex > 0 then
    begin
      FList.Add(sStr);
    end;
  end;

  if sStr = 'ConnectServer' then
  begin
    if Assigned(FOnConnServer) then
    begin
      FOnConnServer(Self);
    end;
  end
  else if Pos('CheckLogin', sStr) > 0 then
  begin
    TryStrToInt(StringReplace(sStr, 'CheckLogin,', '', [rfReplaceAll]), nNum);

    if ClientControl.StudentInfo.stuNumber = nNum then
    begin
      SendPacksDataUDP(sIP, ListenPort, 'IPLogin,' + GetIPAddress);
    end;
  end
  else if Pos('IPLogin', sStr) > 0 then
  begin
    FLogInIP := StringReplace(sStr, 'IPLogin,', '', [rfReplaceAll]);
  end
end;

procedure TUDPClient.WriteINI;
begin

end;
end.
