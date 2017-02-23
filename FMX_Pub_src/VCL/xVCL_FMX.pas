unit xVCL_FMX;

interface

uses
  System.Classes, System.SysUtils, VCL.Dialogs, Vcl.Forms, Vcl.ExtCtrls;

type
  TMySaveDialog = class(TSaveDialog)
  end;

type
  TMyOpenDialog = class(TOpenDialog)
  end;

type
  TMyTimer = class(TTimer)
  end;


/// <summary>
/// ��ʱ�ȴ��������ȴ�ʱ���������¼�
/// </summary>
/// <param name="nMSeconds">����</param>
procedure MyWaitForSeconds( nMSeconds : Cardinal );

/// <summary>
/// ��������¼�
/// </summary>
procedure MyProcessMessages;


implementation

procedure MyProcessMessages;
begin
  Application.ProcessMessages;
end;


procedure MyWaitForSeconds( nMSeconds : Cardinal );
var
  nTick : Cardinal;
begin
  nTick := TThread.GetTickCount;

  repeat
    Application.ProcessMessages;
    Sleep(1);
  until TThread.GetTickCount - nTick  > nMSeconds;
end;

end.
