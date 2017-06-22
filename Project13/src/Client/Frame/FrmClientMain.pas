unit FrmClientMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.XPStyleActnCtrls,
  Vcl.ActnMan, Vcl.ToolWin, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, xConfig,
  xDBConn, xClientControl, xUDPClient1, xClientType, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, xFunction, xTCPClient, FrmLogin,
  uStudentInfo, xExerciseControl, FrmExercise, System.IniFiles, xConsts,FrmExamReady,
  xUDPRevScreen, Vcl.Imaging.jpeg;
const
  WM_FORM_LOADING = WM_USER + 1;
type
  TfClientMain = class(TForm)
    stsbrMain: TStatusBar;
    actnmngrMain: TActionManager;
    actExit: TAction;
    actAbout: TAction;
    actOption: TAction;
    actDevLog: TAction;
    actTraining: TAction;
    actExam: TAction;
    actQuestion: TAction;
    actPaper: TAction;
    actExaminee: TAction;
    actHelp: TAction;
    actMore: TAction;
    actExercise: TAction;
    actRanking: TAction;
    actCommitBug: TAction;
    actExerciseSetting: TAction;
    tmr1: TTimer;
    mnmnmm1: TMainMenu;
    mntmN1: TMenuItem;
    mntmOption: TMenuItem;
    mntmExit: TMenuItem;
    mntmN8: TMenuItem;
    mntmTraining: TMenuItem;
    mntmExercise: TMenuItem;
    mntmExerciseSetting: TMenuItem;
    mntmExam: TMenuItem;
    mntmN6: TMenuItem;
    mntmExaminee1: TMenuItem;
    mntmPaper1: TMenuItem;
    mntmN3: TMenuItem;
    mntmRanking2: TMenuItem;
    mntmN2: TMenuItem;
    mntmDevLog: TMenuItem;
    mntmN11: TMenuItem;
    mntmN16: TMenuItem;
    mntmN17: TMenuItem;
    mntmN4: TMenuItem;
    mntmHelpOnAbout: TMenuItem;
    mntmHelp: TMenuItem;
    mntmN7: TMenuItem;
    mntmMore: TMenuItem;
    mntmRanking: TMenuItem;
    imglstil3: TImageList;
    imglstil1: TImageList;
    pnl1: TPanel;
    btn1: TButton;
    tlbr1: TToolBar;
    pnl2: TPanel;
    imgStu: TImage;
    btnStu: TSpeedButton;
    btnDevLog: TToolButton;
    btnExit: TToolButton;
    btnHelp1: TToolButton;
    btnHelp: TToolButton;
    btn3: TToolButton;
    btn7: TToolButton;
    idtcpclnt1: TIdTCPClient;
    spltr2: TSplitter;
    pnl3: TPanel;
    spltr1: TSplitter;
    mmo1: TMemo;
    mmo2: TMemo;
    btnExercise: TToolButton;
    pmn1: TPopupMenu;
    mntmN5: TMenuItem;
    img1: TImage;
    procedure actExitExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actOptionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btnStuClick(Sender: TObject);
    procedure actExerciseExecute(Sender: TObject);
    procedure mntmN5Click(Sender: TObject);
    procedure pmn1Popup(Sender: TObject);
  private
    { Private declarations }
    FExamReadyForm : TfExamReady;
    FRevScreen : TUDPRevScreen;
    /// <summary>
    /// 系统启动处理
    /// </summary>
    procedure ProcLoadingMsg( var Msg : TMessage ); message WM_FORM_LOADING;
    /// <summary>
    /// 设置公共信息
    /// </summary>
    procedure SetPubInfo;

    /// <summary>
    /// 初始化数据库连接
    /// </summary>
    procedure IniDBConn;

    /// <summary>
    /// 加载各个模块
    /// </summary>
    procedure Load;

    /// <summary>
    /// 卸载各个模块
    /// </summary>
    procedure Unload;

    /// <summary>
    /// 状态改变
    /// </summary>
    procedure StateChange(Sender: TObject);

    procedure TCPConnect(Sender: TObject);
    procedure TCPDisconnect(Sender: TObject);

    procedure RevJpg(Sender: TObject);

    procedure TCPLog(const S: string);
    procedure UDPLog(const S: string);
    procedure TCPPacksLog(  aPacks: TBytes; bSend : Boolean);
    procedure UDPPacksLog( sIP : string; nPort: Integer; aPacks: TBytes; bSend : Boolean);
    procedure UDPPacksLog1( sIP : string; nPort: Integer; aPacks: TBytes; bSend : Boolean);
    /// <summary>
    /// TCP连接
    /// </summary>
    procedure TCPConn;
    procedure ConnServer(Sender: TObject);

    procedure Login(Sender: TObject);
    procedure StuReady( nTotalCount : Integer);
    procedure StuProgress( nReadyCount, nTotalCount : Integer);

  public
    { Public declarations }
  end;

var
  fClientMain: TfClientMain;

implementation

{$R *.dfm}

procedure TfClientMain.actAboutExecute(Sender: TObject);
begin
  //
end;

procedure TfClientMain.actExerciseExecute(Sender: TObject);
begin
  with TfExercise.Create(nil) do
  begin
    IsClientExercise := True;
    ShowModal;
    Free;
  end;
end;

procedure TfClientMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfClientMain.actOptionExecute(Sender: TObject);
begin
 //
end;

procedure TfClientMain.btnStuClick(Sender: TObject);
begin
  if btnStu.Caption  = '未登录' then
  begin
    Login(nil);
  end
  else
  begin
    with TfStudentInfo.Create(nil) do
    begin
      ShowStu(ClientControl.StudentInfo);
      ShowModal;
      Free;
    end;
  end;
end;

procedure TfClientMain.ConnServer(Sender: TObject);
begin
  TCPConn;
end;

procedure TfClientMain.FormCreate(Sender: TObject);
begin
  stsbrMain.Panels[1].Text := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now);
  SetPubInfo;
//  ReadsysINI;
//  FError := TWIRINGF_ERROR.Create(nil);
//  FError.PhaseType := ptfThree;

//  clbr1.Visible := bPubIsCompany;


//  Caption := C_SYS_OBJECT_MODEL + '  ' + C_SYS_OBJECT_NAME;
//  fLoadform := TfLoadform.Create(Self);

  PostMessage( Handle, WM_FORM_LOADING, 0, 0 );
end;

procedure TfClientMain.FormDestroy(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
//    WritesysINI;

    Unload;
    if Assigned(ADBConn) then
      ADBConn.Free;

//    FError.Free;


  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfClientMain.IniDBConn;
begin
  if TCPClient.serverIP <> '' then
  begin
    ADBConn := TDBConn.Create;
    ADBConn.ConnStr := 'DriverID=MSSQL;Database=test;Password=ckm2008byx;'+
      'Server='+TCPClient.serverIP+';User_Name=sa';
  end;

end;

procedure TfClientMain.Load;
begin
  try
    UDPClient := TUDPClient.Create;
    UDPClient.OnLog := UDPLog;
    UDPClient.OnIPSendRev := UDPPacksLog;
    UDPClient.Connect;

    TCPClient := TTCPClient.Create;
    TCPClient.OnConnected := TCPConnect;
    TCPClient.OnDisconnect := TCPDisconnect;
    TCPClient.OnLog := TCPLog;
    TCPClient.OnSendRevPack := TCPPacksLog;
    TCPClient.OnStuLogin := Login;
    TCPClient.OnStuReady := StuReady;
    TCPClient.OnStuProgress := StuProgress;


    UDPClient.OnConnServer := ConnServer;

    TCPConn;

    ClientControl := TClientControl.Create;
    ClientControl.OnStateChange := StateChange;

    if UDPClient.Active then
      ClientControl.ClientState := esConned;

    IniDBConn;

    FRevScreen := TUDPRevScreen.Create;
    FRevScreen.ListenPort := 16101;
    FRevScreen.Connect;
    FRevScreen.OnRevJpg := RevJpg;
    FRevScreen.OnIPSendRev := UDPPacksLog1;


    ExerciseControl := TExerciseControl.Create;
    FExamReadyForm := TfExamReady.Create(nil);

    with TIniFile.Create(sPubIniFileName) do
    begin
      if ReadBool('Option', 'InShowLoagin', True) then
      begin
        Login(nil);
      end;
      Free;
    end;

  finally

  end;
end;

procedure TfClientMain.Login(Sender: TObject);
begin
  if ClientControl.ClientState < esLogin then
  begin
    with TfStudentLogin.Create(nil) do
    begin
      if ShowModal = mrOk then
      begin

      end;

      Free;
    end;
  end;

end;

procedure TfClientMain.mntmN5Click(Sender: TObject);
begin
  if ClientControl.ClientState = esLogin then
  begin
    if TCPClient.Active then
    begin
      ClientControl.ClientState := esConned;
      TCPClient.SendStuState(ClientControl.ClientState);
    end
    else
    begin
      ClientControl.ClientState := esDisconn;
    end;
  end;
end;

procedure TfClientMain.pmn1Popup(Sender: TObject);
begin
  if ClientControl.ClientState = esLogin then
  begin
    mntmN5.Visible := True;
  end
  else
  begin

    mntmN5.Visible := False;
  end;
end;

procedure TfClientMain.ProcLoadingMsg(var Msg: TMessage);
begin
  Application.ProcessMessages;

  try
    Enabled := False;
    Load;    // 加载模块
  finally

    Enabled := True;
  end;
end;

procedure TfClientMain.RevJpg(Sender: TObject);
begin
  if Sender is TJPEGImage then
  begin
    mmo2.Lines.Add('刷新图片' + IntToStr(TJPEGImage(Sender).Width) + ';' + IntToStr(TJPEGImage(Sender).Height));

    img1.Picture.Bitmap.Assign(TJPEGImage(Sender));
  end;
end;

procedure TfClientMain.SetPubInfo;
begin

end;

procedure TfClientMain.StateChange(Sender: TObject);
begin
  stsbrMain.Panels[2].Text := ClientStateStr(ClientControl.ClientState);
  TCPClient.SendStuState(ClientControl.ClientState);

  if ClientControl.ClientState = esLogin then
  begin
    btnStu.Caption := ClientControl.StudentInfo.stuName;
    imgStu.Picture.LoadFromFile('OnLine.bmp');
  end
  else if ClientControl.ClientState in [esDisconn, esConned] then
  begin
    btnStu.Caption := '未登录';
    imgStu.Picture.LoadFromFile('OutLine.bmp');
  end;
end;

procedure TfClientMain.StuProgress(nReadyCount, nTotalCount: Integer);
begin
  FExamReadyForm.Show;
  FExamReadyForm.ShowReadyProgress(nReadyCount, nTotalCount);
end;

procedure TfClientMain.StuReady(nTotalCount: Integer);
begin
  FExamReadyForm.ShowReady(nTotalCount);
  FExamReadyForm.Show;
end;

procedure TfClientMain.TCPConn;
  procedure Conn;
  var
    sIP : string;
    nPort : Integer;
  begin
    UDPClient.GetTCPServerIPPort(sIP, nPort, 2000);

    if sIP <> '' then
    begin
      TCPClient.ServerIP := sIP;
      TCPClient.ServerPort := nPort;
      try
        TCPClient.Connect;
      finally

      end;
    end;
  end;
begin
  if not TCPClient.Active then
  begin
    if TCPClient.ServerIP = '' then
    begin
      Conn;
    end
    else
    begin
      try
        TCPClient.Connect;
      finally
        if not TCPClient.Active then
          Conn;
      end;
    end;
  end;
end;

procedure TfClientMain.TCPConnect(Sender: TObject);
begin
  if Assigned(ClientControl) then
  begin
    if ClientControl.ClientState in [esLogin] then
    begin
      TCPClient.StuLogin(ClientControl.StudentInfo.stuNumber);
      TCPClient.SendStuState(ClientControl.ClientState);
    end
    else
    begin
      ClientControl.ClientState := esConned;
    end;
  end;
end;

procedure TfClientMain.TCPDisconnect(Sender: TObject);
begin
  if Assigned(ClientControl) then
  begin
    if ClientControl.ClientState in [esLogin] then
    begin

    end
    else
    begin
      ClientControl.ClientState := esDisconn;
    end;
  end;
end;

procedure TfClientMain.TCPLog(const S: string);
begin
  if mmo1.Visible then
  begin
    if mmo1.Lines.Count > 1000 then
    begin
      mmo1.Lines.Clear;
      mmo1.Lines.Add('删除前1000条数据记录');
    end;
    mmo1.Lines.Add(s);
  end;
end;

procedure TfClientMain.TCPPacksLog(aPacks: TBytes; bSend: Boolean);
var
  s : string;
begin
  if bsend then
    s := '发送'
  else
    s := '接收';

  TCPLog(FormatDateTime('hh:mm:ss:zzz', Now) + s  + ' ' + BCDPacksToStr(aPacks) );
end;

procedure TfClientMain.tmr1Timer(Sender: TObject);
begin
  stsbrMain.Panels[1].Text := FormatDateTime('YYYY-MM-DD hh:mm:ss', Now);
end;

procedure TfClientMain.UDPLog(const S: string);
begin
  if mmo2.Visible then
  begin
    if mmo2.Lines.Count > 1000 then
    begin
      mmo2.Lines.Clear;
      mmo2.Lines.Add('删除前1000条数据记录');
    end;
    mmo2.Lines.Add(s);
  end;
end;

procedure TfClientMain.UDPPacksLog(sIP: string; nPort: Integer; aPacks: TBytes;
  bSend: Boolean);
var
  s : string;
begin
  if bsend then
    s := '发送'
  else
    s := '接收';

  UDPLog(FormatDateTime('hh:mm:ss:zzz', Now) + s + sIP +':' + IntToStr(nPort) + ' ' + PacksToStr(aPacks) );
end;

procedure TfClientMain.UDPPacksLog1(sIP: string; nPort: Integer; aPacks: TBytes;
  bSend: Boolean);
var
  s : string;
  aBuf : TBytes;
begin
  if bsend then
    s := '发送'
  else
    s := '接收';


  SetLength(aBuf, 10);

  aBuf[0] := aPacks[0];
  aBuf[1] := aPacks[1];
  aBuf[2] := aPacks[2];
  aBuf[3] := aPacks[3];
  aBuf[4] := aPacks[4];
  aBuf[5] := aPacks[5];
  aBuf[6] := aPacks[6];
  aBuf[7] := aPacks[7];
  aBuf[8] := aPacks[Length(aPacks)-2];
  aBuf[9] := aPacks[Length(aPacks)-1];





  UDPLog(FormatDateTime('hh:mm:ss:zzz', Now) + s + sIP +':' + IntToStr(nPort) + ' ' + BCDPacksToStr(aBuf) );
end;

procedure TfClientMain.Unload;
begin
  ClientControl.Free;
  UDPClient.Free;
  TCPClient.Free;
  ExerciseControl.Free;
  FExamReadyForm.Free;
  FRevScreen.Free;
end;

end.
