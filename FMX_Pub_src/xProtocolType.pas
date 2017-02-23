unit xProtocolType;

interface

const

  /// <summary>
  /// �������ֵ�� ��������ó������ֵ
  /// </summary>
  C_MAX_ORDER = 10000;

  {ͨ��}
  C_GET_VERSION       = 1; // ��ȡ�汾
  C_SET_ADDR          = 2; // ��ȡ�汾

  {���� ʱ��}
  C_VOICE_PLAY        = 10; // ��������
  C_TIME_SET          = 11; // ����ʱ��


/// <summary>
/// ��ȡ������
/// </summary>
function GetControlCode(const nCommType: Integer) : Integer;

/// <summary>
/// ��ȡ�豸��
/// </summary>
function GetDevCode(const nCommType: Integer) : Integer;

/// <summary>
/// ��ȡ��������
/// </summary>
function GetCommTypeStr(const nCommType: Integer):string;

/// <summary>
/// �����豸����������ȡ��������
/// </summary>
function GetCommType(nDevCode, nControlCode : Integer) : Integer;

implementation

function GetCommType(nDevCode, nControlCode : Integer) : Integer;
var
  i: Integer;
  nC1,nC2 : Integer;
begin
  Result := -1;
  for i := 0 to C_MAX_ORDER do
  begin
    nC1 := GetDevCode(i);
    nC2 := GetControlCode(i);

    if (nDevCode = nC1) and (nControlCode = nC2) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function GetControlCode(const nCommType: Integer) : Integer;
begin
  case nCommType of
    C_GET_VERSION      : Result:= $01; // ��ȡ�汾
    C_SET_ADDR         : Result:= $02; // ��ȡ�汾

    {ʱ������}
    C_TIME_SET         : Result:= $01; // ����ʱ��
    C_VOICE_PLAY       : Result:= $02; // ��������
  else
    Result := $00;
  end;
end;

function GetDevCode(const nCommType: Integer) : Integer;
begin
  {ͨ��}
  if nCommType in [0..9] then
  begin
    Result := $00;
  end
  {����ʱ��}
  else if nCommType in [10..19] then
  begin
    Result := $01;
  end
  else
  begin
    Result := 0;
  end;
end;


function GetCommTypeStr(const nCommType: Integer):string;
var
  i : Integer;
begin
  case nCommType of
    C_GET_VERSION : Result:= '��ȡ�汾';

    {ʱ������}
    C_TIME_SET         : Result:= '����ʱ��';
    C_VOICE_PLAY        : Result:= '��������';

  else
    Result := 'δ����';
  end;

  if Length(Result) < 25 then
  begin
    for i := Length(Result) to 25 do
    begin
      Result := Result + ' ' ;
    end;
  end;
end;

end.
