unit U_VECTOR_CONTROL;

interface

uses Classes, SysUtils, U_VECTOR_LIEN_INFO, Graphics, Windows, XMLIntf, msxmldom,
  XMLDoc,Variants, Forms, Dialogs, GDIPAPI, GDIPOBJ, System.Types;

type
  TVECTOR_CONTROL = class
  private
    FVectorList: TStringList;
    XMLDocument1: TXMLDocument;
    FRect: TRect;
    FCanvas: TCanvas;
    FBackColor: TColor;
    function GetVectorInfo(nIndex: Integer): TVECTOR_LIEN_INFO;
    procedure SetVectorStr(const Value: string);
    function GetVectorStr: string;


  public
    /// <summary>
    /// ����ȫ���������ڲ�ѡ��״̬
    /// </summary>
    procedure SetNoSelect;

    /// <summary>
    /// �������
    /// </summary>
    function AddVector : TVECTOR_LIEN_INFO;

    /// <summary>
    /// ɾ������
    /// </summary>
    procedure DelVector(nVectorID : Integer);

    /// <summary>
    /// ����ͼ
    /// </summary>
    property BackColor : TColor read FBackColor write FBackColor;

    /// <summary>
    /// ��ȡ����������ͼ�����û�з���nil
    /// </summary>
    function PointInVLine(APoint : TPoint): TVECTOR_LIEN_INFO;

    /// <summary>
    /// ����ƶ�
    /// </summary>
    function MouseMove(APoint : TPoint): TVECTOR_LIEN_INFO;

    /// <summary>
    /// ɾ��ѡ������
    /// </summary>
    procedure DelSelect;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// �����б�
    /// </summary>
    property VectorList : TStringList read FVectorList write FVectorList;
    property VectorInfo[nIndex : Integer] : TVECTOR_LIEN_INFO read GetVectorInfo;

    procedure ClearList;

    /// <summary>
    /// ����ͼ����
    /// </summary>
    property VectorStr : string read GetVectorStr write SetVectorStr;

    /// <summary>
    /// ���� ���븳ֵ
    /// </summary>
    property Canvas : TCanvas read FCanvas write FCanvas;

    /// <summary>
    /// �������� ���븳ֵ
    /// </summary>
    property Rect : TRect read FRect write FRect;

    /// <summary>
    /// ����
    /// </summary>
    procedure Draw;
  end;
var
  AVectorControl : TVECTOR_CONTROL;


implementation

{ TVECTOR_CONTROL }

function TVECTOR_CONTROL.AddVector: TVECTOR_LIEN_INFO;
  function GetMaxID : Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to FVectorList.Count - 1 do
    begin
      if VectorInfo[i].VID > Result then
        Result := VectorInfo[i].VID;
    end;
  end;
begin
  Result := TVECTOR_LIEN_INFO.Create;
  Result.VID := GetMaxID + 1;
  FVectorList.AddObject('', Result);
end;

procedure TVECTOR_CONTROL.ClearList;
var
  i: Integer;
begin
  for i := 0 to FVectorList.Count - 1 do
    FVectorList.Objects[i].Free;

  FVectorList.Clear;
end;

constructor TVECTOR_CONTROL.Create;
begin
  XMLDocument1:= TXMLDocument.Create(Application);
  FVectorList:= TStringList.Create;
  FBackColor := clBlack;
end;

procedure TVECTOR_CONTROL.DelSelect;
var
  i: Integer;
  AVLInfo : TVECTOR_LIEN_INFO;
begin
  for i := FVectorList.Count - 1 downto 0 do
  begin
    AVLInfo := VectorInfo[i];
    if AVLInfo.IsSelected then
    begin
      AVLInfo.Free;
      FVectorList.Delete(i);
    end;

  end;
end;

procedure TVECTOR_CONTROL.DelVector(nVectorID: Integer);
var
  i: Integer;
  AVLineInfo : TVECTOR_LIEN_INFO;
begin
  for i := FVectorList.Count - 1 downto 0 do
  begin
    AVLineInfo := VectorInfo[i];

    if Assigned(AVLineInfo) then
    begin
      if AVLineInfo.VID = nVectorID then
      begin
        AVLineInfo.Free;
        FVectorList.Delete(i);
      end;
    end;
  end;
end;

destructor TVECTOR_CONTROL.Destroy;
begin
  ClearList;

  FVectorList.Free;
  XMLDocument1.Free;
  inherited;
end;

procedure TVECTOR_CONTROL.Draw;
  function GetScale : Double;
  begin
    if (FRect.Right - FRect.Left)/430 > (FRect.Bottom - FRect.Top)/350  then
    begin
      Result := (FRect.Bottom - FRect.Top)/350
    end
    else
    begin
      Result := (FRect.Right - FRect.Left)/430
    end;
  end;
var
  AVector : TVECTOR_LIEN_INFO;
  i: Integer;
  g: TGPGraphics;
  p: TGPPen;
  ACenterPoint : TPoint;
  sb: TGPSolidBrush;
  dScale : Double;
begin
  if not Assigned(FCanvas) then
    Exit;

  // ����Ŵ���
  dScale := GetScale;

  // ������
  g := TGPGraphics.Create(FCanvas.Handle);
  g.SetSmoothingMode(TSmoothingMode(1));

  with FRect do
  begin
    ACenterPoint := Point(Round((Left + Right)/2), Round((Top + Bottom)/2));

    sb := TGPSolidBrush.Create(ColorRefToARGB(FBackColor));

    g.FillRectangle(sb, Left ,top,Right-Left,Bottom-top);


    p := TGPPen.Create(MakeColor(192,192,192), 1);
    p.SetDashStyle(DashStyleDash);

    g.DrawLine(p, Left+1 ,Top+1,Right-2,Top+1);
    g.DrawLine(p, Right-2 ,Top+1,Right-2,Bottom-2);
    g.DrawLine(p, Left+1 ,Top+1,Left+1,Bottom-2);
    g.DrawLine(p, Left+1 ,Bottom-2,Right-2,Bottom-2);

    g.DrawLine(p, Left ,ACenterPoint.Y,Right,ACenterPoint.y);
    g.DrawLine(p, ACenterPoint.x ,Top,ACenterPoint.x,Bottom);
  end;

  g.Free;
  p.Free;

  // ��������
  for i := 0 to 2 do
  begin
    AVector := TVECTOR_LIEN_INFO.Create;
    AVector.CenterPoint := ACenterPoint;
    AVector.Canvas := FCanvas;
    AVector.Scale := dScale;

//    AVector.VName := 'U' + Char(ord('a') + i);
    AVector.VName := '';
    AVector.VColor := clSilver;
    AVector.VValue := 220;
    AVector.VAngle := 90 + 120*i;
    AVector.Draw;
    AVector.Free;
  end;

  // ������ͼ
  for i := 0 to FVectorList.Count - 1 do
  begin
    AVector := VectorInfo[i];
    AVector.CenterPoint := ACenterPoint;
    AVector.Canvas := FCanvas;
    AVector.Scale := dScale;
    
    AVector.Draw;
  end;
end;

function TVECTOR_CONTROL.GetVectorInfo(nIndex: Integer): TVECTOR_LIEN_INFO;
begin
  if (nIndex >= 0) and (nIndex < FVectorList.Count) then
  begin
    Result := TVECTOR_LIEN_INFO(FVectorList.Objects[nIndex]);
  end
  else
    Result := nil;
end;

function TVECTOR_CONTROL.GetVectorStr: string;
const
  C_XML = '<LineInfo VID ="%d" VName ="%s" VType="%s" VColor="%d" VValue="%f" VAngle="%f" VDrawPoint="%s">%s</LineInfo>';
var
  i: Integer;
begin
  Result := '<?xml version="1.0" encoding="gb2312"?>' + #13#10;
  Result := Result + '<VectorMap>' + #13#10;
  Result := Result + '<VectorLine>' + #13#10;
  for i := 0 to FVectorList.Count - 1 do
  begin
    with VectorInfo[i] do
    begin
      Result := Result + Format(C_XML, [VID, VName, VTypeStr, VColor, VValue, VAngle,BoolToStr(IsDrawPoint), VName ]) + #13#10;
    end;
  end;

  Result := Result + '</VectorLine>' + #13#10;
  Result := Result + '</VectorMap>' + #13#10;
end;

function TVECTOR_CONTROL.MouseMove(APoint: TPoint): TVECTOR_LIEN_INFO;
var
  i: Integer;
  AVLInfo : TVECTOR_LIEN_INFO;
begin
  Result := nil;

  for i := 0 to FVectorList.Count - 1 do
  begin
    AVLInfo := VectorInfo[i];
    AVLInfo.IsOver := False;
  end;

  for i := 0 to FVectorList.Count - 1 do
  begin
    AVLInfo := VectorInfo[i];

    if AVLInfo.IsInLine(APoint) then
    begin
      Result := AVLInfo;
      Result.IsOver := True;
      Break;
    end;
  end;
end;

function TVECTOR_CONTROL.PointInVLine(APoint: TPoint): TVECTOR_LIEN_INFO;
var
  i: Integer;
  AVLInfo : TVECTOR_LIEN_INFO;
begin
  Result := nil;
  
  for i := 0 to FVectorList.Count - 1 do
  begin
    AVLInfo := VectorInfo[i];

    if AVLInfo.IsInLine(APoint) then
    begin
      Result := AVLInfo;
      Break;
    end;
  end;
end;

procedure TVECTOR_CONTROL.SetNoSelect;
var
  i: Integer;
  AVLInfo : TVECTOR_LIEN_INFO;
begin
  for i := 0 to FVectorList.Count - 1 do
  begin
    AVLInfo := VectorInfo[i];

    AVLInfo.IsSelected := False;
    AVLInfo.IsMainSelect := False;
  end;
end;

procedure TVECTOR_CONTROL.SetVectorStr(const Value: string);
  function GetStrValue(sValue : string; Anode:IXMLNode) : string;
  var
    oValue : OleVariant;
  begin
    oValue := Anode.Attributes[sValue];
    if oValue <> null then
      Result := oValue
    else
      Result := '';
  end;

  function GetIntValue(sValue : string; Anode:IXMLNode) : Integer;
  var
    oValue : OleVariant;
  begin
    oValue := Anode.Attributes[sValue];
    if oValue <> null then
      Result := oValue
    else
      Result := 0;
  end;

  function GetFloatValue(sValue : string; Anode:IXMLNode) : Double;
  var
    oValue : OleVariant;
  begin
    oValue := Anode.Attributes[sValue];
    if oValue <> null then
      Result := oValue
    else
      Result := 0;
  end;

  function GetBoolValue(sValue : string; Anode:IXMLNode) : Boolean;
  var
    oValue : OleVariant;
  begin
    oValue := Anode.Attributes[sValue];
    if oValue <> null then
      Result := oValue
    else
      Result := True;
  end;
var
  node, nodeInfo: IXMLNode;
  i: Integer;
  j: Integer;
  AVLInfo : TVECTOR_LIEN_INFO;
begin
  ClearList;

  XMLDocument1.XML.Text := Value;
  XMLDocument1.Active := True;

  for i := 0 to XMLDocument1.DocumentElement.ChildNodes.Count - 1 do
  begin
    node := XMLDocument1.DocumentElement.ChildNodes[i];

    if node.NodeName = 'VectorLine' then
    begin
      for j := 0 to node.ChildNodes.Count - 1 do
      begin
        nodeInfo := node.ChildNodes[j];
        AVLInfo := AddVector;
        AVLInfo.VID := GetIntValue('VID', nodeInfo);
        AVLInfo.VName := GetStrValue('VName', nodeInfo);
        AVLInfo.VTypeStr := GetStrValue('VType', nodeInfo);
        AVLInfo.VColor := GetIntValue('VColor', nodeInfo);
        AVLInfo.VValue := GetFloatValue('VValue', nodeInfo);
        AVLInfo.VAngle := GetFloatValue('VAngle', nodeInfo);
        AVLInfo.IsDrawPoint := GetBoolValue('VDrawPoint', nodeInfo);
      end;
    end;
  end;
  
  Draw;
end;

end.
