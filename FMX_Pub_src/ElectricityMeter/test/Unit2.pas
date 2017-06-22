unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, xElecMeter,  FMX.Menus,
  xElecPower, xElecLine, xElecOrgan, FMX.ScrollBox, FMX.Memo, xElecPoint,
  FMX.Edit;

type
  TForm2 = class(TForm)
    tmr1: TTimer;
    btn1: TButton;
    PopupMenu1: TPopupMenu;
    mmo1: TMemo;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    edt1: TEdit;
    btn7: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
  private
    { Private declarations }
    APower : TElecPower;
    AMeter : TElecMeter;

    procedure INIMeter4;
    procedure INIMeter3;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.btn1Click(Sender: TObject);
  procedure SetValue(AElecLine: TElecLine);
  var
    AWValue : TWeightValue;
    j : Integer;
    nValue : Integer;
  begin
    TryStrToInt(edt1.Text, nValue);
    for j := 0 to AElecLine.Current.WValueList.count - 1 do
    begin
      AWValue := TWeightValue(AElecLine.Current.WValueList.Objects[j]);

      if AWValue.WID = nValue then
      begin
        mmo1.Lines.Add(AElecLine.LineName +'[' + IntToStr(AWValue.WID) + ',' +
          IntToStr(AWValue.WValue) +']');
      end;

    end;
  end;
var
  i : Integer;
begin
  mmo1.Lines.Add('Ȩֵ�б�');
//  SetValue(APower.VolA);
//  SetValue(APower.VolB);
//  SetValue(APower.VolC);
//  SetValue(APower.VolN);

  SetValue(APower.CurrAIn);
  SetValue(APower.CurrAOut);
  SetValue(APower.CurrBIn);
  SetValue(APower.CurrBOut);
  SetValue(APower.CurrCIn);
  SetValue(APower.CurrCOut);


  for i := 0 to AMeter.OrganList.Count - 1 do
  begin
//    SetValue(AMeter.OrganInfo[i].VolPointIn);
//    SetValue(AMeter.OrganInfo[i].VolPointOut);

    SetValue(AMeter.OrganInfo[i].CurrentPointIn);
    SetValue(AMeter.OrganInfo[i].CurrentPointOut);
  end;






end;

procedure TForm2.btn2Click(Sender: TObject);
  procedure SetValue(AElecLine: TElecLine);
  var
    j : Integer;
  begin
    mmo1.Lines.Add(AElecLine.LineName + ' �����б�');

    for j := 0 to AElecLine.ConnPoints.Count - 1 do
    begin
      mmo1.Lines.Add(TElecLine(AElecLine.ConnPoints.Objects[j]).LineName);
    end;
  end;
var
  i : Integer;
begin
  SetValue(APower.VolA);
  SetValue(APower.VolB);
  SetValue(APower.VolC);
  SetValue(APower.VolN);

  SetValue(APower.CurrAIn);
  SetValue(APower.CurrAOut);
  SetValue(APower.CurrBIn);
  SetValue(APower.CurrBOut);
  SetValue(APower.CurrCIn);
  SetValue(APower.CurrCOut);


  for i := 0 to AMeter.OrganList.Count - 1 do
  begin
    SetValue(AMeter.OrganInfo[i].VolPointIn);
    SetValue(AMeter.OrganInfo[i].VolPointOut);

    SetValue(AMeter.OrganInfo[i].CurrentPointIn);
    SetValue(AMeter.OrganInfo[i].CurrentPointOut);
  end;
end;

procedure TForm2.btn3Click(Sender: TObject);
  procedure SetValue(AElecLine: TElecLine);
  var
    j : Integer;
//    nValue : Integer;
  begin
//    TryStrToInt(edt1.Text, nValue);
    mmo1.Lines.Add(AElecLine.LineName + ' �����б�');

    for j := 0 to AElecLine.CurrentList.Count - 1 do
    begin
      with TElecLine(AElecLine.CurrentList.Objects[j]) do
      begin
        mmo1.Lines.Add('['+LineName+','+inttostr(AElecLine.Current.WeightValue[WID].WValue)+']');
      end;

    end;
  end;
var
  i : Integer;
begin
  SetValue(APower.CurrAIn);
  SetValue(APower.CurrAOut);
  SetValue(APower.CurrBIn);
  SetValue(APower.CurrBOut);
  SetValue(APower.CurrCIn);
  SetValue(APower.CurrCOut);

  for i := 0 to AMeter.OrganList.Count - 1 do
  begin
    SetValue(AMeter.OrganInfo[i].CurrentPointIn);
    SetValue(AMeter.OrganInfo[i].CurrentPointOut);
  end;
end;

procedure TForm2.btn4Click(Sender: TObject);
  procedure SetValue(AElecLine: TElecLine);
  begin
    mmo1.Lines.Add(AElecLine.LineName + '��ѹ��' + FormatFloat('0.0', AElecLine.Voltage.Value) +
      '�Ƕȣ�' + FormatFloat('0.0', AElecLine.Voltage.Angle));
  end;
var
  i : Integer;
  APoint : TElecPoint;
begin
  mmo1.Lines.Add(' ��ѹֵ�б�===========');
//  SetValue(APower.VolA);
//  SetValue(APower.VolB);
//  SetValue(APower.VolC);
//  SetValue(APower.VolN);
//
//  for i := 0 to AMeter.OrganList.Count - 1 do
//  begin
//    SetValue(AMeter.OrganInfo[i].VolPointIn);
//    SetValue(AMeter.OrganInfo[i].VolPointOut);
//  end;

  for i := 0 to AMeter.OrganList.Count - 1 do
  begin
    APoint := AMeter.OrganInfo[i].VolOrgan;

    mmo1.Lines.Add(AMeter.OrganInfo[i].OrganName +
      '��ѹ��' + FormatFloat('0.0', APoint.Value) +
      '�Ƕȣ�' + FormatFloat('0.0', APoint.Angle));
  end;

end;

procedure TForm2.btn5Click(Sender: TObject);
var
  i : Integer;
  APoint : TElecPoint;
begin
  mmo1.Lines.Add(' ����ֵ�б�=====================');
  for i := 0 to AMeter.OrganList.Count - 1 do
  begin
    APoint := AMeter.OrganInfo[i].GetOrganCurrent;

    mmo1.Lines.Add(AMeter.OrganInfo[i].OrganName +
      '������' + FormatFloat('0.0', APoint.Value) +
      '�Ƕȣ�' + FormatFloat('0.0', APoint.Angle));
  end;
end;

procedure TForm2.btn6Click(Sender: TObject);
begin
  mmo1.Lines.Clear;
end;

procedure TForm2.btn7Click(Sender: TObject);
var
  i : Integer;
begin
  mmo1.Lines.Add(' ����ֵ�б�=====================');

  mmo1.Lines.Add('�й�����:' + FormatFloat('0.00', AMeter.ActivePower));
  mmo1.Lines.Add('�޹�����:' + FormatFloat('0.00', AMeter.ReactivePower));
  mmo1.Lines.Add('��������:' + FormatFloat('0.00', AMeter.PowerFactor));
  mmo1.Lines.Add('�����й�����:' + FormatFloat('0.00', AMeter.PositiveActivePower));
  mmo1.Lines.Add('�����й�����:' + FormatFloat('0.00', AMeter.ReverseActivePower));
  mmo1.Lines.Add('�����޹�����:' + FormatFloat('0.00', AMeter.PositiveReactivePower));
  mmo1.Lines.Add('�����޹�����:' + FormatFloat('0.00', AMeter.ReverseReactivePower));

  for i := 1 to 4 do
    mmo1.Lines.Add('��'+inttostr(i)+'�����޹�����:' + FormatFloat('0.00', AMeter.GetQuadrantReactivePower(i)));
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  AMeter := TElecMeter.Create;
  APower := TElecPower.Create;

  INIMeter4;
//  INIMeter3;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  APower.Free;
  AMeter.Free;


end;

procedure TForm2.INIMeter3;
begin
  APower.INIPower3;
  AMeter.ElecPhase := epThereReactive;

  APower.VolA.ConnPointAdd(AMeter.TerminalInfoByName['Ua']);
  APower.VolB.ConnPointAdd(AMeter.TerminalInfoByName['Ub']);
  APower.VolC.ConnPointAdd(AMeter.TerminalInfoByName['Uc']);


  //����
  APower.CurrAIn.ConnPointAdd(AMeter.TerminalInfoByName['Ia+']);
  APower.CurrAOut.ConnPointAdd(AMeter.TerminalInfoByName['Ia-']);
  APower.CurrCIn.ConnPointAdd(AMeter.TerminalInfoByName['Ic+']);
  APower.CurrCOut.ConnPointAdd(AMeter.TerminalInfoByName['Ic-']);


  // ����BA
//  APower.CurrAIn.ConnPointAdd(AMeter.OrganInfo[1].CurrentPointIn);
//  APower.CurrAOut.ConnPointAdd(APower.CurrCOut);
//  APower.CurrAOut.ConnPointAdd(AMeter.OrganInfo[0].CurrentPointIn);
//
//  APower.CurrCIn.ConnPointAdd(AMeter.OrganInfo[0].CurrentPointOut);
//  APower.CurrCIn.ConnPointAdd(AMeter.OrganInfo[1].CurrentPointOut);
//  APower.CurrCOut.ConnPointAdd(AMeter.OrganInfo[0].CurrentPointIn);

  // ��ѹ����
  // ������е�ѹֵ
  AMeter.ClearVolVlaue;
  // �ݹ����е�ѹԴ�ڵ�
  APower.VolA.SendVolValue;
  APower.VolB.SendVolValue;
  APower.VolC.SendVolValue;
  APower.VolN.SendVolValue;

  // ����ֵ���ݣ����е��������������Ͷˣ�
  // ���Ȩֵ
  AMeter.ClearWValue;

  // �ݹ����е����Ͷ˽ڵ�
  // ��ֵȨֵ
  APower.CurrAOut.CalcCurrWValue;
  APower.CurrBOut.CalcCurrWValue;
  APower.CurrCOut.CalcCurrWValue;

  // ���ԭ�������б�
  AMeter.ClearCurrentList;

  // ��ʼ������ԭ�������б�
  APower.CurrAIn.SendCurrentValue;
  APower.CurrBIn.SendCurrentValue;
  APower.CurrCIn.SendCurrentValue;
end;

procedure TForm2.INIMeter4;
begin
  APower.INIPower4;
  AMeter.ElecPhase := epFour;

  APower.VolA.ConnPointAdd(AMeter.TerminalInfoByName['Ua']);
  APower.VolB.ConnPointAdd(AMeter.TerminalInfoByName['Ub']);
  APower.VolC.ConnPointAdd(AMeter.TerminalInfoByName['Uc']);
  APower.VolN.ConnPointAdd(AMeter.TerminalInfoByName['Un']);

  APower.CurrAIn.ConnPointAdd(AMeter.TerminalInfoByName['Ia+']);
  APower.CurrAOut.ConnPointAdd(AMeter.TerminalInfoByName['Ia-']);
  APower.CurrBIn.ConnPointAdd(AMeter.TerminalInfoByName['Ib+']);
  APower.CurrBOut.ConnPointAdd(AMeter.TerminalInfoByName['Ib-']);
  APower.CurrCIn.ConnPointAdd(AMeter.TerminalInfoByName['Ic+']);
  APower.CurrCOut.ConnPointAdd(AMeter.TerminalInfoByName['Ic-']);




//  APower.VolA.ConnPointAdd(AMeter.OrganInfo[0].VolPointIn);
//  APower.VolN.ConnPointAdd(AMeter.OrganInfo[0].VolPointOut);
//  APower.VolB.ConnPointAdd(AMeter.OrganInfo[1].VolPointIn);
//  APower.VolN.ConnPointAdd(AMeter.OrganInfo[1].VolPointOut);
//  APower.VolC.ConnPointAdd(AMeter.OrganInfo[2].VolPointIn);
//  APower.VolN.ConnPointAdd(AMeter.OrganInfo[2].VolPointOut);
//
//  // ����ABN CT1��
//  APower.CurrAOut.ConnPointAdd(AMeter.OrganInfo[0].CurrentPointIn);
//  AMeter.OrganInfo[0].CurrentPointOut.ConnPointAdd(AMeter.OrganInfo[2].CurrentPointOut);
//  AMeter.OrganInfo[0].CurrentPointOut.ConnPointAdd(APower.CurrCIn);
//  APower.CurrAIn.ConnPointAdd(APower.CurrCOut);
//
//  APower.CurrBIn.ConnPointAdd(AMeter.OrganInfo[1].CurrentPointIn);
//  AMeter.OrganInfo[1].CurrentPointOut.ConnPointAdd(APower.CurrCIn);
//  AMeter.OrganInfo[1].CurrentPointOut.ConnPointAdd(AMeter.OrganInfo[2].CurrentPointOut);
//  APower.CurrBOut.ConnPointAdd(APower.CurrCOut);
//
//  APower.CurrCIn.ConnPointAdd(AMeter.OrganInfo[2].CurrentPointOut);
//  APower.CurrCOut.ConnPointAdd(AMeter.OrganInfo[2].CurrentPointIn);

  // ��ѹ����
  // ������е�ѹֵ
  AMeter.ClearVolVlaue;
  // �ݹ����е�ѹԴ�ڵ�
  APower.VolA.SendVolValue;
  APower.VolB.SendVolValue;
  APower.VolC.SendVolValue;
  APower.VolN.SendVolValue;

  // ����ֵ���ݣ����е��������������Ͷˣ�
  // ���Ȩֵ
  AMeter.ClearWValue;

  // �ݹ����е����Ͷ˽ڵ�
  // ��ֵȨֵ
  APower.CurrAOut.CalcCurrWValue;
  APower.CurrBOut.CalcCurrWValue;
  APower.CurrCOut.CalcCurrWValue;

  // ���ԭ�������б�
  AMeter.ClearCurrentList;

  // ��ʼ������ԭ�������б�
  APower.CurrAIn.SendCurrentValue;
  APower.CurrBIn.SendCurrentValue;
  APower.CurrCIn.SendCurrentValue;
end;

end.
