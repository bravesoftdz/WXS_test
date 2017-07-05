unit xTrainQuestionInfo;

interface

type
  /// <summary>
  /// ��ѵ����Ϣ
  /// </summary>
  TTrainQuestion = class
  private
    FTqid     : Integer   ;
    FTqtype   : Integer   ;
    FTqpath   : String    ;
    FTqqname  : String    ;
    FTqcode1  : String    ;
    FTqcode2  : String    ;
    FTqremark : String    ;
  public
    property Tqid     : Integer    read FTqid     write FTqid    ;
    /// <summary>
    /// 0��Ŀ¼ 1���ļ�
    /// </summary>
    property Tqtype   : Integer    read FTqtype   write FTqtype  ;
    property Tqpath   : String     read FTqpath   write FTqpath  ;
    property Tqqname  : String     read FTqqname  write FTqqname ;
    property Tqcode1  : String     read FTqcode1  write FTqcode1 ;
    property Tqcode2  : String     read FTqcode2  write FTqcode2 ;
    property Tqremark : String     read FTqremark write FTqremark;
  end;


implementation

end.
