unit xExamInfo;

interface

type
  TExamInfo = class

  public
    constructor Create;
    destructor Destroy; override;
  private
    FExamTime: Integer;
    FExamName: string;

  public
    /// <summary>
    /// ��������
    /// </summary>
    property ExamName : string read FExamName write FExamName;


    /// <summary>
    /// ����ʱ�� (��)
    /// </summary>
    property ExamTime : Integer read FExamTime write FExamTime;
  end;

implementation

{ TExamInfo }

constructor TExamInfo.Create;
begin
  FExamName := 'ȫ�����ܾ���';
  FExamTime := 45;
end;

destructor TExamInfo.Destroy;
begin

  inherited;
end;

end.
