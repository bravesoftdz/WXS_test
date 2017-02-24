unit xUDPServer;

interface

uses System.Types,System.Classes, xFunction, system.SysUtils, xUDPServerBase,
  xConsts, System.IniFiles, xClientType;

type
  TUDPServer = class(TUDPServerBase)

  private
    FInfoServerPort: Integer;
    FInfoServerIP: string;

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
    /// ������IP
    /// </summary>
    property InfoServerIP : string read FInfoServerIP write FInfoServerIP;

    /// <summary>
    /// �������˿�
    /// </summary>
    property InfoServerPort : Integer read FInfoServerPort write FInfoServerPort;

    /// <summary>
    /// ���ӷ���������
    /// </summary>
    procedure SendConnServer;
  end;
var
  UDPServer : TUDPServer;

implementation

{ TTCPServer }

constructor TUDPServer.Create;
begin
  inherited;
  ReadINI;
end;

destructor TUDPServer.Destroy;
begin
  WriteINI;
  inherited;
end;

procedure TUDPServer.ReadINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    FInfoServerIP := ReadString('UPDOption', 'ServerIP', '');
    FInfoServerPort := ReadInteger('UPDOption', 'ServerPort', 15000);

    ListenPort := ReadInteger('UPDOption', 'ListenPort', 16000);
    Free;
  end;
end;

procedure TUDPServer.RevStrData(sIP: string; nPort: Integer; sStr: string);
begin
  inherited;
  if sStr = 'GetServerInfo' then
  begin
    SendPacksData(sIP, ListenPort+1, FInfoServerIP + ',' + IntToStr(FInfoServerPort));
  end;
end;

procedure TUDPServer.SendConnServer;
begin
  SendPacksData('255.255.255.255', ListenPort+1, 'ConnectServer');
end;

procedure TUDPServer.WriteINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    WriteString('UPDOption', 'ServerIP', FInfoServerIP);
    WriteInteger('UPDOption', 'ServerPort', FInfoServerPort);

    Free;
  end;
end;

end.