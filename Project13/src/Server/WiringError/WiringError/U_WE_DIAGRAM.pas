{===============================================================================
  Copyright(c) 2007-2009, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ������ߣ�����ͼ��ͼ��Ԫ
  + TWE_DIAGRAM     ����ͼ

===============================================================================}

unit U_WE_DIAGRAM;

interface

uses SysUtils, Classes, Windows, Graphics, U_WIRING_ERROR, system.Types;

type
  /// <summary>
  /// ����ͼ
  /// </summary>
  TWE_DIAGRAM = class( TComponent )
  private
    FCanvas : TCanvas;
    FDiagram3 : TBitmap;
    FDiagram4 : TBitmap;
    FWiringError : TWIRING_ERROR;
    FRect : TRect;
    procedure SetWiringError( const Value : TWIRING_ERROR );
    procedure SetRect( const Value : TRect );
  protected
    procedure DrawDiagram;
    procedure DrawDiagram3;
    procedure DrawDiagram4;

    /// <summary>
    /// ��������
    /// </summary>
    /// <param name="APosStart">���</param>
    /// <param name="APosEnd">�յ�</param>
    /// <param name="AStraightLine">�Ƿ�Ϊֱ��</param>
    procedure DrawConnection( APosStart, APosEnd : TPoint;
      AStraightLine : Boolean = False; AColor : TColor = clBlack );

    /// <summary>
    /// ������
    /// </summary>
    procedure DrawBroken( APosStart, APosEnd : TPoint );

    /// <summary>
    /// �л�����
    /// </summary>
    procedure ChangeSequence( var AOrder : array of TPoint; ASequence : TWE_SEQUENCE_TYPE );
  public
    constructor Create( AOwner : TComponent ); override;
    destructor Destroy; override;
  public
    /// <summary>
    /// ����
    /// </summary>
    property Canvas : TCanvas read FCanvas write FCanvas;

    /// <summary>
    /// ��ͼ������
    /// </summary>
    property Rect : TRect read FRect write SetRect;

    /// <summary>
    /// �������
    /// </summary>
    property WiringError : TWIRING_ERROR read FWiringError write
      SetWiringError;
  end;

implementation

{ TWE_DIAGRAM }

{$R wediagram.res}

procedure TWE_DIAGRAM.ChangeSequence( var AOrder: array of TPoint;
  ASequence: TWE_SEQUENCE_TYPE);
var
  OldOrder : array of TPoint;
  i: Integer;
begin
  if Length( AOrder ) <> 3 then
    Exit;

  SetLength( OldOrder, 3 );

  for i := 0 to 3 - 1 do
    OldOrder[ i ] := AOrder[ i ];

  case ASequence of
    stACB:
    begin
      AOrder[ 0 ] := OldOrder[ 0 ];
      AOrder[ 1 ] := OldOrder[ 2 ];
      AOrder[ 2 ] := OldOrder[ 1 ];
    end;

    stBAC:
    begin
      AOrder[ 0 ] := OldOrder[ 1 ];
      AOrder[ 1 ] := OldOrder[ 0 ];
      AOrder[ 2 ] := OldOrder[ 2 ];
    end;

    stBCA:
    begin
      AOrder[ 0 ] := OldOrder[ 1 ];
      AOrder[ 1 ] := OldOrder[ 2 ];
      AOrder[ 2 ] := OldOrder[ 0 ];
    end;

    stCAB:
    begin
      AOrder[ 0 ] := OldOrder[ 2 ];
      AOrder[ 1 ] := OldOrder[ 0 ];
      AOrder[ 2 ] := OldOrder[ 1 ];
    end;

    stCBA:
    begin
      AOrder[ 0 ] := OldOrder[ 2 ];
      AOrder[ 1 ] := OldOrder[ 1 ];
      AOrder[ 2 ] := OldOrder[ 0 ];
    end;
  end;
end;

constructor TWE_DIAGRAM.Create( AOwner : TComponent );
begin
  inherited;
  FWiringError := TWIRING_ERROR.Create;
  FDiagram3 := TBitmap.Create;
  FDiagram4 := TBitmap.Create;
  FDiagram3.LoadFromResourceID( HInstance, 7203 );
  FDiagram4.LoadFromResourceID( HInstance, 7204 );
end;

destructor TWE_DIAGRAM.Destroy;
begin
  FWiringError.Free;
  FDiagram3.Free;
  FDiagram4.Free;
  inherited;
end;

procedure TWE_DIAGRAM.DrawBroken(APosStart, APosEnd: TPoint);
var
  pO : TPoint;
begin
  pO.X := (APosStart.X + APosEnd.X) div 2;
  pO.Y := (APosStart.Y + APosEnd.Y) div 2;

  with FCanvas do
  begin
    // ��������
    Pen.Color := Pixels[ 0, 0 ];
    Polyline([ APosStart, APosEnd ] );

    // �� X
    Pen.Color := clRed;
    Polyline([Point(po.X - 4, pO.Y - 4),Point(pO.X + 5, pO.Y + 5)]);
    Polyline([Point(po.X - 4, pO.Y + 4),Point(pO.X + 5, pO.Y - 5)]);
  end;
end;

procedure TWE_DIAGRAM.DrawConnection( APosStart, APosEnd : TPoint;
  AStraightLine : Boolean; AColor : TColor );
begin
  with FCanvas do
  begin
    Pen.Color := AColor;

    if ( APosStart.X = APosEnd.X ) or ( APosStart.Y = APosEnd.Y ) or
        AStraightLine then
      Polyline( [ APosStart, APosEnd ] )
    else
    begin
      Polyline( [ APosStart, Point( APosEnd.X, APosStart.Y ) ] );
      Polyline( [ Point( APosEnd.X, APosStart.Y ), APosEnd ] );
    end;
  end;
end;

procedure TWE_DIAGRAM.DrawDiagram;
begin
  if not Assigned( FCanvas ) then
    Exit;

  if FWiringError.PhaseType = ptThree then
  begin
    FCanvas.Draw( FRect.Left, FRect.Top, FDiagram3 );
    DrawDiagram3;
  end
  else
  begin
    FCanvas.Draw( FRect.Left, FRect.Top, FDiagram4 );
    DrawDiagram4;
  end;
end;

procedure TWE_DIAGRAM.DrawDiagram3;
var
  pSa, pSb, pSc       : TPoint;  // ��ѹ�� ��
  pSUa, pSUb, pSUc    : TPoint;  // ��ѹ��Ȧ ��
  pTVa_P, pTVa_N, pTVc_P, pTVc_N  : TPoint;  // ������Ȧ
  pSign_Ua_In, pSign_Ub_In, pSign_Uc_In : TPoint;  // ��ѹ���߱�־ ��
  pSign_Ua_Out, pSign_Ub_Out, pSign_Uc_Out : TPoint;  // ��ѹ���߱�־ ��
  pUa, pUb, pUc : TPoint;        // ��ѹ

  pTAa_P, pTAa_N, pTAc_P, pTAc_N : TPoint;  // ������Ȧ
  pSign_Ia_P_In, pSign_Ia_N_In,
  pSign_Ic_P_In, pSign_Ic_N_In : TPoint; // ������־ ��
  pSign_Ia_P_Out, pSign_Ia_N_Out,
  pSign_Ic_P_Out, pSign_Ic_N_Out : TPoint; // ������־ ��
  pIa_P, pIa_N, pIc_P, pIc_N : TPoint;  // ���� ����

  pU_Order : array[0..2] of TPoint;     // ��ѹ����
  pI_Order : array[0..3] of TPoint;     // ��������

//  bInIsTaken : Boolean; // In �Ƿ�ʹ��
begin
  // ��ѹ�� ��
  pSa := Point(FRect.Left +110, FRect.Top + 103);
  pSb := Point(FRect.Left +110, FRect.Top +  135);
  pSc := Point(FRect.Left +110, FRect.Top +  167);

  // ��ѹ��Ȧ ��
  pSUa := Point(FRect.Left +120, FRect.Top + 103);
  pSUb := Point(FRect.Left +120, FRect.Top + 135);
  pSUc := Point(FRect.Left +120, FRect.Top + 167);

  // ��ѹ��Ȧ ��
  pTVa_P := Point(FRect.Left +172, FRect.Top + 103);
  pTVa_N := Point(FRect.Left +172, FRect.Top + 130);
  pTVc_P := Point(FRect.Left +172, FRect.Top + 140);
  pTVc_N := Point(FRect.Left +172, FRect.Top + 167);

  // ��ѹ��־ ��
  pSign_Ua_In := Point(FRect.Left +180, FRect.Top + 103);
  pSign_Ub_In := Point(FRect.Left +180, FRect.Top + 135);
  pSign_Uc_In := Point(FRect.Left +180, FRect.Top + 167);

  // ��ѹ��־ ��
  pSign_Ua_Out := Point(FRect.Left +209, FRect.Top + 103);
  pSign_Ub_Out := Point(FRect.Left +209, FRect.Top + 135);
  pSign_Uc_Out := Point(FRect.Left +209, FRect.Top + 167);

  // ��ѹ
  pUa  := Point(FRect.Left +233, FRect.Top + 103);
  pUb  := Point(FRect.Left +233, FRect.Top + 135);
  pUc  := Point(FRect.Left +233, FRect.Top + 167);

  // ������Ȧ ��
  pTAa_P := Point(FRect.Left +41, FRect.Top + 237);
  pTAa_N := Point(FRect.Left +41, FRect.Top + 273);
  pTAc_P := Point(FRect.Left +125, FRect.Top + 237);
  pTAc_N := Point(FRect.Left +125, FRect.Top + 273);

  // ������־ ��
  pSign_Ia_P_In := Point(FRect.Left +52, FRect.Top + 213);
  pSign_Ia_N_In := Point(FRect.Left +52, FRect.Top + 285);
  pSign_Ic_P_In := Point(FRect.Left +136, FRect.Top + 237);
  pSign_Ic_N_In := Point(FRect.Left +136, FRect.Top + 285);

  // ������־ ��
  pSign_Ia_P_Out := Point(FRect.Left +186, FRect.Top + 213);
  pSign_Ia_N_Out := Point(FRect.Left +186, FRect.Top + 285);
  pSign_Ic_P_Out := Point(FRect.Left +186, FRect.Top + 237);
  pSign_Ic_N_Out := Point(FRect.Left +186, FRect.Top + 285);

  // ����
  pIa_P  := Point(FRect.Left + 254, FRect.Top + 206);
  pIa_N  := Point(FRect.Left + 290, FRect.Top + 206);
  pIc_P  := Point(FRect.Left + 326, FRect.Top + 206);
  pIc_N  := Point(FRect.Left + 362, FRect.Top + 206);

  //----------------------------------------------------------------------------
  // ��ѹ���� ����
  //----------------------------------------------------------------------------
  if FWiringError.PT1Reverse then     // PT1��
  begin
    DrawConnection( pTVa_N, pSign_Ua_In );
    DrawConnection( pTVa_N, pTVa_P );
  end
  else
  begin
    DrawConnection( pTVa_P, pSign_Ua_In );
  end;

  if FWiringError.PT2Reverse then     // PT2��
  begin
    DrawConnection( pTVc_P, pSign_Uc_In );
    DrawConnection( pTVc_P, pTVc_N );
  end
  else
  begin
    DrawConnection( pTVc_N, pSign_Uc_In );
  end;

  //----------------------------------------------------------------------------
  // ��ѹ���� ����
  //----------------------------------------------------------------------------
  pU_Order[0] := pSign_Ua_Out;
  pU_Order[1] := pSign_Ub_Out;
  pU_Order[2] := pSign_Uc_Out;
  ChangeSequence( pU_Order, FWiringError.USequence );
  DrawConnection( pU_Order[0], pUa, True );
  DrawConnection( pU_Order[1], pUb, True );
  DrawConnection( pU_Order[2], pUc, True );

  //----------------------------------------------------------------------------
  // ������·��·
  //----------------------------------------------------------------------------
  // ���ε�����·
  if FWiringError.InBroken then
    DrawBroken( Point( 170, pSign_Ic_N_In.Y ),
      Point( 180, pSign_Ic_N_In.Y ) );

  if FWiringError.IaBroken then
    DrawBroken( Point( 170, pSign_Ia_P_In.Y ),
      Point( 180, pSign_Ia_P_In.Y ) );

  if FWiringError.IcBroken then
    DrawBroken( Point( 170, pSign_Ic_P_In.Y ),
      Point( 180, pSign_Ic_P_In.Y ) );

  // ���ε�����·
  if FWiringError.CT1Short then
    DrawConnection( Point( pTAa_P.X - 6, pTAa_P.Y + 2 ),
      Point( pTAa_N.X - 6, pTAa_N.Y - 2 ), True, clRed );

  if FWiringError.CT2Short then
    DrawConnection( Point( pTAc_P.X - 6, pTAc_P.Y + 2 ),
      Point( pTAc_N.X - 6, pTAc_N.Y - 2 ), True, clRed );

  //----------------------------------------------------------------------------
  // �������� ����
  //----------------------------------------------------------------------------
  if FWiringError.CT1Reverse then     // Ia ��
  begin
    DrawConnection( pTAa_N, pSign_Ia_P_In );
    DrawConnection( pSign_Ia_N_In, pTAa_P );
  end
  else
  begin
    DrawConnection( pTAa_P, pSign_Ia_P_In );
    DrawConnection( pTAa_N, pSign_Ia_N_In );
  end;

  if FWiringError.CT2Reverse then     // Ic ��
  begin
    DrawConnection( pTAc_N, pSign_Ic_P_In );
    DrawConnection( pSign_Ic_N_In, pTAc_P );
  end
  else
  begin
    DrawConnection( pTAc_P, pSign_Ic_P_In );
    DrawConnection( pTAc_N, pSign_Ic_N_In );
  end;

  //----------------------------------------------------------------------------
  // ���� ����
  //----------------------------------------------------------------------------
  case FWiringError.I1In of
    plA: pI_Order[ 0 ] := pSign_Ia_P_Out;
    plN: pI_Order[ 0 ] := pSign_Ia_N_Out;
    plC: pI_Order[ 0 ] := pSign_Ic_P_Out;
  end;

  case FWiringError.I1Out of
    plA: pI_Order[ 1 ] := pSign_Ia_P_Out;
    plN: pI_Order[ 1 ] := pSign_Ia_N_Out;
    plC: pI_Order[ 1 ] := pSign_Ic_P_Out;
  end;

  case FWiringError.I2In of
    plA: pI_Order[ 2 ] := pSign_Ia_P_Out;
    plN: pI_Order[ 2 ] := pSign_Ic_N_Out;
    plC: pI_Order[ 2 ] := pSign_Ic_P_Out;
  end;

  case FWiringError.I2Out of
    plA: pI_Order[ 3 ] := pSign_Ia_P_Out;
    plN: pI_Order[ 3 ] := pSign_Ic_N_Out;
    plC: pI_Order[ 3 ] := pSign_Ic_P_Out;
  end;

  DrawConnection( pI_Order[0], pIa_P, False );
  DrawConnection( pI_Order[1], pIa_N, False );
  DrawConnection( pI_Order[2], pIc_P, False );
  DrawConnection( pI_Order[3], pIc_N, False );

  //----------------------------------------------------------------------------
  // ��ѹ����
  //----------------------------------------------------------------------------
  if FWiringError.UaBroken then     // Ua һ�ζ�
    DrawBroken( pSa, pSUa );

  if FWiringError.UbBroken then     // Ub һ�ζ�
    DrawBroken( pSb, pSUb );

  if FWiringError.UcBroken then     // Uc һ�ζ�
    DrawBroken( pSc, pSUc );

  if FWiringError.UsaBroken then     // Ua ���ζ�
    DrawBroken( Point( pSign_Ua_Out.X - 11, pSign_Ua_Out.Y ),
      Point( pSign_Ua_Out.X, pSign_Ua_Out.Y ) );

  if FWiringError.UsbBroken then     // Ub ���ζ�
    DrawBroken( Point( pSign_Ub_Out.X - 11, pSign_Ub_Out.Y ),
      Point( pSign_Ub_Out.X, pSign_Ub_Out.Y ) );

  if FWiringError.UscBroken then     // Uc ���ζ�
    DrawBroken( Point( pSign_Uc_Out.X - 11, pSign_Uc_Out.Y ),
      Point( pSign_Uc_Out.X, pSign_Uc_Out.Y ) );
end;

procedure TWE_DIAGRAM.DrawDiagram4;
var
  pSUa, pSUb, pSUc, pSUn    : TPoint;  // ��ѹԴ
  pUa, pUb, pUc, pUn : TPoint;        // ��ѹ

  pTAa_P, pTAa_N,
  pTAb_P, pTAb_N,
  pTAc_P, pTAc_N : TPoint;  // ������Ȧ

  pSign_Ia_P_In, pSign_Ia_N_In,
  pSign_Ib_P_In, pSign_Ib_N_In,
  pSign_Ic_P_In, pSign_Ic_N_In : TPoint; // ������־ ��

  pSign_Ia_P_Out, pSign_Ia_N_Out,
  pSign_Ib_P_Out, pSign_Ib_N_Out,
  pSign_Ic_P_Out, pSign_Ic_N_Out : TPoint; // ������־ ��

  pIa_P, pIa_N,
  pIb_P, pIb_N,
  pIc_P, pIc_N : TPoint;  // ���� ����

  pU_Order : array[0..2] of TPoint;     // ��ѹ����
  pI_Order : array[0..2] of TPoint;     // ��������
begin
  // ��ѹԴ
  pSUa := Point( FRect.Left + 159, FRect.Top + 94  );
  pSUb := Point( FRect.Left + 159, FRect.Top + 112 );
  pSUc := Point( FRect.Left + 159, FRect.Top + 130 );
  pSUn := Point( FRect.Left + 159, FRect.Top + 148 );

  // ��ѹ
  pUa  := Point( FRect.Left + 179, FRect.Top + 94  );
  pUb  := Point( FRect.Left + 179, FRect.Top + 112 );
  pUc  := Point( FRect.Left + 179, FRect.Top + 130 );
  pUn  := Point( FRect.Left + 179, FRect.Top + 148 );

  // ������Ȧ ��
  pTAa_P := Point( FRect.Left + 61,  FRect.Top + 198 );
  pTAa_N := Point( FRect.Left + 61,  FRect.Top + 222 );
  pTAb_P := Point( FRect.Left + 103, FRect.Top + 225 );
  pTAb_N := Point( FRect.Left + 103, FRect.Top + 249 );
  pTAc_P := Point( FRect.Left + 145, FRect.Top + 252 );
  pTAc_N := Point( FRect.Left + 145, FRect.Top + 276 );

  // ������־ ��
  pSign_Ia_P_In := Point(FRect.Left + 69, FRect.Top + 198);
  pSign_Ia_N_In := Point(FRect.Left + 61, FRect.Top + 289);
  pSign_Ib_P_In := Point(FRect.Left + 111,FRect.Top +  225);
  pSign_Ib_N_In := Point(FRect.Left + 103,FRect.Top +  289);
  pSign_Ic_P_In := Point(FRect.Left + 153,FRect.Top +  252);
  pSign_Ic_N_In := Point(FRect.Left + 145,FRect.Top +  289);

  // ������־ ��
  pSign_Ia_P_Out := Point(FRect.Left + 172, FRect.Top + 198);
  pSign_Ia_N_Out := Point(FRect.Left + 172, FRect.Top + 289);
  pSign_Ib_P_Out := Point(FRect.Left + 172, FRect.Top + 225);
  pSign_Ib_N_Out := Point(FRect.Left + 172, FRect.Top + 289);
  pSign_Ic_P_Out := Point(FRect.Left + 172, FRect.Top + 252);
  pSign_Ic_N_Out := Point(FRect.Left + 172, FRect.Top + 289);

  // ����
  pIa_P  := Point(FRect.Left + 189, FRect.Top + 198);
  pIa_N  := Point(FRect.Left + 189, FRect.Top + 289);
  pIb_P  := Point(FRect.Left + 189, FRect.Top + 225);
  pIb_N  := Point(FRect.Left + 189, FRect.Top + 289);
  pIc_P  := Point(FRect.Left + 189, FRect.Top + 252);
  pIc_N  := Point(FRect.Left + 189, FRect.Top + 289);

  //----------------------------------------------------------------------------
  // ��ѹ ����
  //----------------------------------------------------------------------------
  pU_Order[0] := pSUa;
  pU_Order[1] := pSUb;
  pU_Order[2] := pSUc;
  ChangeSequence( pU_Order, FWiringError.USequence );
  DrawConnection( pU_Order[0], pUa, True );
  DrawConnection( pU_Order[1], pUb, True );
  DrawConnection( pU_Order[2], pUc, True );
  DrawConnection( pSUn, pUn, True );

  //----------------------------------------------------------------------------
  // ���� ����
  //----------------------------------------------------------------------------
  if FWiringError.CT1Reverse then     // Ia ��
  begin
    DrawConnection( pTAa_N, pSign_Ia_P_In );
    DrawConnection( pSign_Ia_N_In, pTAa_P );
  end
  else
  begin
    DrawConnection( pTAa_P, pSign_Ia_P_In );
    DrawConnection( pTAa_N, pSign_Ia_N_In );
  end;

  if FWiringError.CT2Reverse then     // Ib ��
  begin
    DrawConnection( pTAb_N, pSign_Ib_P_In );
    DrawConnection( pSign_Ib_N_In, pTAb_P );
  end
  else
  begin
    DrawConnection( pTAb_P, pSign_Ib_P_In );
    DrawConnection( pTAb_N, pSign_Ib_N_In );
  end;

  if FWiringError.CT3Reverse then     // Ic ��
  begin
    DrawConnection( pTAc_N, pSign_Ic_P_In );
    DrawConnection( pSign_Ic_N_In, pTAc_P );
  end
  else
  begin
    DrawConnection( pTAc_P, pSign_Ic_P_In );
    DrawConnection( pTAc_N, pSign_Ic_N_In );
  end;

  //----------------------------------------------------------------------------
  // ���� ����
  //----------------------------------------------------------------------------
  pI_Order[0] := pSign_Ia_P_Out;
  pI_Order[1] := pSign_Ib_P_Out;
  pI_Order[2] := pSign_Ic_P_Out;
  ChangeSequence( pI_Order, FWiringError.ISequence );
  DrawConnection( pI_Order[0], pIa_P, True );
  DrawConnection( pI_Order[1], pIb_P, True );
  DrawConnection( pI_Order[2], pIc_P, True );

  pI_Order[0] := pSign_Ia_N_Out;
  pI_Order[1] := pSign_Ib_N_Out;
  pI_Order[2] := pSign_Ic_N_Out;
  ChangeSequence( pI_Order, FWiringError.ISequence );
  DrawConnection( pI_Order[0], pIa_N, True );
  DrawConnection( pI_Order[1], pIb_N, True );
  DrawConnection( pI_Order[2], pIc_N, True );

  //----------------------------------------------------------------------------
  // ��ѹ����
  //----------------------------------------------------------------------------
  if FWiringError.UaBroken then
    DrawBroken( Point(pSUa.X - 15, pSUa.Y), Point(pSUa.X - 5, pSUa.Y) );

  if FWiringError.UbBroken then
    DrawBroken( Point(pSUb.X - 15, pSUb.Y), Point(pSUb.X - 5, pSUb.Y) );

  if FWiringError.UcBroken then
    DrawBroken( Point(pSUc.X - 15, pSUc.Y), Point(pSUc.X - 5, pSUc.Y) );

  if FWiringError.UnBroken then
    DrawBroken( Point(pSUn.X - 15, pSUn.Y), Point(pSUn.X - 5, pSUn.Y) );

  //----------------------------------------------------------------------------
  // ���ε�����·
  //----------------------------------------------------------------------------
  if FWiringError.IaBroken then
    DrawBroken( Point(pSign_Ia_P_Out.X - 12, pSign_Ia_P_Out.Y),
      Point(pSign_Ia_P_Out.X - 2, pSign_Ia_P_Out.Y) );

  if FWiringError.IbBroken then
    DrawBroken( Point(pSign_Ib_P_Out.X - 12, pSign_Ib_P_Out.Y),
      Point(pSign_Ib_P_Out.X - 2, pSign_Ib_P_Out.Y) );

  if FWiringError.IcBroken then
    DrawBroken( Point(pSign_Ic_P_Out.X - 12, pSign_Ic_P_Out.Y),
      Point(pSign_Ic_P_Out.X - 2, pSign_Ic_P_Out.Y) );

  //----------------------------------------------------------------------------
  // ���ε�����·
  //----------------------------------------------------------------------------
  if FWiringError.CT1Short then
    DrawConnection( Point( pTAa_P.X - 5, pTAa_P.Y + 2 ),
      Point( pTAa_N.X - 5, pTAa_N.Y - 2 ), True, clRed );

  if FWiringError.CT2Short then
    DrawConnection( Point( pTAb_P.X - 5, pTAb_P.Y + 2 ),
      Point( pTAb_N.X - 5, pTAb_N.Y - 2 ), True, clRed );

  if FWiringError.CT3Short then
    DrawConnection( Point( pTAc_P.X - 5, pTAc_P.Y + 2 ),
      Point( pTAc_N.X - 5, pTAc_N.Y - 2 ), True, clRed );
end;

procedure TWE_DIAGRAM.SetRect( const Value : TRect );
begin
  FRect := Value;
end;

procedure TWE_DIAGRAM.SetWiringError( const Value : TWIRING_ERROR );
begin
  if Assigned( Value ) then
  begin
    FWiringError.Assign( Value );
    DrawDiagram;
  end;
end;

end.

