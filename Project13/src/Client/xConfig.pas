unit xConfig;

interface

uses System.SysUtils, IniFiles, xConsts;

var
  /// <summary>
  /// ���ݿ������IP��ַ
  /// </summary>
  sPubDBServerIP : string;

  /// <summary>
  /// ���ݿ�������˿�
  /// </summary>
  sPubDBServerPort : Integer;

implementation

initialization
  if sPubIniFileName <> '' then
  begin
    with TIniFile.Create(sPubIniFileName) do
    begin
      sPubDBServerIP   := ReadString('Option', 'DBServerIP', '');
      sPubDBServerPort := ReadInteger('Option', 'DBServerPort', 15000);

      free;
    end;
  end;

finalization

  if sPubSysIniFileName <> '' then
  begin
    with TIniFile.Create(sPubSysIniFileName) do
    begin
      WriteString('Option',  'DBServerIP',   sPubDBServerIP);
      WriteInteger('Option', 'DBServerPort', sPubDBServerPort);

      free;
    end;
  end;
end.
