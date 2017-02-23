{===============================================================================
  Copyright(c) 2013, ��ɽ��ˮ��QQ121926828��
  All rights reserved.

  �̿�ģ���豸
  + TCKM_DEVICE  �豸����
  + TCKM_TIMER   ��ʱ����
  + TCKM_POWER   ����Դ

===============================================================================}

unit U_CKM_DEVICE;

interface

uses SysUtils, Classes, ExtCtrls, DateUtils;

type
  /// <summary>
  /// �̿�ģ���豸����
  /// </summary>
  TCKM_DEVICE = class( TComponent )
  private
    FControlAdd: Integer;
    FSN: String;
    FVersion: string;
    FOwner: TObject;
    FControlAdd2: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;
    /// <summary>
    /// �豸���
    /// </summary>
    property SN : string read FSN write FSN;

    /// <summary>
    /// ���Ƶ�ַ1
    /// </summary>
    property ControlAdd : Integer read FControlAdd write FControlAdd;

    /// <summary>
    /// ���Ƶ�ַ2
    /// </summary>
    property ControlAdd2 : Integer read FControlAdd2 write FControlAdd2;

    /// <summary>
    /// �汾
    /// </summary>
    property Version : string read FVersion write FVersion;

    /// <summary>
    /// ������
    /// </summary>
    property Owner : TObject read FOwner write FOwner;
  end;

type
  /// <summary>
  /// ���������
  /// </summary>
  TVOICE = class(TCKM_DEVICE)
  private
    FVoiceType: Integer;

  public
    constructor Create(AOwner: TComponent); override;

    /// <summary>
    /// ������ʾ����
    /// ���Կ�ʼ      01
    /// ����ʣ��10����02
    /// ����ʣ��5���� 03
    /// ���Խ���      04
    /// ��ѵ��ʼ      05
    /// ��ѵ����      06
    /// </summary>
    property VoiceType : Integer read FVoiceType write FVoiceType;
  end;

type
  /// <summary>
  /// ��ʱ����, ʱ�� / ����ʱ / ����ʱ
  /// </summary>
  TCKM_TIMER_TYPE = ( ttClock, ttRevTimer, ttPosTimer );

  /// <summary>
  /// ��ȡ��ʱ��������
  /// </summary>
  function GetTimerTypeName( AType : TCKM_TIMER_TYPE ) : string;

type
  /// <summary>
  /// ��ʱ������״̬
  /// </summary>
  TTIMER_WORK_STATUS = ( tsStop, tsRuning, tsPaused );

  /// <summary>
  /// ��ȡ��ʱ������״̬����
  /// </summary>
  function GetTimerWorkStatusName( AStatus : TTIMER_WORK_STATUS ) : string;

type
  /// <summary>
  /// ��ʱ��
  /// </summary>
  TCKM_TIMER = class( TCKM_DEVICE )
  private
    FTimerStart : TDateTime; // ��ʱ��ʼʱ��
    FTimerPaused : Integer; // ��ͣʱ�� (��)
    FCurrentTime: TDateTime; // ��ǰʱ��
    FExamPeriod: Integer;
    FWorkType: TCKM_TIMER_TYPE;
    FWorkStatus: TTIMER_WORK_STATUS;
    FOnMinChange: TNotifyEvent;
    FPausedRefreshTimes: Integer;
    FOnPausedRefresh: TNotifyEvent;
    FDevPort: Integer;
    FOnTimeOver: TNotifyEvent;
    FMins : Integer;
    procedure SetExamPeriod(const Value: Integer);
    procedure SetWorkType(const Value: TCKM_TIMER_TYPE);
    function GetCurrentTime: TDateTime;
    procedure SetCurrentTime(const Value: TDateTime);
  protected
    /// <summary>
    /// �ڲ���ʱ��
    /// </summary>
    Timer : TTimer;

    /// <summary>
    /// �ڲ���ʱ����ʱ
    /// </summary>
    procedure OnTimer( Sender : TObject );
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    /// <summary>
    /// ��ʱ��ʽ
    /// </summary>
    property WorkType : TCKM_TIMER_TYPE read FWorkType write SetWorkType;

    /// <summary>
    /// ���Լ�ʱ( ���� )
    /// </summary>
    property ExamPeriod : Integer read FExamPeriod write SetExamPeriod;

    /// <summary>
    /// ��ǰ��ʱ��
    /// </summary>
    property CurrentTime : TDateTime read GetCurrentTime write SetCurrentTime;

    /// <summary>
    /// ��ʱ������״̬
    /// </summary>
    property WorkStatus : TTIMER_WORK_STATUS read FWorkStatus write FWorkStatus;

    /// <summary>
    /// ��ʼ
    /// </summary>
    procedure Start;

    /// <summary>
    /// ��ͣ
    /// </summary>
    procedure Paused;

    /// <summary>
    /// ����
    /// </summary>
    procedure Continue;

    /// <summary>
    /// ֹͣ
    /// </summary>
    procedure Stop;

    /// <summary>
    /// ���Ӽ��ı��¼�
    /// </summary>
    property OnMinChange : TNotifyEvent read FOnMinChange write FOnMinChange;

    /// <summary>
    /// ��ͣˢ��ʱ�� -1Ϊ��ˢ��
    /// </summary>
    property PausedRefreshTimes : Integer read FPausedRefreshTimes
      write FPausedRefreshTimes;

    /// <summary>
    /// ��ͣˢ���¼�
    /// </summary>
    property OnPausedRefresh : TNotifyEvent read FOnPausedRefresh write FOnPausedRefresh;

    /// <summary>
    /// ����ʱʱ�䵽�¼�
    /// </summary>
    property OnTimeOver : TNotifyEvent read FOnTimeOver write FOnTimeOver;

    /// <summary>
    /// ��Ӧ�豸���ڵ�ַ
    /// </summary>
    property DevPort : Integer read FDevPort write FDevPort;
  end;

const
  /// <summary>
  /// ��С����
  /// </summary>
  C_POWER_MIN_CURRENT = 0;

type
  /// <summary>
  /// ����Դ����״̬
  /// </summary>
  TPOWER_WORK_STATUS = ( psOff, psOn, psAlarm );

  /// <summary>
  /// ��ȡ����Դ����״̬����
  /// </summary>
  function GetPowerWorkStatusName( AStatus : TPOWER_WORK_STATUS ) : string;

type
  /// <summary>
  /// ����������
  /// </summary>
  TPOWER_OUTPUT_TYPE = ( ptSingle,   // ����
                         ptThree,    // ��������
                         ptFour,     // ��������
                         ptFour577   // ��������57.7
                         );

  /// <summary>
  /// ��ȡ��������������
  /// </summary>
  function GetPowerOutputTypeName( AType : TPOWER_OUTPUT_TYPE ) : string;

type
  /// <summary>
  /// �������, False ���࣬ TrueΪͨ
  /// </summary>
  PPOWER_OUTPUT = ^TPOWER_OUTPUT;
  TPOWER_OUTPUT = record
    Ua : Boolean;
    Ub : Boolean;
    Uc : Boolean;
    Un : Boolean;
    Ia : Boolean;
    Ib : Boolean;
    Ic : Boolean;
  end;

  /// <summary>
  /// ��ȡĬ�ϵ��������
  /// </summary>
  function GetPowerOutputDefault( AType : TPOWER_OUTPUT_TYPE ) : TPOWER_OUTPUT;

type
  /// <summary>
  /// ��������
  /// </summary>
  TPOWER_ALARM_TYPE = ( plUa, plIa, plUb, plIb, plUc, plIc );

type
  /// <summary>
  /// ����
  /// </summary>
  TPOWER_ALARM = set of TPOWER_ALARM_TYPE;

  /// <summary>
  /// ��ȡ������Ϣ
  /// </summary>
  function GetPowerAlarmDescription( APAlarm : TPOWER_ALARM ) : string;

type
  /// <summary>
  /// ����Դ��������
  /// </summary>
  TPOWER_OPERATE_TYPE = ( poTurnOn, poTurnOff, poAdjust);

type
  /// <summary>
  /// ����Դ�����¼�
  /// </summary>
  TPOWER_OPERATE_EVENT = procedure( Sender : TObject;
    AOperateType : TPOWER_OPERATE_TYPE ) of object;

type
  /// <summary>
  /// ����Դ
  /// </summary>
  TCKM_POWER = class( TCKM_DEVICE )
  private
    FPowerOutputType: TPOWER_OUTPUT_TYPE;
    FPowerOutput: TPOWER_OUTPUT;
    FCurrent: Double;
    FVoltage: Double;
    FMaxVoltage: Double;

    FWorkStatus: TPOWER_WORK_STATUS;
    FAlarm : TPOWER_ALARM;
    FOnAlarm : TNotifyEvent;
    FOnOperation : TPOWER_OPERATE_EVENT;
    FCurrentPercent: Integer;
    FVoltagePercent: Integer;
    FAngle: Double;

    FOnSettingChange : TNotifyEvent;
    FMaxCurrent: Double;
    FDefAngle: Double;
    FMaxAngle: Double;
    FMinAngle: Double;
    FAdjustAngle3: Double;
    FAdjustAngle4: Double;
    procedure SetAngle(const Value: Double);
    procedure SetCurrent(const Value: Double);
    procedure SetPowerOutputType(const Value: TPOWER_OUTPUT_TYPE);
    procedure SetVoltage(const Value: Double);
    procedure SetMaxVoltage(const Value: Double);
    procedure SetPowerOutput(const Value: TPOWER_OUTPUT);
    function GetAlarmDescription : string;
    procedure SetCurrentPercent(const Value: Integer);
    procedure SetVoltagePercent(const Value: Integer);
    procedure SetAlarm(const Value: TPOWER_ALARM);
    procedure SetMaxCurrent(const Value: Double);
    /// <summary>
    /// ����Դ�����̵�ѹֵ
    /// </summary>
    function GetFullMaxVol : Double;
    /// <summary>
    /// ����Դ�����̵���ֵ
    /// </summary>
    function GetFullMaxCur : Double;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(Source: TPersistent); override;

    /// <summary>
    /// ������Դ
    /// </summary>
    procedure TurnOn;

    /// <summary>
    /// �ع���Դ
    /// </summary>
    procedure TurnOff;

    /// <summary>
    /// ��������Դ
    /// </summary>
    procedure Adjust;
  public
    /// <summary>
    /// ��������
    /// </summary>
    property PowerOutputType: TPOWER_OUTPUT_TYPE read FPowerOutputType write SetPowerOutputType;

    /// <summary>
    /// ����ѹ
    /// </summary>
    property MaxVoltage : Double read FMaxVoltage write SetMaxVoltage;

    /// <summary>
    /// ������
    /// </summary>
    property MaxCurrent : Double read FMaxCurrent write SetMaxCurrent;

    /// <summary>
    /// Ĭ�ϽǶ�
    /// </summary>
    property DefAngle : Double read FDefAngle write FDefAngle;

    /// <summary>
    /// ���Ƕ�
    /// </summary>
    property MaxAngle : Double read FMaxAngle write FMaxAngle;

    /// <summary>
    /// ��С�Ƕ�
    /// </summary>
    property MinAngle : Double read FMinAngle write FMinAngle;

    /// <summary>
    /// ͳһ��ѹֵ
    /// </summary>
    property Voltage : Double read FVoltage write SetVoltage;

    /// <summary>
    /// ͳһ��ѹ�������
    /// </summary>
    property VoltagePercent : Integer read FVoltagePercent write SetVoltagePercent;

    /// <summary>
    /// ͳһ����
    /// </summary>
    property Current : Double read FCurrent write SetCurrent;

    /// <summary>
    /// ͳһ��ѹ�������
    /// </summary>
    property CurrentPercent : Integer read FCurrentPercent write SetCurrentPercent;

    /// <summary>
    /// �Ƕ�
    /// </summary>
    property Angle : Double read FAngle write SetAngle;

    /// <summary>
    /// ���״̬
    /// </summary>
    property PowerOutput : TPOWER_OUTPUT read FPowerOutput write SetPowerOutput;



    /// <summary>
    /// ����״̬
    /// </summary>
    property WorkStatus : TPOWER_WORK_STATUS read FWorkStatus;

    /// <summary>
    /// ����
    /// </summary>
    property Alarm : TPOWER_ALARM read FAlarm write SetAlarm;

    /// <summary>
    /// �����Ƕ�
    /// </summary>
    property AdjustAngle3 : Double read FAdjustAngle3 write FAdjustAngle3;
    property AdjustAngle4 : Double read FAdjustAngle4 write FAdjustAngle4;
    function GetAdjustAngle:Double;

    /// <summary>
    /// ������Ϣ
    /// </summary>
    property AlarmDescription : string read GetAlarmDescription;

    /// <summary>
    /// �����¼�
    /// </summary>
    property OnAlarm : TNotifyEvent read FOnAlarm write FOnAlarm;

    /// <summary>
    /// �����¼�
    /// </summary>
    property OnOperation : TPOWER_OPERATE_EVENT read FOnOperation write FOnOperation;

    /// <summary>
    /// ���øı��¼�
    /// </summary>
    property OnSettingChange : TNotifyEvent read FOnSettingChange write FOnSettingChange;
  end;

type
  /// <summary>
  /// ��ѹ�Źʱ�����
  /// </summary>
  TLFAlarm = class(TCKM_DEVICE)
  private
    FIsCurrentOverB: Boolean;
    FIsCurrentOverC: Boolean;
    FIsCurrentOverA: Boolean;
    FIsVolOut: Boolean;
    FOnChange: TNotifyEvent;
    FIsControlPowerOn: Boolean;
    FIsReplay: Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    /// <summary>
    /// A�����
    /// </summary>
    property IsCurrentOverA : Boolean read FIsCurrentOverA write FIsCurrentOverA;
    /// <summary>
    /// B�����
    /// </summary>
    property IsCurrentOverB : Boolean read FIsCurrentOverB write FIsCurrentOverB;
    /// <summary>
    /// C�����
    /// </summary>
    property IsCurrentOverC : Boolean read FIsCurrentOverC write FIsCurrentOverC;
    /// <summary>
    /// ©��
    /// </summary>
    property IsVolOut : Boolean read FIsVolOut write FIsVolOut;

    /// <summary>
    /// �Ƿ�ͨ��
    /// </summary>
    property IsControlPowerOn : Boolean read FIsControlPowerOn write FIsControlPowerOn;

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChange : TNotifyEvent read FOnChange write FOnChange;

    /// <summary>
    /// ͨѶ�Ƿ�ظ�
    /// </summary>
    property IsReplay  : Boolean read FIsReplay write FIsReplay;
  end;

type
  /// <summary>
  /// �ز����ư�
  /// </summary>
  TCarrierControl = class(TCKM_DEVICE)
  private
    FIsOn: Boolean;

  public
    constructor Create(AOwner: TComponent); override;
    /// <summary>
    /// �Ƿ���ز�
    /// </summary>
    property IsOn : Boolean read FIsOn write FIsOn;
  end;

implementation

function GetTimerTypeName( AType : TCKM_TIMER_TYPE ) : string;
begin
  case AType of
    ttClock: Result := 'ʱ��';
    ttRevTimer: Result := '����ʱ';
    ttPosTimer : Result := '����ʱ';
  end;
end;

function GetTimerWorkStatusName( AStatus : TTIMER_WORK_STATUS ) : string;
begin
  case AStatus of
    tsStop: Result := 'ֹͣ';
    tsRuning: Result := '����';
    tsPaused: Result := '��ͣ';
  end;
end;

{ TCKM_TIMER }

procedure TCKM_TIMER.Continue;
begin
  case FWorkStatus of
    tsPaused: WorkStatus := tsRuning;
  end;
end;

constructor TCKM_TIMER.Create(AOwner: TComponent);
begin
  inherited;

  // �ڲ���ʱ��
  Timer := TTimer.Create( nil );
  Timer.Enabled := False;
  Timer.OnTimer := OnTimer;

  FTimerStart := Now;
  FExamPeriod := 30;
  FWorkType   := ttClock;
  FCurrentTime := -1;
  FWorkStatus := tsStop;
  FPausedRefreshTimes := 60;
end;

destructor TCKM_TIMER.Destroy;
begin
  Timer.Free;
  inherited;
end;

function TCKM_TIMER.GetCurrentTime: TDateTime;
begin
  case FWorkStatus of
    tsStop:
    begin
      if FWorkType = ttRevTimer then
        Result := FExamPeriod/minsperday
      else
        Result := FCurrentTime;
    end;
  else
    Result := FCurrentTime;
  end;
end;

procedure TCKM_TIMER.OnTimer(Sender: TObject);
begin
  case FWorkStatus of
    tsStop:
    begin
      FTimerStart := Now;
      FTimerPaused := 0;
    end;
    tsRuning:
    begin

    end;
    tsPaused:
    begin
      Inc(FTimerPaused);
    end;
  end;

  case FWorkType of
    ttClock:    CurrentTime := Now;
    ttRevTimer:
    begin
      CurrentTime := FTimerStart + (FExamPeriod / MinsPerDay) - Now +
        FTimerPaused/SecsPerDay;

      if CurrentTime <= 0 then
      begin
        if Assigned(FOnTimeOver) then
          FOnTimeOver(Self);
      end;
    end;

    ttPosTimer: CurrentTime := Now - FTimerStart - FTimerPaused/SecsPerDay;
  end;

  // ��ͣˢ��
  if (FPausedRefreshTimes <> -1) and (WorkStatus = tsPaused) then
  begin
    if (FTimerPaused mod FPausedRefreshTimes) = 0 then
    begin
      if Assigned(FOnPausedRefresh) then
        FOnPausedRefresh(Self);
    end;
  end;
end;

procedure TCKM_TIMER.Paused;
begin
  case FWorkStatus of
    tsRuning:
    begin
      WorkStatus := tsPaused;

      if Assigned(FOnPausedRefresh) then
        FOnPausedRefresh(Self);
    end;
  end;
end;

procedure TCKM_TIMER.SetCurrentTime(const Value: TDateTime);
var
  nMin : Integer;
begin
  FCurrentTime := Value;
  nMin := MinuteOf(Value);

  if nMin <> FMins then
  begin
    FMins := nMin;
    if Assigned(FOnMinChange) then
      FOnMinChange(Self);
  end;
end;

procedure TCKM_TIMER.SetExamPeriod(const Value: Integer);
begin
  FExamPeriod := Value;
end;

procedure TCKM_TIMER.SetWorkType(const Value: TCKM_TIMER_TYPE);
begin
  FWorkType := Value;

end;

procedure TCKM_TIMER.Start;
begin
  case FWorkStatus of
    tsStop:
    begin
      Timer.Enabled := True;
      OnTimer(Timer);
      FTimerStart := Now;
      FTimerPaused := 0;
      WorkStatus := tsRuning;
      
    end;
    tsPaused:
    begin
      Timer.Enabled := True;
      WorkStatus := tsRuning;
    end;
  end;
end;

procedure TCKM_TIMER.Stop;
begin
  WorkStatus := tsStop;

  OnTimer(Timer);
  Timer.Enabled := False;
  FCurrentTime := -1;
end;

function GetPowerWorkStatusName( AStatus : TPOWER_WORK_STATUS ) : string;
begin
  case AStatus of
    psOff: Result := '�ر�';
    psOn:  Result := '��';
    psAlarm: Result := '����';
  end;
end;

function GetPowerOutputTypeName( AType : TPOWER_OUTPUT_TYPE ) : string;
begin
  case AType of
    ptThree  : Result := '��������';
    ptFour   : Result := '��������';
    ptFour577: Result := '��������57.7';
  else
    Result := '����';
  end;
end;

function GetPowerOutputDefault( AType : TPOWER_OUTPUT_TYPE ) : TPOWER_OUTPUT;
begin
  case AType of
    ptSingle:
    with Result do
    begin
      Ua := True;
      Ub := True;
      Uc := True;
      Un := True;
      Ia := True;
      Ib := True;
      Ic := True;
    end;

    ptThree:
    with Result do
    begin
      Ua := True;
      Ub := True;
      Uc := True;
      Un := False;
      Ia := True;
      Ib := True;
      Ic := True;
    end;

    ptFour, ptFour577:
    with Result do
    begin
      Ua := True;
      Ub := True;
      Uc := True;
      Un := True;
      Ia := True;
      Ib := True;
      Ic := True;
    end;
  end;
end;

function GetPowerAlarmDescription( APAlarm : TPOWER_ALARM ) : string;
var
  i : TPOWER_ALARM_TYPE;
begin
  Result := '';

  if APAlarm <> [] then
  begin
    for i in APAlarm do
    begin
      case i of
        plUa : Result := Result + 'Ua��·,';
        plIa : Result := Result + 'Ia��·,';
        plUb : Result := Result + 'Ub��·,';
        plIb : Result := Result + 'Ib��·,';
        plUc : Result:= Result +  'Uc��·,';
        PlIc : Result:= Result +  'Ic��·,';
      end;
    end;

    Result := Copy( Result, 1, Length( Result ) - 1 );
  end;
end;

{ TCKM_POWER }

procedure TCKM_POWER.Adjust;
begin
  if FWorkStatus = psOn then
    if Assigned( FOnOperation ) then
      FOnOperation( Self, poAdjust );
end;

procedure TCKM_POWER.Assign(Source: TPersistent);
begin
  inherited;
  Assert( Source is TCKM_POWER );
  
  FPowerOutputType := TCKM_POWER( Source ).PowerOutputType;
  FPowerOutput     := TCKM_POWER( Source ).PowerOutput;
  FCurrent         := TCKM_POWER( Source ).Current;
  FVoltage         := TCKM_POWER( Source ).Voltage;
  FMaxVoltage      := TCKM_POWER( Source ).MaxVoltage;
  FAngle           := TCKM_POWER( Source ).Angle;
  FWorkStatus      := TCKM_POWER( Source ).WorkStatus;
  FCurrentPercent  := TCKM_POWER( Source ).CurrentPercent;
  FVoltagePercent  := TCKM_POWER( Source ).VoltagePercent;
end;

constructor TCKM_POWER.Create(AOwner: TComponent);
begin
  inherited;
  FDefAngle := 0;
  FMaxAngle := 360;
  FMinAngle := -180;
  FAdjustAngle3:= 0;
  FAdjustAngle4:= 0;

  SetPowerOutputType(ptFour);

  FWorkStatus := psOff;
end;

function TCKM_POWER.GetAdjustAngle: Double;
begin
  if FPowerOutputType = ptThree then
    Result := FAdjustAngle3
  else
    Result := FAdjustAngle4
end;

function TCKM_POWER.GetAlarmDescription: string;
begin
  Result := GetPowerAlarmDescription( FAlarm );
end;

function TCKM_POWER.GetFullMaxCur: Double;
begin
  Result := 5;
end;

function TCKM_POWER.GetFullMaxVol: Double;
begin
  case FPowerOutputType of
    ptThree: Result := 100;
  else
    Result := 220;
  end;
end;

procedure TCKM_POWER.SetAlarm(const Value: TPOWER_ALARM);
begin
  try
    FAlarm := Value;

    if FAlarm <> [] then
    begin
      FWorkStatus := psAlarm;

      if Assigned( FOnAlarm ) then
        FOnAlarm ( Self );
    end;
  finally

  end;
end;

procedure TCKM_POWER.SetAngle(const Value: Double);
begin
  if FAngle <> Value then
  begin
    // ���ƽǶ��� 0.0-359.9֮��
    FAngle := (round(Value * 10) mod 3600)/10;

    if FAngle < FMinAngle then
      FAngle := FMinAngle
    else if FAngle > FMaxAngle then
      FAngle := FMaxAngle;
  end;
end;

procedure TCKM_POWER.SetCurrent(const Value: Double);
begin
  if FCurrent <> Value then
  begin
    if Value > FMaxCurrent then
      FCurrent := FMaxCurrent
    else if Value < 0 then
      FCurrent := 0
    else
      FCurrent := Value;

    FCurrentPercent := Round( FCurrent / GetFullMaxCur * 100 );
  end;
end;

procedure TCKM_POWER.SetCurrentPercent(const Value: Integer);
begin
  if FCurrentPercent <> Value then
    SetCurrent(GetFullMaxCur * Value / 100);
end;

procedure TCKM_POWER.SetMaxCurrent(const Value: Double);
begin
  FMaxCurrent := Value;

  if FCurrent > FMaxCurrent then
    FCurrent := FMaxCurrent;

  FCurrentPercent := Round( FCurrent / GetFullMaxCur * 100 );
end;

procedure TCKM_POWER.SetMaxVoltage(const Value: Double);
begin
  FMaxVoltage := Value;

  if FVoltage > FMaxVoltage then
    FVoltage := FMaxVoltage;

  FVoltagePercent := Round( FVoltage / GetFullMaxVol * 100 );
end;

procedure TCKM_POWER.SetPowerOutputType(const Value: TPOWER_OUTPUT_TYPE);
begin
  if Value <> FPowerOutputType then
  begin
    FPowerOutputType := Value;
    // ��ֵ������
    MaxCurrent := 5;

    // ��ֵ����ѹ
    case FPowerOutputType of
      ptThree: MaxVoltage := 100;
      ptFour577: MaxVoltage := 57.7;
    else
      MaxVoltage := 220;
    end;

    // �����ѹ�����Ƕ�
//    SetAngle(FDefAngle);
//    SetVoltagePercent( Round(MaxVoltage/GetFullMaxVol) );
//    SetCurrentPercent( 100 );

    // �ı书��Դ���״̬
    SetPowerOutput(GetPowerOutputDefault( FPowerOutputType ));
  end;
end;

procedure TCKM_POWER.SetPowerOutput(const Value: TPOWER_OUTPUT);
begin
  if (FPowerOutput.Ua <> Value.Ua)or
    (FPowerOutput.Ub <> Value.Ub)or
    (FPowerOutput.Uc <> Value.Uc)or
    (FPowerOutput.Ia <> Value.Ia)or
    ((FPowerOutput.Ib <> Value.Ib))or
    (FPowerOutput.Ic <> Value.Ic)then
  begin
    FPowerOutput := Value;
  end;
end;

procedure TCKM_POWER.SetVoltage(const Value: Double);
begin
  if FVoltage <> Value then
  begin
    if Value > FMaxVoltage then
      FVoltage := FMaxVoltage
    else if Value < 0 then
      FVoltage := 0
    else
      FVoltage := Value;

    FVoltagePercent := Round( FVoltage / GetFullMaxVol * 100 );
  end;
end;

procedure TCKM_POWER.SetVoltagePercent(const Value: Integer);
begin
  if FVoltagePercent <> Value then
  begin
    SetVoltage(GetFullMaxVol * Value/100);
  end;

end;

procedure TCKM_POWER.TurnOff;
begin
  FWorkStatus := psOff;
  
  if Assigned( FOnOperation ) then
    FOnOperation( Self, poTurnOff );
end;

procedure TCKM_POWER.TurnOn;
begin
  FWorkStatus := psOn;

  if Assigned( FOnOperation ) then
    FOnOperation( Self, poTurnOn );
end;

{ TCKM_DEVICE }

procedure TCKM_DEVICE.Assign(Source: TPersistent);
begin
  Assert(Source is TCKM_DEVICE);
  FControlAdd := TCKM_DEVICE(Source).ControlAdd;
  FControlAdd2:= TCKM_DEVICE(Source).ControlAdd2;
  FSN         := TCKM_DEVICE(Source).SN;
  FVersion    := TCKM_DEVICE(Source).Version;
end;

constructor TCKM_DEVICE.Create(AOwner: TComponent);
begin
  inherited;
  FControlAdd := -1;
  FControlAdd2 := -1;
end;

{ TVOICE }

constructor TVOICE.Create(AOwner: TComponent);
begin
  inherited;
  FVoiceType := 1;
end;

{ TLFAlarm }

constructor TLFAlarm.Create(AOwner: TComponent);
begin
  inherited;
  FIsCurrentOverB:= False;
  FIsCurrentOverC:= False;
  FIsCurrentOverA:= False;
  FIsVolOut      := False;
  FIsControlPowerOn := False;
  FIsReplay := False;
end;

{ TCarrierControl }

constructor TCarrierControl.Create(AOwner: TComponent);
begin
  inherited;
  FIsOn := False;
end;

end.
