{===============================================================================
  �쳣����Ԫ

===============================================================================}

unit xExceptionCatch;

interface

uses System.Classes, System.SysUtils, Winapi.Windows;

type
  /// <summary>
  /// ��Ϣ����
  /// </summary>
  TMessageType = (mtNote = 0,                         //  ��
                  mtInformation = MB_ICONINFORMATION, //  ��ʾ
                  mtQuestion = MB_ICONQUESTION,       //  ѯ��
                  mtWARNING = MB_ICONWARNING,         //  ����
                  mtSTOP = MB_ICONSTOP                //  ����
                  );

/// <summary>
/// ��ȡ�ļ�
/// </summary>
function ExceptionReadFile:string;

procedure WriteMsg(sUnitName, sCode, sMsg : string );
procedure WriteSql( sSQL: string );

/// <summary>
/// ��Ϣ�쳣����ʾ�쳣��Ϣ���û�����
/// </summary>
/// <param name="sUnitName">��Ԫ����</param>
/// <param name="MsgType">��ʾ��Ϣ����</param>
/// <param name="msgStr">��ʾ��Ϣ</param>
procedure MsgException(sUnitName:string; MsgType : TMessageType;
  sMsgStr : string );

/// <summary>
/// ��¼�쳣���쳣��Ϣ��¼���ļ��У�����ʾ���û�����
/// </summary>
/// <param name="sUnitName">��Ԫ����</param>
/// <param name="sCode">�쳣����</param>
/// <param name="sExcStr">�쳣��Ϣ</param>
procedure RecordException(sUnitName,sCode, sExcStr : string );

/// <summary>
/// Sql�쳣���쳣��Ϣ��¼���ļ��У�����ʾ���û�����
/// </summary>
/// <param name="sUnitName">��Ԫ����</param>
/// <param name="sCode">�쳣����</param>
/// <param name="sExcStr">�쳣��Ϣ</param>
/// <param name="sSqlStr">ִ�е�Sql���</param>
procedure SQLException(sUnitName,sCode, sExcStr, sSqlStr : string );

implementation

{ TEXCEPTION_CATCH }

function ExceptionReadFile:string;
var
  s,s2:string;
  FFile : TextFile;
begin
  s:='';
  Result:='';
  AssignFile(FFile,'Exception Code.txt');
  if FileExists('Exception Code.txt') then
  begin
    try
      Reset(FFile);
      while not Eof(FFile) do
      begin
        Readln(FFile, s2);
        s:=s + s2 + #13#10;
      end;
      Result:=s;
    finally
      CloseFile(FFile);
    end;
  end;    
end;

procedure MsgException(sUnitName:string;MsgType: TMessageType; sMsgStr: string);
begin
  WriteMsg(sUnitName, '-1', sMsgStr);
  MessageBox(0, PWideChar(sMsgStr), '', MB_OK + Integer(MsgType));
//  Application.MessageBox(PWideChar(sMsgStr), '', MB_OK + Integer(MsgType));
end;

procedure RecordException(sUnitName,sCode, sExcStr: string);
begin
  WriteMsg(sUnitName,sCode, sExcStr);
end;

procedure SQLException(sUnitName,sCode, sExcStr, sSqlStr: string);
begin
  WriteMsg(sUnitName,sCode, sExcStr);
  WriteSql(sSqlStr);
  MessageBox(0,PWideChar(sExcStr), '', MB_OK + MB_ICONWARNING);
end;

procedure WriteMsg(sUnitName, sCode, sMsg: string);
const
  C_SIGN = '------------------------------------------------';
var
  s : string;
  FFile : TextFile;
begin
  AssignFile(FFile,'Exception Code.txt');
  s := ExceptionReadFile;
  try
    ReWrite(FFile);

    write(FFile, s);
    Writeln( FFile, C_SIGN + C_SIGN );
    Writeln( FFile, '�쳣ʱ�䣺' + FormatDateTime('YYYY-MM-DD hh:mm:ss', Now));
    Writeln( FFile, '�쳣�ļ���' + sUnitName );
    Writeln( FFile, '�쳣���룺' + sCode );
    Writeln( FFile, '�쳣��Ϣ��' + sMsg );
  finally
    CloseFile(FFile);
  end;
end;

procedure WriteSql(sSQL: string);
var
  s : string;
  FFile : TextFile;
begin
  AssignFile(FFile,'Exception Code.txt');
  s := ExceptionReadFile;

  try
    ReWrite(FFile);
    write(FFile, s);
    Write( FFile, 'SQL ��Ϣ��' + sSQL );
  finally
    CloseFile(FFile);
  end;
end;

end.

