unit xThreadUDPSendScreen;

interface

uses System.Types,System.Classes, xFunction, system.SysUtils, xUDPServerBase,
  xConsts, System.IniFiles, xClientType, Winapi.WinInet, winsock, Graphics,
  xThreadBase;

type
  TThreadUDPSendScreen = class(TThreadBase)

  private
    FStream1 : TMemoryStream;
    FStream2 : TMemoryStream;
    FIsStream1 : Boolean;

    /// <summary>
    /// ��ȡҪ���͵�������
    /// </summary>
    function GetStream : TMemoryStream;

    procedure ReadINI;
    procedure WriteINI;
    procedure SetSendSecreen(const Value: TBitmap);

  protected

    /// <summary>
    /// ִ�ж�ʱ���� �������ʱ����Ҫִ���б���Ҫ�ж� FIsStop �Ƿ�ֹͣ���У����ͦʬ������Ҫ����ѭ����
    /// </summary>
    procedure ExecuteTimerOrder; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// Ҫ���͵���ĻͼƬ
    /// </summary>
    property SendSecreen : TBitmap write SetSendSecreen;
  end;
var
  UDPSendScreen : TThreadUDPSendScreen;

implementation

{ TTCPServer }

constructor TThreadUDPSendScreen.Create;
begin
  inherited;

  ProType := ctUDPServer;
  ReadINI;
end;

destructor TThreadUDPSendScreen.Destroy;
begin
  WriteINI;
  inherited;
end;

procedure TThreadUDPSendScreen.ExecuteTimerOrder;
var
  AStream : TMemoryStream;
begin
  inherited;
  AStream := GetStream;

  if AStream.Size > 0 then
  begin

  end;
end;

function TThreadUDPSendScreen.GetStream: TMemoryStream;
begin
  if FIsStream1 then
  begin
    Result := FStream1;
  end
  else
  begin
    Result := FStream2;
  end;
end;

procedure TThreadUDPSendScreen.ReadINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin

    TUDPServerBase(FCommBase).ListenPort := ReadInteger('UPDSendScreen', 'ListenPort', 16100);
    Free;
  end;
end;

procedure TThreadUDPSendScreen.SetSendSecreen(const Value: TBitmap);
begin
  if FIsStream1 then
  begin
    Value.SaveToStream(FStream2);
    FIsStream1 := False;
  end
  else
  begin
    Value.SaveToStream(FStream1);
    FIsStream1 := True;
  end;
end;

procedure TThreadUDPSendScreen.WriteINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    WriteInteger('UPDSendScreen', 'ListenPort', TUDPServerBase(FCommBase).ListenPort);

    Free;
  end;
end;

end.

