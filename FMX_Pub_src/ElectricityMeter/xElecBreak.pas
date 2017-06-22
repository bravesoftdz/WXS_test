unit xElecBreak;

interface

uses xElecLine, xElecPoint, System.Classes, System.SysUtils;

type
  /// <summary>
  /// ��·��
  /// </summary>
  TElecBreak = class
  private
    FInLineN: TElecLine;
    FOutLineA: TElecLine;
    FInLineB: TElecLine;
    FInLineC: TElecLine;
    FInLineA: TElecLine;
    FOnBreakChange: TNotifyEvent;
    FIsBreakOn: Boolean;
    FOutLineN: TElecLine;
    FOutLineB: TElecLine;
    FOutLineC: TElecLine;
    FBreakName: string;
    procedure SetIsBreakOn(const Value: Boolean);

  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ��·������
    /// </summary>
    property BreakName : string read FBreakName write FBreakName;

    /// <summary>
    /// A�����
    /// </summary>
    property InLineA : TElecLine read FInLineA write FInLineA;

    /// <summary>
    /// B�����
    /// </summary>
    property InLineB : TElecLine read FInLineB write FInLineB;

    /// <summary>
    /// C�����
    /// </summary>
    property InLineC : TElecLine read FInLineC write FInLineC;

    /// <summary>
    /// N�����
    /// </summary>
    property InLineN : TElecLine read FInLineN write FInLineN;

    /// <summary>
    /// A�����
    /// </summary>
    property OutLineA : TElecLine read FOutLineA write FOutLineA;

    /// <summary>
    /// B�����
    /// </summary>
    property OutLineB : TElecLine read FOutLineB write FOutLineB;

    /// <summary>
    /// C�����
    /// </summary>
    property OutLineC : TElecLine read FOutLineC write FOutLineC;

    /// <summary>
    /// N�����
    /// </summary>
    property OutLineN : TElecLine read FOutLineN write FOutLineN;

    /// <summary>
    /// �Ƿ�պ�
    /// </summary>
    property IsBreakOn : Boolean read FIsBreakOn write SetIsBreakOn;

    /// <summary>
    /// ����״̬�ı�
    /// </summary>
    property OnBreakChange : TNotifyEvent read FOnBreakChange write FOnBreakChange;

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

{ TElecBreak }

procedure TElecBreak.ClearCurrentList;
begin
  FInLineA.ClearCurrentList;
  FInLineB.ClearCurrentList;
  FInLineC.ClearCurrentList;
  FInLineN.ClearCurrentList;
  FOutLineA.ClearCurrentList;
  FOutLineB.ClearCurrentList;
  FOutLineC.ClearCurrentList;
  FOutLineN.ClearCurrentList;
end;

procedure TElecBreak.ClearVolVlaue;
begin

end;

procedure TElecBreak.ClearWValue;
begin
  FInLineA.ClearWValue;
  FInLineB.ClearWValue;
  FInLineC.ClearWValue;
  FInLineN.ClearWValue;
  FOutLineA.ClearWValue;
  FOutLineB.ClearWValue;
  FOutLineC.ClearWValue;
  FOutLineN.ClearWValue;
end;

constructor TElecBreak.Create;
begin
  FInLineA  := TElecLine.Create;
  FInLineB  := TElecLine.Create;
  FInLineC  := TElecLine.Create;
  FInLineN  := TElecLine.Create;
  FOutLineA := TElecLine.Create;
  FOutLineB := TElecLine.Create;
  FOutLineC := TElecLine.Create;
  FOutLineN := TElecLine.Create;
  FIsBreakOn:= True;
  FBreakName:= '��·��';
end;

destructor TElecBreak.Destroy;
begin
  FInLineA.Free;
  FInLineB.Free;
  FInLineC.Free;
  FInLineN.Free;
  FOutLineA.Free;
  FOutLineB.Free;
  FOutLineC.Free;
  FOutLineN.Free;

  inherited;
end;

procedure TElecBreak.SetIsBreakOn(const Value: Boolean);
begin
  FIsBreakOn := Value;
end;

end.
