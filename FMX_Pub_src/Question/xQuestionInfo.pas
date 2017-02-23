unit xQuestionInfo;

interface

uses System.SysUtils, System.Classes;

type
  TQuestionInfo = class
  private
    FQid       : Integer   ;
    FQtype     : Integer   ;
    FQname     : String    ;
    FQCode     : string    ;
    FQdescribe : String    ;
    FQanswer   : String    ;
    FQexplain  : String    ;
    FQremark1  : String    ;
    FQremark2  : String    ;
    FSortID: Integer;
  public
    constructor Create;
    /// <summary>
    /// ���ƶ���
    /// </summary>
    procedure Assign(Source : TQuestionInfo);

    /// <summary>
    /// ���ID
    /// </summary>
    property SortID : Integer read FSortID write FSortID;
    /// <summary>
    /// ������
    /// </summary>
    property QID       : Integer    read FQid       write FQid      ;
    /// <summary>
    /// ��������
    /// </summary>
    property QType     : Integer    read FQtype     write FQtype    ;

    /// <summary>
    /// ��������
    /// </summary>
    function QTypeString : string; virtual;
    /// <summary>
    /// ��������
    /// </summary>
    property QName     : String     read FQname     write FQname    ;

    /// <summary>
    /// �������
    /// </summary>
    property QCode : String     read FQCode write FQCode;

    /// <summary>
    /// ��������
    /// </summary>
    property QDescribe : String     read FQdescribe write FQdescribe;
    /// <summary>
    /// �����
    /// </summary>
    property QAnswer   : String     read FQanswer   write FQanswer  ;
    /// <summary>
    /// �������
    /// </summary>
    property QExplain  : String     read FQexplain  write FQexplain ;
    /// <summary>
    /// ���ⱸע1
    /// </summary>
    property QRemark1  : String     read FQremark1  write FQremark1 ;
    /// <summary>
    /// ���ⱸע2
    /// </summary>
    property QRemark2  : String     read FQremark2  write FQremark2 ;
  end;

implementation

{ TQuestionInfo }

procedure TQuestionInfo.Assign(Source: TQuestionInfo);
begin
  FSortID    := Source.SortID   ;
  FQid       := Source.Qid      ;
  FQtype     := Source.Qtype    ;
  FQname     := Source.Qname    ;
  FQCode     := Source.FQCode   ;
  FQdescribe := Source.Qdescribe;
  FQanswer   := Source.Qanswer  ;
  FQexplain  := Source.Qexplain ;
  FQremark1  := Source.Qremark1 ;
  FQremark2  := Source.Qremark2 ;
end;

constructor TQuestionInfo.Create;
begin
  FQid       := -1;
  FQtype     := -1;
  FQname     := '';
  FQCode     := '';
  FQdescribe := '';
  FQanswer   := '';
  FQexplain  := '';
  FQremark1  := '';
  FQremark2  := '';
end;

function TQuestionInfo.QTypeString: string;
begin
  Result := '����' + IntToStr(FQtype);
end;

end.
