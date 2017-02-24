unit xExamControl;

interface

uses xClientInfo, System.SysUtils, System.Classes, xFunction, System.IniFiles,
  xTCPServer, xStudentInfo, xConsts, xClientType, xStudentControl;

type
  /// <summary>
  /// ������
  /// </summary>
  TExamControl = class
  private
    FClientList: TStringList;
    FColCount: Integer;
    FOnClinetChanged: TNotifyEvent;
//    FTCPServer : TTCPServer;
    FExamStuList: TStringList;
    FOnTCPLog: TGetStrProc;


    function GetClientInfo(nIndex: Integer): TClientInfo;
    procedure SetClinetCount(const Value: Integer);
    function GetClinetCount: Integer;

    procedure ReadINI;
    procedure WriteINI;

    procedure ClinetChanged(Sender: TObject);
    procedure LoginEvent(Sender: TObject; nStuID : Integer);
    procedure RevPacksData(sIP: string; nPort :Integer;aPacks: TArray<Byte>);
    procedure ClientChange( AIP: string; nPort: Integer; AConnected: Boolean );

//    procedure TCPPacksLog( sIP : string; nPort: Integer; aPacks: TArray<Byte>; bSend : Boolean);
//    procedure TCPLog(const S: string);
  public
    constructor Create;
    destructor Destroy; override;

//    /// <summary>
//    /// TCPͨѶ����
//    /// </summary>
//    property TCPServer : TTCPServer read FTCPServer write FTCPServer;

    /// <summary>
    /// �ͻ�������
    /// </summary>
    property ClinetCount : Integer read GetClinetCount write SetClinetCount;

    /// <summary>
    /// �б�
    /// </summary>
    property ClientList : TStringList read FClientList write FClientList;
    property ClientInfo[nIndex:Integer] : TClientInfo read GetClientInfo;

    /// <summary>
    /// ��ȡ�ͻ���
    /// </summary>
    function GetClient(sIP : string; nPort : Integer) : TClientInfo;

    /// <summary>
    /// ��ʾ������
    /// </summary>
    property ColCount : Integer read FColCount write FColCount;

    /// <summary>
    /// �μӿ��ԵĿ����б�
    /// </summary>
    property ExamStuList : TStringList read FExamStuList write FExamStuList;

    /// <summary>
    /// ���ӿ���
    /// </summary>
    procedure AddStu(AStu : TStudentInfo);

  public
    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnClinetChanged : TNotifyEvent read FOnClinetChanged write FOnClinetChanged;

    /// <summary>
    /// TCPͨѶ���ݼ�¼
    /// </summary>
    property OnTCPLog : TGetStrProc read FOnTCPLog write FOnTCPLog;

  end;
var
  ExamControl : TExamControl;
implementation

{ TExamControl }

procedure TExamControl.AddStu(AStu: TStudentInfo);
begin
  if Assigned(AStu) then
  begin
    FExamStuList.AddObject(IntToStr(AStu.stuNumber), AStu);
  end;
end;

procedure TExamControl.ClientChange(AIP: string; nPort: Integer;
  AConnected: Boolean);
var
  AClientInfo : TClientInfo;
begin
  AClientInfo := GetClient(AIP, nPort);

  if Assigned(AClientInfo) then
  begin
    if AConnected then
      AClientInfo.ClientState := esConned
    else
      AClientInfo.ClientState := esDisconn
  end;
end;

procedure TExamControl.ClinetChanged(Sender: TObject);
begin
  if Assigned(FOnClinetChanged) then
  begin
    FOnClinetChanged(Sender);
  end;
end;

constructor TExamControl.Create;
begin
  FClientList := TStringList.Create;
  FExamStuList:= TStringList.Create;
  TCPServer.OnRevStuData := RevPacksData;
  TCPServer.OnClientChange := ClientChange;
//  FTCPServer := TTCPServer.Create;
//  FTCPServer.OnIPSendRev := TCPPacksLog;
//  FTCPServer.OnLog := TCPLog;
//  FTCPServer.Connect;

  ReadINI;
end;

destructor TExamControl.Destroy;
begin
  WriteINI;
//  FTCPServer.Free;

  ClearStringList(FClientList);
  FClientList.Free;
  FExamStuList.Free;
  inherited;
end;

function TExamControl.GetClient(sIP: string; nPort: Integer): TClientInfo;
var
  i : Integer;
begin
  Result := nil;
  for i := 0 to FClientList.Count - 1 do
  begin
    with TClientInfo(FClientList.Objects[i]) do
    begin
      if (ClientIP = sIP) then
      begin
        Result := TClientInfo(FClientList.Objects[i]);
        Break;
      end;
    end;
  end;

end;

function TExamControl.GetClientInfo(nIndex: Integer): TClientInfo;
begin
  if (nIndex >= 0) and (nIndex < FClientList.Count) then
  begin
    Result := TClientInfo(FClientList.Objects[nIndex]);
  end
  else
  begin
    Result := nil;
  end;
end;

function TExamControl.GetClinetCount: Integer;
begin
  Result := FClientList.Count;
end;

procedure TExamControl.LoginEvent(Sender: TObject; nStuID: Integer);
var
  nIndex : Integer;
begin
  with TClientInfo(Sender) do
  begin
//    nIndex := FExamStuList.IndexOf(IntToStr(nStuID));
//    TCPServer.LoginResult(ClientIP, ClientPort, nIndex <> -1);
//
//    if nIndex <> -1 then
//    begin
//      StudentInfo.Assign(TStudentInfo(FExamStuList.Objects[nIndex]));
//    end;
    TCPServer.LoginResult(ClientIP, ClientPort, True);
    StudentInfo.Assign(StudentControl.SearchStu(nStuID));
    ClientState := esLogin;
  end;
end;

procedure TExamControl.ReadINI;
var
  s : string;
  i : Integer;
  AStuInfo : TStudentInfo;
  nSN : Integer;
begin
  with TIniFile.Create( spubFilePath + 'OptionClient.ini') do
  begin
    FColCount := ReadInteger('Option', 'ClientColCount', 6);
    ClinetCount := ReadInteger('Option', 'ClientCount', 30);

    s := ReadString('Exam', 'ExamStuList', '');

    GetPartValue(FExamStuList,s, ',');

    for i := FExamStuList.Count - 1 downto 0 do
    begin
      TryStrToInt(FExamStuList[i], nSN);
      AStuInfo := StudentControl.SearchStu(nSN);
      if Assigned(AStuInfo) then
      begin
        FExamStuList.Objects[i] := AStuInfo;
      end
      else
      begin
        FExamStuList.Delete(i);
      end;
    end;



    Free;
  end;
end;

procedure TExamControl.RevPacksData(sIP: string; nPort: Integer;
  aPacks: TArray<Byte>);
var
  AClientInfo : TClientInfo;
begin
  AClientInfo := GetClient(sIP, nPort);

  if Assigned(AClientInfo) then
  begin
    AClientInfo.RevPacksData(sIP, nPort, aPacks);
  end;
end;

procedure TExamControl.SetClinetCount(const Value: Integer);
var
  i: Integer;
  AClientInfo : TClientInfo;
begin
  if Value > FClientList.Count then
  begin
    // ����
    for i := FClientList.Count to Value - 1 do
    begin
      AClientInfo := TClientInfo.Create;
      AClientInfo.ClientSN := i+1;
      AClientInfo.OnChanged := ClinetChanged;
      AClientInfo.OnStuLogin := LoginEvent;

      FClientList.AddObject('', AClientInfo);
    end;
  end
  else if Value < FClientList.Count then
  begin
    for i := FClientList.Count - 1 downto Value do
    begin
      FClientList.Objects[i].Free;
      FClientList.Delete(i);
    end;
  end;
end;

//procedure TExamControl.TCPLog(const S: string);
//begin
//  if Assigned(FOnTCPLog) then
//    FOnTCPLog(s);
//end;
//
//procedure TExamControl.TCPPacksLog(sIP: string; nPort: Integer; aPacks: TArray<Byte>;
//  bSend: Boolean);
//var
//  s : string;
//begin
//  if bsend then
//    s := '����'
//  else
//    s := '����';
//
//  if Assigned(FOnTCPLog) then
//    FOnTCPLog(FormatDateTime('hh:mm:ss:zzz', Now) + s + sIP +':' + IntToStr(nPort) + ' ' + BCDPacksToStr(aPacks) );
//end;

procedure TExamControl.WriteINI;
var
  s : string;
  i : Integer;
begin
  with TIniFile.Create(spubFilePath + 'OptionClient.ini') do
  begin
    WriteInteger('Option', 'ClientColCount', FColCount);
    WriteInteger('Option', 'ClientCount', ClinetCount);

    s := '';
    for i := 0 to FExamStuList.Count - 1 do
      s := s + FExamStuList[i] + ',';

    WriteString('Exam', 'ExamStuList', s);
    Free;
  end;
end;

end.

