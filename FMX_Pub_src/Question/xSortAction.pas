unit xSortAction;

interface

uses xDBActionBase, xSortInfo, System.Classes, System.SysUtils, FireDAC.Stan.Param,
  xFunction;

type
  TSortAction = class(TDBActionBase)

  public
    /// <summary>
    /// ��ȡ�����
    /// </summary>
    function GetMaxSN : Integer;

    /// <summary>
    /// ������
    /// </summary>
    procedure AddSort(ASort : TSortInfo);

    /// <summary>
    /// ɾ�����
    /// </summary>
    procedure DelSort(nSortID: Integer); overload;
    procedure DelSort(ASort : TSortInfo); overload;

    /// <summary>
    /// �޸����
    /// </summary>
    procedure EditSort(ASort : TSortInfo);

    /// <summary>
    /// ������
    /// </summary>
    procedure ClearSort;

    /// <summary>
    /// �������
    /// </summary>
    procedure LoadSort(slList :TStringList);


  end;



implementation

{ TSortAction }

procedure TSortAction.AddSort(ASort: TSortInfo);
const
  C_SQL = 'insert into SortInfo ( SortID, SortName, SortRemark' +
          ') values (  %d, :SortName, :SortRemark )';
begin
  if Assigned(ASort) then
  begin
    with ASort, FQuery.Params do
    begin
      FQuery.Sql.Text := Format( C_SQL, [ Sortid ] );

      ParamByName( 'SortName'   ).Value := Sortname  ;
      ParamByName( 'SortRemark' ).Value := Sortremark;
    end;

    ExecSQL;
  end;
end;

procedure TSortAction.ClearSort;
begin
  FQuery.Sql.Text := 'delete from SortInfo';
  ExecSQL;
end;

procedure TSortAction.DelSort(ASort: TSortInfo);
begin
  if Assigned(ASort) then
  begin
    DelSort(ASort.SortID);
  end;
end;

procedure TSortAction.DelSort(nSortID: Integer);
const
  C_SQL = 'delete from SortInfo where SortID = %d';
begin
  FQuery.Sql.Text := Format( C_SQL, [ nSortID ] );
  ExecSQL;

end;

procedure TSortAction.EditSort(ASort: TSortInfo);
const
  C_SQL = 'update SortInfo set SortName = :SortName,' +
          'SortRemark = :SortRemark where SortID = %d';
begin
  if Assigned(ASort) then
  begin
    with ASort, FQuery.Params do
    begin
      FQuery.Sql.Text := Format( C_SQL, [ Sortid ] );

      ParamByName( 'SortName'   ).Value := Sortname  ;
      ParamByName( 'SortRemark' ).Value := Sortremark;
    end;

    ExecSQL;
  end;
end;

function TSortAction.GetMaxSN: Integer;
const
  C_SQL = 'select max(SortID) as MaxSN from SortInfo';
begin
  FQuery.Open(C_SQL);

  if FQuery.RecordCount = 1 then
    Result := FQuery.FieldByName('MaxSN').AsInteger
  else
    Result := 0;

  FQuery.Close;
end;

procedure TSortAction.LoadSort(slList: TStringList);
var
  ASortInfo : TSortInfo;
begin
  if Assigned(slList) then
  begin
    ClearStringList(slList);
    FQuery.Open('select * from SortInfo');

    while not FQuery.Eof do
    begin
      ASortInfo := TSortInfo.Create;
      with ASortInfo, FQuery do
      begin
        Sortid     := FieldByName( 'SortID'     ).AsInteger;
        Sortname   := FieldByName( 'SortName'   ).AsString;
        Sortremark := FieldByName( 'SortRemark' ).AsString;
      end;
      slList.AddObject('', ASortInfo);
      FQuery.Next;
    end;
    FQuery.Close;
  end;
end;

end.

