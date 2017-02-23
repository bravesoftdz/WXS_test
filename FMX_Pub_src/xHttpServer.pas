unit xHttpServer;

interface

uses
  System.SysUtils, System.Types,  System.Classes, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext;

type
  THttpServer = class
  private
    FHttpServer: TIdHTTPServer;
    FRootDir: string;
    FFileText : TStringList;
    FDefaultMainPage: string;
    FDefaultPort: Integer;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);

  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// ��������Ŀ¼ ��Ĭ�� �����Ŀ¼�µ�www�ļ��У�
    /// </summary>
    property RootDir : string read FRootDir write FRootDir;

    /// <summary>
    /// �������˿� (Ĭ��80)
    /// </summary>
    property DefaultPort : Integer read FDefaultPort write FDefaultPort;

    /// <summary>
    /// �Ƿ�����
    /// </summary>
    property Active : Boolean read GetActive write SetActive;

    /// <summary>
    /// Ĭ����ҳ (���Ŀ¼)
    /// </summary>
    property DefaultMainPage : string read FDefaultMainPage write FDefaultMainPage;

  end;

implementation

{ THttpServer }

procedure THttpServer.CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LFilename: string;
  LPathname: string;
  sFileExt : string;
begin
//���������http://127.0.0.1:8008/index.html?a=1&b=2
  //ARequestInfo.Document  ����    /index.html
  //ARequestInfo.QueryParams ����  a=1b=2
  //ARequestInfo.Params.Values['name']   ����get,post����������
  ////webserver���ļ�
  LFilename := ARequestInfo.Document;

  if LFilename = '/' then
    LFilename := '/'+DefaultMainPage;

  LPathname := RootDir + LFilename;

  if FileExists(LPathname) then
  begin
    sFileExt := UpperCase(ExtractFileExt(LPathname));

    if (sFileExt = '.HTML') or (sFileExt = '.HTM')then
    begin
      FFileText.LoadFromFile(LPathname);
      AResponseInfo.ContentType :='text/html;Charset=UTF-8'; // ���Ĳ�����
      AResponseInfo.ContentText:=FFileText.Text;
    end
    else if sFileExt = '.XML'then
    begin
      FFileText.LoadFromFile(LPathname);
      AResponseInfo.ContentType :='text/xml;Charset=UTF-8';
      AResponseInfo.ContentText:=FFileText.Text;
    end
    else
    begin
      AResponseInfo.ContentStream := TFileStream.Create(LPathname, fmOpenRead + fmShareDenyWrite);//���ļ�
      if (sFileExt = '.RAR') or (sFileExt = '.ZIP')or (sFileExt = '.EXE') then
      begin
        //�����ļ�ʱ��ֱ�Ӵ���ҳ�򿪶�û�е�������Ի����������
        AResponseInfo.CustomHeaders.Values['Content-Disposition'] :='attachment; filename="'+extractfilename(LPathname)+'"';
      end;
    end;
  end
  else
  begin
    AResponseInfo.ContentType :='text/html;Charset=UTF-8';
    AResponseInfo.ResponseNo := 404;
    AResponseInfo.ContentText := '�Ҳ���' + ARequestInfo.Document;
  end;
//�滻 IIS
  {AResponseInfo.Server:='IIS/6.0';
  AResponseInfo.CacheControl:='no-cache';
  AResponseInfo.Pragma:='no-cache';
  AResponseInfo.Date:=Now;}
end;

constructor THttpServer.Create;
begin
  FHttpServer:= TIdHTTPServer.Create;
  FFileText := TStringList.Create;
  FHttpServer.OnCommandGet := CommandGet;
  FRootDir := ExtractFilePath(ParamStr(0)) + 'www';
  FDefaultMainPage := 'Index.html';
  FDefaultPort := 80;
end;

destructor THttpServer.Destroy;
begin
  FHttpServer.Free;
  FFileText.Free;
  inherited;
end;

function THttpServer.GetActive: Boolean;
begin
  Result := FHttpServer.Active;
end;

procedure THttpServer.SetActive(const Value: Boolean);
begin
  if FHttpServer.Active <> Value then
  begin
    if Value then
    begin
      FHttpServer.Bindings.Clear;
      FHttpServer.DefaultPort:= FDefaultPort;
    end;

    FHttpServer.Active := Value;
  end;
end;

end.
