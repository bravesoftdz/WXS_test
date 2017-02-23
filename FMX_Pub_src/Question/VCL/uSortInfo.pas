unit uSortInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, xSortInfo;

type
  TfSortInfo = class(TForm)
    lblMemo: TLabel;
    mmoSortRemark: TMemo;
    lbl1: TLabel;
    edtSortName: TEdit;
    pnl1: TPanel;
    bvl1: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
  private
    FSortInfo : TSortInfo;
  public
    /// <summary>
    /// ��ʾ��Ϣ
    /// </summary>
    procedure ShowInfo(ASortInfo : TSortInfo);

    /// <summary>
    /// ������Ϣ
    /// </summary>
    procedure SaveInfo;
  end;

var
  fSortInfo: TfSortInfo;

implementation

{$R *.dfm}

{ TfS17SortInfo }

procedure TfSortInfo.SaveInfo;
begin
  if Assigned(FSortInfo) then
  begin
    FSortInfo.SortName := edtSortName.Text;
    FSortInfo.SortRemark := mmoSortRemark.Text;
  end;
end;

procedure TfSortInfo.ShowInfo(ASortInfo: TSortInfo);
begin
  if Assigned(ASortInfo) then
  begin
    FSortInfo := ASortInfo;

    edtSortName.Text := FSortInfo.SortName;
    mmoSortRemark.Text := FSortInfo.SortRemark;
  end;
end;

end.
