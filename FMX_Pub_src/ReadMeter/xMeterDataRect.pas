{===============================================================================
  Copyright(c) 2006-2009, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ���õ�����ݵ�Ԫ

  + TMeterDataItem  �������-������
  + TMeterDataGroup �������-������
  + TMeterData       �������
  + TMETER_DATA_GROUP_DL645 ���ڱ�׼DL645Э���������

===============================================================================}

unit xMeterDataRect;

interface

uses SysUtils, Classes, xFunction, xDL645Type;

type
  /// <summary>
  /// �������-������
  /// </summary>
  TMeterDataItem = class(TPersistent)
  private
    FSign   : Int64;
    FNote   : string;
    FFormat : string;
    FUnits  : string;
    FLength : Integer;
    FValue  : string;
    procedure SetValue( Val : string );
  published
    /// <summary>
    /// ��ʶ
    /// </summary>
    property Sign : Int64 read FSign write FSign;

    /// <summary>
    /// ˵��
    /// </summary>
    property Note : string read FNote write FNote;

    /// <summary>
    /// ��ʽ
    /// </summary>
    property Format : string read FFormat write FFormat;

    /// <summary>
    /// ��λ
    /// </summary>
    property Units : string read FUnits write FUnits;

    /// <summary>
    /// ����
    /// </summary>
    property Length : Integer read FLength write FLength;

    /// <summary>
    /// ֵ
    /// </summary>
    property Value : string read FValue write SetValue;

    /// <summary>
    /// ����ֵ
    /// </summary>
    procedure Assign(Source: TPersistent); override;
  public
    function SignInHex : string;
  end;

type
  /// <summary>
  /// �������-������
  /// </summary>
  TMeterDataGroup = class( TPersistent )
  private
    FItems : TStringList;
    FGroupName: string;
    FVerifyValue : Boolean;
    function GetItem( nSign : Int64 ) : TMeterDataItem;
    function GetItemValue( nSign : Int64 ) : string;
    procedure SetItemValue( nSign : Int64; const Value : string );
    procedure SetGroupName(const Value: string);
  protected

  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignValue(Source: TPersistent);

    /// <summary>
    /// �Ƿ�У������
    /// </summary>
    property VerifyValue : Boolean read FVerifyValue write FVerifyValue;

    /// <summary>
    /// ������
    /// </summary>
    property GroupName : string read FGroupName write SetGroupName;

    /// <summary>
    /// ����������
    /// </summary>
    property Items : TStringList read FItems;

    /// <summary>
    /// ������
    /// </summary>
    /// <param name="nSign">���ݱ�ʶ</param>
    property Item[ nSign : Int64 ] : TMeterDataItem read GetItem;

    /// <summary>
    /// �������ֵ
    /// </summary>
    property ItemValue[ nSign : Int64 ] : string read GetItemValue write
      SetItemValue;

    /// <summary>
    /// �½�һ��������, ����Ѵ��ڣ��򷵻ص�����������
    /// </summary>
    /// <param name="nSign">���ݱ�ʶ</param>
    /// <returns>������</returns>
    function NewItem( nSign : Int64 ) : TMeterDataItem; overload;virtual;

    /// <summary>
    /// ɾ��������
    /// </summary>
    procedure DelItem( nSign : Int64 );

    /// <summary>
    /// �½�һ��������, ����Ѵ��ڣ��򷵻ص�����������
    /// </summary>
    /// <param name="nSign">��ʶ</param>
    /// <param name="sFormat">��ʽ</param>
    /// <param name="nLen">����</param>
    /// <param name="sUnit">��λ</param>
    /// <param name="sNote">˵��</param>
    /// <returns>������</returns>
    function NewItem(nSign: Int64; sFormat: string; nLen: integer;
      sUnit, sNote: string) : TMeterDataItem; overload;virtual;

    /// <summary>
    /// ɾ������������
    /// </summary>
    procedure DeleteAllItems;

    /// <summary>
    /// ��������������ֵ
    /// </summary>
    procedure ClearAllItemsValue;
  end;

type
  /// <summary>
  /// �������
  /// </summary>
  TMeterData = class( TPersistent )
  private
    FAutoCreateGroup : Boolean;
    FAutoCreateItem : Boolean;
    FDefaultGroupName : string;
    FGroups : TStringList;     // ���з����������
    FGroupStructure : TMeterDataGroup;
    function GetDefaultGroupName : string;
    procedure SetDefaultGroupName( const Value : string );
    function GetGroup( sGroupName : string  ) : TMeterDataGroup;
    function GetGroupItem( sGroupName : string; nSign : Int64 ) :
      TMeterDataItem;
    function GetDefaultGroupItem( nSign : Int64 ) : TMeterDataItem;
    function GetGroupItemValue( sGroupName : string; nSign : Int64 ) : string;
    procedure SetGroupItemValue( sGroupName : string; nSign : Int64;
      const Value: string);
    function GetDefaultGroupItemValue( nSign : Int64 ) : string;
    procedure SetDefaultGroupItemValue( nSign : Int64; const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ����MeterData����
    /// </summary>
    procedure Assign(Source: TPersistent); override;

    /// <summary>
    /// �µ�������
    /// </summary>
    /// <param name="sGroupName">������</param>
    /// <returns>������</returns>
    function NewGroup( sGroupName : string ) : TMeterDataGroup;virtual;

    /// <summary>
    /// ɾ��ĳһ������
    /// </summary>
    procedure DeleteGroup( sGroupName : string );

    /// <summary>
    /// ɾ������������
    /// </summary>
    procedure DeleteAllGroups;

    /// <summary>
    /// ���ĳһ�������������ֵ
    /// </summary>
    procedure ClearGroupItemsValue( sGroupName : string );

    /// <summary>
    /// �����������
    /// </summary>
    procedure ClearAllGroupItemsValue;

    /// <summary>
    /// ���Ĭ���������������ֵ
    /// </summary>
    procedure ClearItemsValue;

    /// <summary>
    /// �Ƿ��Զ���������(��ȡ�������û�������ȴ������ٷ���)
    /// </summary>
    property AutoCreateGroup : Boolean read FAutoCreateGroup
      write FAutoCreateGroup;

    /// <summary>
    /// �Ƿ��Զ�����������(��ȡ������ʱ���û�����������ȴ����������ٷ���)
    /// </summary>
    property AutoCreateItem : Boolean read FAutoCreateItem
      write FAutoCreateItem;

    /// <summary>
    /// ����������
    /// </summary>
    property Groups : TStringList read FGroups;

    /// <summary>
    /// Ĭ�ϵ���ṹ(����Ӧ������������)
    /// </summary>
    property GroupStructure : TMeterDataGroup read FGroupStructure
      write FGroupStructure;

    /// <summary>
    /// Ĭ�ϵ�������
    /// </summary>
    property DefaultGroupName : string read GetDefaultGroupName
      write SetDefaultGroupName;

    /// <summary>
    /// ������
    /// </summary>
    /// <param name="sGroupName">������</param>
    property Group[ sGroupName : string ] : TMeterDataGroup read GetGroup;

    /// <summary>
    /// �����е�������
    /// </summary>
    /// <param name="sGroupName">������</param>
    /// <param name="nSign">���ݱ�ʶ</param>
    property GroupItem[ sGroupName : string; nSign : Int64 ]: TMeterDataItem
      read GetGroupItem;

    /// <summary>
    /// Ĭ�����е�������
    /// </summary>
    /// </summary>
    /// <param name="sGroupName">������</param>
    /// <param name="nSign">���ݱ�ʶ</param>
    property Item[ nSign : Int64 ] : TMeterDataItem
      read GetDefaultGroupItem;

    /// <summary>
    /// �������������ֵ
    /// </summary>
    /// <param name="sGroupName">������</param>
    /// <param name="nSign">���ݱ�ʶ</param>
    property GroupItemValue[ sGroupName : string; nSign : Int64 ]: string
       read GetGroupItemValue write SetGroupItemValue;

    /// <summary>
    /// Ĭ�������������ֵ
    /// </summary>
    /// <param name="sGroupName">������</param>
    /// <param name="nSign">���ݱ�ʶ</param>
    property ItemValue[ nSign : Int64 ]: string read GetDefaultGroupItemValue
      write SetDefaultGroupItemValue;
  end;

type
  /// <summary>
  /// ���ڱ�׼DL645Э���������
  /// </summary>
  TMETER_DATA_GROUP_DL645 = class( TMeterDataGroup )
  private
    /// <summary>
    /// ���һ������
    /// </summary>
    /// <param name="sType">��������</param>
    /// <param name="nBaseSign">��ʼ���ݱ�ʶ</param>
    /// <param name="nLen">����</param>
    /// <param name="sFormat">��ʽ</param>
    /// <param name="sUnitA">�й���λ</param>
    /// <param name="sUnitU">�޹���λ</param>
    procedure AddNormalData( sType: string; nBaseSign : Integer;
      nLen : Integer; sFormat, sUnitA, sUnitU : string );

    /// <summary>
    /// ���ʱ����Ϣ����
    /// </summary>
    procedure AddTimePeriodData;

    /// <summary>
    /// ��ӱ����Ͳα���
    /// </summary>
    procedure AddVariableData;
  public
    constructor Create;
  end;

/// <summary>
/// У����������
/// </summary>
procedure VerifyMeterDataItem( AItem : TMeterDataItem );

/// <summary>
/// �˶����ݸ�ʽ
/// </summary>
function VerifiedStr( const sData, sFormat : string; nLen : Integer ) : string;

/// <summary>
/// ��������������ʾ
/// </summary>
function FixDataForShow( AData: string; AFormat: string; ALen: Integer) : string; overload;
function FixDataForShow( AData: TBytes; AFormat: string; ALen: Integer) : string; overload;

implementation

{ TMETER_READING }

procedure TMeterDataItem.Assign(Source: TPersistent);
begin
  Assert( Source is TMeterDataItem );

  FSign   := TMeterDataItem( Source ).Sign  ;
  FNote   := TMeterDataItem( Source ).Note  ;
  FFormat := TMeterDataItem( Source ).Format;
  FUnits  := TMeterDataItem( Source ).Units ;
  FLength := TMeterDataItem( Source ).Length;
  FValue  := TMeterDataItem( Source ).Value ;
end;

{ TMeterData }

procedure TMeterData.Assign(Source: TPersistent);
var
  i : Integer;
begin
  Assert( Source is TMeterData );
  ClearStringList( Groups );

  AutoCreateGroup  := TMeterData( Source ).AutoCreateGroup;
  AutoCreateItem   := TMeterData( Source ).AutoCreateItem;
  DefaultGroupName := TMeterData( Source ).DefaultGroupName;

  GroupStructure.Assign( TMeterData( Source ).GroupStructure );
  Groups.Text := TMeterData( Source ).Groups.Text;

  for i := 0 to TMeterData( Source ).Groups.Count -1 do
  begin
    Groups.Objects[ i ] := TMeterDataGroup.Create;
    TMeterDataGroup( Groups.Objects[ i ] ).Assign( TMeterDataGroup(
      TMeterData( Source ).Groups.Objects[ i ] ) );
  end;
end;

procedure TMeterData.ClearAllGroupItemsValue;
var
  i: Integer;
begin
  for i := 0 to FGroups.Count - 1 do
    ClearGroupItemsValue( FGroups[ i ] );
end;

procedure TMeterData.ClearGroupItemsValue(sGroupName: string);
var
  mdGroup : TMeterDataGroup;
begin
  mdGroup := GetGroup( sGroupName );

  if Assigned( mdGroup ) then
    mdGroup.ClearAllItemsValue;
end;

procedure TMeterData.ClearItemsValue;
begin
  ClearGroupItemsValue( FDefaultGroupName );
end;

constructor TMeterData.Create;
begin
  FGroups := TStringList.Create;
  FGroupStructure := TMeterDataGroup.Create;
  FAutoCreateGroup := False;
  FAutoCreateItem := False;
end;

destructor TMeterData.Destroy;
begin
  FGroups.Free;
  FGroupStructure.Free;
  inherited;
end;

procedure TMeterData.DeleteAllGroups;
var
  i : Integer;
begin
  for i := 0 to fgroups.Count - 1 do
    FGroups.Objects[ i ].Free;

  FGroups.Clear;
end;

procedure TMeterData.DeleteGroup( sGroupName : string );
var
  nIndex : Integer;
begin
  nIndex := FGroups.IndexOf( sGroupName );

  if nIndex <> -1 then
  begin
    FGroups.Objects[ nIndex ].Free;
    FGroups.Delete( nIndex );
  end;
end;

function TMeterData.GetDefaultGroupItem(nSign: Int64): TMeterDataItem;
begin
  Result := GetGroupItem( GetDefaultGroupName, nSign );
end;

function TMeterData.GetDefaultGroupItemValue(nSign: Int64): string;
begin
  Result := GetGroupItemValue( GetDefaultGroupName, nSign );
end;

function TMeterData.GetDefaultGroupName: string;
begin
  if FDefaultGroupName <> EmptyStr then
    Result := FDefaultGroupName
  else
  begin
    if FGroups.Count > 0 then
      Result := FGroups[ 0 ]
    else
      Result := EmptyStr;
  end;
end;

function TMeterData.GetGroup(sGroupName: string): TMeterDataGroup;
var
  nIndex : Integer;
begin
  nIndex := FGroups.IndexOf( sGroupName );

  if nIndex = -1 then
  begin
    // ��������Զ������������µ�������
    if AutoCreateGroup then
    begin
      Result := TMeterDataGroup.Create;
      FGroups.AddObject( sGroupName, Result );
    end
    else
      Result := nil
  end
  else
    Result := TMeterDataGroup( FGroups.Objects[ nIndex ] );
end;

function TMeterData.GetGroupItem(sGroupName: string; nSign: Int64):
  TMeterDataItem;
var
  mdGroup : TMeterDataGroup;
begin
  mdGroup := GetGroup( sGroupName );

  if not Assigned( mdGroup ) then
    Result := nil
  else
  begin
    Result := mdGroup.Item[ nSign ];

    // ��������Զ������������µ�������
    if ( not Assigned( Result ) ) and AutoCreateItem then
      Result := mdGroup.NewItem( nSign );
  end;
end;

function TMeterData.GetGroupItemValue(sGroupName: string; nSign: Int64):
  string;
var
  mdItem : TMeterDataItem;
begin
  mdItem := GetGroupItem( sGroupName, nSign );

  if Assigned( mdItem ) then
    Result := mdItem.Value
  else
    Result := EmptyStr;
end;

function TMeterData.NewGroup(sGroupName: string): TMeterDataGroup;
var
  mdGroup : TMeterDataGroup;
begin
  if sGroupName = EmptyStr then
  begin
    Result := nil;
    Exit;
  end;

  mdGroup := GetGroup( sGroupName );

  if not Assigned( mdGroup ) then
  begin
    mdGroup := TMeterDataGroup.Create;

    // ʹ�������ݽṹ
    mdGroup.Assign( GroupStructure );

    mdGroup.GroupName := sGroupName;

    FGroups.AddObject( sGroupName, mdGroup );
  end;

  Result := mdGroup;
end;

procedure TMeterData.SetDefaultGroupItemValue(nSign: Int64;
  const Value: string);
begin
  SetGroupItemValue( GetDefaultGroupName, nSign, Value );
end;

procedure TMeterData.SetDefaultGroupName(const Value: string);
begin
  if FGroups.IndexOf( Value ) <> -1 then
    FDefaultGroupName := Value;
end;

procedure TMeterData.SetGroupItemValue(sGroupName: string; nSign: Int64;
  const Value: string);
var
  mdItem : TMeterDataItem;
begin
  mdItem := GetGroupItem( sGroupName, nSign );

  if Assigned( mdItem ) then
    mdItem.Value := Value;
end;

{ TMeterDataGroup }

procedure TMeterDataGroup.Assign(Source: TPersistent);
var
  mdGroup : TMeterDataGroup;
  mdItem : TMeterDataItem;
  i: Integer;
begin
  Assert( Source is TMeterDataGroup );

  DeleteAllItems;

  GroupName := TMeterDataGroup( Source ).GroupName;

  mdGroup := TMeterDataGroup( Source );

  FVerifyValue := mdGroup.VerifyValue;

  for i := 0 to mdGroup.Items.Count - 1 do
  begin
    mdItem := TMeterDataItem.Create;
    mdItem.Assign( TMeterDataItem( mdGroup.Items.Objects[ i ] ) );
    FItems.AddObject( mdGroup.Items[ i ], mdItem );
  end;
end;

procedure TMeterDataGroup.AssignValue(Source: TPersistent);
var
  i: Integer;
  AItem : TMeterDataItem;
begin
  Assert( Source is TMeterDataGroup );

  ClearAllItemsValue;

  for i := 0 to Items.Count - 1 do
  begin
    with TMeterDataItem(Items.Objects[i]) do
    begin
      AItem := TMeterDataGroup(Source).Item[Sign];
      if Assigned(AItem) then
        Value :=  AItem.Value;
    end;
  end;
end;

procedure TMeterDataGroup.ClearAllItemsValue;
var
  mdItem : TMeterDataItem;
  i : Integer;
begin
  for i := 0 to FItems.Count - 1 do
  begin
    mdItem := TMeterDataItem( FItems.Objects[ i ] );
    mdItem.Value := EmptyStr;
  end;
end;

constructor TMeterDataGroup.Create;
begin
  FItems := TStringList.Create;
  FVerifyValue := False;
end;

procedure TMeterDataGroup.DeleteAllItems;
var
  i : Integer;
begin
  for i := 0 to FItems.Count - 1 do
    FItems.Objects[ i ].Free;

  FItems.Clear;
end;

procedure TMeterDataGroup.DelItem(nSign: Int64);
var
  i: Integer;
begin
  for i := 0 to FItems.Count - 1 do
  begin
    if TMeterDataItem(FItems.Objects[i]).Sign = nSign then
    begin
      FItems.Objects[ i ].Free;
      FItems.Delete(i);
      Exit;
    end;
  end;
end;

destructor TMeterDataGroup.Destroy;
begin
  DeleteAllItems;
  FItems.Free;
  inherited;
end;

function TMeterDataGroup.GetItem(nSign: Int64): TMeterDataItem;
var
  nIndex : Integer;
  sSign : string;
begin
//  if nSign > $FFFF then
    sSign := IntToHex( nSign and $FFFFFFFF, 8 );
//  else
//    sSign := IntToHex( nSign and C_METER_DATA_SIGN_MAX, 4 );

  nIndex := FItems.IndexOf( sSign );
  if nIndex = -1 then
  begin
    nIndex := FItems.IndexOf( IntToHex( Sign97To07(nSign) and $FFFFFFFF, 8 ) );
  end;

  if nIndex = -1 then
    Result := nil
  else
    Result := TMeterDataItem( FItems.Objects[ nIndex ] );
end;

function TMeterDataGroup.GetItemValue(nSign: Int64): string;
var
  mdItem : TMeterDataItem;
begin
  mdItem := GetItem( nSign );

  if Assigned( mdItem ) then
    Result := mdItem.Value
  else
    Result := EmptyStr;
end;

function TMeterDataGroup.NewItem(nSign: Int64; sFormat: string;
  nLen: integer; sUnit, sNote: string): TMeterDataItem;
begin
  Result := NewItem( nSign );

  with Result do
  begin
    Note   := sNOTE;
    Format := sFORMAT;
    Units  := sUNIT;
    Length := nLEN;
    Value  := EmptyStr;
  end;
end;

function TMeterDataGroup.NewItem(nSign: Int64): TMeterDataItem;
var
  nIndex : Integer;
  sSign : string;
begin
//  if nSign > $FFFF then
    sSign := IntToHex( nSign and $FFFFFFFF, 8 );
//  else
//    sSign := IntToHex( nSign and C_METER_DATA_SIGN_MAX, 4 );

  nIndex := FItems.IndexOf( sSign );

  if nIndex = -1 then
  begin
    Result := TMeterDataItem.Create;
    Result.Sign := nSign;
    FItems.AddObject( sSign, Result );
  end
  else
    Result := TMeterDataItem( FItems.Objects[ nIndex ] );
end;

procedure TMeterDataGroup.SetGroupName(const Value: string);
begin
  FGroupName := Value;
end;

procedure TMeterDataGroup.SetItemValue(nSign: Int64; const Value: string);
var
  mdItem : TMeterDataItem;
begin
  mdItem := GetItem( nSign );

  if Assigned( mdItem ) then
  begin
    mdItem.Value := Value;

    if VerifyValue then
      VerifyMeterDataItem( mdItem );
  end;
end;

{ TMETER_DATA_GROUP_DL645 }

procedure TMETER_DATA_GROUP_DL645.AddNormalData( sType: string;
  nBaseSign : Integer; nLen : Integer; sFormat, sUnitA, sUnitU : string );
  function GetNote(n1, n2, n3: Integer; sType : string ): string;
  begin
    if n1 < 2 then
      Result := '����ǰ��'
    else if n1 < 4 then
      Result := '�����£�'
    else
      Result := '�������£�';

    if n3 in [ 1..$E ] then
    begin
      Result := Result + '����' + IntToStr( n3 );
    end;

    case n2 of
      1 : Result := Result + '����';
      2 : Result := Result + '����';
      3 : Result := Result + 'һ����';
      4 : Result := Result + '������';
      5 : Result := Result + '������';
      6 : Result := Result + '������';
    end;

    if n1 in [ 0, 2, 4 ] then
      Result := Result + '�й�'
    else
      Result := Result + '�޹�';

    if n3 = 0 then
      result := result + '��' + sType
    else if n3 = $f then
      result := result + sType + '���ݿ�'
    else
      result := result + sType;
  end;
var
  i, j, k : Integer;
  sUnit, sNote : string;
  nSign : Int64;
begin
  for i := 0 to 5 do       // �·� , 0, 2, 4�й�, 1,3,5�޹�
  begin
    for j := 1 to 6 do     // ����
    begin
      for k := 0 to 15 do  // ����
      begin
        if ( i in [ 0, 2, 4 ] ) and ( j > 2 ) then   // �й�û�ж�����
          Break;

        nSign := nBaseSign;

        if i in [ 0, 2, 4 ] then     // �й�
        begin
          nSign := nSign + ( i * 2 ) shl 8 + j shl 4 + k;
          sUnit := sUnitA;
        end
        else
        begin
          nSign := nSign + ( ( i - 1 ) * 2 + 1 ) shl 8 + j shl 4 + k;
          sUnit := sUnitU;
        end;

        sNote := GetNote( i, j, k, sType );

        if k < 15 then
          NewItem( nSign, sFormat, nLen, sUnit, sNote )
        else
          NewItem( nSign, sFormat, nLen * 15, sUnit, sNote );
      end;
    end;
  end;
end;


procedure TMETER_DATA_GROUP_DL645.AddTimePeriodData;
var
  i, j : Integer;
  nSign : Int64;
  sNote : string;
begin
  for i := 1 to 15 do
  begin
    nSign := $C320 + i;
    sNote := Format( '%dʱ����ʼ���ڼ���ʱ�α��', [ i ] );

    NewItem( nSign, 'MMDDNN', 3, '', sNote );
  end;

  for i := 1 to 8 do
    for j := 1 to 15 do
    begin
      nSign := $C300 + ( i + 2 ) shl 4 + j;
      sNote := Format( '��%d��ʱ�α��%dʱ����ʼʱ�估���ʺ�', [ i, j ] );

      NewItem( nSign, 'hhmmNN', 3, '', sNote );
    end;

  for i := 1 to $D do
  begin
    nSign := $C410 + i;
    sNote := Format( '��%d�����������ڼ���ʱ�α��', [ i ] );

    NewItem( nSign, 'MMDDNN', 3, '', sNote );
  end;
end;

procedure TMETER_DATA_GROUP_DL645.AddVariableData;
begin
  // ����
  NewItem( $B210, 'MMDDhhmm'    , 4, '����ʱ��', '���һ�α��ʱ��' );
  NewItem( $B211, 'MMDDhhmm'    , 4, '����ʱ��', '���һ�������������ʱ��' );
  NewItem( $B212, '0000'        , 2, ''        , '��̴���' );
  NewItem( $B213, '0000'        , 2, ''        , '��������������' );
  NewItem( $B214, '000000'      , 3, '����'    , '��ع���ʱ��' );
  NewItem( $B310, '0000'        , 2, ''        , '�ܶ������' );
  NewItem( $B311, '0000'        , 2, ''        , 'A��������' );
  NewItem( $B312, '0000'        , 2, ''        , 'B��������' );
  NewItem( $B313, '0000'        , 2, ''        , 'C��������' );
  NewItem( $B320, '000000'      , 3, '����'    , '����ʱ���ۼ�ֵ' );
  NewItem( $B321, '000000'      , 3, '����'    , 'A����ʱ���ۼ�ֵ' );
  NewItem( $B322, '000000'      , 3, '����'    , 'B����ʱ���ۼ�ֵ' );
  NewItem( $B323, '000000'      , 3, '����'    , 'C����ʱ���ۼ�ֵ' );
  NewItem( $B330, 'MMDDhhmm'    , 4, '����ʱ��', '���һ�ζ�����ʼʱ��' );
  NewItem( $B331, 'MMDDhhmm'    , 4, '����ʱ��', 'A�����������ʼʱ��' );
  NewItem( $B332, 'MMDDhhmm'    , 4, '����ʱ��', 'B�����������ʼʱ��' );
  NewItem( $B333, 'MMDDhhmm'    , 4, '����ʱ��', 'C�����������ʼʱ��' );
  NewItem( $B340, 'MMDDhhmm'    , 4, '����ʱ��', '���һ�ζ���Ľ���ʱ��' );
  NewItem( $B341, 'MMDDhhmm'    , 4, '����ʱ��', 'A�����һ�ζ���Ľ���ʱ��' );
  NewItem( $B342, 'MMDDhhmm'    , 4, '����ʱ��', 'B�����һ�ζ���Ľ���ʱ��' );
  NewItem( $B343, 'MMDDhhmm'    , 4, '����ʱ��', 'C�����һ�ζ���Ľ���ʱ��' );
  NewItem( $B611, '000'         , 2, 'V'       , 'A���ѹ' );
  NewItem( $B612, '000'         , 2, 'V'       , 'B���ѹ' );
  NewItem( $B613, '000'         , 2, 'V'       , 'C���ѹ' );
  NewItem( $B621, '00.00'       , 2, 'A'       , 'A�����' );
  NewItem( $B622, '00.00'       , 2, 'A'       , 'B�����' );
  NewItem( $B623, '00.00'       , 2, 'A'       , 'C�����' );
  NewItem( $B630, '00.0000'     , 3, 'kW'      , '˲ʱ�й�����' );
  NewItem( $B631, '00.0000'     , 3, 'kW'      , 'A���й�����' );
  NewItem( $B632, '00.0000'     , 3, 'kW'      , 'B���й�����' );
  NewItem( $B633, '00.0000'     , 3, 'kW'      , 'C���й�����' );
  NewItem( $B634, '00.00'       , 2, 'kW'      , '�����й���������ֵ' );
  NewItem( $B635, '00.00'       , 2, 'kW'      , '�����й���������ֵ' );
  NewItem( $B640, '00.00'       , 2, 'kvarh'   , '˲ʱ�޹�����' );
  NewItem( $B641, '00.00'       , 2, 'kvarh'   , 'A���޹�����' );
  NewItem( $B642, '00.00'       , 2, 'kvarh'   , 'B���޹�����' );
  NewItem( $B643, '00.00'       , 2, 'kvarh'   , 'C���޹�����' );
  NewItem( $B650, '0.000'       , 2, ''        , '�ܹ�������' );
  NewItem( $B651, '0.000'       , 2, ''        , 'A�๦������' );
  NewItem( $B652, '0.000'       , 2, ''        , 'B�๦������' );
  NewItem( $B653, '0.000'       , 2, ''        , 'C�๦������' );

  // �α���
  NewItem( $C010, 'YYMMDDWW'    , 4, '��������', '���ڼ��ܴ�' );
  NewItem( $C011, 'hhmmss'      , 3, 'ʱ����'  , 'ʱ��' );
  NewItem( $C020, ''            , 1, ''        , '�������״̬��' );
  NewItem( $C021, ''            , 1, ''        , '����״̬��' );
  NewItem( $C022, ''            , 1, ''        , '������״̬��' );
  NewItem( $C030, '000000'      , 3, 'p/(kWh)' , '��������й���' );
  NewItem( $C031, '000000'      , 3, 'p/(kvarh)','��������޹���' );
  NewItem( $C032, '000000000000', 6, ''        , '���' );
  NewItem( $C033, '000000000000', 6, ''        , '�û���' );
  NewItem( $C034, '000000000000', 6, ''        , '�豸��' );
  NewItem( $C111, '00'          , 1, '����'    , '�����������' );
  NewItem( $C112, '00'          , 1, '����'    , '����ʱ��' );
  NewItem( $C113, '00'          , 1, '��'      , 'ѭ��ʱ��' );
  NewItem( $C114, '00'          , 1, '��'      , 'ͣ��ʱ�� ' );
  NewItem( $C115, '00'          , 1, ''        , '��ʾ����С��λ�� ' );
  NewItem( $C116, '00'          , 1, ''        , '��ʾ���ʣ����������С��λ��' );
  NewItem( $C117, 'DDhh'        , 2, '��ʱ'    , '�Զ���������' );
  NewItem( $C118, '00'          , 1, ''        , '���ɴ�����' );
  NewItem( $C119, '000000.0'    , 4, 'kWh'     , '�й�������ʼ����' );
  NewItem( $C11A, '000000.0'    , 4, 'kvarh'   , '�޹�������ʼ����' );
  NewItem( $C211, '0000'        , 2, 'ms'      , '���������' );
  NewItem( $C212, '00000000'    , 4, ''        , '����Ȩ�޼�����' );
  NewItem( $C310, '00'          , 1, ''        , '��ʱ����P' );
  NewItem( $C311, '00'          , 1, ''        , '��ʱ�α���q' );
  NewItem( $C312, '00'          , 1, ''        , '��ʱ�Σ�ÿ���л�����m��10' );
  NewItem( $C313, '00'          , 1, ''        , '������k��14' );
  NewItem( $C314, '00'          , 1, ''        , '����������n' );
  NewItem( $C41E, '00'          , 1, ''        , '�����ղ��õ���ʱ�α��' );
  NewItem( $C510, 'MMDDhhmm'    , 4, '����ʱ��', '���ɼ�¼��ʼʱ��' );
  NewItem( $C511, '0000'        , 2, '����'    , '���ɼ�¼���ʱ��' );
end;

constructor TMETER_DATA_GROUP_DL645.Create;
begin
  inherited;

  AddNormalData( '����', $9000, 4, '000000.00', 'kWh', 'kvarh' );
  AddNormalData( '�������', $A000, 3, '00.0000', 'kW', 'kvar' );
  AddNormalData( '�����������ʱ��', $B000, 4, 'MMDDhhmm',
    '����ʱ��', '����ʱ��' );

  AddVariableData;
  AddTimePeriodData;
end;

procedure TMeterDataItem.SetValue(Val: string);
begin
  if Val <> FValue then
    FValue := Val;
end;

function TMeterDataItem.SignInHex: string;
begin
  Result := IntToHex( Sign, 8 );
end;

procedure VerifyMeterDataItem( AItem : TMeterDataItem );
begin
  AItem.Value := VerifiedStr( AItem.Value, AItem.Format, AItem.Length );
end;

function VerifiedStr( const sData, sFormat : string; nLen : Integer ) : string;
  // �����ַ�������
  procedure ChangeStrSize( var s : string; nLen : Integer );
  var
    i : Integer;
  begin
    if Length( s ) < nLen then
    begin
      for i := 1 to nLen - Length( s ) do
        s := '0' + s;
    end
    else if Length( s ) > nLen then
    begin
      s := Copy( s, Length( s ) - nLen + 1, nLen );
    end;
  end;
var
  nLenStr : Integer;
  dTemp : Double;
  s : string;
  aBuf : TBytes;
begin
  s := Trim( sData );
  s := StringReplace( s, ' ', '', [rfReplaceAll] );
  s := StringReplace( s, '-', '', [rfReplaceAll] );
  s := StringReplace( s, ':', '', [rfReplaceAll] );

  if (sFormat <> EmptyStr) and (sFormat <> '00.0000YYMMDDhhmm') then   // �����ݸ�ʽ��
  begin
    // ����������
    if ( Pos( '0.0', sFormat ) > 0 ) then
    begin
      TryStrToFloat( s, dTemp );
      s := FormatFloat( sFormat, dTemp );
    end
    else
    begin
      if Pos('X', sFormat) > 0 then
      begin
        nLenStr := Round(Length( sFormat )/2);
        ChangeStrSize( s, nLenStr );
        aBuf := StrToPacks( s );
        s := BCDPacksToStr(aBuf);

        s := StringReplace(s, ' ', '', [rfReplaceAll]);
      end
      else
      begin
        nLenStr := Length( sFormat );
        ChangeStrSize( s, nLenStr );
      end;

    end;
  end
  else
  begin
    s := StringReplace( s, '.', '', [rfReplaceAll] );
    nLenStr := nLen * 2;    // �ֽڸ�����2����Ϊ��ʮ������
    ChangeStrSize( s, nLenStr );

    Insert('.',s, 3);
  end;

  Result := s;
end;

function FixDataForShow( AData: string; AFormat: string; ALen: Integer) : string;
const
  C_DATETIME_STR = '%s-%s %s:%s';
var
  nRStrLen : Integer; // .�ұߵ��ַ�������
  s : string;
begin
  if Pos( '.', AFormat ) > 0 then
  begin
    nRStrLen := Length( AFormat ) - Pos( '.', AFormat );
    s := Copy( AData, 1, Length( AData ) - nRStrLen );
    s := s + '.';
    s := s + Copy( AData, Length( AData ) - nRStrLen + 1, nRStrLen );
    Result := s;
  end
  else if ( UpperCase( AFormat ) = 'MMDDHHMM' ) and ( Length( AData ) = 8 ) then
  begin
    s := AData;
    Result := Format( C_DATETIME_STR, [ Copy( s, 1, 2 ), Copy( s, 3, 2 ),
        Copy( s, 5, 2 ), Copy( s, 7, 2 ) ] );
  end;
end;

function FixDataForShow( AData: TBytes; AFormat: string; ALen: Integer) : string;
var
  s : string;
  i: Integer;
begin
  s := '';
  for i := 0 to Length(AData) - 1 do
    s :=  s + IntToHex(adata[i], 2);
  Result := FixDataForShow(s, AFormat, ALen);
end;

end.





