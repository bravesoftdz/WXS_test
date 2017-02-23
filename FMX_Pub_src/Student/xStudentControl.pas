{===============================================================================
  Copyright(c) 2014, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ѧԱ��Ϣ��Ԫ

  + TStudentControl  ѧԱ����Ϣ������

===============================================================================}
unit xStudentControl;

interface

uses
  System.Classes, System.SysUtils, xStudentInfo, xStudentAction;

type
  /// <summary>
  /// ѧԱ����Ϣ������
  /// </summary>
  TStudentControl = class
  private
    FStuList : TStringList;
    FStuAction : TStudentAction;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ѧԱ�б�
    /// </summary>
    property StuList : TStringList read FStuList write FStuList;

    /// <summary>
    /// ���ѧԱ
    /// </summary>
    procedure AddStu(AStuInfo : TStudentInfo);

    /// <summary>
    /// �޸�ѧԱ
    /// </summary>
    procedure EditStu(AStuInfo : TStudentInfo);

    /// <summary>
    /// ɾ��ѧԱ
    /// </summary>
    function DelStu(AStuInfo : TStudentInfo) : Boolean; overload;
    function DelStu(nStuNum : Integer) : Boolean; overload;

    /// <summary>
    /// ��ѯ������ģ�����ң�
    /// </summary>
    /// <param name="sKey">�����ѯ�Ĺؼ��֣���¼��/����/���֤��</param>
    procedure SearchStus(sKey: string; slStus: TStringList);

    /// <summary>
    /// ���ݱ�Ų�ѯѧԱ��Ϣ
    /// </summary>
    function SearchStu(sStuNum : Integer) : TStudentInfo;

    /// <summary>
    /// ���ѧԱ��
    /// </summary>
    procedure ClearStus;

    /// <summary>
    /// �Ƿ���ڵ�¼�Ŀ��� ����¼ʱ�ã�ֻ����¼�����û��������߿��ţ�
    /// </summary>
    function StuExist(AStuInfo : TStudentInfo) : Boolean;

    /// <summary>
    /// �����Ƿ����
    /// </summary>
    /// <param name="nNum">ѧԱ���</param>
    procedure IsExisStu(nStuNum : Integer; slstu: TStringList); overload;
    /// <param name="sStuName">ѧԱ����</param>
    procedure IsExisStu(sStuName : string; slstu: TStringList); overload;
    /// <param name="sStuLoginName">ѧԱ��¼��</param>
    ///  <param name="sStuPwd">ѧԱ��¼������</param>
    procedure IsExisStu(sStuLoginName, sStuPwd : string; slstu: TStringList); overload;
  end;

var
  StudentControl : TStudentControl;

implementation

uses
  xFunction;

{ TStudentControl }

procedure TStudentControl.AddStu(AStuInfo: TStudentInfo);
begin
  if Assigned(AStuInfo) then
  begin
    if Assigned(FStuAction) then
    begin
      AStuInfo.stuNumber := FStuAction.GetStuMaxNumber;
      FStuAction.SaveStuData(AStuInfo);
      FStuList.AddObject(IntToStr(AStuInfo.stuNumber), AStuInfo);
    end;
  end;
end;

constructor TStudentControl.Create;
begin
  FStuList := TStringList.Create;
  FStuAction := TStudentAction.Create;
  FStuAction.SelStusAll(FStuList);
end;

function TStudentControl.DelStu(AStuInfo: TStudentInfo) : Boolean;
begin
  result := False;
  if Assigned(AStuInfo) then
    result := DelStu(AStuInfo.stuNumber);
end;

function TStudentControl.DelStu(nStuNum: Integer) : Boolean;
var
  nIndex : Integer;
begin
  Result := False;
  // �ͷ�ѧԱ����
  nIndex := FStuList.IndexOf(IntToStr(nStuNum));
  if nIndex <> -1 then
  begin
     // ɾ�����ݿ��м�¼
    FStuAction.DelStu(nStuNum);
    {$IFDEF MSWINDOWS}
    FStuList.Objects[nIndex].Free;
    {$ENDIF}

   // ɾ��list
    FStuList.Delete(nIndex);

    Result := True;
  end;
end;

procedure TStudentControl.ClearStus;
begin
  if Assigned(FStuAction) then
  begin
    FStuAction.ClearStus;
    ClearStringList(FStuList);
  end;
end;

destructor TStudentControl.Destroy;
begin
  ClearStringList(FStuList);
  FStuList.Free;

  FStuAction.Free;
  inherited;
end;

procedure TStudentControl.EditStu(AStuInfo: TStudentInfo);
begin
  if Assigned(AStuInfo) then
  begin
    if Assigned(FStuAction) then
    begin
      FStuAction.SaveStuData(AStuInfo);
    end;
  end;
end;

procedure TStudentControl.IsExisStu(nStuNum : Integer; slstu: TStringList);
var
  i: Integer;
begin
  for i := 0 to FStuList.Count - 1 do
  begin
    if TStudentInfo(FStuList.Objects[i]).stuNumber = nStuNum then
    begin
      slstu.AddObject('',FStuList.Objects[i]);
      Break;
    end;
  end;
end;

procedure TStudentControl.IsExisStu(sStuName : string; slstu: TStringList);
var
  i: Integer;
begin
  if Assigned(slstu) then
  begin
    for i := 0 to FStuList.Count - 1 do
    begin
      if TStudentInfo(FStuList.Objects[i]).stuName = sStuName then
      begin
        slstu.AddObject('',FStuList.Objects[i]);
      end;
    end;
  end;
end;

procedure TStudentControl.IsExisStu(sStuLoginName, sStuPwd: string;
  slstu: TStringList);
var
  i: Integer;
begin
  for i := 0 to FStuList.Count - 1 do
  begin
    if (TStudentInfo(FStuList.Objects[i]).stuLogin = sStuLoginName) and
    (TStudentInfo(FStuList.Objects[i]).stuPwd = sStuPwd) then
    begin
      slstu.AddObject('',FStuList.Objects[i]);
    end
  end;
end;

function TStudentControl.SearchStu(sStuNum: Integer): TStudentInfo;
var
  nIndex : integer;
begin
  Result := nil;

  nIndex := FStuList.IndexOf(IntToStr(sStuNum));
  if nIndex <> -1 then
  begin
    Result := TStudentInfo(FStuList.Objects[nIndex]);
  end;
end;

procedure TStudentControl.SearchStus(sKey: string; slStus: TStringList);
var
  i: Integer;
begin
  if Assigned(slStus) then
  begin
    ClearStringList(slStus);
    for i := 0 to FStuList.Count - 1 do
    with TStudentInfo(FStuList.Objects[i]) do
    begin
      //���ú��� Pos ��TStringlist��ģ������
      if (Pos(sKey,stuLogin)>0) or (Pos(sKey,stuName) >0) or (Pos(sKey,stuIdCard) >0) then
        slStus.AddObject(IntToStr(stuNumber), FStuList.Objects[i]);
    end;
  end;
end;

function TStudentControl.StuExist(AStuInfo: TStudentInfo) : Boolean;
var
  i : integer;
begin
  Result := False;
  if Assigned(AStuInfo) then
  begin
    for i := 0 to FStuList.Count - 1 do
    begin
      with TStudentInfo(FStuList.Objects[i]) do
      begin
        if (stuLogin = AStuInfo.stuLogin ) or (stuName = AStuInfo.stuName) or
          (stuIdCard = AStuInfo.stuIDcard) then
        begin
          Result := True;
          AStuInfo.Assign(TStudentInfo(FStuList.Objects[i]));
          Break;
        end;
      end;
    end;
  end;
end;

end.
