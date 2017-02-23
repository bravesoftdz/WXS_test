{===============================================================================
  Copyright(c) 2010, ���������˵����Ǳ��������ι�˾
  All rights reserved.

  ���ܱ� ͨѶ���͵�Ԫ

===============================================================================}
unit xDL645Type;

interface

const
  C_645_RESET_TIME        = 1; //  �㲥Уʱ
  C_645_READ_DATA         = 2; //  ������
  C_645_READ_NEXTDATA     = 3; //  ����������
  C_645_READ_ADDR         = 4; //  ��ͨ�ŵ�ַ
  C_645_WRITE_DATA        = 5; //  д����
  C_645_WRITE_ADDR        = 6; //  дͨ�ŵ�ַ
  C_645_FREEZE            = 7; //  ��������
  C_645_CHANGE_BAUD_RATE  = 8; //  �Ĳ�ͨѶ����
  C_645_CHANGE_PWD        = 9; //  ������
  C_645_CLEAR_MAX_DEMAND  = 10;//  �����������
  C_645_CLEAR_RDATA       = 11;//  �������
  C_645_CLEAR_REVENT      = 12;//  �¼�����
  C_SET_WOUT_TYPE         = 13;//  ���ö๦�ܿ�
  C_645_IDENTITY          = 14;//  �����֤
  C_645_ONOFF_CONTROL     = 15;//  ����բ
  C_645_CLEAR_RDATA_13    = 16;//  �������
  C_645_CLEAR_REVENT_13   = 17;//  �¼�����
  C_645_DATA_COPY         = 18;//  ���ݻس�

type
  /// <summary>
  /// Э������
  /// </summary>
  TDL645_PROTOCOL_TYPE = ( dl645ptNone, //  δ֪����
                           dl645pt1997, //  DL645-1997
                           dl645pt2007  //  DL645-2007
                          );

const
  /// <summary>
  /// ����ȴ�ʱ��
  /// </summary>
  C_COMMAND_TIMEOUT = 1500;
type
  /// <summary>
  /// �๦�ܿ����
  /// </summary>
  TMOUT_TYPE = (
                 motSecond,    //  ������
                 motCycDemand, //  ��������
                 motSwitch     //  ʱ��Ͷ��
  );


//type
//  /// <summary>
//  /// ������������
//  /// </summary>
//  TCOMMAND_DL645_TYPE = ( cmd645None,
//                          C_645_RESET_TIME,      //  �㲥Уʱ
//                          C_645_READ_DATA,       //  ������
//                          C_645_READ_NEXTDATA,   //  ����������
//                          C_645_READ_ADDR,       //  ��ͨ�ŵ�ַ
//                          C_645_WRITE_DATA,      //  д����
//                          C_645_WRITE_ADDR,      //  дͨ�ŵ�ַ
//                          C_645_FREEZE,         //  ��������
//                          C_645_CHANGE_BAUD_RATE, //  �Ĳ�ͨѶ����
//                          C_645_CHANGE_PWD,      //  ������
//                          C_645_CLEAR_MAX_DEMAND, //  �����������
//                          C_645_CLEAR_RDATA,      //  �������
//                          C_645_CLEAR_REVENT,     //  �¼�����
//                          C_SET_WOUT_TYPE,       //  ���ö๦�ܿ��������
//                          C_645_IDENTITY,       //  �����֤
//                          C_645_ONOFF_CONTROL   //  ����բ����
//
//                       );


//  C_645_RESET_TIME        = 1; //  �㲥Уʱ
//  C_645_READ_DATA         = 2; //  ������
//  C_645_READ_NEXTDATA     = 3; //  ����������
//  C_645_READ_ADDR         = 4; //  ��ͨ�ŵ�ַ
//  C_645_WRITE_DATA        = 5; //  д����
//  C_645_WRITE_ADDR        = 6; //  дͨ�ŵ�ַ
//  C_645_FREEZE            = 7; //  ��������
//  C_645_CHANGE_BAUD_RATE  = 8; //  �Ĳ�ͨѶ����
//  C_645_CHANGE_PWD        = 9; //  ������
//  C_645_CLEAR_MAX_DEMAND  = 10;//  �����������
//  C_645_CLEAR_RDATA       = 11;//  �������
//  C_645_CLEAR_REVENT      = 12;//  �¼�����
//  C_SET_WOUT_TYPE         = 13;//  ���ö๦�ܿ�
//  C_645_IDENTITY          = 14;//  �����֤
//  C_645_ONOFF_CONTROL     = 15;//  ����բ
//  C_645_CLEAR_RDATA_13    = 16;//  �������
//  C_645_CLEAR_REVENT_13   = 17;//  �¼�����
//  C_645_DATA_COPY         = 18;//  ���ݻس�








//function GetDL645TypeStr( ADL645Type : TCOMMAND_DL645_TYPE ) :string;
type
  /// <summary>
  /// DL645_07��������
  /// </summary>
  TDL645_07_ERR = ( de645_07None,
                    de645_07OverRate,      // ��������
                    de645_07OverDayTime,   // ��ʱ������
                    de645_07OverYearTme,   // ��ʱ������
                    de645_07BaudNotChange, // ͨѶ���ʲ��ܸ�
                    de645_07PwdError,      // ��������δ��Ȩ
                    de645_07NoneData,      // ����������
                    de645_07OtherError,     // ��������
                    de645_07RepeatTopUp,     // �ظ���ֵ
                    de645_07ESAMError,         // ESAM��֤ʧ��
                    de645_07IdentityError,     // �����֤ʧ��
                    de645_07ClientSNError,     // �ͻ���Ų�ƥ��
                    de645_07TopUpTimesError,   // ��ֵ��������
                    de645_07BuyOverError       // ���糬�ڻ�

                  );



  /// <summary>
  /// ��������
  /// </summary>
  TDL645_07_FREEZE_TYPE = ( dft_07None,    // δ֪����
                            dft_07Month,   // �¶���
                            dft_07Day,     // �ն���
                            dft_07Hour,    // ʱ����
                            dft_07Now      // ˲ʱ����
                           );

  /// <summary>
  /// �¼���������
  /// </summary>
  TDL645_07_CLEAREVENT_TYPE = ( dct_07None, // δ֪����
                                dct_07All,  // ȫ������
                                dct_07Item  // ��������
  );

function Get07ErrStr( AErrType : TDL645_07_ERR ) : string;


/// <summary>
/// 97�����ݱ�ʶת����07�����ݱ�ʶ
/// </summary>
function Sign97To07(nSign:int64):int64;

implementation
//
//function GetDL645TypeStr( ADL645Type : TCOMMAND_DL645_TYPE ) :string;
//begin
//  Result := '';
//  case ADL645Type of
//    C_645_RESET_TIME:      Result := '�㲥Уʱ';
//    C_645_READ_DATA:       Result := '������';
//    C_645_READ_NEXTDATA:   Result := '����������';
//    C_645_READ_ADDR:       Result := '��ͨ�ŵ�ַ';
//    C_645_WRITE_DATA:      Result := 'д����';
//    C_645_WRITE_ADDR:      Result := 'дͨ�ŵ�ַ';
//    C_645_FREEZE:         Result := '��������';
//    C_645_CHANGE_BAUD_RATE: Result := '�Ĳ�ͨѶ����';
//    C_645_CHANGE_PWD:      Result := '������';
//    C_645_CLEAR_MAX_DEMAND: Result := '�����������';
//    C_645_CLEAR_RDATA:      Result := '�������';
//    C_645_CLEAR_REVENT:     Result := '�¼�����';
//    C_SET_WOUT_TYPE:       Result := '�๦�ܿ�����';
//    C_645_IDENTITY:       Result := '�����֤';
//    C_645_ONOFF_CONTROL :  Result := '�ѿع���';
//  end;
//end;

function Get07ErrStr( AErrType : TDL645_07_ERR ) : string;
begin
  case AErrType of
    de645_07None:          Result := '�޴���';
    de645_07OverRate:      Result := '��������';
    de645_07OverDayTime:   Result := '��ʱ������';
    de645_07OverYearTme:   Result := '��ʱ������';
    de645_07BaudNotChange: Result := 'ͨѶ���ʲ��ܸ�';
    de645_07PwdError:      Result := '��������δ��Ȩ';
    de645_07NoneData:      Result := '����������';
    de645_07OtherError:    Result := '��������';
    de645_07RepeatTopUp:    Result := '�ظ���ֵ';
    de645_07ESAMError:    Result := 'ESAM��֤ʧ��';
    de645_07IdentityError:    Result := '�����֤ʧ��';
    de645_07ClientSNError:    Result := '�ͻ���Ų�ƥ��';
    de645_07TopUpTimesError:    Result := '��ֵ��������';
    de645_07BuyOverError:    Result := '���糬�ڻ�';
  end;
end;

function Sign97To07(nSign:int64):int64;
begin
  if nSign = $9010 then
    Result := $00000000
  else if nSign = $9011 then
    Result := $00000100
  else if nSign = $9012 then
    Result := $00000200
  else if nSign = $9013 then
    Result := $00000300
  else if nSign = $9014 then
    Result := $00000400
  else if nSign = $9110 then
    Result := $00030000
  else if nSign = $9120 then
    Result := $00040000
  else if nSign = $A010 then
    Result := $01010000
  else if nSign = $B010 then
    Result := $01010000
  else if nSign = $A110 then
    Result := $01020000
  else if nSign = $B110 then
    Result := $01020000

  else if nSign = $B611 then Result := $02010100
  else if nSign = $B612 then Result := $02010200
  else if nSign = $B613 then Result := $02010300
  else if nSign = $B621 then Result := $02020100
  else if nSign = $B622 then Result := $02020200
  else if nSign = $B623 then Result := $02020300
  else if nSign = $B630 then Result := $02030000
  else if nSign = $B631 then Result := $02030100
  else if nSign = $B632 then Result := $02030200
  else if nSign = $B633 then Result := $02030300
  else if nSign = $B640 then Result := $02040000
  else if nSign = $B641 then Result := $02040100
  else if nSign = $B642 then Result := $02040200
  else if nSign = $B643 then Result := $02040300
  else if nSign = $C030 then Result := $04000409
  else if nSign = $C031 then Result := $0400040A
  else if nSign = $C032 then Result := $04000402
  else if nSign = $C010 then Result := $04000101
  else if nSign = $C011 then Result := $04000102
  else
    Result := $00010000


//$C033
//$C034
//$C035






end;

end.















