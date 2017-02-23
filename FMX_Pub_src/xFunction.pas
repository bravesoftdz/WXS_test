{===============================================================================
  ���ú��� 
  + function GetSpecialFolder  ��ȡWindowsϵͳ�ļ���
  + function GetTempFolder     ��ȡWindows��ʱ�ļ���
  + procedure WaitForSeconds   ��ʱ�ȴ��������ȴ�ʱ���������¼�
  + function IntToBCD          ��������ת����BCD��
  + function IntToByte         ������������ȡĳһ���ֽ�
  + function CalCS             ����CSУ����
  + function BCDToDouble       BCD��ת��Double, nDigitalΪС��λ��
  + procedure WriteRunLog      �������м�¼
  + function CheckAndCreateDir ����ļ����Ƿ���ڣ������ڴ���
  + function GetFileVersion    ��ȡ�����ļ��汾��Ϣ
  + function CheckPath         ���Ŀ¼��������
  + function GetFloatIntLength ��ȡ���������������ֳ��ȣ�����������
  + function FileCopy          �ļ������������ʾ���ȣ��ļ������ֳ�100�ν��п���
  + procedure ClearStringList  ��� TStringList / TStrings �� �ڲ�����
  + function ApplicationExists �жϳ����Ƿ��Ѿ�����
  + function GetPartValue      ��ȡ��spart�ָ��ֵ�б�
  + function IntToLenStr       ����ת���ɹ̶����ȵ��ַ������������ֵ��������ʾ��������ֵ
  + function FormatDT          ��ʽ��ʱ��
  + function GetPointLen       ��ȡ����֮��ľ���
  + function GetMD5            MD5����
  + function CheckPortStatus     ��ѯ�˿�״̬
  + procedure GetAllCommPorts    ��ȡ���ж˿��б�
  + function PortStatusToStr     �˿�״̬ת�����ַ���
  + function PortNameToSN        ������ת���ɴ��ں�
  + function PortSNToName        ���ں�ת���ɴ�����
  + function StrToPacks          �ַ���ת�������ݰ� '12 34' ---> $31 32 20 33
  + function PacksToStr          ���ݰ�ת�����ַ��� $31 32 20 33 ---> '12 3'
  + function StrToBCDPacks       �ַ���ת��BCD���ݰ� '12 34'��'1234' ---> $12 34
  + function BCDPacksToStr       BCD���ݰ�ת�����ַ��� $12 34 ---> '12 34'
  + procedure HintMessage        �Զ�����Ϣ��ʾ����

===============================================================================}
unit xFunction;

interface

uses System.Classes,EncdDecd, IOUtils, IdHash, IdGlobal,
   Math,  StrUtils, DateUtils, IdHashMessageDigest, xVCL_FMX,

  {$IFDEF MSWINDOWS}
  Winapi.Windows, ShlObj, CommCtrl, Messages,
  {$ENDIF}

  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,FMX.Helpers.Android,
  Androidapi.Helpers,
  {$ENDIF}

  {$IFDEF IOS}
  FMX.Platform.iOS,iOSapi.Foundation,Macapi.ObjectiveC,
  {$ENDIF}

  {$IFDEF MACOS}
  FMX.Platform.Mac, Macapi.Foundation, Macapi.ObjectiveC,
  {$ENDIF}
  System.SysUtils;

/// <summary>
/// ��ȡ�ļ�·�� �������򴴽�
/// </summary>
function FilePath(sFile:String = ''):String;

/// <summary>
/// BCD�ֽ�ת���������ֽ�
/// </summary>
function BCDToByte( n : Byte ) : Byte;

/// <summary>
/// ��ʱ�ȴ��������ȴ�ʱ���������¼�
/// </summary>
/// <param name="nMSeconds">����</param>
procedure WaitForSeconds( nMSeconds : Cardinal );

/// <summary>
/// ��������ת����BCD��
/// </summary>
/// <param name="nNum">��������</param>
/// <param name="nLen">BCD���ֽڳ���</param>
/// <returns>BCD���ֽ�����</returns>
function IntToBCD( nNum, nLen : Integer): TBytes; overload;
function IntToBCD( nNum : Int64; nLen : Integer): TBytes; overload;

/// <summary>
/// ������������ȡĳһ���ֽ�
/// </summary>
/// <param name="n">��������</param>
/// <param name="nPos">�ӵ�λ��ʼ�ĵ�*���ֽ�, nPos = 0, 1, 2, 3...</param>
/// <returns>�ֽ�����</returns>
function IntToByte( const n, nPos : Integer ) : Byte; overload;
function IntToByte( const n : Int64; const nPos : Integer ) : Byte; overload;

/// <summary>
/// ����CSУ����
/// </summary>
/// <param name="AData">�ֽ�����</param>
/// <param name="AFrom">��ʼ�ֽ�</param>
/// <param name="ATo">��ֹ�ֽڣ�-1Ϊ��󳤶�</param>
function CalCS( AData : TBytes; AFrom : Integer = 0; ATo : Integer = -1 ) : Byte;

/// <summary>
/// BCDת��Double, nDigitalΪС��λ��
/// </summary>
/// <param name="aBCD"></param>
/// <param name="nDigital"></param>
/// <returns></returns>
function BCDToDouble( aBCD : TBytes; nDigital : Integer ) : Double;

/// <summary>
/// �������м�¼
/// </summary>
/// <param name="sLogFileName">���м�¼�ļ�</param>
/// <param name="sRunMsg">���м�¼</param>
procedure WriteRunLog( sLogFileName : string; sRunMsg : string );

/// <summary>
/// ����ļ����Ƿ���ڣ������ڴ���
/// </summary>
/// <param name="sDirPath">�ļ���·��</param>
/// <returns>�Ƿ����</returns>
function CheckAndCreateDir( sDirPath : string ) : Boolean;

/// <summary>
/// ��ȡ�ļ��汾
/// </summary>
/// <param name="sFileName">�ļ��� ����ǿ� ���ȡ��ǰ����汾</param>
/// <returns>�ļ��汾��</returns>
function GetFileVersion(sFileName : string = ''):string;

/// <summary>
/// ���Ŀ¼��������
/// ���� c:\windows ������·��Ϊ c:\windows\
/// </summary>
/// <param name="sPath">ԭ·��</param>
/// <param name="sDelim">�ָ��� \ �� /</param>
/// <returns>����·��</returns>
function CheckPath( sPath, sDelim : string ) : string;

/// <summary>
/// ��ȡ���������������ֳ��ȣ�����������
/// </summary>
/// <param name="d">��������</param>
/// <returns>�������ֳ���</returns>
function GetFloatIntLength( d : Double ) : Integer;

/// <summary>
/// ��� TStringList / TStrings �� �ڲ�����
/// </summary>
/// <param name="sl">TStringList / TStrings</param>
procedure ClearStringList( sl : TStringList );

/// <summary>
/// ��ȡ��spart�ָ��ֵ�б�
/// </summary>
/// <param name="slValue">ֵ�б�</param>
/// <param name="sText">ֵ�ַ���</param>
/// <param name="sPart">�ָ���</param>
/// <returns>�Ƿ�ɹ�</returns>
function GetPartValue( slValue : TStringList; const sText : string;
  const sPart : Char ): Boolean;

/// <summary>
/// ����ת���ɹ̶����ȵ��ַ������������ֵ��������ʾ��������ֵ
/// </summary>
/// <param name="nValue">����ֵ</param>
/// <param name="nStrLen">ת���󳤶�</param>
/// <param name="sStr">�������Ȳ�����ַ� Ĭ��Ϊ'0'</param>
/// <returns></returns>
function IntToLenStr(nValue: Int64; nStrLen : Integer; sStr : string = '0'): string;

/// <summary>
/// ��ȡ�ֽڵĵڼ�λ��ֵ
/// </summary>
/// <param name="nByte">�����ֽ�</param>
/// <param name="nIndex">�ֽ��еĵڼ�λ 0-7</param>
/// <returns>�ֽ��еĵڼ�λ��ֵ 0����1</returns>
function GetByteBitValue(nByte, nIndex : Byte) : Byte;

/// <summary>
/// ��ʽ��ʱ��
/// </summary>
function FormatDT(sFormat : string; dtValue : TDateTime) : string;

/// <summary>
/// ��ȡ�б�ɾ��ĳ���󣬵�ǰ������� ��һ���б�ɾ��һ�к���������ţ�
/// </summary>
/// <param name="nCount">�б�����</param>
/// <param name="nDelIndex">��ǰ������ ��0��ʼ</param>
/// <returns>����ɾ���������� ��0��ʼ</returns>
function GetDelIndex(nCount, nDelIndex : Integer) : Integer;

/// <summary>
/// ��ȡ����֮��ľ���
/// </summary>
function GetPointLen(dX1, dY1, dX2, dY2 : Double) : Double;

/// <summary>
/// MD5����
/// </summary>
function GetMD5(const sStr: String): String;

type
  /// <summary>
  /// ����״̬
  /// </summary>
  TPORT_STATUS = (psNone, psAvail, psBusy);

/// <summary>
/// ��ѯ�˿�״̬
/// </summary>
function CheckPortStatus(nPort: Integer): TPORT_STATUS;

/// <summary>
/// ��ȡ���д����б�
/// </summary>
procedure GetAllCommPorts(APortList : TStrings);

/// <summary>
/// ��ȡ���д�������
/// </summary>
function GetAllCommPortsStr : string;

/// <summary>
/// �˿�״̬ת�����ַ���
/// </summary>
function PortStatusToStr(AStatus : TPORT_STATUS) : string;

/// <summary>
/// ������ת���ɴ��ں�
/// </summary>
function PortNameToSN(sPortName: string) : Integer;

/// <summary>
/// ���ں�ת���ɴ�����
/// </summary>
function PortSNToName(nPortSN: Byte) : string;

/// <summary>
/// �ַ���ת�������ݰ� '12 3' ---> $31 32 20 33
/// </summary>
function StrToPacks( sData : string ) : TBytes;

/// <summary>
/// ���ݰ�ת�����ַ��� $31 32 20 33 ---> '12 3'
/// </summary>
function PacksToStr(aPacks: TBytes): string;

/// <summary>
/// �ַ���ת��BCD���ݰ� '12 34'��'1234' ---> $12 34
/// </summary>
function StrToBCDPacks( sData : string ) : TBytes;

/// <summary>
/// BCD���ݰ�ת�����ַ��� $12 34 ---> '12 34'
/// </summary>
function BCDPacksToStr(aPacks : TBytes): string;

/// <summary>
/// ��ʾ��Ϣ��ť����
///  hbtOk : ȷ��; hbtOkCancel: ȷ��/ȡ��; hbtYesNoCancel : ��/��/ȡ��
///  hbtYesNo : ��/��; hbtAbortRetryIgnore : ��ֹ/����/����; hbtRetryCancel:
///  ����/ȡ��;
/// </summary>
type
  THintBtnType = (hbtOk, hbtOkCancel, hbtYesNoCancel, hbtYesNo, hbtAbortRetryIgnore
              , hbtRetryCancel);

/// <summary>
/// ��ʾ��Ϣͼ������
///  hitNoThing : ��, hitHint : ��ʾ, hitInquiry : ѯ��, hitWarning :����
///  hitError : ����
/// </summary>
type
  THintIconType = (hitNoThing, hitHint, hitInquiry, hitWarning, hitError);

/// <summary>
/// ��ʾ��Ϣ��������
///  hrtOk :ȷ��, hrtCancel : ȡ��, hrtAbort : ��ֹ, hrtRetry:����
///  hrtIgnore :����, hrtYes:��,  hrtNo : ��
///  hrtNothing : �޷���
/// </summary>
type
  THintResultType = (hrtOk, hrtCancel, hrtAbort, hrtRetry, hrtIgnore,
                      hrtYes, hrtNo, hrtNothing);

/// <summary>
/// �Զ�����Ϣ��ʾ��
/// </summary>
/// <param name="nType">0:showmessage 1:messageBox   ��Windowsϵͳ��ͳһΪ:showmessage</param>
///  <param name="sText">��ʾ��Ϣ</parma>
///  <param name="sCaption">��ʾ����  nTypeΪ0�ǿ���ʡ��</param>
///  <param name="uType">MessageBox��ť����   nTypeΪ0ʱ�Ϳ���ʡ��</param>
///  <param name="uiType">MessageBoxͼ������  nTypeΪ0ʱ����ʡ��</param>
/// <returns>MessageBox��������   nTypeΪ0�ǿ���ʡ��</returns>
function HintMessage(nType : Integer; sText : string; sCaption: string = '';
                      uType: THintBtnType = hbtOk;
                      uiType : THintIconType = hitHint) : THintResultType;

implementation

function BCDPacksToStr(aPacks : TBytes): string;
var
  i : Integer;
begin
  Result := EmptyStr;

  for i := 0 to Length(aPacks) - 1 do
  begin
    if i = 0 then
      Result := Result + IntToHex( aPacks[ i ], 2 )
    else
      Result := Result + ' ' + IntToHex( aPacks[ i ], 2 );
  end;
end;

function StrToBCDPacks( sData : string ) : TBytes;
  function GetIndex( sValue, sFormat : string ) : Integer;
  begin
    Result := Pos( sFormat, sValue );
  end;

  procedure AddValue(var sAddValue : string);
  var
    nValue : Integer;
  begin
    SetLength( Result, Length( Result ) + 1 );
    TryStrToInt( '$' + sAddValue, nValue );
    Result[ Length( Result ) - 1 ] := nValue;
    sAddValue := '';
  end;
var
  s, sValue : string;
  i: Integer;

begin
  try
    SetLength( Result, 0 );

    //  ɾ���ո�
    s := StringReplace(sData ,' ','',[rfReplaceAll]);

    //  ȡֵ
    {$IFDEF ANDROID}
        for i := 0 to Length(s) - 1 do
        begin
          if s[i] <> #0 then
            sValue := sValue + s[i];

          if Length(sValue) = 2 then
            AddValue(sValue);
        end;
    {$ENDIF}

    {$IFDEF MSWINDOWS}
        for i := 1 to Length(s) do
        begin
          if s[i] <> #0 then
            sValue := sValue + s[i];

          if Length(sValue) = 2 then
            AddValue(sValue);
        end;
    {$ENDIF}

    if Length(sValue) = 1 then
      AddValue(sValue);
  except

  end;
end;

function PacksToStr(aPacks: TBytes): string;
var
  i: Integer;
begin
//  Result := StringOf(aPacks);
  Result := '';

  for i := 0 to Length(aPacks) - 1 do
    Result := Result + Char(aPacks[i]);
end;

function StrToPacks( sData : string ) : TBytes;
var
  i: Integer;
begin
//  Result := BytesOf(sData);
  SetLength(Result, Length(sData));


{$IFDEF ANDROID}
  for i := 0 to Length(Result) - 1 do
    Result[i] := ord(sData[i]);
{$ENDIF}

{$IFDEF MSWINDOWS}
  for i := 0 to Length(Result) - 1 do
    Result[i] := ord(sData[i+1]);
{$ENDIF}
end;

function PortSNToName(nPortSN: Byte) : string;
begin
  if nPortSN > 0 then
    Result := Format( 'COM%d', [ nPortSN ] )
  else
    Result := EmptyStr;
end;

function PortNameToSN( sPortName : string ) : Integer;
begin
  TryStrToInt( StringReplace(sPortName, 'COM', '', [rfIgnoreCase] ), Result);
end;

function PortStatusToStr(AStatus : TPORT_STATUS) : string;
begin
  case AStatus of
    psNone:   Result := '������';
    psAvail:  Result := '����';
    psBusy:   Result := 'ʹ����';
  end;
end;

function CheckPortStatus(nPort: Integer): TPORT_STATUS;
{$IFDEF MSWINDOWS}
var
  hComm : Cardinal;
  s : string;
begin
  s := PortSNToName( nPort );
  if s <> '' then
  begin
    hComm := CreateFile(PChar( '\\.\' + s),
                        GENERIC_READ or GENERIC_WRITE,
                        0,
                        nil,
                        OPEN_EXISTING,
                        FILE_FLAG_OVERLAPPED,
                        0);

    if GetLastError = ERROR_ACCESS_DENIED then
      Result := psBusy
    else if hComm <> 4294967295 then
    begin
      Result := psAvail;
      CloseHandle( hComm );
    end
    else
    begin
      result := psNone;
      CloseHandle( INVALID_HANDLE_VALUE );
    end;
  end
  else
  begin
    Result := psNone;
  end;

end;
{$ENDIF}
{$IFDEF ANDROID}
begin
  Result := psNone;
end;
{$ENDIF}
procedure GetAllCommPorts( APortList : TStrings );
{$IFDEF MSWINDOWS}
var
  KeyHandle: HKEY;
  ErrCode, Index: Integer;
  ValueName, Data: string;
  ValueLen, DataLen, ValueType: DWORD;
  TmpPorts: TStringList;
  i: Integer;
begin
  ErrCode := RegOpenKeyEx(
    HKEY_LOCAL_MACHINE,
    'HARDWARE\DEVICEMAP\SERIALCOMM',
    0,
    KEY_READ,
    KeyHandle);

  if ErrCode <> ERROR_SUCCESS then
  begin
    //raise EComPort.Create(CError_RegError, ErrCode);
    exit;
  end;

  TmpPorts := TStringList.Create;
  try
    Index := 0;
    repeat
      ValueLen := 256;
      DataLen := 256;
      SetLength(ValueName, ValueLen);
      SetLength(Data, DataLen);
      ErrCode := RegEnumValue(
        KeyHandle,
        Index,
        PChar(ValueName),
        {$IFDEF DELPHI_4_OR_HIGHER}
        Cardinal(ValueLen),
        {$ELSE}
        ValueLen,
          {$ENDIF}
        nil,
        @ValueType,
        PByte(PChar(Data)),
        @DataLen);

      if ErrCode = ERROR_SUCCESS then
      begin
        SetLength(Data, DataLen - 1);
        TmpPorts.Add(Data);
        Inc(Index);
      end
      else
        if ErrCode <> ERROR_NO_MORE_ITEMS then break;
          //raise EComPort.Create(CError_RegError, ErrCode);

    until (ErrCode <> ERROR_SUCCESS) ;

    TmpPorts.Sort;
    for i := 0 to TmpPorts.Count - 1 do
      APortList.Add(Trim(TmpPorts[i]));

    APortList.Insert(0, '');
  finally
    RegCloseKey(KeyHandle);
    TmpPorts.Free;
  end;
end;
{$ENDIF}
{$IFDEF ANDROID}
begin

end;
{$ENDIF}

function GetAllCommPortsStr : string;
var
  APortList : TStrings;
begin
  APortList := TStringList.Create;

  GetAllCommPorts(APortList);

  Result := APortList.Text;
  APortList.Free;
end;

function GetMD5(const sStr: String): String;
Var
   MD5: TIdHashMessageDigest5;
begin
   MD5 := TIdHashMessageDigest5.Create;
   Try
      Result := MD5.HashStringAsHex(sStr, IndyTextEncoding_UTF8).ToLower;
   finally
      MD5.Free;
   end;
end;

function GetPointLen(dX1, dY1, dX2, dY2 : Double) : Double;
begin
  Result := Sqrt(Sqr(dX2-dX1)+Sqr(dY2-dY1));
end;

function GetDelIndex(nCount, nDelIndex : Integer) : Integer;
begin
  if (nCount > nDelIndex) and (nDelIndex >= 0) then
  begin
    if nCount - nDelIndex > 1 then
    begin
      Result := nDelIndex;
    end
    else
    begin
      Result := nDelIndex - 1;
    end;
  end
  else
  begin
    if nCount > 0 then
      Result := 0
    else
      Result := -1;
  end;
end;

function FormatDT(sFormat : string; dtValue : TDateTime) : string;
var
  nHH, nMM, nSS, nMS, nDD, nMonth, nYY : Integer;
  sHH, sMM, sSS, sMS, sDD, sMonth, sYY : string;
begin
  nYY := 16;
  nMonth := 1;
  nDD := 1;
  nHH := 1;
  nMM := 1;
  nSS := 1;
  nMS := 1;

  RecodeDateTime(dtValue, nyy, nMonth, ndd, nHH, nMM, nSS, nMS);
  sYY := IntToLenStr(nyy, 2);
  sMonth := IntToLenStr(nMonth, 2);
  sDD := IntToLenStr(ndd, 2);
  sHH := IntToLenStr(nHH, 2);
  sMM := IntToLenStr(nMM, 2);
  sSS := IntToLenStr(nSS, 2);
  sMS := IntToLenStr(nMS, 2);

  if UpperCase(sFormat) = 'HH:MM:SS' then
  begin
    Result := sHH + ':' + sMM + ':' + sSS;
  end
  else if UpperCase(sFormat) = 'HHMMSS' then
  begin
    Result := sHH + sMM+ sSS;
  end
  else if UpperCase(sFormat) = 'HHMM' then
  begin
    Result := sHH + sMM;
  end
  else if UpperCase(sFormat) = 'YY-MM-DD' then
  begin
    Result := sYY + '-' + sMonth + '-' + sDD;
  end
  else if UpperCase(sFormat) = 'YY.MM.DD' then
  begin
    Result := sYY + '.' + sMonth + '.' + sDD;
  end
  else if UpperCase(sFormat) = 'YYMM' then
  begin
    Result := sYY+ sMonth;
  end
  else if UpperCase(sFormat) = 'MMDD' then
  begin
    Result := sMonth + sDD;
  end
  else if UpperCase(sFormat) = 'YYYY.MM.DD' then
  begin
    Result := '20' + sYY + '.' + sMonth + '.' + sDD;
  end
  else if UpperCase(sFormat) = 'YYMMDDHHMM' then
  begin
    Result := sYY + sMonth+ sDD + sHH + sMM;
  end
  else if UpperCase(sFormat) = 'YYMMDD' then
  begin
    Result := sYY + sMonth+ sDD;
  end
  else if UpperCase(sFormat) = 'YYYY-MM-DD HH:MM:SS' then
  begin
    Result := sYY + '-' + sMonth + '-' + sDD + ' '+ sHH + ':' + sMM + ':' + sSS;
  end
  else
  begin
    Result := FormatDateTime(sFormat, dtValue);
  end;
end;

function BCDToByte( n : Byte ) : Byte;
begin
  Result := ( n shr 4 ) * 10 + n and $F ;
end;

function GetByteBitValue(nByte, nIndex : Byte) : Byte;
begin
  if ((nByte shr nIndex) and $01) = $01 then
    Result := 1
  else
    Result := 0;
end;

function IntToLenStr(nValue: Int64; nStrLen : Integer; sStr : string): string;
var
  s : string;
  nLen : Integer;
begin
  s := IntToStr(nValue);

  nLen := nStrLen - Length(s);
  if nLen > 0 then
  begin
    Result := DupeString(sStr, nLen) + s;
  end
  else
    Result := s;
end;


function StrToBytes( sData : string ) : TBytes;
  function GetIndex( sValue, sFormat : string ) : Integer;
  begin
    Result := Pos( sFormat, sValue );
  end;
var
  s, sValue : string;
  i: Integer;
  nValue : Integer;
begin
  try
    SetLength( Result, 0 );

    //  ɾ���ո�
    s := StringReplace(sData ,' ','',[rfReplaceAll]);

    //  ȡֵ
    for i := 1 to Length(s) do
    begin
      if s[i] <> #0 then
        sValue := sValue + s[i];

      if Length(sValue) = 2 then
      begin
        SetLength( Result, Length( Result ) + 1 );
        TryStrToInt( '$' + sValue, nValue );
        Result[ Length( Result ) - 1 ] := nValue;
        sValue := '';
      end;
    end;
  except

  end;
end;

function StrToBytes1( sData : string ) : TBytes;
var
  i: Integer;
begin
  SetLength(Result, Length(sData));

  for i := 0 to Length(Result) - 1 do
    Result[i] := ord(sData[i+1]);
end;

procedure WaitForSeconds( nMSeconds : Cardinal );
var
  nTick : Cardinal;
begin
  nTick := TThread.GetTickCount;

  repeat
    MyProcessMessages;
    Sleep(1);
  until TThread.GetTickCount - nTick  > nMSeconds;
end;

function IntToBCD( nNum, nLen : Integer): TBytes;
var
  i : Integer;
begin
  SetLength( Result, nLen );

  for i := 0 to nLen - 1 do
  begin
    Result[i] := (((nNum mod 100) div 10) shl 4) + (nNum mod 10);
    nNum := nNum div 100;
  end;
end;

function IntToBCD( nNum : Int64; nLen : Integer): TBytes;
var
  i : Integer;
begin
  SetLength( Result, nLen );

  for i := 0 to nLen - 1 do
  begin
    Result[i] := (((nNum mod 100) div 10) shl 4) + (nNum mod 10);
    nNum := nNum div 100;
  end;
end;

function IntToByte( const n, nPos : Integer ) : Byte;
begin
  if nPos in [ 0..3 ] then
    Result := n shr ( 8 * nPos ) and $FF
  else
    Result := $00;
end;

function IntToByte( const n : Int64; const nPos : Integer ) : Byte;
begin
  if nPos in [ 0..7 ] then
    Result := n shr ( 8 * nPos ) and $FF
  else
    Result := $00;
end;

function CalCS( AData : TBytes; AFrom : Integer = 0; ATo : Integer = -1 ) : Byte;
var
  nFrom, nTo : Integer;
  nSum : Integer;
  i: Integer;
begin
  if Length( AData ) = 0 then
  begin
    Result := 0;
    Exit;
  end;

  // ȷ����ʼ����ֹλ��
  if AFrom < Low( AData ) then
    nFrom := Low( AData )
  else if AFrom > High( AData ) then
    nFrom := High( AData )
  else
    nFrom := AFrom;

  if ATo = -1 then
    nTo := High( AData )
  else if ATo < Low( AData ) then
    nTo := Low( AData )
  else if ATo > High( AData ) then
    nTo := High( AData )
  else
    nTo := ATo;

  // ����CS
  nSum := 0;

  for i := nFrom to nTo do
    nSum := nSum + AData[ i ];

  Result := nSum and $FF;
end;

function BCDToDouble( aBCD : TBytes; nDigital : Integer ) : Double;
var
  i : Integer;
  nInt : Integer;
begin
  Result := 0;
  nInt := 2 * Length( aBCD ) - nDigital; // ��������

  for i := 0 to High( aBCD ) do
    Result := Result + ( ( aBCD[ i ] shr 4 ) * 10 + ( aBCD[ i ] and $F ) ) *
      Power( 10, nInt - ( i + 1 ) * 2 );
end;

procedure WriteRunLog( sLogFileName : string; sRunMsg : string );
var
  fileRunLog : TextFile;
begin
  AssignFile( fileRunLog, sLogFileName );

  if not FileExists( sLogFileName ) then
    Rewrite(fileRunLog);

  try
    Append( fileRunLog );
//    Writeln( fileRunLog, PChar( FormatDateTime( 'YYYY-MM-DD hh:mm:ss:zzz',Now )
//      + #9 + sRunMsg ));

    Writeln( fileRunLog, PChar( DateTimeToStr(Now)
      + #9 + sRunMsg ));
    CloseFile( fileRunLog );
  except
  end;
end;

function CheckAndCreateDir( sDirPath : string ) : Boolean;
begin
  Result := DirectoryExists( sDirPath );

  // �ļ��в������򴴽�
  if not Result then
    Result := CreateDir( sDirPath );
end;

function GetFileVersion(sFileName: string = ''): string;
{$IFDEF MSWINDOWS}
var
  VerInfoSize, VerValueSize, Dummy: DWORD;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  sFName: string;
begin
  Result := '';

  if (sFileName <> '') and FileExists(sFileName) then
    sFName := sFileName
  else
    sFName := ParamStr(0);

  VerInfoSize := GetFileVersionInfoSize(PChar(sFName), Dummy);
  if VerInfoSize > 0 then
  begin
    GetMem(VerInfo, VerInfoSize);
    try
      if GetFileVersionInfo(PChar(sFName), 0, VerInfoSize, VerInfo) then
      begin
        VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
        with VerValue^ do
        begin
          Result := IntToStr((dwFileVersionMS shr 16) and $FFFF) + '.' + IntToStr(dwFileVersionMS and $FFFF) + '.' + IntToStr((dwFileVersionLS shr 16) and $FFFF) + '.' + IntToStr(dwFileVersionLS and $FFFF);
        end;
      end;
    finally
      FreeMem(VerInfo, VerInfoSize);
    end;
  end;
end;
{$ENDIF}

{$IFDEF ANDROID}
var PackageInfo: JPackageInfo;
    PackageName: JString;
begin
  PackageName := TAndroidHelper.Context.getPackageName;
  PackageInfo := TAndroidHelper.Context.getPackageManager.getPackageInfo(PackageName, 0);
  Result:= JStringToString(PackageInfo.versionName);
end;
{$ENDIF}

{$IF Defined(IOS) or Defined(MACOS)}
var AppNameKey: Pointer;
    AppBundle: NSBundle;
    NSAppName: NSString;
begin
  AppBundle := TNSBundle.Wrap(TNSBundle.OCClass.mainBundle);
  AppNameKey := (NSSTR('CFBundleVersion') as ILocalObject).GetObjectID;
  NSAppName := TNSString.Wrap(AppBundle.infoDictionary.objectForKey(AppNameKey));
  Result:=  UTF8ToString(NSAppName.UTF8String)+#13#10;
end;
{$ENDIF}

function CheckPath( sPath, sDelim : string ) : string;
begin
  if sPath <> EmptyStr then
  begin
    if sPath[ Length( sPath ) ] <> sDelim then
      Result := sPath + sDelim
    else
      Result := sPath;
  end;
end;

function GetFloatIntLength( d : Double ) : Integer;
var
  n : Int64;
begin
  // �������, ��ȥ��������
  n := Abs( Trunc( d ) );

  if n > 0 then
    Result := ( n - 1 )
  else
    Result := Length( IntToStr( n ) );
end;

procedure ClearStringList( sl : TStringList );
var
  i : Integer;
  AObject : TObject;
begin
  if not Assigned( sl ) then
    Exit;

  for i := 0 to sl.Count - 1 do
  begin
    AObject := sl.Objects[i];

    if Assigned(AObject) then
      AObject.Free;
  end;

  sl.Clear;
end;

function GetPartValue( slValue : TStringList; const sText : string;
  const sPart : Char ): Boolean;
var
  s : string;
  nIndex : Integer;
begin
  Result := False;
  slValue.Clear;
  if not Assigned( slValue ) then
    Exit;

  if sText = '' then
    Exit;

  s := Trim(sText);
  nIndex := Pos( sPart, s );
  while not (nIndex = 0) do
  begin
    if nindex <> 1 then
      slValue.Add(Copy(s, 0, nindex-1))
    else
      slValue.Add('');

    s := Trim(Copy(s, nIndex + 1, Length(s)- nindex + 1));
    nIndex := Pos( sPart, s );
  end;
  if (s <> '') and (s <>sPart ) then
    slValue.Add(s);

  Result := True;
end;

function FilePath(sFile:String=''):String;
var
  FList:TStrings;
  i:Integer;
  procedure CheckDir;
  begin
    if(not TDirectory.Exists(result)) then TDirectory.CreateDirectory(result);
    result:=result+PathDelim;
  end;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    Result:=TPath.GetDocumentsPath+PathDelim;
  {$ELSE}
    Result:=TPath.GetLibraryPath;
  {$ENDIF}
  if(sFile<>'') then begin
    FList:=TStringList.Create;
    FList.CommaText:=sFile;
    for i:=0 to FList.Count-1 do begin //�ж��ļ�·���Ƿ���ڣ������Զ�����
      FList[i]:=FList[i].Trim;
      if(FList[i]<>'') then begin
        Result:=Result+FList[i];
        CheckDir;
      end;
    end;
    FList.Free;
  end;
end;

function HintMessage(nType : Integer; sText : string; sCaption: string = '';
                       uType: THintbtnType = hbtOk;
                      uiType : THintIconType = hitHint) : THintResultType;
  function IconType(nType : THintIconType): Integer;
  begin
    Result := 0;

    {$IFDEF MSWINDOWS}
      case nType of
        hitHint :
          begin
            Result := MB_ICONINFORMATION;
          end;
        hitInquiry :
          begin
            Result := MB_ICONQUESTION;
          end;
        hitWarning :
          begin
            Result := MB_ICONWARNING;
          end;
        hitError :
          begin
            Result := MB_ICONSTOP;
          end;
      end;
    {$ENDIF}
  end;
{$IFDEF MSWINDOWS}
var
  nValue : Integer;
{$ENDIF}
begin
  Result := hrtNothing;
  {$IFDEF MSWINDOWS}
     if nType = 0 then
     begin
//        ShowMessage(sText);
        MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_OK + IconType(uiType));
     end
     else
     begin
      case uType of
        hbtOk:
          begin
            MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_OK + IconType(uiType));
            Result := hrtOk;
          end;
        hbtOkCancel:
          begin
            nValue := MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_OKCANCEL + IconType(uiType));
            if nValue = IDOK then
              Result := hrtOk
            else
              result := hrtCancel;
          end;
        hbtYesNoCancel:
          begin
            nValue := MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_YESNOCANCEL + IconType(uiType));
            if nValue = IDYES then
              Result := hrtYes
            else if nValue = IDNO then
              Result := hrtNo
            else
              result := hrtCancel;
          end;
        hbtYesNo:
          begin
            nValue := MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_YESNO + IconType(uiType));
            if nValue = IDYES then
              Result := hrtYes
            else
              Result := hrtNo;
          end;
        hbtAbortRetryIgnore :
          begin
            nValue := MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_ABORTRETRYIGNORE + IconType(uiType));
            if nValue = IDABORT then
              Result := hrtAbort
            else if nValue = IDRETRY then
              Result := hrtRetry
            else
              result := hrtIgnore;
          end;
        hbtRetryCancel :
          begin
            nValue := MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_RETRYCANCEL + IconType(uiType));
            if nValue = IDRETRY then
              Result := hrtRetry
            else
              Result := hrtCancel;
          end;
      end;
      end;
  {$ELSE}
//    ShowMessage(sText);
    MessageBox(0, PWideChar(sText), PWideChar(sCaption), MB_OK + IconType(uiType));
  {$ENDIF}
end;

end.


