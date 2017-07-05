unit xClientType;

interface

uses System.Classes, System.SysUtils;

type
  /// <summary>
  /// ����״̬
  /// </summary>
  TClientState = (esDisconn,      // δ����
                  esConned,       // �Ѿ�����
                  esLogin,        // �ѵ�¼
                  esWorkReady,    // ׼���ÿ���
                  esWorking,      // ���ڿ���
                  esWorkFinished, // ����
                  esPractise,     // ������ϰ
                  esTrain         // ������ѵ
                  );
/// <summary>
/// ״̬ת�����ַ���
/// </summary>
function ClientStateStr(AState : TClientState) : string;

type
  /// <summary>
  /// �ͻ�������״̬
  /// </summary>
  TClientConnState = (ccsDisConn,  // δ����
                      ccsConned    // ������
                      );
function ClientConnStateStr(AState : TClientConnState) : string;

type
  /// <summary>
  /// ��¼״̬
  /// </summary>
  TLoginState = (lsLogin, // �ѵ�¼
                 lsLogOut // δ��¼
                 );
function LoginStateStr(AState : TLoginState) : string;

type
  /// <summary>
  /// �ͻ��˵�¼״̬
  /// </summary>
  TClientWorkState = (cwsNot,          // δ����
                      cwsTrain,        // ������ѵ
                      cwsPractise,     // ������ϰ
                      cwsExamReady,    // ׼���ÿ���
                      cwsExamDoing,    // ���ڴ��
                      cwsExamFinished  // �������
                      );
function ClientWorkStateStr(AState : TClientWorkState) : string;

/// <summary>
/// ���
/// </summary>
function BuildData(aData: TBytes): TBytes;

/// <summary>
/// �������
/// </summary>
function AnalysisRevData(aRevData : TBytes) : TBytes;

implementation

function ClientWorkStateStr(AState : TClientWorkState) : string;
begin
  case AState of
   cwsTrain :       Result := '������ѵ';
   cwsPractise:     Result := '������ϰ';
   cwsExamReady:    Result := '׼���ÿ���';
   cwsExamDoing:    Result := '���ڴ���';
   cwsExamFinished: Result := '�ѽ���';
  else
    Result := 'δ����';
  end;
end;

function LoginStateStr(AState : TLoginState) : string;
begin
  case AState of
   lsLogin : Result := '�ѵ�¼';
   lsLogOut: Result := 'δ��¼';
  else
    Result := 'δ����';
  end;
end;

function ClientConnStateStr(AState : TClientConnState) : string;
begin
  case AState of
   ccsDisConn : Result := 'δ����';
   ccsConned  : Result := '������';
  else
    Result := 'δ����';
  end;
end;

function BuildData(aData: TBytes): TBytes;

var
  nByte, nCode1, nCode2 : Byte;
  i : Integer;
  nFixCodeCount, nIndex : Integer; // ת���ַ�����

  function IsFixCode(nCode : Integer) : Boolean;
  begin
    Result := nCode in [$7F, $7E];


    if Result then
    begin
      Inc(nFixCodeCount);
      nCode1 := $7F;
      if nCode = $7E then
        nCode2 := $01
      else
        nCode2 := $02;
    end;
  end;
begin
  nByte := 0;
  nFixCodeCount := 0;

  for i := 0 to Length(aData) - 1 do
  begin
    IsFixCode(aData[i]); // ����ת���ַ�����
    nByte := (nByte + aData[i])and $FF; // ����У����
  end;
  IsFixCode(nByte); // �ж�У�����Ƿ���ת���ַ�

  SetLength(Result, Length(aData) + nFixCodeCount + 3);
  Result[0] := $7E;
  Result[Length(Result)-1] := $7E;
  Result[Length(Result)-2] := nByte;

  nIndex := 1;

  for i := 0 to Length(aData) - 1 do
  begin
    if IsFixCode(aData[i]) then
    begin
      Result[nIndex] := nCode1;
      Result[nIndex+1] := nCode2;

      Inc(nIndex, 2);
    end
    else
    begin
      Result[nIndex] := aData[i];
      Inc(nIndex);
    end;
  end;
end;

function AnalysisRevData(aRevData : TBytes) : TBytes;
var
  aBuf : TBytes;
  i : Integer;
  nCS : Byte;

  procedure AddByte(nByte : Byte);
  var
    nLen : Integer;
  begin
    nLen := Length(aBuf);
    SetLength(aBuf, nLen + 1);
    aBuf[nLen] := nByte;
  end;
begin
  Result := nil;
  // ����ת���ַ�
  for i := 0 to Length(aRevData) - 1 do
  begin
    if (aRevData[i] = $7F) and (aRevData[i+1] = $01) then
    begin

      AddByte($7E);
    end
    else if (aRevData[i] = $7F) and (aRevData[i+1] = $02) then
    begin
      AddByte($7F);
    end
    else
    begin
      AddByte(aRevData[i]);
    end;
  end;

  // ����У���
  nCS := 0;
  for i := 1 to Length(aBuf) - 3 do
  begin
    nCS := (nCS + aBuf[i]) and $FF;
  end;

  if nCS = aBuf[Length(aBuf)-2] then
  begin
    Result := aBuf;
  end;
end;

function ClientStateStr(AState : TClientState) : string;
begin
  case AState of
   esDisconn      :   Result := 'δ����';
   esConned       :   Result := '�Ѿ�����';
   esLogin        :   Result := '�ѵ�¼';
   esWorkReady    :   Result := '׼���ÿ���';
   esWorking      :   Result := '���ڿ���';
   esWorkFinished :   Result := '����';
   esPractise     :   Result := '������ϰ';
   esTrain        :   Result := '������ѵ';
  else
    Result := 'δ����';
  end;
end;


end.
