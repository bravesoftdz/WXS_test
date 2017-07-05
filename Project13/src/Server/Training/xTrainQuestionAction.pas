unit xTrainQuestionAction;

interface

uses xDBActionBase, xTrainQuestionInfo, System.Classes, System.SysUtils, FireDAC.Stan.Param,
  xFunction;

type
  /// <summary>
  /// ��ϰ�����ݿ����
  /// </summary>
  TTrainQuestionAction = class(TDBActionBase)

  public
    /// <summary>
    /// ��ȡ�����
    /// </summary>
    function GetMaxSN : Integer;

    /// <summary>
    /// ���
    /// </summary>
    procedure AddInfo(AInfo : TTrainQuestion);

    /// <summary>
    /// ɾ��
    /// </summary>
    procedure DelInfo(nID: Integer); overload;
    /// <summary>
    /// ɾ��
    /// </summary>
    /// <param name="bIsDelPath">�����Ŀ¼���Ƿ�ɾ��Ŀ¼</param>
    procedure DelInfo(AInfo : TTrainQuestion; bIsDelPath: Boolean); overload;

    /// <summary>
    /// �޸�
    /// </summary>
    procedure EditInfo(AInfo : TTrainQuestion);

    /// <summary>
    /// ���
    /// </summary>
    procedure ClearInfo;

    /// <summary>
    /// ����
    /// </summary>
    procedure LoadInfo(slList :TStringList);


  end;

implementation

{ TTrainQuestionAction }

procedure TTrainQuestionAction.AddInfo(AInfo: TTrainQuestion);
const
  C_SQL ='insert into TrainQuestion ( TQID, TQType, TQPath, TQQName,' +
         'TQCode1, TQCode2, TQRemark ) values (  %d, %d, :TQPath,' +
         ':TQQName, :TQCode1, :TQCode2, :TQRemark )';
begin
  if Assigned(AInfo) then
  begin
    with AInfo, FQuery.Params do
    begin
      FQuery.Sql.Text := Format( C_SQL, [ Tqid, Tqtype ] );

      ParamByName( 'TQPath'   ).Value := Tqpath  ;
      ParamByName( 'TQQName'  ).Value := Tqqname ;
      ParamByName( 'TQCode1'  ).Value := Tqcode1 ;
      ParamByName( 'TQCode2'  ).Value := Tqcode2 ;
      ParamByName( 'TQRemark' ).Value := Tqremark;
    end;

    ExecSQL;
  end;
end;

procedure TTrainQuestionAction.ClearInfo;
begin
  FQuery.Sql.Text := 'delete from TrainQuestion';
  ExecSQL;
end;

procedure TTrainQuestionAction.DelInfo(AInfo: TTrainQuestion;
  bIsDelPath: Boolean);
const
  C_SQL = 'delete from TrainQuestion where TQPath LIKE ' ;
begin

  if Assigned(AInfo) then
  begin
    // Ŀ¼
    if AInfo.TQtype = 0 then
    begin
      FQuery.Sql.Text := C_SQL + AInfo.TQPath + '''\%''';
      ExecSQL;

      if bIsDelPath then
      begin
        DelInfo(AInfo.TQId);
      end;
    end
    else
    // �ļ�
    begin
      DelInfo(AInfo.TQId);
    end;
  end;
end;

procedure TTrainQuestionAction.DelInfo(nID: Integer);
const
  C_SQL = 'delete from TrainQuestion where TQID = %d ';
begin
  FQuery.Sql.Text := Format( C_SQL, [ nID ] );
  ExecSQL;
end;

procedure TTrainQuestionAction.EditInfo(AInfo: TTrainQuestion);
const
  C_SQL = 'update TrainQuestion set TQType = %d,' +
           'TQPath = :TQPath, TQQName = :TQQName, TQCode1 = :TQCode1,' +
           'TQCode2 = :TQCode2, TQRemark = :TQRemark where TQID = %d';
begin
  if Assigned(AInfo) then
  begin
    with AInfo, FQuery.Params do
    begin
      FQuery.Sql.Text := Format( C_SQL, [ Tqtype, Tqid ] );

      ParamByName( 'TQPath'   ).Value := Tqpath  ;
      ParamByName( 'TQQName'  ).Value := Tqqname ;
      ParamByName( 'TQCode1'  ).Value := Tqcode1 ;
      ParamByName( 'TQCode2'  ).Value := Tqcode2 ;
      ParamByName( 'TQRemark' ).Value := Tqremark;
    end;

    ExecSQL;
  end;
end;

function TTrainQuestionAction.GetMaxSN: Integer;
const
  C_SQL = 'select max(TQID) as MaxSN from TrainQuestion';
begin
  FQuery.Open(C_SQL);

  if FQuery.RecordCount = 1 then
    Result := FQuery.FieldByName('MaxSN').AsInteger
  else
    Result := 0;

  FQuery.Close;
end;

procedure TTrainQuestionAction.LoadInfo(slList: TStringList);
const
  C_SQL = 'select * from TrainQuestion';
var
  AInfo : TTrainQuestion;
begin
  if Assigned(slList) then
  begin
    ClearStringList(slList);

    FQuery.Open(C_SQL);

    while not FQuery.Eof do
    begin
      AInfo := TTrainQuestion.Create;
      with AInfo, FQuery do
      begin
        Tqid     := FieldByName( 'TQID'     ).AsInteger;
        Tqtype   := FieldByName( 'TQType'   ).AsInteger;
        Tqpath   := FieldByName( 'TQPath'   ).AsString;
        Tqqname  := FieldByName( 'TQQName'  ).AsString;
        Tqcode1  := FieldByName( 'TQCode1'  ).AsString;
        Tqcode2  := FieldByName( 'TQCode2'  ).AsString;
        Tqremark := FieldByName( 'TQRemark' ).AsString;
      end;
      slList.AddObject('', AInfo);
      FQuery.Next;
    end;
    FQuery.Close;
  end;
end;

end.
