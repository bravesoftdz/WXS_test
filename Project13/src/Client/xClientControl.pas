unit xClientControl;

interface

uses System.Classes, System.SysUtils, xClientType, xStudentInfo, xTCPClient,
  xFunction, xDataDictionary;

type
  TClientControl = class
  private
    FStudentInfo: TStudentInfo;
    FStartTime: TDateTime;
    FClientState: TClientState;
    FEndTime: TDateTime;
    FSubList: TStringList;
    FOnStateChange: TNotifyEvent;
    FConnState: TClientConnState;
    FLoginState: TLoginState;
    FWorkState: TClientWorkState;
    FOnStopExam: TNotifyEvent;
    FOnStuReady: TStuReadyEvent;
    FOnStartExam: TNotifyEvent;
    FOnStuProgress: TStuProgressEvent;
    FOnStuLogin: TNotifyEvent;
    FOnConnected: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FTCPClient : TTCPClient;
    FOnLog: TGetStrProc;
    FExamName: string;
    FExamTimes: Integer;

    procedure ReadINI;
    procedure WriteINI;

    procedure StateChange;
    procedure SetClientState(const Value: TClientState);
    procedure SetConnState(const Value: TClientConnState);
    procedure SetLoginState(const Value: TLoginState);
    procedure SetWorkState(const Value: TClientWorkState);

    /// <summary>
    /// �ͻ��˻���״̬�ı�
    /// </summary>
    procedure ClientStateChange;

    procedure TCPConnect(Sender: TObject);
    procedure TCPDisconnect(Sender: TObject);
    procedure StuLogin(Sender: TObject);
    procedure StuReady( nTotalCount : Integer);
    procedure StuProgress( nReadyCount, nTotalCount : Integer);
    procedure StartExam(Sender: TObject);
    procedure StopExam(Sender: TObject);
    procedure TCPLog(const S: string);
    procedure TCPPacksLog(  aPacks: TBytes; bSend : Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// �ͻ�������״̬
    /// </summary>
    property ConnState : TClientConnState read FConnState write SetConnState;

    /// <summary>
    /// ��¼״̬
    /// </summary>
    property LoginState : TLoginState read FLoginState write SetLoginState;

    /// <summary>
    /// ����״̬
    /// </summary>
    property WorkState : TClientWorkState read FWorkState write SetWorkState;



    /// <summary>
    /// �ͻ���״̬
    /// </summary>
    property ClientState : TClientState read FClientState write SetClientState;

    /// <summary>
    /// ������Ϣ
    /// </summary>
    property StudentInfo : TStudentInfo read FStudentInfo write FStudentInfo;

    /// <summary>
    /// �����Ŀ����б�
    /// </summary>
    property SubList : TStringList read FSubList write FSubList;

    /// <summary>
    /// ��ʼ����ʱ��
    /// </summary>
    property StartTime : TDateTime read FStartTime write FStartTime;

    /// <summary>
    /// ��������ʱ��
    /// </summary>
    property EndTime : TDateTime read FEndTime write FEndTime;

    /// <summary>
    /// ��������
    /// </summary>
    property ExamName : string read FExamName write FExamName;

    /// <summary>
    /// ����ʱ�� ����
    /// </summary>
    property ExamTimes : Integer read FExamTimes write FExamTimes;

  public
    property TCPClient : TTCPClient read FTCPClient;
    /// <summary>
    /// ������¼
    /// </summary>
    function SendStuLogin(nStuID : Integer) : Boolean;

    /// <summary>
    /// ���Ϳ���״̬
    /// </summary>
    procedure SendStuState(AState : TClientState);

    /// <summary>
    /// ѧԱ��׼������
    /// </summary>
    procedure StuReadyExam;

  public
    /// <summary>
    /// ״̬�ı�
    /// </summary>
    property OnStateChange : TNotifyEvent read FOnStateChange write FOnStateChange;

    /// <summary>
    /// �����¼�
    /// </summary>
    property OnConnected : TNotifyEvent read FOnConnected write FOnConnected;

    /// <summary>
    /// �Ͽ������¼�
    /// </summary>
    property OnDisconnect : TNotifyEvent read FOnDisconnect write FOnDisconnect;

    /// <summary>
    /// ѧԱ��¼�¼�
    /// </summary>
    property OnStuLogin : TNotifyEvent read FOnStuLogin write FOnStuLogin;

    /// <summary>
    /// ѧԱ׼���¼�
    /// </summary>
    property OnStuReady : TStuReadyEvent read FOnStuReady write FOnStuReady;

    /// <summary>
    /// ѧԱ׼�������¼�
    /// </summary>
    property OnStuProgress : TStuProgressEvent read FOnStuProgress write FOnStuProgress;

    /// <summary>
    /// ��ʼ�����¼�
    /// </summary>
    property OnStartExam : TNotifyEvent read FOnStartExam write FOnStartExam;

    /// <summary>
    /// ֹͣ�����¼�
    /// </summary>
    property OnStopExam : TNotifyEvent read FOnStopExam write FOnStopExam;
    /// <summary>
    /// ͨѶ��¼
    /// </summary>
    property OnLog : TGetStrProc read FOnLog write FOnLog;
  end;
var
  ClientControl : TClientControl;

implementation

{ TClientControl }


procedure TClientControl.ClientStateChange;
begin
  if FConnState = ccsDisConn then
  begin
    ClientState := esDisconn;
    if FLoginState = lsLogin then
    begin
      ClientState := esLogin;
    end
    else
    begin
      ClientState := esConned;
    end;
  end
  else
  begin
    case FWorkState of
      cwsNot :
      begin
        if FLoginState = lsLogin then
        begin
          ClientState := esLogin;
        end
        else
        begin
          ClientState := esConned;
        end;
      end;
      cwsTrain :
      begin
        ClientState := esTrain;
      end;
      cwsPractise:
      begin
        ClientState := esPractise;
      end;
      cwsExamReady:
      begin
        ClientState := esWorkReady;
      end;
      cwsExamDoing:
      begin
        ClientState := esWorking;
      end;
      cwsExamFinished:
      begin
        ClientState := esWorkFinished;
      end;
    end;
  end;
end;

constructor TClientControl.Create;
begin
  FExamName:= 'Ĭ�Ͽ���';
  FExamTimes:= 30;
  FSubList:= TStringList.Create;
  FClientState := esDisconn;
  FStudentInfo:= TStudentInfo.Create;

  FConnState:= ccsDisConn;
  FLoginState:= lsLogOut;
  FWorkState:= cwsNot;

  FTCPClient := TTCPClient.Create;
  FTCPClient.OnConnected := TCPConnect;
  FTCPClient.OnDisconnect := TCPDisconnect;
  FTCPClient.OnLog := TCPLog;
  FTCPClient.OnSendRevPack := TCPPacksLog;
  FTCPClient.OnStuLogin := StuLogin;
  FTCPClient.OnStuReady := StuReady;
  FTCPClient.OnStuProgress := StuProgress;
  FTCPClient.OnStartExam := StartExam;
  FTCPClient.OnStopExam := StopExam;

  ReadINI;
end;

destructor TClientControl.Destroy;
begin
  WriteINI;

  FStudentInfo.Free;
  FTCPClient.Free;
  FSubList.Free;
  inherited;
end;

procedure TClientControl.ReadINI;
begin

end;

function TClientControl.SendStuLogin(nStuID: Integer): Boolean;
begin
  Result := FTCPClient.StuLogin(nStuID);
end;

procedure TClientControl.SendStuState(AState: TClientState);
begin
  FTCPClient.SendStuState(AState);
end;

procedure TClientControl.SetClientState(const Value: TClientState);
begin
  if FClientState <> Value then
  begin
    FClientState := Value;
    StateChange;
    FTCPClient.SendStuState(FClientState);
  end;
end;

procedure TClientControl.SetConnState(const Value: TClientConnState);
begin
  if FConnState <> Value then
  begin
    FConnState := Value;
    ClientStateChange;
  end;
end;

procedure TClientControl.SetLoginState(const Value: TLoginState);
begin
  if FLoginState <> Value then
  begin
    FLoginState := Value;
    ClientStateChange;
    FTCPClient.StuLogin(FStudentInfo.stuNumber);
  end;
end;

procedure TClientControl.SetWorkState(const Value: TClientWorkState);
begin
  if FWorkState <> Value then
  begin
    FWorkState := Value;
    ClientStateChange;
  end;
end;

procedure TClientControl.StartExam(Sender: TObject);
begin
  if Assigned(FOnStartExam) then
  begin
    FStartTime := Now;
    FOnStartExam(Self);
  end;
end;

procedure TClientControl.StateChange;
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Self);
end;

procedure TClientControl.StopExam(Sender: TObject);
begin
  if Assigned(FOnStopExam) then
  begin
    EndTime := Now;
    FOnStopExam(Self);
  end;
end;

procedure TClientControl.StuLogin(Sender: TObject);
begin
  if Assigned(FOnStuLogin) then
  begin
    FOnStuLogin(Self);
  end;
end;

procedure TClientControl.StuProgress(nReadyCount, nTotalCount: Integer);
begin
  if Assigned(FOnStuProgress) then
  begin
    FOnStuProgress(nReadyCount, nTotalCount);
  end;
end;

procedure TClientControl.StuReady(nTotalCount: Integer);
begin
  if Assigned(FOnStuReady) then
  begin
    FOnStuReady(nTotalCount);

    FSubList.Text := DataDict.Dictionary['�����б�'].Text;
    FExamName := DataDict.Dictionary['��������'].Text;
    trystrtoint(DataDict.Dictionary['����ʱ��'].Text, fexamtimes);

  end;
end;

procedure TClientControl.StuReadyExam;
begin
  FTCPClient.StuReadyExam;
end;

procedure TClientControl.TCPConnect(Sender: TObject);
begin
  if Assigned(FOnConnected) then
  begin
    FOnConnected(Sender);
  end;
end;

procedure TClientControl.TCPDisconnect(Sender: TObject);
begin
  if Assigned(FOnDisconnect) then
  begin
    FOnDisconnect(Sender);
  end;
end;

procedure TClientControl.TCPLog(const S: string);
begin
  if Assigned(FOnLog) then
  begin
    FOnLog(s);
  end;
end;

procedure TClientControl.TCPPacksLog(aPacks: TBytes; bSend: Boolean);
var
  s : string;
begin
  if bsend then
    s := '����'
  else
    s := '����';

  TCPLog(FormatDateTime('hh:mm:ss:zzz', Now) + s  + ' ' + BCDPacksToStr(aPacks) );
end;

procedure TClientControl.WriteINI;
begin

end;

end.
