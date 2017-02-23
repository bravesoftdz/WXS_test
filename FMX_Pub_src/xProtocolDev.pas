unit xProtocolDev;

interface

uses System.Types, xTypes, xConsts, System.Classes, xFunction,
  system.SysUtils, xVCL_FMX, System.DateUtils;

type
  /// <summary>
  /// ͨѶ�豸����
  /// </summary>
  TProtocolDevBase = class
  private
    FControlAdd: Integer;
    FSN: String;
    FVersion: string;
    FOwnerDEV: TObject;

  protected
    procedure SetSN(const Value: String); virtual;
    procedure SetControlAdd(const Value: Integer);  virtual;
  public
    constructor Create; virtual;
    procedure Assign(Source: TObject); virtual;

    /// <summary>
    /// �豸���
    /// </summary>
    property SN : String read FSN write SetSN;

    /// <summary>
    /// ���Ƶ�ַ
    /// </summary>
    property ControlAdd : Integer read FControlAdd write SetControlAdd;

    /// <summary>
    /// �汾
    /// </summary>
    property Version : string read FVersion write FVersion;

    /// <summary>
    /// ������
    /// </summary>
    property OwnerDEV : TObject read FOwnerDEV write FOwnerDEV;
  end;

type
  /// <summary>
  /// ��������
  /// </summary>
  TVoice = class(TProtocolDevBase)
  private
    FVoiceType: Integer;

  public
    constructor Create; override;

    /// <summary>
    /// ������ʾ����
    /// ����ʱ�俪ʼ         01
    /// ����ʱ�䵽           02
    /// ����ʱ�仹ʣʮ����   03
    /// ����ʱ�仹ʣ�����   04
    /// </summary>
    property VoiceType : Integer read FVoiceType write FVoiceType;
  end;

type
  TMinuteLeftEvent = procedure(nMinuteLeft: Integer) of object;

type
  /// <summary>
  /// ʱ������
  /// </summary>
  TWorkTimerType = ( ttClock,    // ʱ��
                      ttPosTimer, // ����ʱ
                      ttRevTimer  // ����ʱ
                      );

  /// <summary>
  /// ��ȡ��ʱ��������
  /// </summary>
  function GetTimerTypeName( AType : TWorkTimerType ) : string;

type
  /// <summary>
  /// ��ʱ��
  /// </summary>
  TPDTimer = class( TProtocolDevBase )
  private
    FEnabled: Boolean;
    FWorkType: TWorkTimerType;
    FOnMinuteLeft: TMinuteLeftEvent;
    FCurrentTime: TDateTime;
    FStartTime : TDateTime; // ��ʼʱ��
    FPauseTimeStart : TDateTime; // ��ͣ��ʼʱ��
    FPauseTimeValue : TDateTime; // ��ͣ��ʱ��
    FPaused: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetWorkType(const Value: TWorkTimerType);
    procedure SetPaused(const Value: Boolean);
    /// <summary>
    /// �����ʱ��ʱ����
    /// </summary>
    procedure ClearTime;
    function GetCurrentTime: TDateTime;
    procedure SetCurrentTime(const Value: TDateTime);
  protected
    /// <summary>
    /// �ڲ���ʱ��
    /// </summary>
    Timer : TMyTimer;

    /// <summary>
    /// �ڲ���ʱ����ʱ
    /// </summary>
    procedure OnTimer( Sender : TObject );

    /// <summary>
    /// ����ʱ��
    /// </summary>
    procedure UpdateTime;
  public
    constructor Create; override;
    destructor Destroy; override;
  public
    /// <summary>
    /// ��ʱ��ʽ
    /// </summary>
    property WorkType : TWorkTimerType read FWorkType write SetWorkType;

    /// <summary>
    /// �Ƿ�������ʱ
    /// </summary>
    property Enabled : Boolean read FEnabled write SetEnabled;

    /// <summary>
    /// ��ǰ��ʱ��
    /// </summary>
    property CurrentTime : TDateTime read GetCurrentTime write SetCurrentTime;

    /// <summary>
    /// ��ͣ
    /// </summary>
    property Paused : Boolean read FPaused write SetPaused;

    /// <summary>
    /// ʣ��ʱ����ʾ ֻ�е���ʱ����
    /// </summary>
    property OnSecLeft: TMinuteLeftEvent read FOnMinuteLeft write FOnMinuteLeft;
  end;

implementation

{ TProtocolDevBase }

procedure TProtocolDevBase.Assign(Source: TObject);
begin
  Assert(Source is TProtocolDevBase);
  FControlAdd := TProtocolDevBase(Source).ControlAdd;
  FSN         := TProtocolDevBase(Source).SN;
  FVersion   := TProtocolDevBase(Source).Version;
end;

constructor TProtocolDevBase.Create;
begin
  FControlAdd := -1;
end;

procedure TProtocolDevBase.SetControlAdd(const Value: Integer);
begin
  FControlAdd := Value;
end;

procedure TProtocolDevBase.SetSN(const Value: String);
begin
  FSN := Value;
end;


{ TVoice }

constructor TVoice.Create;
begin
  inherited;
  FVoiceType := 0;
end;

{ TPDTimer }

function GetTimerTypeName( AType : TWorkTimerType ) : string;
begin
  case AType of
    ttClock: Result := 'ʱ��';
    ttPosTimer: Result := '����ʱ';
    ttRevTimer: Result := '����ʱ';
  else
    Result := 'δ����';
  end;
end;

procedure TPDTimer.ClearTime;
begin

  FStartTime := 0;
  FPauseTimeStart := 0;
  FPauseTimeValue := 0;
end;

constructor TPDTimer.Create;
begin
  inherited;
  Timer := TMyTimer.Create( nil );
  Timer.Enabled := False;
  Timer.OnTimer := OnTimer;

  FEnabled    := False;
  FWorkType   := ttClock;
  FCurrentTime := 0;
  ClearTime;
end;

destructor TPDTimer.Destroy;
begin
  Timer.Free;
  inherited;
end;

function TPDTimer.GetCurrentTime: TDateTime;
begin
  if FEnabled then
  begin
    case FWorkType of
      ttClock: Result := Now;
      ttPosTimer:
      begin
        if FPaused then
        begin
          Result := FPauseTimeStart - FStartTime - FPauseTimeValue + FCurrentTime;
        end
        else
        begin
          Result := Now - FStartTime - FPauseTimeValue + FCurrentTime;
        end;
      end;
      ttRevTimer:
      begin
        if FPaused then
        begin
          Result := FCurrentTime - (FPauseTimeStart - FStartTime - FPauseTimeValue);
        end
        else
        begin
          Result := FCurrentTime - (Now - FStartTime - FPauseTimeValue);
        end;
      end;
    else
      Result := FCurrentTime;
    end;
  end
  else
  begin
    Result := FCurrentTime;
  end;

end;

procedure TPDTimer.OnTimer(Sender: TObject);
begin
  UpdateTime;
end;

procedure TPDTimer.SetCurrentTime(const Value: TDateTime);
begin
  if not FEnabled then
  begin
    FCurrentTime := Value;
  end;
end;

procedure TPDTimer.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  Timer.Enabled := FEnabled;

  if FEnabled then
  begin
    ClearTime;
    FStartTime := Now;
  end;
end;

procedure TPDTimer.SetPaused(const Value: Boolean);
begin
  if FWorkType <> ttClock then
  begin
    if FEnabled then
    begin
      FPaused := Value;

      if FPaused then
      begin
        FPauseTimeStart := now;
      end
      else
      begin
        FPauseTimeValue := FPauseTimeValue + Now - FPauseTimeStart;
      end;
    end;
  end;
end;

procedure TPDTimer.SetWorkType(const Value: TWorkTimerType);
begin
  FWorkType := Value;
end;

procedure TPDTimer.UpdateTime;
var
  dtTemp : TDateTime;
begin
  if not Enabled then
    Exit;

  if FWorkType = ttRevTimer then
  begin
    dtTemp := CurrentTime;

    if SecondOf(dtTemp) = 0 then
    begin
      if Assigned(FOnMinuteLeft) then
      begin
        FOnMinuteLeft(MinuteOfTheDay(dtTemp));
      end;
    end;
  end;
end;

end.



