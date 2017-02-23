{===============================================================================
  ������Ԫ 

===============================================================================}
unit xConsts;

interface

uses System.SysUtils, IniFiles;

const
  /// <summary>
  /// �ظ�����
  /// </summary>
  C_REPLY_NORESPONSE   = -1;  // δ����
  C_REPLY_CS_ERROR     = 1;   // У��λ����
  C_REPLY_CORRECT      = 2;   // ����������ȷ
  C_REPLY_PACK_ERROR   = 4;   // ���ݰ�����
  C_REPLY_CODE1_ERROR  = 5;   // �豸��1����
  C_REPLY_CODE2_ERROR  = 6;   // �豸��2����

var
{-------------��Ŀ��Ϣ-----------------}
  C_SYS_COMPANY      : string= '****��˾';
  C_SYS_WEB          : string= '';
  C_SYS_OBJECT_MODEL : string= '****�ͺ�';
  C_SYS_OBJECT_NAME  : string= '****ϵͳ';

{-------------Ȩ����Ϣ-----------------}
  /// <summary>
  /// �Ƿ��ǵ���ģʽ
  /// </summary>
  bPubIsAdmin : Boolean = False;

{-------------������Ϣ-----------------}
  /// <summary>
  /// ����·��+����
  /// </summary>
  sPubExePathName : string;

  /// <summary>
  /// �����ļ���·��
  /// </summary>
  spubFilePath : string;

  /// <summary>
  /// INI�ļ�����
  /// </summary>
  sPubIniFileName : string;

  /// <summary>
  /// �����ϢINI�ļ�����
  /// </summary>
  sPubSysIniFileName : string;

implementation

initialization
  sPubExePathName    := ParamStr(0);
  spubFilePath       := ExtractFilePath(sPubExePathName);
  sPubIniFileName    := ChangeFileExt( sPubExePathName, '.ini' );
  sPubSysIniFileName := spubFilePath + 'Config.ini';

  if sPubSysIniFileName <> '' then
  begin
    with TIniFile.Create(sPubSysIniFileName) do
    begin
      C_SYS_COMPANY      := ReadString('System', 'Company',     '****��˾');
      C_SYS_WEB          := ReadString('System', 'Web',         '');
      C_SYS_OBJECT_MODEL := ReadString('System', 'ObjectModel', '****�ͺ�');
      C_SYS_OBJECT_NAME  := ReadString('System', 'ObjectName',  '****ϵͳ');
      bPubIsAdmin        := ReadBool('System',   'IsAdmin',      False);
      free;
    end;
  end;

finalization

  if sPubSysIniFileName <> '' then
  begin
    with TIniFile.Create(sPubSysIniFileName) do
    begin
      WriteString('System',  'Company',     C_SYS_COMPANY);
      WriteString('System',  'Web',         C_SYS_WEB);
      WriteString('System',  'ObjectModel', C_SYS_OBJECT_MODEL);
      WriteString('System',  'ObjectName',  C_SYS_OBJECT_NAME);
      WriteBool('System',    'IsAdmin',     bPubIsAdmin);
      free;
    end;
  end;
end.
