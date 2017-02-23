unit uUserControl;

interface

uses
  System.Classes, system.SysUtils, uUserInfo, uUserAction;

type
  /// <summary>
  /// ��¼���
  /// </summary>
  TUA_LOGIN_STATUS = ( uaUserNotExist, uaWrongPassword, uaSucceed );

type
  TUserControl = class
  private
    FUserGroupList: TStringList;
    FUserList: TStringList;
    FUserRightList: TStringList;
    /// <summary>
    /// �û���¼�ɹ�����б�
    /// </summary>
    FUserLognList : TStringList;
    FUserAction : TUserAction;
    FUserInfo: TUser;
    function GetUserList: TStringList;
    function GetUserRightList: TStringList;
    function GetUserGroupList: TStringList;
  public
    constructor Create;
    destructor Destroy;override;

    /// <summary>
    /// �л��б�
    /// </summary>
    property UserList : TStringList read GetUserList;

    /// <summary>
    /// �����û��б�
    /// </summary>
    procedure LoadUserList;

    /// <summary>
    /// �����û�(����/�༭)
    /// </summary>
    procedure SaveUser(AUser : TUser);

    /// <summary>
    /// ɾ���û�
    /// </summary>
    procedure DelUser(nUname : string);overload;
    procedure DelUser(AUser : TUser);overload;

    /// <summary>
    /// Ȩ���б�
    /// </summary>
    property UserRightList : TStringList read GetUserRightList;

    /// <summary>
    /// �����л�Ȩ���б�
    /// </summary>
    procedure LoadUserRightList;

    /// <summary>
    /// �����û�Ȩ��(����/�༭)
    /// </summary>
    procedure SaveUserRight(AUserRight : TUserRight);

    /// <summary>
    /// ɾ���û�Ȩ��
    /// </summary>
    procedure DelUserRight(sUserRightName: string);overload;
    procedure DelUserRight(AUserRight : TUserRight);overload;

    /// <summary>
    /// �л����б�
    /// </summary>
    property UserGroupList : TStringList read GetUserGroupList;

    /// <summary>
    /// �����û���(����/�༭)
    /// </summary>
    procedure SaveUserGroup(AUserGroup : TUserGroup);

    /// <summary>
    /// ɾ���û���
    /// </summary>
    procedure DelUserGroup(sUserGroupName : string);overload;
    procedure DelUserGroup(AUserGroup : TUserGroup);overload;

    /// <summary>
    /// ͨ��UserName��ȡ�û���Ϣ
    /// </summary>
    function GetUserInfo(sUserName : string) : TUser;

    /// <summary>
    /// �����л����б�
    /// </summary>
    procedure LoadUserGroupList;

    /// <summary>
    /// ͨ��GroupName��ȡ����Ϣ
    /// </summary>
    function GetGroupInfo(sGroupName : string) : TUserGroup;

    /// <summary>
    /// ���������б�
    /// </summary>
    procedure LoadUserAllList;

    /// <summary>
    /// �û���Ϣ
    /// </summary>
    property UserInfo : TUser read FUserInfo write FUserInfo;

    /// <summary>
    /// ��¼
    /// </summary>
    function Login( const sLName, sLPassword : string ) : TUA_LOGIN_STATUS;

    /// <summary>
    /// ע��
    /// </summary>
    procedure LogOut;

    /// <summary>
    /// �ж�Ȩ���Ƿ����
    /// </summary>
    function RightExist( sRightName : string ) : Boolean;

    /// <summary>
    /// �û����Ƿ����
    /// </summary>
    function CheckUNameExists(sUname : string) : Boolean;

    /// <summary>
    /// �û����Ƿ����
    /// </summary>
    function CheckUGNameExists(sUGname : string) : Boolean;

    /// <summary>
    /// �޸�����
    /// </summary>
    procedure UserUpass;overload; //�޸ĵ�¼�û�����
    procedure UserUpass(AUser : TUser);overload; //�����û��޸�����

  end;

var
  UserControl : TUserControl;

implementation

uses
  xFunction, uUpUsPass, System.UITypes;

{ TUserControl }

function TUserControl.CheckUGNameExists(sUGname: string): Boolean;
begin
  Result := FUserAction.CheckUGNameExists(sUGname);
end;

function TUserControl.CheckUNameExists(sUname: string): Boolean;
begin
  Result := FUserAction.CheckUNameExists(sUname);
end;

constructor TUserControl.Create;
begin
  FUserList := TStringList.Create;
  FUserRightList := TStringList.Create;
  FUserGroupList := TStringList.Create;
  FUserAction := TUserAction.Create;
  FUserLognList := TStringList.Create;
  LoadUserAllList;
end;

procedure TUserControl.DelUser(nUname: string);
var
  nIndex : Integer;
begin
  FUserAction.DelUser(nUname);
  nIndex := FUserList.IndexOf(nUname);
  if nIndex <> -1 then
  begin
    FUserList.Objects[nIndex].Free;
    FUserList.Delete(nIndex);
  end;
end;

procedure TUserControl.DelUser(AUser: TUser);
begin
  if Assigned(AUser) then
    DelUser(AUser.LoginName);
end;

procedure TUserControl.DelUserGroup(sUserGroupName: string);
var
  nIndex : Integer;
begin
  FUserAction.DelUserGroup(sUserGroupName);
  nIndex := FUserGroupList.IndexOf(sUserGroupName);
  if nIndex <> -1 then
  begin
    FUserGroupList.Objects[nIndex].Free;
    FUserGroupList.Delete(nIndex);
  end;
end;

procedure TUserControl.DelUserGroup(AUserGroup: TUserGroup);
begin
  if Assigned(AUserGroup) then
      DelUserGroup(AUserGroup.GroupName);
end;

procedure TUserControl.DelUserRight(sUserRightName: string);
var
  nIndex : integer;
begin
  FUserAction.DelUserRight(sUserRightName);
  nIndex := FUserRightList.IndexOf(sUserRightName);
  if nIndex <> -1 then
  begin
    FUserRightList.Objects[nIndex].Free;
    FUserRightList.Delete(nIndex);
  end;
end;

procedure TUserControl.DelUserRight(AUserRight: TUserRight);
begin
  if Assigned(AUserRight) then
    DelUserRight(AUserRight.RightName);
end;

destructor TUserControl.Destroy;
begin
  ClearStringList(FUserList);
  ClearStringList(FUserRightList);
  ClearStringList(FUserGroupList);
  ClearStringList(FUserLognList);
  FUserList.Free;
  FUserRightList.Free;
  FUserGroupList.Free;
  FUserAction.Free;
  FUserLognList.Free;
  inherited;
end;

function TUserControl.GetGroupInfo(sGroupName: string): TUserGroup;
var
  nIndex : integer;
begin
  Result := nil;
  nIndex := UserGroupList.IndexOf(sGroupName);
  if nIndex <> -1 then
  begin
    Result := TUserGroup(UserGroupList.Objects[nIndex]);
  end;
end;

function TUserControl.GetUserGroupList: TStringList;
begin
  LoadUserGroupList;
  Result := FUserGroupList;
end;

function TUserControl.GetUserInfo(sUserName : string) : TUser;
var
  nIndex : integer;
begin
  Result := nil;
  nIndex := UserList.IndexOf(sUserName);
  if nIndex <> -1 then
  begin
    Result := TUser(UserList.Objects[nIndex]);
  end;
end;

function TUserControl.GetUserList: TStringList;
begin
  LoadUserList;
  Result := FUserList;
end;

function TUserControl.GetUserRightList: TStringList;
begin
  LoadUserRightList;
  Result := FUserRightList;
end;

procedure TUserControl.LoadUserAllList;
begin
  LoadUserList;
  LoadUserRightList;
  LoadUserGroupList;
end;

procedure TUserControl.LoadUserGroupList;
begin
  FUserAction.GetAllUserGroups(FUserGroupList);
end;

procedure TUserControl.LoadUserList;
begin
  FUserAction.GetAllUsers(FUserList);
end;

procedure TUserControl.LoadUserRightList;
begin
  FUserAction.GetAllUserRights(FUserRightList);
end;

function TUserControl.Login(const sLName, sLPassword: string): TUA_LOGIN_STATUS;
begin
  FUserInfo := TUser.Create;

  // ��¼
  if not FUserAction.GetUserInfo( sLName, FUserInfo ) then
    Result := uaUserNotExist
  else
  begin
    if UpperCase(GetMD5( sLPassword )) = FUserInfo.Password then
      Result := uaSucceed
    else
      Result := uaWrongPassword;
  end;

  // ��¼�ɹ����ȡȨ��
  if Result = uaSucceed then
    FUserAction.GetUserRights( FUserInfo.GroupID, FUserLognList )
  else
    FreeAndNil( FUserInfo );
end;

procedure TUserControl.LogOut;
begin
  if Assigned( FUserInfo ) then
    FreeAndNil( FUserInfo );

  ClearStringList( FUserLognList );
end;

function TUserControl.RightExist(sRightName: string): Boolean;
begin
  result := False;
  if FUserLognList.IndexOf( sRightName ) <> -1 then
    Result := True;
end;

procedure TUserControl.SaveUser(AUser : TUser);
var
  nIndex : Integer;
  FUser :TUser;
begin
  FUserAction.SaveUser(AUser);

  if Assigned(AUser) then
  begin
    nIndex := FUserGroupList.IndexOf(AUser.LoginName);
    if nIndex <> -1 then
    begin
      FUserList.Delete(nIndex);
      FUser := TUser.Create;
      FUser.Assign(AUser);
      FUserGroupList.AddObject(FUser.LoginName, FUser);
    end
    else
    begin
      FUser := TUser.Create;
      FUser.Assign(AUser);
      FUserGroupList.AddObject(FUser.LoginName, FUser);
    end;
  end;
end;

procedure TUserControl.SaveUserGroup(AUserGroup: TUserGroup);
var
  nIndex : Integer;
  AGroupUser :TUserGroup;
begin
  FUserAction.SaveUserGroup(AUserGroup);
  if Assigned(AUserGroup) then
  begin
    nIndex := FUserGroupList.IndexOf(AUserGroup.GroupName);
    if nIndex <> -1 then
    begin
      FUserGroupList.Delete(nIndex);
      AGroupUser := TUserGroup.Create;
      AGroupUser.Assign(AUserGroup);
      FUserGroupList.AddObject(AGroupUser.GroupName, AGroupUser);
    end
    else
    begin
      AGroupUser := TUserGroup.Create;
      AGroupUser.Assign(AUserGroup);
      FUserGroupList.AddObject(AGroupUser.GroupName, AGroupUser);
    end;
  end;
end;

procedure TUserControl.SaveUserRight(AUserRight: TUserRight);
var
  nIndex : integer;
  ARightUser : TUserRight;
begin
  FUserAction.SaveUserRight(AUserRight);

  if Assigned(AUserRight) then
  begin
    nIndex := FUserGroupList.IndexOf(AUserRight.RightName);
    if nIndex <> -1 then
    begin
      TUserGroup(FUserRightList.Objects[nIndex]).Assign(AUserRight);
    end
    else
    begin
      ARightUser := TUserRight.Create;
      ARightUser.Assign(AUserRight);
      FUserGroupList.AddObject(ARightUser.RightName, ARightUser);
    end;
  end;
end;

procedure TUserControl.UserUpass(AUser: TUser);
begin
  if Assigned(AUser) then
  begin
    with TfUpUsPass.Create(nil) do
    begin
      ShowInfo(AUser);
      if ShowModal = mrOk then
      begin
        SaveInfo;
        FUserAction.UpUserPass(AUser);
        HintMessage(0, '�޸ĳɹ�!', '��ʾ');
      end;
      Free;
    end;
  end;
end;

procedure TUserControl.UserUpass;
begin
  UserUpass(UserInfo);
end;

end.
