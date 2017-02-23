unit xExerciseInfo;

interface
type
  TExerciseInfo = class
  private
    FId         : Integer   ;
    FPath       : String    ;
    FPtype      : Integer    ;
    FEname      : String    ;
    FImageindex : Integer   ;
    FCode1      : String    ;
    FCode2      : String    ;
    FRemark     : String    ;
  public
    /// <summary>
    /// ���
    /// </summary>
    property Id         : Integer    read FId         write FId        ;
    /// <summary>
    /// Ŀ¼
    /// </summary>
    property Path       : String     read FPath       write FPath      ;
    /// <summary>
    /// ����
    /// </summary>
    property Ptype      : Integer     read FPtype      write FPtype     ;
    /// <summary>
    /// Ŀ¼��������
    /// </summary>
    property Ename      : String     read FEname      write FEname     ;
    /// <summary>
    /// ͼ�����
    /// </summary>
    property Imageindex : Integer    read FImageindex write FImageindex;
    /// <summary>
    /// ����1
    /// </summary>
    property Code1      : String     read FCode1      write FCode1     ;
    /// <summary>
    /// ����2
    /// </summary>
    property Code2      : String     read FCode2      write FCode2     ;
    /// <summary>
    /// ��ע
    /// </summary>
    property Remark     : String     read FRemark     write FRemark    ;
  end;


implementation

end.
