{===============================================================================
  Copyright(c) 2013, 
  All rights reserved.

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
  + function GetFileFullVersion ��ȡ�����ļ��汾��Ϣ
  + function CheckPath         ���Ŀ¼��������
  + function GetFloatIntLength ��ȡ���������������ֳ��ȣ�����������
  + function FileCopy          �ļ������������ʾ���ȣ��ļ������ֳ�100�ν��п���
  + procedure ClearStringList  ��� TStringList / TStrings �� �ڲ�����
  + function ApplicationExists �жϳ����Ƿ��Ѿ�����
  + function GetPartValue      ��ȡ��spart�ָ��ֵ�б�
  + function BytesToASC        Tbytesת����string $31 32 ---> '12'
  + function BytesToPackStr    Tbytesת����string $31 32 ---> '31 32'
  + procedure PcBeep           PC���ȷ���
  + function CalCRC16          ����CRC16У����
  + function IntToLenStr       ����ת���ɹ̶����ȵ��ַ������������ֵ��������ʾ��������ֵ
  + function GetIPFromURL      ����������ȡIP��ַ


===============================================================================}

unit U_PUB_FUN;

interface

uses SysUtils, Windows, Forms, Math, ShlObj, Classes, CommCtrl, Messages,Dialogs,
  StrUtils, WinSock;

type
   P8byte  = ^Byte;

type
  /// <summary>
  /// Windowsϵͳ�ļ�������
  /// </summary>
  TSpecialFolder = (
    sfDesktop,                // <desktop>
    sfInternet,               // Internet Explorer (icon on desktop)
    sfPrograms,               // Start Menu\Programs
    sfControls,               // My Computer\Control Panel
    sfPrinters,               // My Computer\Printers
    sfPersonal,               // My Documents
    sfFavorites,              // <user name>\Favorites
    sfStartup,                // Start Menu\Programs\Startup
    sfRecent,                 // <user name>\Recent
    sfSendTo,                 // <user name>\SendTo
    sfBitBucket,              // <desktop>\Recycle Bin
    sfStartMenu,              // <user name>\Start Menu
    sfMyDocuments,            // logical "My Documents" desktop icon
    sfMyMusic,                // "My Music" folder
    sfMyVideo,                // "My Videos" folder
    sfDesktopDirectory,       // <user name>\Desktop
    sfDrives,                 // My Computer
    sfNetwork,                // Network Neighborhood (My Network Places)
    sfNethood,                // <user name>\nethood
    sfFonts,                  // windows\fonts
    sfTemplates,              // <user name>\Templates
    sfCommonStartMenu,        // All Users\Start Menu
    sfCommonPrograms,         // All Users\Start Menu\Programs
    sfCommonStartup,          // All Users\Startup
    sfCommonDesktopDirectory, // All Users\Desktop
    sfAppData,                // <user name>\Application Data
    sfPrinthood,              // <user name>\PrintHood
    sfLocalAppData,           // <user name>\Local Settings\Applicaiton Data (non roaming)
    sfALTStartup,             // non localized startup
    sfCommonALTStartup,       // non localized common startup
    sfCommonFavorites,        // All Users\Favorites
    sfInternetCache,          // <user name>\Local Settings\Temporary Internet Files
    sfCookies,                // <user name>\Cookies
    sfHistory,                // <user name>\Local Settings\History
    sfCommonAppData,          // All Users\Application Data
    sfWindows,                // GetWindowsDirectory()
    sfSystem,                 // GetSystemDirectory()
    sfProgramFiles,           // C:\Program Files
    sfMyPictures,             // C:\Program Files\My Pictures
    sfProfile,                // USERPROFILE
    sfSystemX86,              // x86 system directory on RISC
    sfProgramFilesX86,        // x86 C:\Program Files on RISC
    sfProgramFilesCommon,     // C:\Program Files\Common
    sfProgramFilesCommonX86,  // x86 Program Files\Common on RISC
    sfCommonTemplates,        // All Users\Templates
    sfCommonDocuments,        // All Users\Documents
    sfCommonAdminTools,       // All Users\Start Menu\Programs\Administrative Tools
    sfAdminTools,             // <user name>\Start Menu\Programs\Administrative Tools
    sfConnections,            // Network and Dial-up Connections
    sfCommonMusic,            // All Users\My Music
    sfCommonPictures,         // All Users\My Pictures
    sfCommonVideo,            // All Users\My Video
    sfResources,              // Resource Direcotry
    sfResourcesLocalized,     // Localized Resource Direcotry
    sfCommonOEMLinks,         // Links to All Users OEM specific apps
    sfCDBurnArea,             // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning
    sfComputersNearMe,        // Computers Near Me (computered from Workgroup membership)
    sfTemp
  );

/// <summary>
/// ��ȡWindowsϵͳ�ļ���
/// </summary>
/// <param name="SpecialFolder">Windowsϵͳ�ļ�������</param>
/// <returns>Windowsϵͳ�ļ���</returns>
function GetSpecialFolder(SpecialFolder: TSpecialFolder): string;

/// <summary>
/// ��ȡWindows��ʱ�ļ���
/// </summary>
/// <returns>Windows��ʱ�ļ���</returns>
function GetTempFolder : string;

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
/// ��ȡ�����ļ��汾��Ϣ
/// </summary>
/// <param name="sFileName">�ļ�����</param>
/// <returns>�����汾��Ϣ ����:1.0.0.0</returns>
function GetFileFullVersion( sFileName : string ) : string;

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
/// �ļ������������ʾ���ȣ��ļ������ֳ�100�ν��п���
/// </summary>
/// <param name="sFileFrom">Դ�ļ���</param>
/// <param name="sFileTo">Ŀ���ļ���</param>
/// <param name="hPB">������TProgressBar���</param>
/// <param name="sError">������Ϣ</param>
/// <returns>�����Ƿ�ɹ�</returns>
function FileCopy( const sFileFrom, sFileTo : string; hPB : THandle;
  var sError : string ) : Boolean;

/// <summary>
/// ��� TStringList / TStrings �� �ڲ�����
/// </summary>
/// <param name="sl">TStringList / TStrings</param>
procedure ClearStringList( sl : TStrings );

/// <summary>
/// �жϳ����Ƿ��Ѿ�����
/// </summary>
/// <param name="SpecialFolder"></param>
/// <returns></returns>
function ApplicationExists( AClass, ATitle : string;
  AShowIfExists : Boolean = True ) : Boolean;

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
/// �ַ���ת����Tbytes '12' ---> $12      ��U_PUB_COMM_FUN �к��������
/// </summary>
function StrToBytes( sData : string ) : TBytes;

/// <summary>
/// �ַ���ת����Tbytes '12' ---> $31 32  ��U_PUB_COMM_FUN �к��������
/// </summary>
function StrToBytes1( sData : string ) : TBytes;

/// <summary>
/// Tbytesת����string $31 32 ---> '12' ��U_PUB_COMM_FUN �к��������
/// </summary>
function BytesToASC( aBytes : TBytes ) : string;

/// <summary>
/// Tbytesת����string $31 32 ---> '31 32' ��U_PUB_COMM_FUN �к��������
/// </summary>
function BytesToPackStr( aPack: TBytes ) : string;

/// <summary>
/// PC���ȷ���
/// </summary>
/// <param name="nFreq">Ƶ��</param>
/// <param name="nDura">��������ʱ�䣨���룩</param>
procedure PcBeep(nFreq : Word = 500; nDura: Word = 1000);

/// <summary>
/// ����CRC16У����
/// </summary>
function CalCRC16(AData: array of Byte; AStart,AEnd: Integer): Word;

function iMask_Crc16(AData: TBytes; AStart, AEnd: Integer; Mask, Init: Word): Word;

/// <summary>
/// ����ת���ɹ̶����ȵ��ַ������������ֵ��������ʾ��������ֵ
/// </summary>
/// <param name="nValue">����ֵ</param>
/// <param name="nStrLen">ת���󳤶�</param>
/// <param name="sStr">�������Ȳ�����ַ� Ĭ��Ϊ'0'</param>
/// <returns></returns>
function IntToLenStr(nValue, nStrLen : Integer; sStr : string = '0'): string;

/// <summary>
/// ����XorУ����
/// </summary>
/// <param name="AData">�ֽ�����</param>
/// <param name="AFrom">��ʼ�ֽ�</param>
/// <param name="ATo">��ֹ�ֽڣ�-1Ϊ��󳤶�</param>
function CalXor( AData : TBytes; AFrom : Integer = 0; ATo : Integer = -1 ) : Byte;


///// <summary>
///// ����������ȡIP��ַ
///// </summary>
//function GetIPFromURL(sURL: string): string;

implementation

//function GetIPFromURL(sURL: string): string;
//var
//  WSAData: TWSAData;
//  HostEnt: PHostEnt;
//begin
//  WSAStartup(2, WSAData);
//  HostEnt := gethostbyname(PChar(sURL));
//
//  if Assigned(HostEnt) then
//  begin
//    with HostEnt^ do
//      Result := Format('%d.%d.%d.%d', [Byte(h_addr^[0]),
//        Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
//  end;
//
//  WSACleanup;
//end;

function CalXor( AData : TBytes; AFrom : Integer = 0; ATo : Integer = -1 ) : Byte;
var
  nFrom, nTo : Integer;
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
  Result := 0;
  for i := nFrom to nTo do
    Result := Result xor AData[ i ];
end;

function IntToLenStr(nValue, nStrLen : Integer; sStr : string): string;
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

function CalCRC16(AData: array of Byte; AStart,AEnd: Integer): Word;
const
  GENP = $A001; //����ʽ��ʽX16+X15+X2+1��1100 0000 0000 0101��
var
  crc:Word;
  i:Integer;
  tmp:Byte;
  procedure CalOneByte(AByte:Byte); //����1���ֽڵ�У����
  var
    j:Integer;
  begin
    crc:=crc xor AByte; //��������CRC�Ĵ����ĵ�8λ�������

    for j := 0 to 7 do //��ÿһλ����У��
    begin
      tmp:=crc and 1; //ȡ�����λ
      crc:=crc shr 1; //�Ĵ���������һλ
      crc:=crc and $7FFF; //�����λ��0

      if tmp=1 then //����Ƴ���λ�����Ϊ1����ô�����ʽ���
        crc:=crc xor GENP;

      crc:=crc and $FFFF;
    end;
  end;
begin
  crc := $FFFF; //�������趨ΪFFFF

  for i:=AStart to AEnd do //��ÿһ���ֽڽ���У��
    CalOneByte(AData[i]);

  Result:=crc;
end;

function iMask_Crc16(AData: TBytes; AStart,AEnd: Integer; Mask, Init: Word): Word;
var
  i, t : Integer;
  crc : Word;
  i_crc : Cardinal;
  b1 : Byte;
begin
  crc := init;

  for i := AStart to AEnd do
  begin
    b1 := AData[i];
    t := b1;
    t:= t*256;
    crc := crc xor t;
    for t := 1 to 8 do
    begin
      if ((crc and $8000) = $8000) then
      begin
        i_crc := (crc * 2) xor Mask;
        crc := word(i_crc);
      end
      else
      begin
        crc := crc *2;
      end;
    end;
  end;
  Result := crc;
end;

procedure PcBeep(nFreq, nDura: Word);
var
  VerInfo: TOSVersionInfo;
  nStart: DWord;
begin
  VerInfo.dwOSVersionInfoSize := SizeOf(VerInfo);
  GetVersionEx(VerInfo);

  if VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
    Windows.Beep(nFreq, nDura)
  else
  begin 
    Asm
      push bx
      in al,$61 
      mov bl,al 
      and al,3
      jne @@Skip 
      mov al,bl 
      or al,3
      out $61,al 
      mov al,$b6 
      out $43,al
      @@Skip: 
      mov ax,nFreq 
      out $42,al
      mov al,ah 
      out $42,al 
      pop bx
    end; 
    nStart:=GetTickCount;
    repeat
      Application.ProcessMessages;
    Until GetTickCount > nStart + nDura;
    asm
      IN AL,$61
      AND AL,$FC
      OUT $61,AL
    end;
  end;
end;

function BytesToPackStr( aPack: TBytes ) : string;
var
  i : Integer;
begin
  Result := EmptyStr;
  
  for i := 0 to High( aPack ) do
    Result := Result + ' ' + IntToHex( aPack[ i ], 2 );
end;

function BytesToASC( aBytes : TBytes ) : string;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to Length(aBytes) - 1 do
    Result := Result + Char(aBytes[i]);
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

function GetSpecialFolder(SpecialFolder: TSpecialFolder): string;
const
  SpecialFolderValues: array[TSpecialFolder] of Integer = ($0000, $0001, $0002,
    $0003, $0004, $0005, $0006, $0007, $0008, $0009, $000a, $000b, $000c, $000d,
    $000e, $0010, $0011, $0012, $0013, $0014, $0015, $0016, $0017, $0018, $0019,
    $001a, $001b, $001c, $001d, $001e, $001f, $0020, $0021, $0022, $0023, $0024,
    $0025, $0026, $0027, $0028, $0029, $002a, $002b, $002c, $002d, $002e, $002f,
    $0030, $0031, $0035, $0036, $0037, $0038, $0039, $003a, $003b, $003d, $FFFF);
var
  ItemIDList: PItemIDList;
  Buffer: array [0..MAX_PATH] of Char;
begin
  if SpecialFolder = sfTemp then
    Result := GetTempFolder
  else
  begin
    SHGetSpecialFolderLocation( 0, SpecialFolderValues[ SpecialFolder ],
      ItemIDList );
    SHGetPathFromIDList(ItemIDList, Buffer);
    Result := StrPas(Buffer);
  end;
end;

function GetTempFolder : string;
var
  Buffer : array[0..MAX_PATH] of Char;
begin
  GetTempPath( MAX_PATH, Buffer );
  Result := StrPas( Buffer );
end;

procedure WaitForSeconds( nMSeconds : Cardinal );
var
  nTick : Cardinal;
begin
  nTick := GetTickCount;

  repeat
    Application.ProcessMessages;
    Sleep(5);
  until GetTickCount - nTick  > nMSeconds;
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

function GetFileFullVersion( sFileName : string ) : string;
var
  VerValue : PVSFixedFileInfo;
  VerInfoSize, VerValueSize, Dummy : Dword;
  VerInfo : Pointer;
  V1, V2, V3, V4 : word;
begin
  Result := EmptyStr;

  if FileExists( sFileName ) then
  begin
    VerInfoSize := GetFileVersionInfoSize( Pchar( sFileName ), Dummy );

    if VerInfoSize > 0 then
    begin
      GetMem( VerInfo, VerInfoSize );
      GetFileVersionInfo( PChar( sFileName ), 0, VerInfoSize, VerInfo );
      VerQueryValue( VerInfo, '\', Pointer(VerValue), VerValueSize );

      if Assigned( VerValue ) then
      begin
        With VerValue^ do
        begin
          V1 := dwFileVersionMS shr 16;
          V2 := dwFileVersionMS and $FFFF;
          V3 := dwFileVersionLS shr 16;
          V4 := dwFileVersionLS and $FFFF;
        end;

        FreeMem(VerInfo,VerInfoSize);
        Result := IntToStr(V1) + '.' + IntToStr(V2) + '.' + IntToStr(V3) + '.' +
          IntToStr(V4);
      end;
    end
    else
      Result := EmptyStr;
  end
  else
    Result := EmptyStr;
end;

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

function FileCopy( const sFileFrom, sFileTo : string; hPB : THandle;
  var sError : string ) : Boolean;
const
  C_COPY_DIV = 100;  // �����ֶ���
var
  fsFrom, fsTo : TFileStream; // �ļ���
  nCopyLen : Int64;  // �ѿ����ļ��ĳ���
  nDivLen  : Int64;  // �ֶο����ĳ���
begin
  try
    fsFrom := TFileStream.Create( sFileFrom, fmOpenRead or fmShareDenyWrite );

    try
      // ���Ŀ���ļ����ڣ�ɾ��
      if FileExists( sFileTo ) then
        if not DeleteFile( PWideChar( sFileTo + #0 ) ) then
          raise Exception.Create( 'Ŀ���ļ��Ѵ���, ���Ҳ��ܸ���' );

      fsTo := TFileStream.Create( sFileTo, fmCreate or fmOpenWrite );

      // �������ʾ���ȣ�ֱ�ӿ���
      if hPB = 0 then
      begin
        fsTo.CopyFrom( fsFrom, fsFrom.Size );
      end
      else
      begin
        // ���ļ��ֳ�100�ν��п���
        nDivLen := fsFrom.Size div C_COPY_DIV;
        nCopyLen := 0;

        // ������Ĭ��ʹ��Ĭ������
        // ���ý�������ʼλ��
        SendMessage( hPB, PBM_SETPOS, 0, 0 );

        // �ֶο����ļ�
        repeat
          if nCopyLen + nDivLen < fsFrom.Size then
          begin
            nCopyLen := nCopyLen + fsTo.CopyFrom( fsFrom, nDivLen );
            SendMessage( hPB, PBM_STEPIT, 0, 0 );     // ����+1
            Application.ProcessMessages;
          end
          else
          begin
            fsTo.CopyFrom( fsFrom, fsFrom.Size - nCopyLen );
            nCopyLen := fsFrom.Size;
            SendMessage( hPB, PBM_SETPOS, C_COPY_DIV, 0 );  // ������ʾ���
            Application.ProcessMessages;
          end;
        until nCopyLen = fsFrom.Size;
      end;

      fsFrom.Free;
      fsTo.Free;
      Result := True;
    except
      on e: Exception do
      begin
        sError := e.Message;
        fsFrom.Free;
        Result := False;
      end;
    end;
  except
    on e: Exception do
    begin
      sError := e.Message;
      Result := False;
    end;
  end;
end;

procedure ClearStringList( sl : TStrings );
var
  i : Integer;
begin
  if not Assigned( sl ) then
    Exit;


  for i := 0 to sl.Count - 1 do
    if Assigned( sl.Objects[ i ] ) then
      sl.Objects[ i ].Free;

  sl.Clear;  
end;

function ApplicationExists( AClass, ATitle : string;
  AShowIfExists : Boolean = True ) : Boolean;
var
  h : THandle;
  pClass, pTitle : PWideChar;
begin
  if Trim( AClass ) <> EmptyStr then
    pClass := PWideChar( AClass )
  else
    pClass := nil;

  if Trim( ATitle ) <> EmptyStr then
    pTitle := PWideChar( ATitle )
  else
    pTitle := nil;

  h := FindWindow( pClass, pTitle );

  Result := h <> 0;

  if Result and AShowIfExists then
  begin
    //��ԭ����λ�úʹ�С�ָ����ڲ�����
    windows.ShowWindow( h, SW_RESTORE );
    windows.SetForegroundWindow( h );
    windows.SetActiveWindow( h );
  end;
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

  s := sText;
  nIndex := Pos( sPart, s );
  while not (nIndex = 0) do
  begin
    if nindex <> 1 then
      slValue.Add(Copy(s, 0, nindex-1))
    else
      slValue.Add('');

    s := Copy(s, nIndex + 1, Length(s)- nindex + 1);
    nIndex := Pos( sPart, s );
  end;
  if (s <> '') and (s <>sPart ) then
    slValue.Add(s);

  Result := True;
end;

end.
