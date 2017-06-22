unit xClientInfo;

interface

uses System.Classes, System.SysUtils, System.IniFiles, xStudentInfo, xFunction,
  xClientType, xConsts;

type
  TLoginEvent = procedure(Sender: TObject; nStuID : Integer) of object;

type
  TClientInfo = class
  private
    FClientIP: string;
    FIsConnected: Boolean;
    FOnChanged: TNotifyEvent;
    FClientSN: Integer;
    FStudentInfo: TStudentInfo;
    FStartTime: TDateTime;
    FRemark: string;
    FClientPort: Integer;
    FEndTime: TDateTime;
    FSubList: TStringList;
    FClientState: TClientState;

    FCanRevData : Boolean; // �Ƿ���Խ�������
    FRevData : TBytes;     // ���յ����ݰ�
    FOnStuLogin: TLoginEvent;
    FOnStuReady: TNotifyEvent;

    procedure ReadINI;
    procedure WriteINI;
    procedure SetClientSN(const Value: Integer);

    /// <summary>
    /// ��������
    /// </summary>
    procedure AnalysisData;
    procedure SetClientState(const Value: TClientState);
    function GetClientName: string;

  public
    constructor Create;
    destructor Destroy; override;



    /// <summary>
    /// �ͻ��˱�ţ����ñ��ʱ��ȡINI������Ϣ��
    /// </summary>
    property ClientSN : Integer read FClientSN write SetClientSN;

    /// <summary>
    /// �ͻ�����
    /// </summary>
    property ClientName : string read GetClientName;

    /// <summary>
    /// �ͻ���IP��ַ
    /// </summary>
    property ClientIP : string read FClientIP write FClientIP;

    /// <summary>
    /// �ͻ������Ӷ˿�
    /// </summary>
    property ClientPort : Integer read FClientPort write FClientPort;

    /// <summary>
    /// �ͻ���״̬
    /// </summary>
    property ClientState : TClientState read FClientState write SetClientState;

    /// <summary>
    /// �Ƿ�����
    /// </summary>
    property IsConnected : Boolean read FIsConnected write FIsConnected;

    /// <summary>
    /// ������Ϣ
    /// </summary>
    property StudentInfo : TStudentInfo read FStudentInfo write FStudentInfo;

    /// <summary>
    /// �����Ŀ����б�
    /// </summary>
    property SubList : TStringList read FSubList write FSubList;

    /// <summary>
    /// ��ʼ����ʱ��
    /// </summary>
    property StartTime : TDateTime read FStartTime write FStartTime;

    /// <summary>
    /// ��������ʱ��
    /// </summary>
    property EndTime : TDateTime read FEndTime write FEndTime;

    /// <summary>
    /// ��ע
    /// </summary>
    property Remark : string read FRemark write FRemark;

  public
    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure RevPacksData(sIP: string; nPort :Integer;aPacks: TArray<Byte>);

    /// <summary>
    /// �ı��¼�
    /// </summary>
    property OnChanged : TNotifyEvent read FOnChanged write FOnChanged;

    /// <summary>
    /// ѧԱ�����¼�¼�
    /// </summary>
    property OnStuLogin : TLoginEvent read FOnStuLogin write FOnStuLogin;

    /// <summary>
    /// ѧԱ����׼���¼�
    /// </summary>
    property OnStuReady : TNotifyEvent read FOnStuReady write FOnStuReady;
  end;

implementation


{ TClientInfo }

procedure TClientInfo.AnalysisData;
var
  aBuf : TBytes;
  nStuID : Integer;
begin
  aBuf := AnalysisRevData(FRevData);

  if Assigned(aBuf) then
  begin
    // ��������
    if Length(aBuf) = 5 then
    begin
      // ����״̬
      if aBuf[1] = $07 then
      begin
        ClientState := TClientState(aBuf[2]);
      end;
    end
    else if Length(aBuf) = 7 then
    begin
      if Assigned(FOnStuLogin) then
      begin
        nStuID := aBuf[2] shl 16 + aBuf[3] shl 8 + aBuf[4];

        FOnStuLogin(Self, nStuID);
      end;
    end
    // ����׼��
    else if Length(aBuf) = 4 then
    begin
      // ����״̬
      if aBuf[1] = $08 then
      begin
        if Assigned(FOnStuReady) then
        begin
          FOnStuReady(Self);
        end;
      end;
    end;

  end;
end;

constructor TClientInfo.Create;
begin
  FStudentInfo:= TStudentInfo.Create;
  FSubList:= TStringList.Create;
  FCanRevData := False;
  FClientState := esDisconn;
end;

destructor TClientInfo.Destroy;
begin
  WriteINI;

  FStudentInfo.free;
//  ClearStringList(FSubList);
  FSubList.Free;

  inherited;
end;

function TClientInfo.GetClientName: string;
begin
  case FClientState of
    esDisconn, esConned : Result := FClientIP;
  else
    Result := StudentInfo.stuName;
  end;
end;

procedure TClientInfo.ReadINI;
var
  s : string;
begin
  s := 'Client' + IntToStr(FClientSN);
  with TIniFile.Create(spubFilePath + 'OptionClient.ini') do
  begin
    FClientIP := ReadString(s, 'ClientIP', '192.168.1.' + IntToStr(100+FClientSN));


    Free;
  end;
end;

procedure TClientInfo.RevPacksData(sIP: string; nPort: Integer;
  aPacks: TArray<Byte>);
  procedure AddData(nData : Byte);
  var
    nLen : Integer;
  begin
    nLen := Length(FRevData);

    SetLength(FRevData, nLen + 1);
    FRevData[nLen] := nData;
  end;
var
  i : Integer;
  nByte : Byte;
begin
  for i := 0 to Length(aPacks) - 1 do
  begin
    nByte := aPacks[i];
    if nByte = $7E then
    begin
      if Length(FRevData) = 0 then
      begin
        FCanRevData := True;
        AddData(nByte);
      end
      else
      begin
        if FRevData[Length(FRevData)-1] = $7E then
        begin
          SetLength(FRevData, 0);

          FCanRevData := True;
          AddData(nByte);
        end
        else
        begin
          AddData(nByte);
          // ת���ַ�����
          AnalysisData;
          SetLength(FRevData, 0);
          FCanRevData := False;
        end;

      end;
    end
    else
    begin
      if FCanRevData then
      begin
        AddData(nByte);
      end;
    end;
  end;
end;

procedure TClientInfo.SetClientSN(const Value: Integer);
begin
  FClientSN := Value;
  ReadINI;
end;

procedure TClientInfo.SetClientState(const Value: TClientState);
begin
  FClientState := Value;
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;

procedure TClientInfo.WriteINI;
var
  s : string;
begin
  s := 'Client' + IntToStr(FClientSN);
  with TIniFile.Create(spubFilePath + 'OptionClient.ini') do
  begin
    WriteString(s, 'ClientIP', FClientIP);



    Free;
  end;
end;

end.
