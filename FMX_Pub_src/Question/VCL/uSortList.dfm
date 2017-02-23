object fSortList: TfSortList
  Left = 0
  Top = 0
  Caption = #39064#24211#21015#34920
  ClientHeight = 406
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lvSortList: TListView
    Left = 0
    Top = 0
    Width = 547
    Height = 365
    Align = alClient
    Columns = <
      item
        Caption = #32534#21495
        Width = 60
      end
      item
        Caption = #39064#24211#21517#31216
        Width = 150
      end
      item
        Caption = #39064#24211#22791#27880
        Width = 300
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = pctnbr1
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvSortListClick
    OnDblClick = lvSortListDblClick
    ExplicitTop = 3
  end
  object pnl1: TPanel
    Left = 0
    Top = 365
    Width = 547
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnAdd: TButton
      Left = 14
      Top = 9
      Width = 75
      Height = 25
      Action = actAdd
      TabOrder = 0
    end
    object btnDelete: TButton
      Left = 95
      Top = 9
      Width = 75
      Height = 25
      Action = actDelete
      TabOrder = 1
    end
    object btnEdit: TButton
      Left = 176
      Top = 9
      Width = 75
      Height = 25
      Action = actEdit
      TabOrder = 2
    end
    object btnClear: TButton
      Left = 257
      Top = 9
      Width = 75
      Height = 25
      Action = actClear
      TabOrder = 3
    end
  end
  object actmgr1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actAdd
            ImageIndex = 0
          end
          item
            Action = actEdit
            ImageIndex = 1
          end
          item
            Action = actDelete
            ImageIndex = 2
          end>
      end>
    Images = il1
    Left = 320
    Top = 56
    StyleName = 'XP Style'
    object actAdd: TAction
      Caption = #28155#21152'(&A)'
      ImageIndex = 0
      OnExecute = actAddExecute
    end
    object actEdit: TAction
      Caption = #20462#25913'(&E)'
      ImageIndex = 1
      OnExecute = actEditExecute
    end
    object actDelete: TAction
      Caption = #21024#38500'(&D)'
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actClear: TAction
      Caption = #28165#31354'(&C)'
      ImageIndex = 4
      OnExecute = actClearExecute
    end
    object actLoadList: TAction
      Caption = 'actLoadList'
      OnExecute = actLoadListExecute
    end
  end
  object il1: TImageList
    Left = 360
    Top = 56
    Bitmap = {
      494C010109000E00140010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000004620900035F
      090003560600014F0400014C0400014C0400014C0400014C0400014C0400014C
      0400014C0400013D030000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000078216000C9C2300099A
      1D000796150005920F0003900B00038F0A00038F0A0003900A0003900A00038F
      0A0003960B0002740700013D0300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000D98250013B53A000FAF
      2D000CAC230009AB1C0006A7150004A50E0003A50C0003A50C0003A50C0003A4
      0C0003AC0D0003960A00014C0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000010A02D001CB4490016AD
      390011A92F000DA72600C6EDCE001CAB2C00059F1000039E0C00039D0B00039C
      0B0003A40C0003900A00014D0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F0028B85B001FB2
      4C0018AD3D0012AA3500FFFFFF00EDFAEF0035BA470005A01300039F0D00039D
      0B0003A50C0003900A00014C0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F003EC270002DBA
      5F001FB54E0018AD4200FFFFFF00FFFFFF00FFFFFF0062CB740006A01600049E
      0F0003A40C0003900A00014C0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F005CCC880038BD
      670024B757001FB45000FFFFFF00FFFFFF00FFFFFF00FFFFFF0092DCA00008A1
      190005A7120003910B00014D0400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F0070D4970042C2
      70002AB85B0021B55300FFFFFF00FFFFFF00FFFFFF00FFFFFF0095DDA6000BA6
      230009A91C000593110002540500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F007DD79F004AC5
      76002FBB5F0024B75700FFFFFF00FFFFFF00FFFFFF005ECC810013AC37000FA9
      2D000DAC270009991B00035F0900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F0086DAA60054C9
      7F003DC06B0035BD6500FFFFFF00EFFAF30041C26E001CB24D0018B0450015AD
      3B0012AF35000D9E2500056B0C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F0093DEB10066CF
      8C0043C270003FC16D00D3F2E00036BD66002BB85C0023B555001DB2500019B0
      480017B1420010A12F0006760F00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A1300099E1B50090DD
      AD0078D59A006CD091005DCB86004CC678003FC16D002CBA5D0020B553001DB2
      51001CB54F0015A93D0008841400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000011A12F0079D79F0099E1
      B6009DE2B80093DEB10083DAA5006DD395004FC97E0035BF680024B7590020B5
      55001FB8580018AD4300098E1600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000022A9400037B5
      550039B5560037B5540033B250002AAF490021AA40001AA6390013A4310012A1
      320012A431000C9A230000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000003A95000039
      92000035870000317E00002F7900002F7900002F7900002F7900002F7900002F
      7900002F790000296A0000000000000000000000000000000000003A95000039
      92000035870000317E00002F7900002F7900002F7900002F7900002F7900002F
      7900002F790000296A0000000000000000000000000000000000003A95000039
      92000035870000317E00002F7900002F7900002F7900002F7900002F7900002F
      7900002F790000296A000000000000000000000000000000000004620900035F
      090003560600014F0400014C0400014C0400014C0400014C0400014C0400014C
      0400014C0400013D0300000000000000000000000000004BC0000058E1000055
      D9000052D100004EC700004BC000004BC000004BC000004BC000004BC000004B
      C000004DC5000041A50000296A000000000000000000004BC0000058E1000055
      D9000052D100004EC700004BC000004BC000004BC000004BC000004BC000004B
      C000004DC5000041A50000296A000000000000000000004BC0000058E1000055
      D9000052D100004EC700004BC000004BC000004BC000004BC000004BC000004B
      C000004DC5000041A50000296A000000000000000000078216000C9C2300099A
      1D000796150005920F0003900B00038F0A00038F0A0003900A0003900A00038F
      0A0003960B0002740700013D030000000000000000000057DE000268FF000062
      F800005EF000005CEB000058E1000054D7000054D7000054D7000054D7000054
      D7000056DC00004DC500002F790000000000000000000057DE000268FF000062
      F800005EF000005CEB000058E1000054D7000054D7000054D7000054D7000054
      D7000056DC00004DC500002F790000000000000000000057DE000268FF000062
      F800005EF000005CEB000058E1000054D7000054D7000054D7000054D7000054
      D7000056DC00004DC500002F790000000000000000000D98250013B53A000FAF
      2D000CAC230009AB1C0006A7150004A50E0003A50C0003A50C0003A50C0003A4
      0C0003AC0D0003960A00014C04000000000000000000005DEE00066CFF000167
      FF000060F600005DEE00005AE6000056DC000054D7000052D1000051CF000050
      CC000054D700004BC00000307B000000000000000000005DEE00066CFF000167
      FF000060F600005DEE000664E700C1DCF8001C70DE000052D1000051CF000050
      CC000054D700004BC00000307B000000000000000000005DEE00066CFF000167
      FF000669F60066AAF700FFFFFF00FFFFFF00FFFFFF0066A3E900065AD1000050
      CC000054D700004BC00000307B00000000000000000010A02D001CB4490016AD
      390011A92F000DA726000AA41E0007A0160018AB2500C4EDC700039D0B00039C
      0B0003A40C0003900A00014D04000000000000000000005EF0000F75FF00086E
      FF000268FF00FFFFFF00C1DEFC000665EA000058E10088BAEF00FFFFFF000051
      CF000054D700004BC000002F79000000000000000000005EF0000F75FF00086E
      FF000268FF00066AF800C1DEFC00FFFFFF0076B1F2000054D7000052D1000051
      CF000054D700004BC000002F79000000000000000000005EF0000F75FF00086E
      FF008BC2FF00EAF4FF004596F6002880EE004592ED00EAF3FC0088B8EE000051
      CF000054D700004BC000002F7900000000000000000011A12F0028B85B001FB2
      4C0018AD3D0012AA35000EA72A0038BB4F00EBF8EE00FFFFFF00039F0D00039D
      0B0003A50C0003900A00014C04000000000000000000005EF0002686FF001579
      FF00086EFF00C2E0FF00FFFFFF00C1DEFC0088BDF800FFFFFF00C1DCF8000053
      D4000054D700004BC000002F79000000000000000000005EF0002686FF001579
      FF001176FF00C2E0FF00FFFFFF00FFFFFF00D5E9FC000059E3000055D9000053
      D4000054D700004BC000002F79000000000000000000005EF0002686FF001579
      FF00FFFFFF00499DFF000063FB00005FF300005DEE004592EE00FFFFFF000053
      D4000054D700004BC000002F7900000000000000000011A12F003EC270002DBA
      5F001FB54E0018AD42006ACF8600FFFFFF00FFFFFF00FFFFFF0006A01600049E
      0F0003A40C0003900A00014C04000000000000000000005EF000469AFF001F81
      FF000D73FF001176FF00C2E0FF00FFFFFF00FFFFFF00C1DEFC000665EA000057
      DE000056DC00004CC20000307B000000000000000000005EF000469AFF001F81
      FF00D9EDFF00FFFFFF00C2E0FF00459AFF00FFFFFF002883F400005BE9000057
      DE000056DC00004CC20000307B000000000000000000005EF000469AFF001F81
      FF00FFFFFF003590FF00499DFF00FFFFFF000062F8001070F20066A9F4000057
      DE000056DC00004CC20000307B00000000000000000011A12F005CCC880038BD
      670024B757009FE2B700FFFFFF00FFFFFF00FFFFFF00FFFFFF000BA5210008A1
      190005A7120003910B00014D04000000000000000000005EF0005CA7FF002988
      FF001277FF000A70FF008EC4FF00FFFFFF00FFFFFF00C1DEFE000667F200005B
      E900005AE600004FCA00003382000000000000000000005EF0005CA7FF002988
      FF005BA7FF0092C6FF000D74FF000268FF009CCBFF0088C0FC00005EF000005B
      E900005AE600004FCA00003382000000000000000000005EF0005CA7FF002988
      FF00EDF6FF00A3CFFF006CB1FF00FFFFFF00FFFFFF004598FB00005EF000005B
      E900005AE600004FCA0000338200000000000000000011A12F0070D4970042C2
      70002AB85B00A0E2B800FFFFFF00FFFFFF00FFFFFF00FFFFFF000FA92C000BA6
      230009A91C0005931100025405000000000000000000005EF00069AFFF00328E
      FF00187BFF0093C7FF00FFFFFF00C4E1FF00C4E1FF00FFFFFF00C1E0FF00005F
      F300005EF0000054D700003A95000000000000000000005EF00069AFFF00328E
      FF00187BFF000D73FF00066CFF00056BFF00177AFF00D7EAFF00066CFF00005F
      F300005EF0000054D700003A95000000000000000000005EF00069AFFF00328E
      FF0060AAFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ADD5FF00005F
      F300005EF0000054D700003A9500000000000000000011A12F007DD79F004AC5
      76002FBB5F0024B7570065CF8C00FFFFFF00FFFFFF00FFFFFF0013AC37000FA9
      2D000DAC270009991B00035F09000000000000000000005EF00074B5FF003D95
      FF002484FF00EEF6FF00C9E3FF001579FF001377FF00C4E1FF00FFFFFF000166
      FF000064FF000059E3000040A3000000000000000000005EF00074B5FF003D95
      FF002484FF001C7FFF001176FF000C72FF00096FFF004D9FFF0059A6FF000166
      FF000064FF000059E3000040A3000000000000000000005EF00074B5FF003D95
      FF002484FF004A9DFF00B7DAFF00FFFFFF00FFFFFF009FCEFF001479FF000166
      FF000064FF000059E3000040A300000000000000000011A12F0086DAA60054C9
      7F003DC06B0035BD650028B8590043C27200EEFAF300FFFFFF0018B0450015AD
      3B0012AF35000D9E2500056B0C000000000000000000005EF00081BCFF0050A0
      FF002B89FF002686FF001B7EFF001378FF001277FF000C72FF00066CFF000369
      FF000268FF00005DEE000044AF000000000000000000005EF00081BCFF0050A0
      FF002B89FF002686FF001B7EFF001378FF001277FF000C72FF006DB2FF000369
      FF000268FF00005DEE000044AF000000000000000000005EF00081BCFF0050A0
      FF002B89FF002686FF007FBCFF00FFFFFF004097FF000C72FF00066CFF000369
      FF000268FF00005DEE000044AF00000000000000000011A12F0093DEB10066CF
      8C0043C270003FC16D0034BD64002CBA5D0035BC6600CFF0DC001DB2500019B0
      480017B1420010A12F0006760F000000000000000000005EF0008AC1FF007FBB
      FF0065ACFF0056A4FF00469AFF003590FF002686FF001378FF00096FFF00066C
      FF00066CFF000064FF00004BC0000000000000000000005EF0008AC1FF007FBB
      FF0065ACFF0056A4FF00469AFF003590FF002686FF001378FF00096FFF00066C
      FF00066CFF000064FF00004BC0000000000000000000005EF0008AC1FF007FBB
      FF0065ACFF0056A4FF00469AFF003590FF002686FF001378FF00096FFF00066C
      FF00066CFF000064FF00004BC000000000000000000011A1300099E1B50090DD
      AD0078D59A006CD091005DCB86004CC678003FC16D002CBA5D0020B553001DB2
      51001CB54F0015A93D00088414000000000000000000005EF00067ADFF008AC1
      FF008FC4FF0081BCFF0072B4FF005AA6FF003791FF001E80FF000D73FF00096F
      FF000A70FF000268FF000050CC000000000000000000005EF00067ADFF008AC1
      FF008FC4FF0081BCFF0072B4FF005AA6FF003791FF001E80FF000D73FF00096F
      FF000A70FF000268FF000050CC000000000000000000005EF00067ADFF008AC1
      FF008FC4FF0081BCFF0072B4FF005AA6FF003791FF001E80FF000D73FF00096F
      FF000A70FF000268FF000050CC00000000000000000011A12F0079D79F0099E1
      B6009DE2B80093DEB10083DAA5006DD395004FC97E0035BF680024B7590020B5
      55001FB8580018AD4300098E1600000000000000000000000000056BFF00197D
      FF001B7EFF00197DFF001579FF000D73FF00056BFF000166FF000060F600005E
      F000005FF3000057DE0000000000000000000000000000000000056BFF00197D
      FF001B7EFF00197DFF001579FF000D73FF00056BFF000166FF000060F600005E
      F000005FF3000057DE0000000000000000000000000000000000056BFF00197D
      FF001B7EFF00197DFF001579FF000D73FF00056BFF000166FF000060F600005E
      F000005FF3000057DE000000000000000000000000000000000022A9400037B5
      550039B5560037B5540033B250002AAF490021AA40001AA6390013A4310012A1
      320012A431000C9A230000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000D6C00000D
      6800000C5D00000A5300000A4F00000A4F00000A4F00000A4F00000A4F00000A
      4F00000A4F000008400000000000000000000000000000000000000D6C00000D
      6800000C5D00000A5300000A4F00000A4F00000A4F00000A4F00000A4F00000A
      4F00000A4F000008400000000000000000000000000000000000000D6C00000D
      6800000C5D00000A5300000A4F00000A4F00000A4F00000A4F00000A4F00000A
      4F00000A4F000008400000000000000000000000000000000000004B0000004B
      0000A1828300A1828300A1828300A1828300A1828300A1828300A1828300004B
      0000004B000000000000000000000000000000000000001397000017BB000016
      B4000015AA000013A00000139900001397000013970000139900001399000013
      970000139E00000F7B00000840000000000000000000001397000017BB000016
      B4000015AA000013A00000139900001397000013970000139900001399000013
      970000139E00000F7B00000840000000000000000000001397000017BB000016
      B4000015AA000013A00000139900001397000013970000139900001399000013
      970000139E00000F7B00000840000000000000000000004B0000008100000081
      0000DDD4D500004B0000004B0000DCE0E000D7DADE00CED5D700BDBABD00004B
      000001630100004B00000000000000000000000000000017B800001CE300001A
      D4000019CC000018C5000017BB000016B1000016AF000016AF000016AF000016
      AF000016B60000139E00000A4F0000000000000000000017B800001CE300001A
      D4000019CC000018C5000017BB000016B1000016AF000016AF000016AF000016
      AF000016B60000139E00000A4F0000000000000000000017B800001CE300001A
      D4000019CC000018C5000017BB000016B1000016AF000016AF000016AF000016
      AF000016B60000139E00000A4F000000000000000000004B0000008100000081
      0000E2D9D900004B0000004B0000D9D8DA00D9DEE100D3D9DC00C1BDC100004B
      000001630100004B00000000000000000000000000000018C700001EF000001C
      E100001AD1000018C7000018C0000016B6000016AF000015AA000015A7000014
      A5000016AF0000139900000A510000000000000000000018C700001EF000001C
      E100001AD1000018C7003653D300EAEEFA008899E000061FAF000015A7000014
      A5000016AF0000139900000A510000000000000000000018C700001EF000001C
      E100001AD1000018C7000018C0000016B6000016AF000015AA000015A7000014
      A5000016AF0000139900000A51000000000000000000004B0000008100000081
      0000E6DCDC00004B0000004B0000D5D3D500D8DEE100D7DDE000C6C2C500004B
      000001630100004B00000000000000000000000000000018CA000224FF00001F
      F600001CE300001AD4000018CA00FFFFFF00F4F7FF000016B1000015AA000015
      A7000016AF0000139900000A4F0000000000000000000018CA000224FF00001F
      F6009AACF6000624D7000018CA009AAAEB00FFFFFF008899E1000015AA000015
      A7000016AF0000139900000A4F0000000000000000000018CA000224FF00001F
      F600001CE300001AD4000018CA000018C2000017BB000016B1000015AA000015
      A7000016AF0000139900000A4F000000000000000000004B0000008100000081
      0000EADEDE00E7DDDD00DDD4D500D7D3D500D5D7D900D7D8DA00CAC2C500004B
      000001630100004B00000000000000000000000000000018CA00163BFF000629
      FF00001FF600001CE300001BD700FFFFFF00FFFFFF000017BD000016B4000015
      AC000016AF0000139900000A4F0000000000000000000018CA00163BFF000629
      FF00FFFFFF00768FF300001BD7003654DE00FFFFFF00ADBBEE000016B4000015
      AC000016AF0000139900000A4F0000000000000000000018CA00163BFF000629
      FF00001FF600001CE300001BD7000019CF000018C7000017BD000016B4000015
      AC000016AF0000139900000A4F000000000000000000004B0000008100000081
      0000008100000081000000810000008100000081000000810000008100000081
      000000810000004B00000000000000000000000000000018CA003559FF000F35
      FF000121FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000017
      B8000016B60000139C00000A510000000000000000000018CA003559FF000F35
      FF00FFFFFF00FFFFFF00768FF400EAEEFC00FFFFFF00889CEB000018C2000017
      B8000016B60000139C00000A510000000000000000000018CA003559FF000F35
      FF000121FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000017
      B8000016B60000139C00000A51000000000000000000004B0000008100009DC2
      9D009DC29D009DC29D009DC29D009DC29D009DC29D009DC29D009DC29D009DC2
      9D0000810000004B00000000000000000000000000000018CA004E6EFF00193F
      FF000427FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000018
      C2000018C0000014A300000B590000000000000000000018CA004E6EFF00193F
      FF004C6DFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EAEEFC001C3BD5000018
      C2000018C0000014A300000B590000000000000000000018CA004E6EFF00193F
      FF000427FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000018
      C2000018C0000014A300000B59000000000000000000004B000000810000F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F70000810000004B00000000000000000000000000000018CA005A79FF002146
      FF00082CFF000121FF00001EF000FFFFFF00FFFFFF00001CE100001BD9000019
      CF000019CC000016B100000D6A0000000000000000000018CA005A79FF002146
      FF00082CFF002A4EFF006681F8004565F400C1CCFB00FFFFFF00EAEEFC001C3B
      D8000019CC000016B100000D6A0000000000000000000018CA005A79FF002146
      FF00082CFF000121FF00001EF000001DEE00001DEB00001CE100001BD9000019
      CF000019CC000016B100000D6A000000000000000000004B000000810000F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F70000810000004B00000000000000000000000000000018CA006783FF002D51
      FF001338FF000D31FF000325FF00FFFFFF00FFFFFF00001DEE00001CE600001C
      DE00001BD9000017BD00000F790000000000000000000018CA006783FF002D51
      FF001338FF000D31FF000325FF00001FFF000629F800EAEEFE00FFFFFF00EAEE
      FC00001BD9000017BD00000F790000000000000000000018CA006783FF002D51
      FF001338FF000D31FF000325FF00001FFF00001FF800001DEE00001CE600001C
      DE00001BD9000017BD00000F79000000000000000000004B000000810000F7F7
      F700BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00F7F7
      F70000810000004B00000000000000000000000000000018CA007690FF004163
      FF001B40FF00163BFF000C30FF000528FF000427FF00001FFF00001EF000001C
      E900001CE6000018C7000011870000000000000000000018CA007690FF004163
      FF001B40FF00163BFF000C30FF000528FF000427FF001C41FF00EAEEFE00C1CC
      FB00001CE6000018C7000011870000000000000000000018CA007690FF004163
      FF001B40FF00163BFF000C30FF000528FF000427FF00001FFF00001EF000001C
      E900001CE6000018C700001187000000000000000000004B000000810000F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F70000810000004B00000000000000000000000000000018CA007F98FF00728C
      FF005676FF004668FF003559FF002449FF00163BFF000528FF00001FF800001E
      F000001EF000001BD9000013990000000000000000000018CA007F98FF00728C
      FF005676FF004668FF003559FF002449FF00163BFF000528FF00001FF800001E
      F000001EF000001BD9000013990000000000000000000018CA007F98FF00728C
      FF005676FF004668FF003559FF002449FF00163BFF000528FF00001FF800001E
      F000001EF000001BD900001399000000000000000000004B000000810000F7F7
      F700BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00F7F7
      F70000810000004B00000000000000000000000000000018CA005877FF007F98
      FF00839CFF007690FF006582FF004A6BFF00284CFF000E33FF000121FF00001F
      F800001FFB00001CE3000014A50000000000000000000018CA005877FF007F98
      FF00839CFF007690FF006582FF004A6BFF00284CFF000E33FF000121FF00001F
      F800001FFB00001CE3000014A50000000000000000000018CA005877FF007F98
      FF00839CFF007690FF006582FF004A6BFF00284CFF000E33FF000121FF00001F
      F800001FFB00001CE3000014A5000000000000000000004B000000810000F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F70000810000004B000000000000000000000000000000000000001DEE000A2E
      FF000C30FF000A2EFF000629FF000121FF00001DEE00001CDE00001AD1000019
      CC000019CF000017B80000000000000000000000000000000000001DEE000A2E
      FF000C30FF000A2EFF000629FF000121FF00001DEE00001CDE00001AD1000019
      CC000019CF000017B80000000000000000000000000000000000001DEE000A2E
      FF000C30FF000A2EFF000629FF000121FF00001DEE00001CDE00001AD1000019
      CC000019CF000017B80000000000000000000000000000000000004B0000F7F7
      F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7F700F7F7
      F700004B00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000C003000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      C003000000000000FFFF000000000000FFFFFFFFFFFFFFFFC003C003C003C003
      8001800180018001800180018001800180018001800180018001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      C003C003C003C003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC003C003C003C007
      8001800180018003800180018001800380018001800180038001800180018003
      8001800180018003800180018001800380018001800180038001800180018003
      8001800180018003800180018001800380018001800180038001800180018003
      C003C003C003C007FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object pctnbr1: TPopupActionBar
    Images = il1
    Left = 152
    Top = 88
    object A1: TMenuItem
      Action = actAdd
    end
    object C1: TMenuItem
      Action = actEdit
    end
    object D1: TMenuItem
      Action = actDelete
    end
  end
end
