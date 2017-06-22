unit xElecTV;

interface

uses xElecLine, xElecPoint, System.Classes, System.SysUtils;

type
  /// <summary>
  /// ��ѹ������
  /// </summary>
  TElecTV = class
  private
    FOnValueChnage: TNotifyEvent;
    FTVFirstValue: Double;
    FTVSecondValue: Double;
    FTVName: string;
    FFirstVolL: TElecLine;
    FFirstVolH: TElecLine;
    FSecondVolH: TElecLine;
    FSecondVolL: TElecLine;


    procedure ValueChangeVol(Sender : TObject);
    procedure ValueChange(Sender : TObject);
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ��ѹ����������
    /// </summary>
    property TVName : string read FTVName write FTVName;

    /// <summary>
    /// һ�ε�ѹ�߶�
    /// </summary>
    property FirstVolH : TElecLine read FFirstVolH write FFirstVolH;

    /// <summary>
    /// һ�ε�ѹ�Ͷ�
    /// </summary>
    property FirstVolL : TElecLine read FFirstVolL write FFirstVolL;

    /// <summary>
    /// ���ε�ѹ�߶�
    /// </summary>
    property SecondVolH : TElecLine read FSecondVolH write FSecondVolH;

    /// <summary>
    /// ���ε�ѹ�Ͷ�
    /// </summary>
    property SecondVolL : TElecLine read FSecondVolL write FSecondVolL;

    /// <summary>
    /// TV���һ�β�ֵ
    /// </summary>
    property TVFirstValue : Double read FTVFirstValue write FTVFirstValue;

    /// <summary>
    /// TV��ȶ��β�ֵ
    /// </summary>
    property TVSecondValue : Double read FTVSecondValue write FTVSecondValue;

    /// <summary>
    /// ֵ�ı��¼�
    /// </summary>
    property OnValueChnage : TNotifyEvent read FOnValueChnage write FOnValueChnage;

  public
    /// <summary>
    /// ��յ�ѹֵ
    /// </summary>
    procedure ClearVolVlaue;

    /// <summary>
    /// ���Ȩֵ
    /// </summary>
    procedure ClearWValue;

    /// <summary>
    /// ��յ����б�
    /// </summary>
    procedure ClearCurrentList;
  end;

implementation

{ TElecTV }

procedure TElecTV.ClearCurrentList;
begin
  FFirstVolL.ClearCurrentList;
  FFirstVolH.ClearCurrentList;
  FSecondVolH.ClearCurrentList;
  FSecondVolL.ClearCurrentList;
end;

procedure TElecTV.ClearVolVlaue;
begin

end;

procedure TElecTV.ClearWValue;
begin
  FFirstVolL.ClearWValue;
  FFirstVolH.ClearWValue;
  FSecondVolH.ClearWValue;
  FSecondVolL.ClearWValue;
end;

constructor TElecTV.Create;
begin
  FFirstVolL:= TElecLine.Create;
  FFirstVolH:= TElecLine.Create;
  FSecondVolH:= TElecLine.Create;
  FSecondVolL:= TElecLine.Create;

  FFirstVolH.OnChangeVol := ValueChangeVol;
  FSecondVolH.OnChange := ValueChange;

  FFirstVolL.LineName:= 'TVһ�εͶ�';
  FFirstVolH.LineName:= 'TVһ�θ߶�';
  FSecondVolH.LineName:= 'TV���θ߶�';
  FSecondVolL.LineName:= 'TV���εͶ�';


  FTVFirstValue:= 1;
  FTVSecondValue:= 1;
  FTVName := '��ѹ��ѹ������';
end;

destructor TElecTV.Destroy;
begin
  FFirstVolL.Free;
  FFirstVolH.Free;
  FSecondVolH.Free;
  FSecondVolL.Free;

  inherited;
end;

procedure TElecTV.ValueChange(Sender: TObject);
begin
  if Assigned(FOnValueChnage) then
  begin
    FOnValueChnage(Self);
  end;
end;

procedure TElecTV.ValueChangeVol(Sender: TObject);
begin
  if Assigned(FFirstVolH) then
  begin
    FSecondVolH.Voltage.Value := FFirstVolH.Voltage.Value/FTVFirstValue*FTVSecondValue;
    FSecondVolH.Voltage.Angle := FFirstVolH.Voltage.Angle;

    FSecondVolH.WID := FFirstVolH.WID;
    FSecondVolH.SendVolValue;

  end;
end;

end.
