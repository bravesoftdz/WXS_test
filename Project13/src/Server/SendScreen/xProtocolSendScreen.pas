unit xProtocolSendScreen;

interface

uses System.Types,System.Classes, xFunction, system.SysUtils, xUDPServerBase,
  xConsts, System.IniFiles, Winapi.WinInet, winsock, Graphics,
  xProtocolBase, System.Math;

const

  C_SEND_SCREEN = 1;     // ������Ļ

const
  C_SEND_PACKS_COUNT = 8000; // ÿ������Ͱ�����

type
  TProtocolSendScreen = class(TProtocolBase)

  private


  protected
    /// <summary>
    /// �������ݰ�
    /// </summary>
    function CreatePacks: TBytes; override;

  public
    constructor Create; override;
    destructor Destroy; override;

    /// <summary>
    /// �������ݰ�
    /// </summary>
    function SendData(nOrderType: Integer; ADev: TObject; sParam1, sParam2 : string) : Boolean; override;
  end;


implementation

{ TProtocolSendScreen }

constructor TProtocolSendScreen.Create;
begin
  inherited;
  IsReplay := False;
end;

function TProtocolSendScreen.CreatePacks: TBytes;
//var
//  i : Integer;
begin
//  SetLength(Result, 0);
//  if Assigned(FDev) and (FDev is TMemoryStream) then
//  begin
//    case FOrderType of
//      C_SEND_SCREEN :
//      begin
//        TMemoryStream(FDev).Position := 0;
//        SetLength(Result, TMemoryStream(FDev).Size);
//
//        repeat
//
//
//
//        until (i);
//
//        TMemoryStream(FDev).Position := 0;
//        TMemoryStream(FDev).ReadBuffer(Result[0], 3500);
//      end;
//    end;
//
//  end;
end;

destructor TProtocolSendScreen.Destroy;
begin

  inherited;
end;

function TProtocolSendScreen.SendData(nOrderType: Integer; ADev: TObject;
  sParam1, sParam2: string): Boolean;
var
  aBuf : TBytes;
  i : Integer;
  nPos : Integer;
  aSendBuf : TBytes;
  nLen : Integer;
  nPackIndex : Integer;
  nPackSign : Byte; // ����ʶ
  nRandom : Byte; // �����
  nPackCount : Byte; // ������
begin
  FOrderType := nOrderType;
  FDev := ADev;

  BeforeSend;

  SetLength(aBuf, 0);
  if Assigned(FDev) and (FDev is TMemoryStream) then
  begin
    case FOrderType of
      C_SEND_SCREEN :
      begin
        TMemoryStream(FDev).Position := 0;
        SetLength(aBuf, TMemoryStream(FDev).Size);
        TMemoryStream(FDev).Position := 0;
        TMemoryStream(FDev).ReadBuffer(aBuf[0], TMemoryStream(FDev).Size);

        nLen := Length(aBuf);

        nPackCount := Ceil(nLen / C_SEND_PACKS_COUNT);

        nPos := 0;
        Randomize;
        nRandom := Random(254);
        nPackIndex := 0;
        repeat
          nPackSign := 0;
          // ÿ�����ݰ����й̶���ͷFFAA55 + �������ͬһ��������һ�£� + ͷβ��־ + ����ţ���0��ʼ�� + ������
          // ͷβ��־��λ��ʾ���ӵ͵���λ�� �Ƿ�����ʼ�����Ƿ����м�����Ƿ��ǽ�β�� �磺$05 ������ʼ�ͽ�β��
          if nPos + C_SEND_PACKS_COUNT >= nLen then
          begin
            SetLength(aSendBuf, nLen - nPos + 7);
            nPackSign := nPackSign + 4;
          end
          else
          begin
            SetLength(aSendBuf, C_SEND_PACKS_COUNT + 7);
            nPackSign := nPackSign + 2;
          end;

          for i := 0 to Length(aSendBuf) - 1-7 do
            aSendBuf[i+7] := aBuf[i+nPos];


          if nPos = 0 then
            nPackSign := nPackSign + 1;

          aSendBuf[0] := $FF;
          aSendBuf[1] := $AA;
          aSendBuf[2] := $55;
          aSendBuf[3] := nRandom;
          aSendBuf[4] := nPackSign;
          aSendBuf[5] := nPackIndex;
          aSendBuf[6] := nPackCount;

          CommSenRev(aSendBuf, True, sParam1, sParam2);
          Sleep(10);
          nPos := nPos + C_SEND_PACKS_COUNT;
          Inc(nPackIndex);
        until (nPos >= nLen);


      end;
    end;

  end;



  AfterSend;

  if IsReplay then
    Result := IsReplied
  else
    Result := True;
end;

end.
