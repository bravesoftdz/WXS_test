{===============================================================================
  ���ݿ�������Ԫ 

===============================================================================}
unit xDBUpdate;

interface

uses xDBConn, xDBActionBase, xFunction, xConsts, System.SysUtils, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes;

type
  /// <summary>
  /// ���ݿ���¿���
  /// </summary>
  TDBUpdate = class(TDBActionBase)
  private
    FDBConn : TDBConn;
    FUpdateQuery : TFDQuery;

    /// <summary>
    /// ���ݿ��Ƿ�����
    /// </summary>
    function DBConnected : Boolean;

    /// <summary>
    /// ��ȡ���ݿ����°汾��
    /// </summary>
    function MaxDBVersion : Integer;

    /// <summary>
    /// �����汾��
    /// </summary>
    procedure CreateVersionTable;

    /// <summary>
    /// �������°汾
    /// </summary>
    procedure SaveVersion( nVersion : Integer );

    /// <summary>
    /// �������ݿ�
    /// </summary>
    procedure UpdateDB( nLastVersion : Integer; var nMaxVersion : Integer );

  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// ����
    /// </summary>
    procedure Update;
  end;

implementation

{ TDBUpdate }

constructor TDBUpdate.Create;
begin
  inherited;
  FDBConn := TDBConn.Create;
  FDBConn.ConnStr := 'DriverID=MSAcc; Database='+spubFilePath+'dbupdate.mdb';

  FUpdateQuery := TFDQuery.Create(nil);
  FUpdateQuery.Connection := FDBConn.Connection;
end;

procedure TDBUpdate.CreateVersionTable;
const
  C_CREATE_VER = 'create table DB_VERSION ( ' +
                 'DB_SN int identity,' +
                 'DB_VERSION float,' +
                 'DB_LASTUPDATE datetime,' +
                 'constraint DB_VERSION_PK primary key (DB_SN) )';
begin
  try
    FQuery.ExecSQL(C_CREATE_VER);
  except

  end;
end;

function TDBUpdate.DBConnected: Boolean;
begin
  Result := Assigned( FQuery );

  if Result then
  begin
    try
      FQuery.Connection.Connected := True;
      Result := FQuery.Connection.Connected;
    except
      Result := False
    end;
  end;
end;

destructor TDBUpdate.Destroy;
begin
  if Assigned( FDBConn ) then
    FDBConn.Free;

  if Assigned( FUpdateQuery ) then
    FUpdateQuery.Free;

  inherited;
end;

function TDBUpdate.MaxDBVersion: Integer;
const
  C_SEL_VER = 'select Max( DB_VERSION ) from DB_VERSION';
var
  List: TStrings;
begin
  Result := -1;
  List := TStringList.Create;
  ADBConn.Connection.GetTableNames('', '', '', List);

  if List.IndexOf('DB_VERSION') <> -1 then
  begin
    FQuery.SQL.Text := C_SEL_VER;

    try
      FQuery.Open;
      Result := FQuery.Fields[ 0 ].AsInteger;
      FQuery.Close;
    except
    end;
  end;

  List.Free;
end;

procedure TDBUpdate.SaveVersion(nVersion: Integer);
const
  C_INS_VER = 'insert into DB_VERSION ( ' +
                 'DB_VERSION, DB_LASTUPDATE ) values( ' +
                 ' %d, ''%s'' )';
begin
  try
    FQuery.ExecSQL( Format( C_INS_VER, [ nVersion,
      FormatDateTime( 'yyyy-mm-dd', Now ) ] ) );
  except

  end;
end;

procedure TDBUpdate.Update;
var
  nLastVersion : Integer;
  nMaxVersion : Integer;
begin
  if not DBConnected then
    Exit;

  nLastVersion := MaxDBVersion;

  if nLastVersion = -1 then
    CreateVersionTable;

  UpdateDB( nLastVersion, nMaxVersion );

  if nLastVersion <> nMaxVersion then
    SaveVersion( nMaxVersion );
end;

procedure TDBUpdate.UpdateDB( nLastVersion : Integer;
  var nMaxVersion : Integer );
const
  C_SEL_CMD = 'select DB_VERSION, CMD_SQL from DB_UPDATES ' +
    'where DB_VERSION > %d order by SN';
var
  sCmd : string;
begin
  nMaxVersion := nLastVersion;

  FUpdateQuery.SQL.Text := Format( C_SEL_CMD, [ nLastVersion ] );
  FUpdateQuery.Open;

  // ����и���
  if FUpdateQuery.RecordCount > 0 then
  begin
    try
      while not FUpdateQuery.Eof do
      begin
        if nMaxVersion < FUpdateQuery.FieldByName( 'DB_VERSION' ).AsInteger then
          nMaxVersion := FUpdateQuery.FieldByName( 'DB_VERSION' ).AsInteger;

        sCmd := FUpdateQuery.FieldByName( 'CMD_SQL' ).AsString;

        try
          if sCmd <> '' then
            FQuery.ExecSQL(sCmd);
        except

        end;

        FUpdateQuery.Next;
      end;
    except
      nMaxVersion := nLastVersion;
    end;
  end;

  FQuery.Close;
end;

end.

