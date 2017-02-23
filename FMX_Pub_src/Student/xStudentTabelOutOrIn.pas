{===============================================================================
  Copyright(c) 2014, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ѧԱ��Ϣ���뵼����Ԫ

  + TStudentTableOption  ѧԱ��Ϣ���뵼����

===============================================================================}
unit xStudentTabelOutOrIn;

interface

uses
  System.Classes, System.SysUtils,
  {$IFDEF MSWINDOWS}
  System.Win.ComObj,
  {$ENDIF}
  xVCL_FMX;

type
  /// <summary>
  /// ѧԱ��Ϣ���뵼����
  /// </summary>
  TStudentTableOption = class
  private
    {$IFDEF MSWINDOWS}
    FDlgSaveExecl : TMySaveDialog;
    FDlgOpenExecl : TMyOpenDialog;

    /// <summary>
    /// ����ѧԱʱ����Excel���ú��ʵ��п�����ʼ����ͷ
    /// </summary>
    procedure SetExcelWideIn(AExcel: Variant);
    {$ENDIF}

  public
    /// <summary>
    /// ����Excel����е�ѧԱ��Ϣ����
    /// </summary>
    /// <returns>0��ʾ�ɹ���1��ʾʧ�ܣ�2��ʾ�������� OpenDialog �ؼ��е����ȡ����û�е���Excel</returns>
    function ImportStu(slStus : TStringList) : Integer;

    /// <summary>
    /// ��ѧ����Ϣ������Excel�����
    /// </summary>
    /// <returns>0��ʾ�ɹ���1��ʾʧ�ܣ�2��ʾ�������� SaveDialog �ؼ��е����ȡ,û�е�����¼</returns>
    function ExportStu(slStus:TStringList ):Integer;
  end;
implementation

uses
  xStudentInfo;

{ TStudentTableOption }

function TStudentTableOption.ExportStu(slStus: TStringList): Integer;
{$IFDEF MSWINDOWS}
var
  sExeclFile : string;
  AObjExecl : Variant;
  i : integer;
  ASheet: Variant;
{$ENDIF}
begin
  result := 1;
  {$IFDEF MSWINDOWS}
  if  Assigned(slStus) then
  begin
    FDlgSaveExecl := TMySaveDialog.Create(nil);

    //�����ļ���ʽ
    FDlgSaveExecl.Filter := 'Excel files (*.xls)|.xls|�����ļ�(*.*)|*.*';

    //���ú�׺����
    FDlgSaveExecl.DefaultExt:='.xls';

    if FDlgSaveExecl.Execute then
    begin
      sExeclFile := FDlgSaveExecl.FileName;
      try
        // �½�Excel ��ʼ��
        AObjExecl := CreateOleObject('Excel.application');
        AObjExecl.Visible := False;

        //��ʼ����Ԫ��
        AObjExecl.WorkBooks.Add(-4167);
        AObjExecl.WorkBooks[1].Sheets[1].name :='ѧԱ��Ϣ';
        ASheet := AObjExecl.WorkBooks[1].Sheets['ѧԱ��Ϣ'];
        SetExcelWideIn(AObjExecl);

        //������Ϣ����Excel
        for i := slStus.Count - 1 downto 0  do
        begin
          with TStudentInfo(slStus.Objects[i]) do
          begin
            AObjExecl.Cells[i+2,1].Value := stuName;
            AObjExecl.Cells[i+2,2].Value := stuSex;
            AObjExecl.Cells[i+2,3].Value := stuIDcard;
            AObjExecl.Cells[i+2,4].Value := stuLogin;
            AObjExecl.Cells[i+2,5].Value := stuPwd;
            AObjExecl.Cells[i+2,6].Value := stuArea;
            AObjExecl.Cells[i+2,7].Value := stuTel;
            AObjExecl.Cells[i+2,8].Value := stuNote1;
          end;
        end;

        //�洢�½�Excel
        ASheet.SaveAs( sExeclFile );
        AObjExecl.WorkBooks.Close;
        AObjExecl.Quit;
        FDlgSaveExecl.Free;
        VarClear(AObjExecl);
        Result := 0;
      except
        AObjExecl.WorkBooks.Close;
        AObjExecl.Quit;
        AObjExecl.Free;
        VarClear(AObjExecl);
      end;
    end
    else
    begin
      FDlgSaveExecl.Free;
      Result := 2;
    end;
  end;
  {$ENDIF}
end;

function TStudentTableOption.ImportStu(slStus: TStringList): Integer;
{$IFDEF MSWINDOWS}
var
  sExeclFile : string;
  AObjExecl : Variant;
  i : Integer;
  AStuInfo : TStudentInfo;
{$ENDIF}
begin
  Result := 1;

  {$IFDEF MSWINDOWS}
  if Assigned(slStus) then
  begin
    FDlgOpenExecl := TMyOpenDialog.Create(nil);
    FDlgOpenExecl.Filter :='Excel files (*.xls)|*.xls';

    if FDlgOpenExecl.Execute then
    begin
      sExeclFile := FDlgOpenExecl.FileName;
      AObjExecl :=  CreateOleObject('Excel.application');
      AObjExecl.WorkBooks.Open( sExeclFile );
      AObjExecl.Visible := False;
      try
        if AObjExecl.WorkSheets[1].UsedRange.Columns.Count <> 8 then
        begin
          AObjExecl.WorkBooks.Close;
          AObjExecl.Quit;
          varclear(AObjExecl);
          result := 1;
          Exit;
        end;

        //��ȡExcel�еļ�¼��ѧԱ����
        for i := 2 to AObjExecl.WorkSheets[1].UsedRange.Rows.Count do
        begin
          AStuInfo := TStudentInfo.Create;
          with AStuInfo do
          begin
            stuName          := AObjExecl.Cells[i,1].Value;
            stuSex           := AObjExecl.Cells[i,2].Value;
            stuIDcard        := AObjExecl.Cells[i,3].Value;
            stuLogin         := AObjExecl.Cells[i,4].Value;
            stuPwd           := AObjExecl.Cells[i,5].Value;
            stuArea          := AObjExecl.Cells[i,6].Value;
            stuTel           := AObjExecl.Cells[i,7].Value;
            stuNote1         := AObjExecl.Cells[i,8].Value;
            stuNote2         := AObjExecl.Cells[i,9].Value;
            slStus.AddObject('' ,AStuInfo);
          end;
        end;
        AObjExecl.WorkBooks.Close;
        AObjExecl.Quit;
        VarClear(AObjExecl);
        FDlgOpenExecl.free;
        Result := 0;
      except
        AObjExecl.WorkBooks.Close;
        AObjExecl.Quit;
        VarClear(AObjExecl);
      end;
    end
    else
    begin
      FDlgOpenExecl.Free;
      Result := 2;
    end;
  end;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}
procedure TStudentTableOption.SetExcelWideIn(AExcel: Variant);
begin
  // ��ʼ����ͷ
  AExcel.Cells[1,1].Value := '����';
  AExcel.Cells[1,2].Value := '�Ա�';
  AExcel.Cells[1,3].Value := '���֤��';
  AExcel.Cells[1,4].Value := '��½��';
  AExcel.Cells[1,5].Value := '����';
  AExcel.Cells[1,6].Value := '���ڵ�';
  AExcel.Cells[1,7].Value := '��ϵ�绰';
  AExcel.Cells[1,8].Value := '��ע';

  //��ʼ���п�
  AExcel.ActiveSheet.Columns[1].ColumnWidth := 10;
  AExcel.ActiveSheet.Columns[2].ColumnWidth := 8;
  AExcel.ActiveSheet.Columns[3].ColumnWidth := 20;
  AExcel.ActiveSheet.Columns[4].ColumnWidth := 20;
  AExcel.ActiveSheet.Columns[5].ColumnWidth := 15;
  AExcel.ActiveSheet.Columns[6].ColumnWidth := 8;
  AExcel.ActiveSheet.Columns[7].ColumnWidth := 12;
  AExcel.ActiveSheet.Columns[8].ColumnWidth := 15;

  //��ָ�������ó��ı���ʽ
  AExcel.ActiveSheet.Columns[3].NumberFormatLocal := '@';
  AExcel.ActiveSheet.Columns[4].NumberFormatLocal := '@';
  AExcel.ActiveSheet.Columns[5].NumberFormatLocal := '@';
  AExcel.ActiveSheet.Columns[7].NumberFormatLocal := '@';
  AExcel.ActiveSheet.Columns[8].NumberFormatLocal := '@';
end;
{$ENDIF}

end.
