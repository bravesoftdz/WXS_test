unit xExerciseAction;

interface

uses xDBActionBase, xExerciseInfo, System.Classes, System.SysUtils, FireDAC.Stan.Param,
  xFunction;

type
  /// <summary>
  /// ��ϰ�����ݿ����
  /// </summary>
  TExerciseAction = class(TDBActionBase)

  public
    /// <summary>
    /// ��ȡ�����
    /// </summary>
    function GetMaxSN : Integer;

    /// <summary>
    /// ���
    /// </summary>
    procedure AddExercise(AExercise : TExerciseInfo);

    /// <summary>
    /// ɾ��
    /// </summary>
    procedure DelExercise(nExerciseID: Integer); overload;
    /// <summary>
    /// ɾ��
    /// </summary>
    /// <param name="bIsDelPath">�����Ŀ¼���Ƿ�ɾ��Ŀ¼</param>
    procedure DelExercise(AExercise : TExerciseInfo; bIsDelPath: Boolean); overload;

    /// <summary>
    /// �޸�
    /// </summary>
    procedure EditExercise(AExercise : TExerciseInfo);

    /// <summary>
    /// ���
    /// </summary>
    procedure ClearExercise;

    /// <summary>
    /// ����ָ��Ŀ¼
    /// </summary>
    procedure LoadExercise(sPath : string; slList :TStringList);

    /// <summary>
    /// ��������
    /// </summary>
    procedure LoadExerciseAll(slList :TStringList);


  end;

implementation

{ TExerciseAction }

procedure TExerciseAction.AddExercise(AExercise: TExerciseInfo);
const
  C_SQL ='insert into Exercise ( ID, Path, PType, EName, ImageIndex,' + #13#10 +
         'Code1, Code2, Remark ) values (  %d, :Path, :PType, :EName,' + #13#10 +
         '%d, :Code1, :Code2, :Remark )';
begin
  if Assigned(AExercise) then
  begin
    with AExercise, FQuery.Params do
    begin
      FQuery.Sql.Text := Format( C_SQL, [ Id, Imageindex ] );

      ParamByName( 'Path'       ).Value := Path      ;
      ParamByName( 'PType'      ).Value := Ptype     ;
      ParamByName( 'EName'      ).Value := Ename     ;
      ParamByName( 'Code1'      ).Value := Code1     ;
      ParamByName( 'Code2'      ).Value := Code2     ;
      ParamByName( 'Remark'     ).Value := Remark    ;
    end;

    ExecSQL;
  end;
end;

procedure TExerciseAction.ClearExercise;
begin
  FQuery.Sql.Text := 'delete from Exercise';
  ExecSQL;
end;

procedure TExerciseAction.DelExercise(AExercise: TExerciseInfo; bIsDelPath: Boolean);
const
  C_SQL = 'delete from Exercise where Path LIKE ' ;
begin

  if Assigned(AExercise) then
  begin
    // Ŀ¼
    if AExercise.Ptype = 0 then
    begin
      FQuery.Sql.Text := C_SQL + AExercise.Path + '''\'+ AExercise.Ename + '%''';
      ExecSQL;
      if bIsDelPath then
      begin
        DelExercise(AExercise.Id);
      end;
    end
    else
    // �ļ�
    begin
      DelExercise(AExercise.Id);
    end;
  end;
end;

procedure TExerciseAction.DelExercise(nExerciseID: Integer);
const
  C_SQL = 'delete from Exercise where ID = %d ';
begin
  FQuery.Sql.Text := Format( C_SQL, [ nExerciseID ] );
  ExecSQL;
end;

procedure TExerciseAction.EditExercise(AExercise: TExerciseInfo);
const
  C_SQL = 'update Exercise set Path = :Path, PType = :PType,' + #13#10 +
         'EName = :EName, ImageIndex = %d, Code1 = :Code1,' + #13#10 +
         'Code2 = :Code2, Remark = :Remark where ID = %d';
begin
  if Assigned(AExercise) then
  begin
    with AExercise, FQuery.Params do
    begin
      FQuery.Sql.Text := Format( C_SQL, [Imageindex, Id ] );

      ParamByName( 'Path'       ).Value := Path      ;
      ParamByName( 'PType'      ).Value := Ptype     ;
      ParamByName( 'EName'      ).Value := Ename     ;
      ParamByName( 'Code1'      ).Value := Code1     ;
      ParamByName( 'Code2'      ).Value := Code2     ;
      ParamByName( 'Remark'     ).Value := Remark    ;
    end;

    ExecSQL;
  end;
end;

function TExerciseAction.GetMaxSN: Integer;
const
  C_SQL = 'select max(ID) as MaxSN from Exercise';
begin
  FQuery.Open(C_SQL);

  if FQuery.RecordCount = 1 then
    Result := FQuery.FieldByName('MaxSN').AsInteger
  else
    Result := 0;

  FQuery.Close;
end;

procedure TExerciseAction.LoadExercise(sPath : string;slList: TStringList);
const
  C_SQL = 'select * from Exercise where Path =''%s''';
var
  AExerciseInfo : TExerciseInfo;
begin
  if Assigned(slList) then
  begin
    ClearStringList(slList);

    FQuery.Open(Format(C_SQL, [ sPath ]));

    while not FQuery.Eof do
    begin
      AExerciseInfo := TExerciseInfo.Create;
      with AExerciseInfo, FQuery do
      begin
        Id         := FieldByName( 'ID'         ).AsInteger;
        Path       := FieldByName( 'Path'       ).AsString;
        Ptype      := FieldByName( 'PType'      ).AsInteger;
        Ename      := FieldByName( 'EName'      ).AsString;
        Imageindex := FieldByName( 'ImageIndex' ).AsInteger;
        Code1      := FieldByName( 'Code1'      ).AsString;
        Code2      := FieldByName( 'Code2'      ).AsString;
        Remark     := FieldByName( 'Remark'     ).AsString;
      end;
      slList.AddObject('', AExerciseInfo);
      FQuery.Next;
    end;
    FQuery.Close;
  end;
end;

procedure TExerciseAction.LoadExerciseAll(slList: TStringList);
const
  C_SQL = 'select * from Exercise';
var
  AExerciseInfo : TExerciseInfo;
begin
  if Assigned(slList) then
  begin
    ClearStringList(slList);

    FQuery.Open(C_SQL);

    while not FQuery.Eof do
    begin
      AExerciseInfo := TExerciseInfo.Create;
      with AExerciseInfo, FQuery do
      begin
        Id         := FieldByName( 'ID'         ).AsInteger;
        Path       := FieldByName( 'Path'       ).AsString;
        Ptype      := FieldByName( 'PType'      ).AsInteger;
        Ename      := FieldByName( 'EName'      ).AsString;
        Imageindex := FieldByName( 'ImageIndex' ).AsInteger;
        Code1      := FieldByName( 'Code1'      ).AsString;
        Code2      := FieldByName( 'Code2'      ).AsString;
        Remark     := FieldByName( 'Remark'     ).AsString;
      end;
      slList.AddObject('', AExerciseInfo);
      FQuery.Next;
    end;
    FQuery.Close;
  end;
end;

end.



