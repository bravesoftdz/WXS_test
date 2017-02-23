unit xProtocolPacks;

interface

uses System.Types, xTypes, xConsts, System.Classes, xFunction,
  system.SysUtils;

type
  /// <summary>
  /// ͨѶЭ�����ݰ�������
  /// </summary>
  TProtocolPacks = class
  private

  protected

    {**************************���ɷ������ݰ�******************************}
    function PackNoData: TBytes;                           // ����û�����������

//    /// <summary>
//    /// �������ݰ�
//    /// </summary>
//    function CreatePacks: TBytes;

    function CreatePackRsetTime: TBytes; virtual;                //  �㲥Уʱ
    function CreatePackReadData: TBytes; virtual;                //  ������
    function CreatePackReadNextData: TBytes; virtual;abstract;   //  ����������
    function CreatePackReadAddr: TBytes; virtual;abstract;       //  ��ͨ�ŵ�ַ
    function CreatePackWriteData: TBytes;virtual;abstract;       //  д����
    function CreatePackWriteAddr: TBytes;virtual;                //  дͨ�ŵ�ַ
    function CreatePackFreeze: TBytes; virtual;                  //  ��������
    function CreatePackChangeBaudRate: TBytes; virtual;          //  �Ĳ�ͨѶ����
    function CreatePackChangePWD: TBytes;virtual;abstract;       //  ������
    function CreatePackClearMaxDemand: TBytes;virtual;abstract;  //  �����������
    function CreatePackClearData: TBytes;virtual;                //  �������
    function CreatePackClearEvent: TBytes;virtual;               //  �¼�����
    function CreatePackSetWOutType: TBytes;virtual;abstract;     //  ���ö๦�ܿ�
    function CreatePackIdentity: TBytes;virtual;abstract;         //  �ѿ�
    function CreatePackOnOffControl: TBytes;virtual;abstract;         //  �ѿ�



    {**************************����Ӧ�����ݰ�******************************}
//    {S25-У����}
//    function ReplyPackS25_CALIBRATOR_GET_TIME   : TBytes; //��ȡʱ��









    {**************************�������ݰ�******************************}

//    procedure ParseVersion(ADevice: TObject; APack : TBytes);    // �����汾


    {���ʲ�ѯ��}
//    procedure ParsePackSTATE_GET_VALUE(APowerStatus : TPOWER_STATUS; APack : TBytes);//������ȡ��ѹ�����ǶȲ���ֵ











//    /// <summary>
//    /// ˢ�°�ͷ��β
//    /// </summary>
//    procedure RefreshHeadEnd(nCmdType: Integer);

    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure ParsePack(nCmdType: Integer; ADevice: TObject; APack : TBytes); virtual;


//    /// <summary>
//    /// ��ȡͨѶ��ַ
//    /// </summary>
//    function GetAddr(nCmdType: Integer; ADevice: TObject) : Byte;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    procedure CreatePacks(var aDatas: TBytes; nCmdType: Integer; ADevice: TObject);virtual;

    /// <summary>
    /// ���ɻظ����ݰ�
    /// </summary>
    procedure CreateReplyPacks(var aDatas: TBytes; nCmdType: Integer; ADevice: TObject);virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

//    /// <summary>
//    /// �������ݰ�
//    /// </summary>
//    function ReSetPacks(nCmdType: Integer; ADevice: TObject;aDatas: TBytes;
//      bIsReply : Boolean = False; bIsReplyRight : Boolean = True):TBytes;

    /// <summary>
    /// ��ȡ���ͻظ���������ݰ�
    /// </summary>
    function GetReplyPacks(nCmdType: Integer; ADevice: TObject; APacks : TBytes) : TBytes; virtual;

    /// <summary>
    /// ��ȡ���͵����ݰ�
    /// </summary>
    function GetPacks( nCmdType: Integer; ADevice: TObject ): tbytes; virtual;

    /// <summary>
    /// �������յ����ݰ�
    /// </summary>
    function RevPacks(nCmdType: Integer; ADevice: TObject; APack: TBytes): Integer;virtual;

  end;
var
  AProtocolPacks : TProtocolPacks;

implementation

{ TProtocolPacks }

constructor TProtocolPacks.Create;
begin

end;

function TProtocolPacks.CreatePackChangeBaudRate: TBytes;
begin

end;

function TProtocolPacks.CreatePackClearData: TBytes;
begin

end;

function TProtocolPacks.CreatePackClearEvent: TBytes;
begin

end;

function TProtocolPacks.CreatePackFreeze: TBytes;
begin

end;

function TProtocolPacks.CreatePackReadData: TBytes;
begin

end;

function TProtocolPacks.CreatePackRsetTime: TBytes;
begin

end;

procedure TProtocolPacks.CreatePacks(var aDatas: TBytes; nCmdType: Integer;
  ADevice: TObject);
begin

end;

//function TProtocolPacks.CreatePacks: TBytes;
//begin
//
//end;

function TProtocolPacks.CreatePackWriteAddr: TBytes;
begin

end;

procedure TProtocolPacks.CreateReplyPacks(var aDatas: TBytes; nCmdType: Integer;
  ADevice: TObject);
begin

end;

destructor TProtocolPacks.Destroy;
begin

  inherited;
end;

function TProtocolPacks.GetPacks(nCmdType: Integer; ADevice: TObject): tbytes;
begin
  CreatePacks(Result, nCmdType, ADevice);
end;

function TProtocolPacks.GetReplyPacks(nCmdType: Integer; ADevice: TObject;
  APacks: TBytes): TBytes;
begin

end;

function TProtocolPacks.PackNoData: TBytes;
begin

end;

procedure TProtocolPacks.ParsePack(nCmdType: Integer; ADevice: TObject;
  APack: TBytes);
begin

end;

function TProtocolPacks.RevPacks(nCmdType: Integer; ADevice: TObject;
  APack: TBytes): Integer;
begin
  Result := 0;
end;

end.
