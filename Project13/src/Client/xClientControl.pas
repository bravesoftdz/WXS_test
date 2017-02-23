unit xClientControl;

interface

uses System.Classes, System.SysUtils, xClientType, xStudentInfo, xTCPClient,
  xUDPClient1, xFunction;

type
  TClientControl = class
  private
    FStudentInfo: TStudentInfo;
    FStartTime: TDateTime;
    FClientState: TClientState;
    FEndTime: TDateTime;
    FSubList: TStringList;
    FOnStateChange: TNotifyEvent;

    procedure ReadINI;
    procedure WriteINI;

    procedure StateChange;
    procedure SetClientState(const Value: TClientState);


  public
    constructor Create;
    destructor Destroy; override;

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

  public
    /// <summary>
    /// ״̬�ı�
    /// </summary>
    property OnStateChange : TNotifyEvent read FOnStateChange write FOnStateChange;

  end;
var
  ClientControl : TClientControl;

implementation

{ TClientControl }


constructor TClientControl.Create;
begin
  FClientState := esDisconn;
  FStudentInfo:= TStudentInfo.Create

end;

destructor TClientControl.Destroy;
begin
  FStudentInfo.Free;

  inherited;
end;

procedure TClientControl.ReadINI;
begin

end;

procedure TClientControl.SetClientState(const Value: TClientState);
begin
  if FClientState <> Value then
  begin
    FClientState := Value;
    StateChange;
    TCPClient.SendStuState(FClientState);
  end;
end;

procedure TClientControl.StateChange;
begin
  if Assigned(FOnStateChange) then
    FOnStateChange(Self);
end;

procedure TClientControl.WriteINI;
begin

end;

end.
