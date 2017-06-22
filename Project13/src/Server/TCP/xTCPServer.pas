unit xTCPServer;

interface

uses System.Types,System.Classes, xFunction, system.SysUtils, xTCPServerBase,
  xConsts, System.IniFiles, xClientType;

type
  TRevStuData = procedure (sIP: string; nPort :Integer;aPacks: TArray<Byte>) of object;

type
  TTCPServer = class(TTCPServerBase)

  private

    FOnRevStuData: TRevStuData;

    procedure ReadINI;
    procedure WriteINI;
    /// <summary>
    /// ��������
    /// </summary>
    procedure SendOrder(sIP : string; nPort : Integer; aData : TBytes); overload;
    procedure SendOrder(sIP : string; nPort : Integer; nData : Byte); overload;


  protected
    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure RevPacksData(sIP: string; nPort :Integer;aPacks: TArray<Byte>); override;

  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// ����ѧԱ��¼
    /// </summary>
    procedure StuLogin(sIP : string = ''; nPort : Integer = 0);

    /// <summary>
    /// ����ѧԱ׼������
    /// </summary>
    procedure StuReady(nTotalCount : Integer; sIP : string = ''; nPort : Integer = 0 );

    /// <summary>
    /// ���ͽ���
    /// </summary>
    procedure SendProgress(nReadyCount, nTotalCount : Integer);

    /// <summary>
    /// ��ʼ����
    /// </summary>
    procedure StartExam(sIP : string = ''; nPort : Integer = 0);

    /// <summary>
    /// ֹͣ����
    /// </summary>
    procedure StopExam(sIP : string = ''; nPort : Integer = 0);

    /// <summary>
    /// ���ص�¼���
    /// </summary>
    procedure LoginResult(sIP : string; nPort : Integer; bResult : Boolean);
  public
    /// <summary>
    /// ���յ�ѧԱ�����ݰ�
    /// </summary>
    property OnRevStuData : TRevStuData read FOnRevStuData write FOnRevStuData;
  end;
var
  TCPServer : TTCPServer;

implementation

{ TTCPServer }

//function TTCPServer.BuildData(aData: TBytes): TBytes;
//
//var
//  nByte, nCode1, nCode2 : Byte;
//  i : Integer;
//  nFixCodeCount, nIndex : Integer; // ת���ַ�����
//
//  function IsFixCode(nCode : Integer) : Boolean;
//  begin
//    Result := nCode in [$7F, $7E];
//    Inc(nFixCodeCount);
//
//    if Result then
//    begin
//      nCode1 := $7F;
//      if nCode = $7E then
//        nCode2 := $01
//      else
//        nCode2 := $02;
//    end;
//  end;
//begin
//  nByte := 0;
//  nFixCodeCount := 0;
//
//  for i := 0 to Length(aData) - 1 do
//  begin
//    IsFixCode(aData[i]); // ����ת���ַ�����
//    nByte := (nByte + aData[i])and $FF; // ����У����
//  end;
//  IsFixCode(nByte); // �ж�У�����Ƿ���ת���ַ�
//
//  SetLength(Result, Length(aData) + nFixCodeCount + 2);
//  Result[0] := $7E;
//  Result[Length(Result)-1] := $7E;
//
//  nIndex := 1;
//
//  for i := 0 to Length(aData) - 1 do
//  begin
//    if IsFixCode(aData[i]) then
//    begin
//      Result[nIndex] := nCode1;
//      Result[nIndex+1] := nCode2;
//
//      Inc(nIndex, 2);
//    end
//    else
//    begin
//      Result[nIndex] := aData[i];
//      Inc(nIndex);
//    end;
//  end;
//end;

constructor TTCPServer.Create;
begin
  inherited;
  ReadINI;


end;

destructor TTCPServer.Destroy;
begin
  WriteINI;

  inherited;
end;

procedure TTCPServer.LoginResult(sIP: string; nPort: Integer; bResult: Boolean);
var
  aBuf : Tbytes;
begin
  SetLength(aBuf, 2);
  aBuf[0] := 6;
  if bResult then
    aBuf[1] := $01
  else aBuf[1] := $02;

  SendOrder(sIP, nPort, aBuf);
end;

procedure TTCPServer.ReadINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    ListenPort := ReadInteger('Option', 'ListenPort', 15000);
    Free;
  end;
end;

procedure TTCPServer.RevPacksData(sIP: string; nPort: Integer;
  aPacks: TArray<Byte>);
begin
  inherited;
  if Assigned(FOnRevStuData) then
  begin
    FOnRevStuData(sIP, nPort, aPacks);
  end;
end;

procedure TTCPServer.SendOrder(sIP: string; nPort: Integer; aData: TBytes);
var
  aBuf : TBytes;
begin
  aBuf := BuildData(aData);

  SendPacksDataTCP(sIP, nPort, aBuf);
end;

procedure TTCPServer.SendOrder(sIP: string; nPort: Integer; nData: Byte);
var
  aBuf : Tbytes;
begin
  SetLength(aBuf, 1);
  aBuf[0] := nData;
  SendOrder(sIP, nPort, aBuf);
end;

procedure TTCPServer.SendProgress(nReadyCount, nTotalCount: Integer);
var
  aBuf : Tbytes;
begin
  SetLength(aBuf, 3);
  aBuf[0] := 3;
  aBuf[1] := nReadyCount and $FF;
  aBuf[2] := nTotalCount and $FF;

  SendOrder('', 0, aBuf);
end;

procedure TTCPServer.StartExam(sIP: string; nPort: Integer);
begin
  SendOrder(sIP, nPort, 4);
end;

procedure TTCPServer.StopExam(sIP: string; nPort: Integer);
begin
  SendOrder(sIP, nPort, 5);
end;

procedure TTCPServer.StuLogin(sIP: string; nPort: Integer);
begin
  SendOrder(sIP, nPort, 1);
end;

procedure TTCPServer.StuReady(nTotalCount : Integer;sIP: string; nPort: Integer );
var
  aBuf : Tbytes;
begin
  SetLength(aBuf, 2);
  aBuf[0] := 2;
  aBuf[1] := nTotalCount and $FF;

  SendOrder(sIP, nPort, aBuf);
end;

procedure TTCPServer.WriteINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    WriteInteger('Option', 'ListenPort', ListenPort);

    Free;
  end;
end;

end.
