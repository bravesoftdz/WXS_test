unit FrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,IniFiles, xFunction, xConsts,
  xStudentAction, xStudentInfo, xClientControl, xClientType, xTCPClient,
  xUDPClient1;

const
  /// <summary>
  /// �ͻ��˵�½��ʱʱ��
  /// </summary>
  C_LOGIN_TIMEOUT  = 1500;

type
  TfStudentLogin = class(TForm)
    lbl2: TLabel;
    edtName: TEdit;
    lbl3: TLabel;
    edtPassword: TEdit;
    btnLogin: TBitBtn;
    bvl1: TBevel;
    btnCancel: TButton;
    chk1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
    FStuAction : TStudentAction;
    procedure ReadINI;
    procedure WriteINI;

  public
    { Public declarations }
  end;

var
  fStudentLogin: TfStudentLogin;

implementation

{$R *.dfm}

procedure TfStudentLogin.btnLoginClick(Sender: TObject);
var
  sIP : string;
  AStudentInfo : TStudentInfo;
begin
  if edtName.Text = '' then
  begin
    Application.MessageBox(PChar(lbl2.Caption + '����Ϊ�գ�'), '',
      MB_OK + MB_ICONINFORMATION);
    edtName.SetFocus;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  btnLogin.Enabled := False;

  try
    AStudentInfo := TStudentInfo.create;

    if FStuAction.GetStuInfo(Trim(edtName.Text), Trim(edtPassword.Text), AStudentInfo) then
    begin

      sIP := UDPClient.CheckLogin(AStudentInfo.stuNumber);

      // ��ѧԱ�Ѿ��������������ϵ�¼
      if sIP <> '' then
      begin
        Application.MessageBox(PChar('�û��Ѿ���' + sIP + '�ϵ�¼���������ظ���¼��'),
         '', MB_OK + MB_ICONINFORMATION);
      end
      else
      begin
        ClientControl.StudentInfo.Assign(AStudentInfo);

        ClientControl.LoginState := lsLogin;

        ModalResult := mrOk;
      end;
    end
    else
    begin
      Application.MessageBox(PChar('�û������������'),
         '', MB_OK + MB_ICONINFORMATION);
    end;
    AStudentInfo.Free;
  finally
    Screen.Cursor := crDefault;
    btnLogin.Enabled := True;
  end;
end;

procedure TfStudentLogin.FormCreate(Sender: TObject);
begin
  FStuAction := TStudentAction.Create;
  ReadINI;
end;

procedure TfStudentLogin.FormDestroy(Sender: TObject);
begin
  FStuAction.free;

  WriteINI;
end;

procedure TfStudentLogin.ReadINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    edtName.Text           := ReadString('Client', 'LogName', '');
    edtPassword.Text       := '';
    chk1.Checked := ReadBool('Option', 'InShowLoagin', True);
    Free;
  end;
end;

procedure TfStudentLogin.WriteINI;
begin
  with TIniFile.Create(sPubIniFileName) do
  begin
    WriteString( 'Client', 'LogName', edtName.Text);

    WriteBool('Option', 'InShowLoagin', chk1.Checked);
    Free;
  end;
end;

end.

