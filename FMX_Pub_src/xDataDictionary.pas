unit xDataDictionary;

interface

uses xDBActionBase,  System.Classes, System.SysUtils, FireDAC.Stan.Param, xFunction;

type
  /// <summary>
  /// �����ֵ���
  /// </summary>
  TDataDictionary = class(TDBActionBase)

  private
    FDictionaries: TStringList;
    function GetDictionary(sName: string): TStringList;
    procedure SetDictionary(sName: string; const Value: TStringList);


  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// �����ֵ��б�
    /// </summary>
    property Dictionaries : TStringList read FDictionaries ;

    /// <summary>
    /// �����ֵ��������
    /// </summary>
    /// <param name=" sName "> ���������� </param>
    property Dictionary[ sName : string ] : TStringList read GetDictionary write SetDictionary;

    /// <summary>
    /// ��ȡ�����ֵ��б�
    /// </summary>
    /// <returns>�ֵ������б�</returns>
    procedure LoadFromDB;

    /// <summary>
    /// ���������ֵ��б�
    /// </summary>
    procedure SaveToDB;
  end;
var
  DataDict : TDataDictionary;

implementation

{ TDataDictionary }

constructor TDataDictionary.Create;
begin
  inherited;
  FDictionaries := TStringList.Create;

  try
    LoadFromDB;
  except
  end;
end;

destructor TDataDictionary.Destroy;
begin
  ClearStringList( FDictionaries );
  FDictionaries.Free;

  inherited;
end;

function TDataDictionary.GetDictionary(sName: string): TStringList;
var
  nIndex : Integer;
begin
  nIndex := FDictionaries.IndexOf( sName );
  if nIndex < 0 then
  begin
    Result := TStringList.Create;
    Dictionaries.AddObject( sName, Result );
  end
  else
    Result := TStringList( FDictionaries.Objects[ nIndex ] );
end;

procedure TDataDictionary.LoadFromDB;
const
  C_SEL = ' select * from UserDictionary order by DicSN ';
var
  Items : TStringList;
begin

  FQuery.SQL.Text := C_SEL;

  try
    FQuery.Open;
    while  not FQuery.Eof do
    begin
      Items := TStringList.Create;
      Items.Text := FQuery.FieldByName( 'DicValue' ).AsString;
      FDictionaries.AddObject( FQuery.FieldByName( 'DicName'  ).AsString, Items );
      FQuery.Next;
    end;
    FQuery.Close;
  finally

  end;
end;

procedure TDataDictionary.SaveToDB;
const
  C_DEL = ' delete from  UserDictionary ' ;

  C_INS = ' insert into UserDictionary ( DicSN, DicName, DicValue )' +
    ' values (  :DicSN, :DicName, :DicValue ) ';
var
  i : Integer;
begin

  try
    //��ձ��м�¼
    FQuery.SQL.Text := C_DEL;
    ExecSQL;

    // �����µ�����
    for i := 0 to FDictionaries.Count - 1 do
    begin
      FQuery.SQL.Text := C_INS;
      with FQuery.Params, FDictionaries do
      begin
        ParamByName( 'DicSN' ).Value := i;
        ParamByName( 'DicName'  ).Value := Strings[ i ] ;
        ParamByName( 'DicValue' ).Value := TStringList(
          FDictionaries.Objects[ i ] ).Text;
      end;
      ExecSQL;
    end;
  finally

  end;
end;

procedure TDataDictionary.SetDictionary(sName: string;
  const Value: TStringList);
var
  nIndex : Integer;
begin
  // ���������ֵ��е�λ��
  nIndex := FDictionaries.IndexOf( sName );

  // ���û�ж�Ӧ�����ݣ��˳�
  if nIndex < 0 then
    Exit;

  // ���ֵ������ֵ
  TStringList( FDictionaries.Objects[ nIndex ] ).Text := Value.Text ;
end;

end.
