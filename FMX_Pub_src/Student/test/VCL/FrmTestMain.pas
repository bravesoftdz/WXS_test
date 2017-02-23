unit FrmTestMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfTestMain = class(TForm)
    btn1: TButton;
    btn2: TButton;
    mmo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTestMain: TfTestMain;

implementation
uses
  xDBConn, uStudentList, xStudentInfo, xStudentControl;

{$R *.dfm}

procedure TfTestMain.btn1Click(Sender: TObject);
begin
  with TfStudentList.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TfTestMain.btn2Click(Sender: TObject);
var
  AStuInfo: TStudentInfo;
begin
  with TfStudentList.Create(nil) do
  begin
    AStuInfo := SelOneStu;
    if Assigned(AStuInfo) then
    begin
      mmo1.Lines.Clear;
      mmo1.Lines.Add('����:' + AStuInfo.stuName);
      mmo1.Lines.Add('�Ա�:' + AStuInfo.stuSex);
    end;
    Free;
  end;
end;

procedure TfTestMain.FormCreate(Sender: TObject);
const
  sConnStr = 'DriverID=MSAcc;Database=%s\UserDB.mdb';
var
  sFilePath : string;
begin
  sFilePath := ExtractFilePath(ParamStr(0));

  ADBConn := TDBConn.Create;
  //ע��:64λϵͳ��:  ���ݿ��ļ�����ȫ·���ᱨ��(�Ҳ����ļ�)
  ADBConn.ConnStr := Format(sConnStr, [sFilePath]);

  StudentControl := TStudentControl.Create;
end;

procedure TfTestMain.FormDestroy(Sender: TObject);
begin
  ADBConn.Free;
  StudentControl.Free;
end;

end.
