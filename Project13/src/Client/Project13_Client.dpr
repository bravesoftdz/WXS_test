program Project13_Client;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  FrmClientMain in 'Frame\FrmClientMain.pas' {fClientMain},
  xTCPClient in 'TCP\xTCPClient.pas',
  xCommBase in '..\..\..\FMX_Pub_src\Comm\xCommBase.pas',
  xTCPClientBase in '..\..\..\FMX_Pub_src\Comm\xTCPClientBase.pas',
  xConsts in '..\..\..\FMX_Pub_src\xConsts.pas',
  xFunction in '..\..\..\FMX_Pub_src\xFunction.pas',
  xTypes in '..\..\..\FMX_Pub_src\xTypes.pas',
  xDBConn in '..\..\..\FMX_Pub_src\VCL\xDBConn.pas',
  xVCL_FMX in '..\..\..\FMX_Pub_src\VCL\xVCL_FMX.pas',
  xClientType in '..\Server\Exam\xClientType.pas',
  xClientControl in 'xClientControl.pas',
  xConfig in 'xConfig.pas',
  FrmSelectTCPServer in 'UDP\FrmSelectTCPServer.pas' {fSelectTCPServer},
  xUDPServerBase in '..\..\..\FMX_Pub_src\Comm\xUDPServerBase.pas',
  xUDPClient1 in 'UDP\xUDPClient1.pas',
  FrmLogin in 'Login\FrmLogin.pas' {fStudentLogin},
  xDBActionBase in '..\..\..\FMX_Pub_src\xDBActionBase.pas',
  uStudentInfo in '..\..\..\FMX_Pub_src\Student\VCL\uStudentInfo.pas' {fStudentInfo},
  uStudentList in '..\..\..\FMX_Pub_src\Student\VCL\uStudentList.pas' {fStudentList},
  xStudentAction in '..\..\..\FMX_Pub_src\Student\xStudentAction.pas',
  xStudentControl in '..\..\..\FMX_Pub_src\Student\xStudentControl.pas',
  xStudentInfo in '..\..\..\FMX_Pub_src\Student\xStudentInfo.pas',
  xStudentTabelOutOrIn in '..\..\..\FMX_Pub_src\Student\xStudentTabelOutOrIn.pas',
  xExerciseAction in '..\Server\Exercise\xExerciseAction.pas',
  xExerciseControl in '..\Server\Exercise\xExerciseControl.pas',
  xExerciseInfo in '..\Server\Exercise\xExerciseInfo.pas',
  FrmExercise in '..\Server\Exercise\VCL\FrmExercise.pas' {fExercise},
  xQuestionAction in '..\..\..\FMX_Pub_src\Question\xQuestionAction.pas',
  xQuestionInfo in '..\..\..\FMX_Pub_src\Question\xQuestionInfo.pas',
  xSortAction in '..\..\..\FMX_Pub_src\Question\xSortAction.pas',
  xSortControl in '..\..\..\FMX_Pub_src\Question\xSortControl.pas',
  xSortInfo in '..\..\..\FMX_Pub_src\Question\xSortInfo.pas',
  uQuestionInfo in '..\..\..\FMX_Pub_src\Question\VCL\uQuestionInfo.pas' {fQuestionInfo},
  uQuestionList in '..\..\..\FMX_Pub_src\Question\VCL\uQuestionList.pas' {fQuestionList},
  uSortInfo in '..\..\..\FMX_Pub_src\Question\VCL\uSortInfo.pas' {fSortInfo},
  uSortList in '..\..\..\FMX_Pub_src\Question\VCL\uSortList.pas' {fSortList},
  FrmQInfoC in '..\Server\Question\FrmQInfoC.pas' {fQInfo},
  FrmQuestionListC in '..\Server\Question\FrmQuestionListC.pas' {fQuestionListC},
  FrmErrorSelect in '..\Server\WiringError\FrmErrorSelect.pas' {fErrorSelect},
  U_ERRORF_TO_WIRING in '..\Server\WiringError\U_ERRORF_TO_WIRING.pas',
  FrmWEDetails in '..\Server\WiringError\WiringError\FrmWEDetails.pas' {fWEDetails},
  FrmWEDetails2 in '..\Server\WiringError\WiringError\FrmWEDetails2.pas' {fWEDetails2},
  FrmWEPhaseColor in '..\Server\WiringError\WiringError\FrmWEPhaseColor.pas' {fWEPhaseColor},
  FrmWESelect1 in '..\Server\WiringError\WiringError\FrmWESelect1.pas' {fWESelect1},
  U_DIAGRAM_TYPE in '..\Server\WiringError\WiringError\U_DIAGRAM_TYPE.pas',
  U_POWER_PHASE_MAP in '..\Server\WiringError\WiringError\U_POWER_PHASE_MAP.pas',
  U_POWER_STATUS in '..\Server\WiringError\WiringError\U_POWER_STATUS.pas',
  U_WE_DIAGRAM in '..\Server\WiringError\WiringError\U_WE_DIAGRAM.pas',
  U_WE_DIAGRAM2 in '..\Server\WiringError\WiringError\U_WE_DIAGRAM2.pas',
  U_WE_EQUATION in '..\Server\WiringError\WiringError\U_WE_EQUATION.pas',
  U_WE_EQUATION_DRAW in '..\Server\WiringError\WiringError\U_WE_EQUATION_DRAW.pas',
  U_WE_EQUATION_MATH in '..\Server\WiringError\WiringError\U_WE_EQUATION_MATH.pas',
  U_WE_EXPRESSION in '..\Server\WiringError\WiringError\U_WE_EXPRESSION.pas',
  U_WE_MAKE_LIST in '..\Server\WiringError\WiringError\U_WE_MAKE_LIST.pas',
  U_WE_PHASE_MAP in '..\Server\WiringError\WiringError\U_WE_PHASE_MAP.pas',
  U_WE_POWER_ANALYSIS in '..\Server\WiringError\WiringError\U_WE_POWER_ANALYSIS.pas',
  U_WIRING_ERROR in '..\Server\WiringError\WiringError\U_WIRING_ERROR.pas',
  U_WE_ORGAN in '..\Server\WiringError\WiringError\V2\U_WE_ORGAN.pas',
  U_WE_VECTOR_EQUATION in '..\Server\WiringError\WiringError\V2\U_WE_VECTOR_EQUATION.pas',
  U_WE_VECTOR_MAP in '..\Server\WiringError\WiringError\V2\U_WE_VECTOR_MAP.pas',
  U_POWER_LIST_INFO in '..\Server\WiringError\WiringError\AnalysisMap\U_POWER_LIST_INFO.pas',
  U_WIRINGF_ERROR in '..\Server\WiringError\U_WIRINGF_ERROR.pas',
  U_CKM_DEVICE in '..\..\..\Pub_src\U_CKM_DEVICE.pas',
  U_PUB_FUN in '..\..\..\Pub_src\U_PUB_FUN.pas',
  xDataDictionary in '..\..\..\FMX_Pub_src\xDataDictionary.pas',
  FrmAnswerQuestion in 'AnswerQuestion\FrmAnswerQuestion.pas' {fAnswerQuestion};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfClientMain, fClientMain);
  Application.CreateForm(TfAnswerQuestion, fAnswerQuestion);
  Application.Run;
end.
