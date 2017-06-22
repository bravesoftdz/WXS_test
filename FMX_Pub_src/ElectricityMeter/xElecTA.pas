unit xElecTA;

interface

uses xElecLine, xElecPoint, System.Classes, System.SysUtils, xElecFunction ;

type
  /// <summary>
  /// ����������
  /// </summary>
  TElecTA = class
  private
    FOnValueChnage: TNotifyEvent;
    FTAFirstValue: Double;
    FTASecondValue: Double;
    FTAName: string;
    FFirstCurrentL: TElecLine;
    FSecondCurrentH: TElecLine;
    FSecondCurrentL: TElecLine;
    FFirstCurrentH: TElecLine;

    procedure ValueChangeCurrent(Sender : TObject);
    procedure ValueChange(Sender : TObject);
    procedure SetTAName(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ��������������
    /// </summary>
    property TAName : string read FTAName write SetTAName;

    /// <summary>
    /// һ�ε�ѹ �߶�
    /// </summary>
    property FirstCurrentH : TElecLine read FFirstCurrentH write FFirstCurrentH;

    /// <summary>
    /// һ�ε�ѹ �Ͷ�
    /// </summary>
    property FirstCurrentL : TElecLine read FFirstCurrentL write FFirstCurrentL;

    /// <summary>
    /// ���ε�ѹ �߶�
    /// </summary>
    property SecondCurrentH : TElecLine read FSecondCurrentH write FSecondCurrentH;

    /// <summary>
    /// ���ε�ѹ �Ͷ�
    /// </summary>
    property SecondCurrentL : TElecLine read FSecondCurrentL write FSecondCurrentL;

    /// <summary>
    /// TA���һ�β�ֵ
    /// </summary>
    property TAFirstValue : Double read FTAFirstValue write FTAFirstValue;

    /// <summary>
    /// TA��ȶ��β�ֵ
    /// </summary>
    property TASecondValue : Double read FTASecondValue write FTASecondValue;

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
    procedure FirstClearWValue;

    /// <summary>
    /// ��յ����б�
    /// </summary>
    procedure FirstClearCurrentList;

    /// <summary>
    /// ���Ȩֵ
    /// </summary>
    procedure SecondClearWValue;

    /// <summary>
    /// ��յ����б�
    /// </summary>
    procedure SecondClearCurrentList;

    /// <summary>
    /// ˢ��ֵ
    /// </summary>
    procedure RefurshValue;
  end;

implementation

{ TElecTA }

procedure TElecTA.FirstClearCurrentList;
begin
  FFirstCurrentH.ClearCurrentList;
  FFirstCurrentL.ClearCurrentList;


end;

procedure TElecTA.ClearVolVlaue;
begin

end;

procedure TElecTA.FirstClearWValue;
begin
  FFirstCurrentH.ClearWValue;
  FFirstCurrentL.ClearWValue;


end;

procedure TElecTA.RefurshValue;
begin
  if Assigned(FFirstCurrentH) then
  begin

    GetTwoPointCurrent(FFirstCurrentH, FFirstCurrentL, FFirstCurrentH.Current);
    FSecondCurrentH.Current.Value := FFirstCurrentH.Current.Value/FTAFirstValue*FTASecondValue;
    FSecondCurrentH.Current.Angle := FFirstCurrentH.Current.Angle;


    // �ݹ����е����Ͷ˽ڵ�
    // ��ֵȨֵ
    FSecondCurrentL.CalcCurrWValue;

    // ��ʼ������ԭ�������б�
    FSecondCurrentH.SendCurrentValue;



  end;
end;

constructor TElecTA.Create;
begin
  FFirstCurrentL:= TElecLine.Create;
  FSecondCurrentH:= TElecLine.Create;
  FSecondCurrentL:= TElecLine.Create;
  FFirstCurrentH:= TElecLine.Create;

  FFirstCurrentL.LineName:= 'TAһ�εͶ�';
  FSecondCurrentH.LineName:= 'TA���θ߶�';
  FSecondCurrentL.LineName:= 'TA���εͶ�';
  FFirstCurrentH.LineName:= 'TAһ�θ߶�';

  FFirstCurrentH.ConnPointAdd(FFirstCurrentL);

  FSecondCurrentL.Current.IsLowPoint:= True;
  FSecondCurrentL.Current.IsHighPoint:= False;
  FSecondCurrentH.Current.IsLowPoint:= False;
  FSecondCurrentH.Current.IsHighPoint:= True;

  FFirstCurrentH.OnChangeCurrent := ValueChangeCurrent;
  FSecondCurrentH.OnChange := ValueChange;

  FTAFirstValue:= 100;
  FTASecondValue:= 5;
  FTAName := '����������';
end;

destructor TElecTA.Destroy;
begin
  FFirstCurrentL.Free;
  FSecondCurrentH.Free;
  FSecondCurrentL.Free;
  FFirstCurrentH.Free;

  inherited;
end;

procedure TElecTA.SecondClearCurrentList;
begin
  FSecondCurrentH.ClearCurrentList;
  FSecondCurrentL.ClearCurrentList;
end;

procedure TElecTA.SecondClearWValue;
begin
  FSecondCurrentH.ClearWValue;
//  FSecondCurrentL.ClearWValue;
end;

procedure TElecTA.SetTAName(const Value: string);
begin
  FTAName := Value;

  FFirstCurrentL.LineName:= FTAName + 'һ�εͶ�';
  FSecondCurrentH.LineName:= FTAName + '���θ߶�';
  FSecondCurrentL.LineName:= FTAName + '���εͶ�';
  FFirstCurrentH.LineName:= FTAName + 'һ�θ߶�';
end;

procedure TElecTA.ValueChange(Sender: TObject);
begin
  if Assigned(FOnValueChnage) then
  begin
    FOnValueChnage(Self);
  end;
end;

procedure TElecTA.ValueChangeCurrent(Sender: TObject);
begin
//  if Assigned(FFirstCurrentH) then
//  begin
//    FSecondCurrentH.Current.Value := FFirstCurrentH.Current.Value/FTAFirstValue*FTASecondValue;
//    FSecondCurrentH.Current.Angle := FFirstCurrentH.Current.Angle;
//
////
////    // �ݹ����е����Ͷ˽ڵ�
////    // ��ֵȨֵ
////    FSecondCurrentL.CalcCurrWValue;
//
//    // ���ԭ�������б�
//    SecondClearCurrentList;
//
//    // ��ʼ������ԭ�������б�
//    FSecondCurrentH.SendCurrentValue;
//
//
//
//  end;
end;


end.






