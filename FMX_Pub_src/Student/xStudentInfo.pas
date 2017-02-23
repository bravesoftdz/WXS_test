{===============================================================================
  Copyright(c) 2014, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ѧԱ��Ϣ��Ԫ

  + TStudentInfo  ѧԱ��Ϣ��

===============================================================================}
unit xStudentInfo;

interface

uses
  System.Classes, System.SysUtils;

type
  /// <summary>
  /// ѧԱ��Ϣ��
  /// </summary>
  TStudentInfo = class(TPersistent)
  private
    FstuTel: string;
    FstuNumber: LongInt;
    FstuSex: string;
    FstuArea: string;
    FstuLogin: string;
    FstuName: string;
    FstuPwd: string;
    FstuIdCard: string;
    FstuNote2: string;
    FstuNote1: string;
  public
    /// <summary>
    /// ѧԱ���
    /// </summary>
    property stuNumber : LongInt read FstuNumber write FstuNumber;

    /// <summary>
    /// ѧԱ����
    /// </summary>
    property stuName : string read FstuName write FstuName;

    /// <summary>
    /// �Ա�
    /// </summary>
    property stuSex : string read FstuSex write FstuSex;

    /// <summary>
    /// ���֤��
    /// </summary>
    property stuIdCard : string read FstuIdCard write FstuIdcard;

    /// <summary>
    /// ��¼��
    /// </summary>
    property stuLogin : string read FstuLogin write FstuLogin;

    /// <summary>
    /// ��¼����
    /// </summary>
    property stuPwd : string read FstuPwd write FstuPwd;

    /// <summary>
    /// ��������
    /// </summary>
    property stuArea : string read FstuArea write FstuArea;

    /// <summary>
    /// ��ϵ�绰
    /// </summary>
    property stuTel : string read FstuTel write FstuTel;

    /// <summary>
    /// ��ע1
    /// </summary>
    property stuNote1 : string read FstuNote1 write FstuNote1;

    /// <summary>
    /// ��ע2
    /// </summary>
    property stuNote2 : string read FstuNote2 write FstuNote2;

    constructor Create;

    /// <summary>
    /// ���ƶ���
    /// </summary>
    procedure Assign(Source : TPersistent); override;

    /// <summary>
    /// ��ʼ������
    /// </summary>
    procedure stuDataInio;
  end;
implementation

{ TStuDentInfo }

procedure TStuDentInfo.Assign(Source: TPersistent);
begin
  Assert(Source is TStuDentInfo);

  FstuTel    := TStuDentInfo(Source).stuTel;
  FstuNumber := TStuDentInfo(Source).stuNumber;
  FstuSex    := TStuDentInfo(Source).stuSex;
  FstuArea   := TStuDentInfo(Source).stuArea;
  FstuLogin  := TStuDentInfo(Source).stuLogin;
  FstuName   := TStuDentInfo(Source).stuName;
  FstuPwd    := TStuDentInfo(Source).stuPwd;
  FstuIdCard := TStuDentInfo(Source).stuIdCard;
  FstuNote2  := TStuDentInfo(Source).stuNote2;
  FstuNote1  := TStuDentInfo(Source).stuNote1;
end;

constructor TStuDentInfo.Create;
begin
  stuDataInio;
end;

procedure TStuDentInfo.stuDataInio;
begin
  FstuTel    := '';
  FstuNumber := 0;
  FstuSex    := '';
  FstuArea   := '';
  FstuLogin  := '';
  FstuName   := '';
  FstuPwd    := '';
  FstuIdCard := '';
  FstuNote2  := '';
  FstuNote1  := '';
end;

end.
