unit U_DIAGRAM_TYPE;

interface

uses SysUtils;

type
  /// <summary> ����ͼ���� </summary>
  TDiagramType = (
    dt3CTClear,           //��������CT��
    dt3M,                 //�������߶๦��
    dt3L4,                //��������������

    dt4M_NoPT,            //�������߶๦����PT
    dt4Direct,            //��������ֱͨ
    dt4_NoPT_L6,          //����������PT������

    dt4M_PT,              //�������߶๦����PT
    dt4_PT_CT_CLear,      //�������߾�PT��CT��
    dt4_PT_L6             //�������߾�PT��������
    
    );

function DiagramTypeToStr(ADiagramType: TDiagramType): string;
function DiagramStrToType(sDiagramStr: string): TDiagramType;


implementation

function DiagramTypeToStr(ADiagramType: TDiagramType): string;
begin
  case ADiagramType of
    dt3CTClear:      Result := '��������CT��';
    dt3M:            Result := '�������߶๦��';
    dt3L4:           Result := '��������������';

    dt4M_NoPT:       Result := '�������߶๦����PT';
    dt4M_PT:         Result := '�������߶๦����PT';
    dt4_PT_CT_CLear: Result := '�������߾�PT,CT��';
    dt4_PT_L6:       Result := '�������߾�PT������';
    dt4_NoPT_L6:     Result := '����������PT������';
    dt4Direct:       Result := '��������ֱͨ';
  else
    raise Exception.Create('Unrecognized');
  end;
end;
function DiagramStrToType(sDiagramStr: string): TDiagramType;
begin
  if sDiagramStr = '��������CT��' then
    Result := dt3CTClear
  else if sDiagramStr = '�������߶๦��' then
    Result := dt3M
  else if sDiagramStr = '��������������' then
    Result := dt3L4
  else if sDiagramStr = '�������߶๦����PT' then
    Result := dt4M_NoPT
  else if sDiagramStr = '�������߶๦����PT' then
    Result := dt4M_PT
  else if sDiagramStr = '�������߾�PT,CT��' then
    Result := dt4_PT_CT_CLear
  else if sDiagramStr = '�������߾�PT������' then
    Result := dt4_PT_L6
  else if sDiagramStr = '����������PT������' then
    Result := dt4_NoPT_L6
  else if sDiagramStr = '��������ֱͨ' then
    Result := dt4Direct
  else
    Result := dt3L4;
end;

end.
