unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, xElecBox,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, xElecLine,
  xElecPoint, FMX.Edit, xElecFunction;

type
  TForm3 = class(TForm)
    pnl1: TPanel;
    mmo1: TMemo;
    spltr1: TSplitter;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    edt1: TEdit;
    btn6: TButton;
    btn7: TButton;
    btn5: TButton;
    lbl1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
  private
    { Private declarations }
    FElecBox : TElecBox;
    FElecPoint : TElecPoint;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.btn1Click(Sender: TObject);
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
begin
  SetValue(FElecBox.ElecBusLine.BusLineA);


  SetValue(FElecBox.ElecTV1.SecondVolH);
  SetValue(FElecBox.ElecTV2.SecondVolH);
  SetValue(FElecBox.ElecTV3.SecondVolH);
end;

procedure TForm3.btn2Click(Sender: TObject);
  procedure SetValue(AElecLine: TElecLine);
  begin
    mmo1.Lines.Add(AElecLine.LineName + '��ѹ��' + FormatFloat('0.0', AElecLine.Voltage.Value) +
      '�Ƕȣ�' + FormatFloat('0.0', AElecLine.Voltage.Angle));
  end;
var
  i : Integer;
  APoint : TElecPoint;
begin
  mmo1.Lines.Add(' ���� ��ѹֵ�б�===========');

  SetValue(FElecBox.ElecBusLine.BusLineA);
  SetValue(FElecBox.ElecBusLine.BusLineB);
  SetValue(FElecBox.ElecBusLine.BusLineC);
  SetValue(FElecBox.ElecBusLine.BusLineN);

  mmo1.Lines.Add(' TV һ�θ߶�===========');

  SetValue(FElecBox.ElecTV1.FirstVolH);
  SetValue(FElecBox.ElecTV2.FirstVolH);
  SetValue(FElecBox.ElecTV3.FirstVolH);

  mmo1.Lines.Add(' TV һ�εͶ�===========');
  SetValue(FElecBox.ElecTV1.FirstVolL);
  SetValue(FElecBox.ElecTV2.FirstVolL);
  SetValue(FElecBox.ElecTV3.FirstVolL);

  mmo1.Lines.Add(' TV ���θ߶�===========');

  SetValue(FElecBox.ElecTV1.SecondVolH);
  SetValue(FElecBox.ElecTV2.SecondVolH);
  SetValue(FElecBox.ElecTV3.SecondVolH);

  mmo1.Lines.Add(' TV ���εͶ�===========');
  SetValue(FElecBox.ElecTV1.SecondVolL);
  SetValue(FElecBox.ElecTV2.SecondVolL);
  SetValue(FElecBox.ElecTV3.SecondVolL);

  mmo1.Lines.Add(' ���ߺн��ߵ�ѹ===========');
  SetValue(FElecBox.ElecLineBox.BoxUA.InLineVol);
  SetValue(FElecBox.ElecLineBox.BoxUB.InLineVol);
  SetValue(FElecBox.ElecLineBox.BoxUC.InLineVol);
  SetValue(FElecBox.ElecLineBox.BoxUN.InLineVol);

  mmo1.Lines.Add(' ���ߺг��ߵ�ѹ===========');
  SetValue(FElecBox.ElecLineBox.BoxUA.OutLineVol);
  SetValue(FElecBox.ElecLineBox.BoxUB.OutLineVol);
  SetValue(FElecBox.ElecLineBox.BoxUC.OutLineVol);
  SetValue(FElecBox.ElecLineBox.BoxUN.OutLineVol);

  mmo1.Lines.Add(' ��� ��ѹֵ�б�===========');
  for i := 0 to FElecBox.ElecMeter.OrganList.Count - 1 do
  begin
    APoint := FElecBox.ElecMeter.OrganInfo[i].VolOrgan;

    mmo1.Lines.Add(FElecBox.ElecMeter.OrganInfo[i].OrganName +
      '��ѹ��' + FormatFloat('0.0', APoint.Value) +
      '�Ƕȣ�' + FormatFloat('0.0', APoint.Angle));
  end;
end;

procedure TForm3.btn3Click(Sender: TObject);
  procedure SetValue(AElecH, AElecL: TElecLine);
  begin
    GetTwoPointCurrent(AElecH, AElecL, FElecPoint);
    mmo1.Lines.Add(AElecH.LineName + '-' + AElecL.LineName +
      '������' + FormatFloat('0.0', FElecPoint.Value) +
      '�Ƕȣ�' + FormatFloat('0.0', FElecPoint.Angle));
  end;
var
  i : Integer;
begin
  mmo1.Lines.Add('һ�ε���ֵ=============');
  SetValue(FElecBox.ElecBusLine.BusLineA, FElecBox.ElecTA1.FirstCurrentH);
  SetValue(FElecBox.ElecBusLine.BusLineB, FElecBox.ElecTA2.FirstCurrentH);
  SetValue(FElecBox.ElecBusLine.BusLineC, FElecBox.ElecTA3.FirstCurrentH);

  SetValue(FElecBox.ElecTA1.FirstCurrentH,FElecBox.ElecTA1.FirstCurrentL);
  SetValue(FElecBox.ElecTA2.FirstCurrentH,FElecBox.ElecTA2.FirstCurrentL);
  SetValue(FElecBox.ElecTA3.FirstCurrentH,FElecBox.ElecTA3.FirstCurrentL);

  SetValue(FElecBox.ElecTA1.FirstCurrentL, FElecBox.ElecBusLine.BusLineN);
  SetValue(FElecBox.ElecTA2.FirstCurrentL, FElecBox.ElecBusLine.BusLineN);
  SetValue(FElecBox.ElecTA3.FirstCurrentL, FElecBox.ElecBusLine.BusLineN);

  mmo1.Lines.Add('���ε���ֵ=============');

  SetValue(FElecBox.ElecTA1.SecondCurrentH, FElecBox.ElecLineBox.BoxIA.InLineCurrent1);
  SetValue(FElecBox.ElecTA2.SecondCurrentH, FElecBox.ElecLineBox.BoxIB.InLineCurrent1);
  SetValue(FElecBox.ElecTA3.SecondCurrentH, FElecBox.ElecLineBox.BoxIC.InLineCurrent1);

  SetValue(FElecBox.ElecLineBox.BoxIA.InLineCurrent1, FElecBox.ElecLineBox.BoxIA.OutLineCurrent1);
  SetValue(FElecBox.ElecLineBox.BoxIB.InLineCurrent1, FElecBox.ElecLineBox.BoxIB.OutLineCurrent1);
  SetValue(FElecBox.ElecLineBox.BoxIC.InLineCurrent1, FElecBox.ElecLineBox.BoxIC.OutLineCurrent1);

  SetValue(FElecBox.ElecLineBox.BoxIA.OutLineCurrent1, FElecBox.ElecMeter.TerminalInfoByName['Ia+']);
  SetValue(FElecBox.ElecLineBox.BoxIB.OutLineCurrent1, FElecBox.ElecMeter.TerminalInfoByName['Ib+']);
  SetValue(FElecBox.ElecLineBox.BoxIC.OutLineCurrent1, FElecBox.ElecMeter.TerminalInfoByName['Ic+']);

  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ia+'], FElecBox.ElecMeter.TerminalInfoByName['Ia-']);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ib+'], FElecBox.ElecMeter.TerminalInfoByName['Ib-']);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ic+'], FElecBox.ElecMeter.TerminalInfoByName['Ic-']);

  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ia-'], FElecBox.ElecLineBox.BoxIA.OutLineCurrent3);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ib-'], FElecBox.ElecLineBox.BoxIB.OutLineCurrent3);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ic-'], FElecBox.ElecLineBox.BoxIC.OutLineCurrent3);

  SetValue(FElecBox.ElecLineBox.BoxIA.OutLineCurrent3, FElecBox.ElecLineBox.BoxIA.InLineCurrent2);
  SetValue(FElecBox.ElecLineBox.BoxIB.OutLineCurrent3, FElecBox.ElecLineBox.BoxIB.InLineCurrent2);
  SetValue(FElecBox.ElecLineBox.BoxIC.OutLineCurrent3, FElecBox.ElecLineBox.BoxIC.InLineCurrent2);

  SetValue(FElecBox.ElecLineBox.BoxIA.InLineCurrent2, FElecBox.ElecTA1.SecondCurrentL);
  SetValue(FElecBox.ElecLineBox.BoxIB.InLineCurrent2, FElecBox.ElecTA2.SecondCurrentL);
  SetValue(FElecBox.ElecLineBox.BoxIC.InLineCurrent2, FElecBox.ElecTA3.SecondCurrentL);

  for i := 0 to FElecBox.ElecMeter.OrganList.Count - 1 do
  begin
    SetValue(FElecBox.ElecMeter.OrganInfo[i].CurrentPointIn,FElecBox.ElecMeter.OrganInfo[i].CurrentPointOut);
  end;







//
//  mmo1.Lines.Add(' TA һ�θ߶˵���ֵ===========');
//
//  SetValue(FElecBox.ElecTA1.FirstCurrentH);
//  SetValue(FElecBox.ElecTA2.FirstCurrentH);
//  SetValue(FElecBox.ElecTA3.FirstCurrentH);
//
//  mmo1.Lines.Add(' TA һ�εͶ˵���ֵ===========');
//  SetValue(FElecBox.ElecTA1.FirstCurrentL);
//  SetValue(FElecBox.ElecTA2.FirstCurrentL);
//  SetValue(FElecBox.ElecTA3.FirstCurrentL);
//
//  mmo1.Lines.Add(' TA ���θ߶˵���ֵ===========');
//
//  SetValue(FElecBox.ElecTA1.SecondCurrentH);
//  SetValue(FElecBox.ElecTA2.SecondCurrentH);
//  SetValue(FElecBox.ElecTA3.SecondCurrentH);
//
//  mmo1.Lines.Add(' TA ���εͶ˵���ֵ===========');
//  SetValue(FElecBox.ElecTA1.SecondCurrentL);
//  SetValue(FElecBox.ElecTA2.SecondCurrentL);
//  SetValue(FElecBox.ElecTA3.SecondCurrentL);

//  mmo1.Lines.Add(' ���ߺн��ߵ�ѹȨֵ�б�===========');
//  SetValue(FElecBox.ElecLineBox.BoxUA.InLineVol);
//  SetValue(FElecBox.ElecLineBox.BoxUB.InLineVol);
//  SetValue(FElecBox.ElecLineBox.BoxUC.InLineVol);
//  SetValue(FElecBox.ElecLineBox.BoxUN.InLineVol);
//
//  mmo1.Lines.Add(' ���ߺг��ߵ�ѹȨֵ�б�===========');
//  SetValue(FElecBox.ElecLineBox.BoxUA.OutLineVol);
//  SetValue(FElecBox.ElecLineBox.BoxUB.OutLineVol);
//  SetValue(FElecBox.ElecLineBox.BoxUC.OutLineVol);
//  SetValue(FElecBox.ElecLineBox.BoxUN.OutLineVol);










//  for i := 0 to FElecBox.ElecMeter.OrganList.Count - 1 do
//  begin
////    SetValue(AMeter.OrganInfo[i].VolPointIn);
////    SetValue(AMeter.OrganInfo[i].VolPointOut);
//
//    SetValue(FElecBox.ElecMeter.OrganInfo[i].CurrentPointIn);
//    SetValue(FElecBox.ElecMeter.OrganInfo[i].CurrentPointOut);
//  end;


//var
//  i : Integer;
//  APoint : TElecPoint;
//begin
//  mmo1.Lines.Add(' ����ֵ�б�=====================');
//  for i := 0 to FElecBox.ElecMeter.OrganList.Count - 1 do
//  begin
//    APoint := FElecBox.ElecMeter.OrganInfo[i].GetOrganCurrent;
//
//    mmo1.Lines.Add(FElecBox.ElecMeter.OrganInfo[i].OrganName +
//      '������' + FormatFloat('0.0', APoint.Value) +
//      '�Ƕȣ�' + FormatFloat('0.0', APoint.Angle));
//  end;
end;

procedure TForm3.btn4Click(Sender: TObject);
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
  mmo1.Lines.Add('����Ȩֵ�б�');
  SetValue(FElecBox.ElecBusLine.BusLineA);
  SetValue(FElecBox.ElecBusLine.BusLineB);
  SetValue(FElecBox.ElecBusLine.BusLineC);
  SetValue(FElecBox.ElecBusLine.BusLineN);

  mmo1.Lines.Add(' TA һ�θ߶�Ȩֵ�б�===========');

  SetValue(FElecBox.ElecTA1.FirstCurrentH);
  SetValue(FElecBox.ElecTA2.FirstCurrentH);
  SetValue(FElecBox.ElecTA3.FirstCurrentH);

  mmo1.Lines.Add(' TA һ�εͶ�Ȩֵ�б�===========');
  SetValue(FElecBox.ElecTA1.FirstCurrentL);
  SetValue(FElecBox.ElecTA2.FirstCurrentL);
  SetValue(FElecBox.ElecTA3.FirstCurrentL);



  mmo1.Lines.Add(' TA ���εͶ�Ȩֵ�б�===========');
  SetValue(FElecBox.ElecTA1.SecondCurrentL);
  SetValue(FElecBox.ElecTA2.SecondCurrentL);
  SetValue(FElecBox.ElecTA3.SecondCurrentL);

  mmo1.Lines.Add(' ���ߺн���2===========');
  SetValue(FElecBox.ElecLineBox.BoxIA.InLineCurrent2);
  SetValue(FElecBox.ElecLineBox.BoxIB.InLineCurrent2);
  SetValue(FElecBox.ElecLineBox.BoxIC.InLineCurrent2);


  mmo1.Lines.Add(' ���ߺг���3===========');
  SetValue(FElecBox.ElecLineBox.BoxIA.OutLineCurrent3);
  SetValue(FElecBox.ElecLineBox.BoxIB.OutLineCurrent3);
  SetValue(FElecBox.ElecLineBox.BoxIC.OutLineCurrent3);

  mmo1.Lines.Add(' �����ӵͶ�===========');
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ia-']);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ib-']);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ic-']);


  mmo1.Lines.Add(' ���ԭ��===========');
  for i := 0 to FElecBox.ElecMeter.OrganList.Count - 1 do
  begin
    SetValue(FElecBox.ElecMeter.OrganInfo[i].CurrentPointOut);
    SetValue(FElecBox.ElecMeter.OrganInfo[i].CurrentPointIn);

  end;

  mmo1.Lines.Add(' �����Ӹ�===========');
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ia+']);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ib+']);
  SetValue(FElecBox.ElecMeter.TerminalInfoByName['Ic+']);

  mmo1.Lines.Add(' ���ߺг���1===========');
  SetValue(FElecBox.ElecLineBox.BoxIA.OutLineCurrent1);
  SetValue(FElecBox.ElecLineBox.BoxIB.OutLineCurrent1);
  SetValue(FElecBox.ElecLineBox.BoxIC.OutLineCurrent1);

  mmo1.Lines.Add(' ���ߺн���1===========');
  SetValue(FElecBox.ElecLineBox.BoxIA.InLineCurrent1);
  SetValue(FElecBox.ElecLineBox.BoxIB.InLineCurrent1);
  SetValue(FElecBox.ElecLineBox.BoxIC.InLineCurrent1);

  mmo1.Lines.Add(' TA ���θ߶�Ȩֵ�б�===========');
  SetValue(FElecBox.ElecTA1.SecondCurrentH);
  SetValue(FElecBox.ElecTA2.SecondCurrentH);
  SetValue(FElecBox.ElecTA3.SecondCurrentH);

end;

procedure TForm3.btn5Click(Sender: TObject);
begin
  mmo1.Lines.Clear;
end;

procedure TForm3.btn6Click(Sender: TObject);
begin
  FElecBox.RefurshValue;
end;

procedure TForm3.btn7Click(Sender: TObject);
var
  i : Integer;
begin
  mmo1.Lines.Add(' ����ֵ�б�=====================');

  mmo1.Lines.Add('�й�����:' + FormatFloat('0.00', FElecBox.ElecMeter.ActivePower));
  mmo1.Lines.Add('�޹�����:' + FormatFloat('0.00', FElecBox.ElecMeter.ReactivePower));
  mmo1.Lines.Add('��������:' + FormatFloat('0.00', FElecBox.ElecMeter.PowerFactor));
  mmo1.Lines.Add('�����й�����:' + FormatFloat('0.00', FElecBox.ElecMeter.PositiveActivePower));
  mmo1.Lines.Add('�����й�����:' + FormatFloat('0.00', FElecBox.ElecMeter.ReverseActivePower));
  mmo1.Lines.Add('�����޹�����:' + FormatFloat('0.00', FElecBox.ElecMeter.PositiveReactivePower));
  mmo1.Lines.Add('�����޹�����:' + FormatFloat('0.00', FElecBox.ElecMeter.ReverseReactivePower));

  for i := 1 to 4 do
    mmo1.Lines.Add('��'+inttostr(i)+'�����޹�����:' + FormatFloat('0.00', FElecBox.ElecMeter.GetQuadrantReactivePower(i)));
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  FElecPoint := TElecPoint.Create;
  FElecBox := TElecBox.Create;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  FElecBox.Free;
  FElecPoint.Free;
end;

end.
