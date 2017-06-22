unit xElecLineBox;

interface

uses xElecLine, xElecPoint, System.Classes, System.SysUtils;


type
  /// <summary>
  /// ���Ͻ��ߺ�-��ѹ
  /// </summary>
  TLineBoxVol = class
  private
    FIsON: Boolean;
    FInLineVol: TElecLine;
    FOutLineVol: TElecLine;
    FOnChange: TNotifyEvent;
    procedure SetIsON(const Value: Boolean);

    procedure OnOffChange(Sender : TObject);
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// ����
    /// </summary>
    property InLineVol : TElecLine read FInLineVol write FInLineVol;

    /// <summary>
    /// ����
    /// </summary>
    property OutLineVol : TElecLine read FOutLineVol write FOutLineVol;

    /// <summary>
    /// ���߳����Ƿ�����
    /// </summary>
    property IsON : Boolean read FIsON write SetIsON;

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChange : TNotifyEvent read FOnChange write FOnChange;

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

type
  /// <summary>
  /// ���Ͻ��ߺ�-����
  /// </summary>
  TLineBoxCurrent = class
  private
    FIsLine23On: Boolean;
    FIsLine12On: Boolean;
    FOutLineCurrent2: TElecLine;
    FOutLineCurrent3: TElecLine;
    FOutLineCurrent1: TElecLine;
    FInLineCurrent2: TElecLine;
    FInLineCurrent3: TElecLine;
    FInLineCurrent1: TElecLine;
    FOnChange: TNotifyEvent;
    procedure SetIsLine12On(const Value: Boolean);
    procedure SetIsLine23On(const Value: Boolean);
    procedure OnOffChange(Sender : TObject);
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// ����1
    /// </summary>
    property InLineCurrent1 : TElecLine read FInLineCurrent1 write FInLineCurrent1;

    /// <summary>
    /// ����2
    /// </summary>
    property InLineCurrent2 : TElecLine read FInLineCurrent2 write FInLineCurrent2;

    /// <summary>
    /// ����3
    /// </summary>
    property InLineCurrent3 : TElecLine read FInLineCurrent3 write FInLineCurrent3;

    /// <summary>
    /// ����1
    /// </summary>
    property OutLineCurrent1 : TElecLine read FOutLineCurrent1 write FOutLineCurrent1;

    /// <summary>
    /// ����2
    /// </summary>
    property OutLineCurrent2 : TElecLine read FOutLineCurrent2 write FOutLineCurrent2;

    /// <summary>
    /// ����2
    /// </summary>
    property OutLineCurrent3 : TElecLine read FOutLineCurrent3 write FOutLineCurrent3;


    /// <summary>
    /// ��·1����·2�Ƿ�պ�
    /// </summary>
    property IsLine12On : Boolean read FIsLine12On write SetIsLine12On;

    /// <summary>
    /// ��·2����·3�Ƿ�պ�
    /// </summary>
    property IsLine23On : Boolean read FIsLine23On write SetIsLine23On;

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
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


type
  /// <summary>
  /// ���Ͻ��ߺ�
  /// </summary>
  TElecLineBox = class
  private
    FLineBoxName: string;
    FBoxUA: TLineBoxVol;
    FBoxUB: TLineBoxVol;
    FBoxUC: TLineBoxVol;
    FBoxUN: TLineBoxVol;
    FBoxIA: TLineBoxCurrent;
    FBoxIB: TLineBoxCurrent;
    FBoxIC: TLineBoxCurrent;
    FOnChange: TNotifyEvent;

    procedure OnOffChange(Sender : TObject);
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ���Ͻ��ߺ�����
    /// </summary>
    property LineBoxName : string read FLineBoxName write FLineBoxName;

    /// <summary>
    /// A���ѹ
    /// </summary>
    property BoxUA : TLineBoxVol read FBoxUA write FBoxUA;

    /// <summary>
    /// B���ѹ
    /// </summary>
    property BoxUB : TLineBoxVol read FBoxUB write FBoxUB;

    /// <summary>
    /// C���ѹ
    /// </summary>
    property BoxUC : TLineBoxVol read FBoxUC write FBoxUC;

    /// <summary>
    /// N���ѹ
    /// </summary>
    property BoxUN : TLineBoxVol read FBoxUN write FBoxUN;

    /// <summary>
    /// A�����
    /// </summary>
    property BoxIA : TLineBoxCurrent read FBoxIA write FBoxIA;

    /// <summary>
    /// B�����
    /// </summary>
    property BoxIB : TLineBoxCurrent read FBoxIB write FBoxIB;

    /// <summary>
    /// C�����
    /// </summary>
    property BoxIC : TLineBoxCurrent read FBoxIC write FBoxIC;

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChange : TNotifyEvent read FOnChange write FOnChange;

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

{ TLineBoxVol }

procedure TLineBoxVol.ClearCurrentList;
begin
  FInLineVol.ClearCurrentList;
  FOutLineVol.ClearCurrentList;
end;

procedure TLineBoxVol.ClearVolVlaue;
begin

end;

procedure TLineBoxVol.ClearWValue;
begin
  FInLineVol.ClearWValue;
  FOutLineVol.ClearWValue;
end;

constructor TLineBoxVol.Create;
begin
  FInLineVol:= TElecLine.Create;
  FOutLineVol:= TElecLine.Create;
  FInLineVol.ConnPointAdd(FOutLineVol);
  FIsON:= True;
end;

destructor TLineBoxVol.Destroy;
begin
  FInLineVol.Free;
  FOutLineVol.Free;

  inherited;
end;

procedure TLineBoxVol.OnOffChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Sender);

    if FIsON then
    begin
      FInLineVol.ConnPointAdd(FOutLineVol);
      FInLineVol.SendVolValue;
    end
    else
    begin
      FInLineVol.ConnPointDel(FOutLineVol);
      FOutLineVol.Voltage.Value := 0;
      FOutLineVol.SendVolValue;
    end;

  end;
end;

procedure TLineBoxVol.SetIsON(const Value: Boolean);
begin
  if FIsON <> Value then
  begin
    FIsON := Value;
    OnOffChange(Self);
  end;

end;

{ TLineBoxCurrent }

procedure TLineBoxCurrent.ClearCurrentList;
begin
  FOutLineCurrent1.ClearCurrentList;
  FOutLineCurrent2.ClearCurrentList;
  FOutLineCurrent3.ClearCurrentList;
  FInLineCurrent1.ClearCurrentList;
  FInLineCurrent2.ClearCurrentList;
  FInLineCurrent3.ClearCurrentList;
end;

procedure TLineBoxCurrent.ClearVolVlaue;
begin

end;

procedure TLineBoxCurrent.ClearWValue;
begin
  FOutLineCurrent1.ClearWValue;
  FOutLineCurrent2.ClearWValue;
  FOutLineCurrent3.ClearWValue;
  FInLineCurrent1.ClearWValue;
  FInLineCurrent2.ClearWValue;
  FInLineCurrent3.ClearWValue;
end;

constructor TLineBoxCurrent.Create;
begin
  FOutLineCurrent1:= TElecLine.Create;
  FOutLineCurrent2:= TElecLine.Create;
  FOutLineCurrent3:= TElecLine.Create;
  FInLineCurrent1:= TElecLine.Create;
  FInLineCurrent2:= TElecLine.Create;
  FInLineCurrent3:= TElecLine.Create;

  FOutLineCurrent1.ConnPointAdd(FInLineCurrent1);
  FOutLineCurrent2.ConnPointAdd(FInLineCurrent2);
  FOutLineCurrent3.ConnPointAdd(FInLineCurrent3);


  FIsLine12On:= False;
  FIsLine23On:= True;
  FInLineCurrent2.ConnPointAdd(FOutLineCurrent3);
end;

destructor TLineBoxCurrent.Destroy;
begin
  FOutLineCurrent1.Free;
  FOutLineCurrent2.Free;
  FOutLineCurrent3.Free;
  FInLineCurrent1.Free;
  FInLineCurrent2.Free;
  FInLineCurrent3.Free;


  inherited;
end;


procedure TLineBoxCurrent.OnOffChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Sender);
  end;
end;

procedure TLineBoxCurrent.SetIsLine12On(const Value: Boolean);
begin
  if FIsLine12On <> Value then
  begin
    FIsLine12On := Value;
    OnOffChange(Self);
  end;

end;

procedure TLineBoxCurrent.SetIsLine23On(const Value: Boolean);
begin
  if FIsLine23On <> Value then
  begin
    FIsLine23On := Value;
    OnOffChange(Self);
  end;
end;

{ TElecLineBox }

procedure TElecLineBox.ClearCurrentList;
begin
  FBoxUA.ClearCurrentList;
  FBoxUB.ClearCurrentList;
  FBoxUC.ClearCurrentList;
  FBoxUN.ClearCurrentList;
  FBoxIA.ClearCurrentList;
  FBoxIB.ClearCurrentList;
  FBoxIC.ClearCurrentList;
end;

procedure TElecLineBox.ClearVolVlaue;
begin

end;

procedure TElecLineBox.ClearWValue;
begin
  FBoxUA.ClearWValue;
  FBoxUB.ClearWValue;
  FBoxUC.ClearWValue;
  FBoxUN.ClearWValue;
  FBoxIA.ClearWValue;
  FBoxIB.ClearWValue;
  FBoxIC.ClearWValue;
end;

constructor TElecLineBox.Create;
begin
  FLineBoxName:= '���Ͻ��ߺ�';
  FBoxUA:= TLineBoxVol.Create;
  FBoxUB:= TLineBoxVol.Create;
  FBoxUC:= TLineBoxVol.Create;
  FBoxUN:= TLineBoxVol.Create;
  FBoxIA:= TLineBoxCurrent.Create;
  FBoxIB:= TLineBoxCurrent.Create;
  FBoxIC:= TLineBoxCurrent.Create;

  FBoxUA.OnChange := OnOffChange;
  FBoxUB.OnChange := OnOffChange;
  FBoxUC.OnChange := OnOffChange;
  FBoxUN.OnChange := OnOffChange;
  FBoxIA.OnChange := OnOffChange;
  FBoxIB.OnChange := OnOffChange;
  FBoxIC.OnChange := OnOffChange;

  FBoxUA.InLineVol.LineName := '���Ͻ��ߺ�UA����';
  FBoxUB.InLineVol.LineName := '���Ͻ��ߺ�UB����';
  FBoxUC.InLineVol.LineName := '���Ͻ��ߺ�UC����';
  FBoxUN.InLineVol.LineName := '���Ͻ��ߺ�UN����';

  FBoxUA.OutLineVol.LineName := '���Ͻ��ߺ�UA����';
  FBoxUB.OutLineVol.LineName := '���Ͻ��ߺ�UB����';
  FBoxUC.OutLineVol.LineName := '���Ͻ��ߺ�UC����';
  FBoxUN.OutLineVol.LineName := '���Ͻ��ߺ�UN����';

  FBoxIA.InLineCurrent1.LineName := '���Ͻ��ߺ�IA����1';
  FBoxIA.InLineCurrent2.LineName := '���Ͻ��ߺ�IA����2';
  FBoxIA.InLineCurrent3.LineName := '���Ͻ��ߺ�IA����3';

  FBoxIB.InLineCurrent1.LineName := '���Ͻ��ߺ�IB����1';
  FBoxIB.InLineCurrent2.LineName := '���Ͻ��ߺ�IB����2';
  FBoxIB.InLineCurrent3.LineName := '���Ͻ��ߺ�IB����3';

  FBoxIC.InLineCurrent1.LineName := '���Ͻ��ߺ�IC����1';
  FBoxIC.InLineCurrent2.LineName := '���Ͻ��ߺ�IC����2';
  FBoxIC.InLineCurrent3.LineName := '���Ͻ��ߺ�IC����3';

  FBoxIA.OutLineCurrent1.LineName := '���Ͻ��ߺ�IA����1';
  FBoxIA.OutLineCurrent2.LineName := '���Ͻ��ߺ�IA����2';
  FBoxIA.OutLineCurrent3.LineName := '���Ͻ��ߺ�IA����3';

  FBoxIB.OutLineCurrent1.LineName := '���Ͻ��ߺ�IB����1';
  FBoxIB.OutLineCurrent2.LineName := '���Ͻ��ߺ�IB����2';
  FBoxIB.OutLineCurrent3.LineName := '���Ͻ��ߺ�IB����3';

  FBoxIC.OutLineCurrent1.LineName := '���Ͻ��ߺ�IC����1';
  FBoxIC.OutLineCurrent2.LineName := '���Ͻ��ߺ�IC����2';
  FBoxIC.OutLineCurrent3.LineName := '���Ͻ��ߺ�IC����3';

end;

destructor TElecLineBox.Destroy;
begin
  FBoxUA.Free;
  FBoxUB.Free;
  FBoxUC.Free;
  FBoxUN.Free;
  FBoxIA.Free;
  FBoxIB.Free;
  FBoxIC.Free;

  inherited;
end;

procedure TElecLineBox.OnOffChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

end.
