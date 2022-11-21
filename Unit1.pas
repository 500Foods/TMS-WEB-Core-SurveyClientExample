unit Unit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.DateUtils,

  JSDelphiSystem,
  JS,
  Web,

  WEBLib.Graphics,
  WEBLib.Controls,
  WEBLib.Forms,
  WEBLib.Dialogs,
  WEBLib.WebCtrls,
  WEBLib.WebTools,
  WEBLib.StdCtrls,

  XData.Web.Client,
  XData.Web.Connection,

  Vcl.StdCtrls,
  Vcl.Controls, WEBLib.ExtCtrls;

type
  TForm1 = class(TWebForm)
    divMain: TWebHTMLDiv;
    divFooter: TWebHTMLDiv;
    divHeader: TWebHTMLDiv;
    btnPrevious: TWebButton;
    btnNext: TWebButton;
    divTitle: TWebHTMLDiv;
    divSubTitleHolder: TWebHTMLDiv;
    btnAbout: TWebButton;
    btnMessage: TWebButton;
    divMiddle: TWebHTMLDiv;
    divAbout: TWebHTMLDiv;
    divFeedback: TWebHTMLDiv;
    divFeedbackHeader: TWebHTMLDiv;
    divFeedbackTitle: TWebHTMLDiv;
    btnFeedbackAbout: TWebButton;
    btnFeedbackFeedback: TWebButton;
    divBottomFeedback: TWebHTMLDiv;
    btnSubmitFeedback: TWebButton;
    btnCancelFeedback: TWebButton;
    divAboutHeader: TWebHTMLDiv;
    divAboutTitle: TWebHTMLDiv;
    btnAboutAbout: TWebButton;
    btnAboutMessage: TWebButton;
    divAboutFooter: TWebHTMLDiv;
    btnAboutOK: TWebButton;
    divAboutContent: TWebHTMLDiv;
    ServerConn: TXDataWebConnection;
    ClientConn: TXDataWebClient;
    tmrRetry: TWebTimer;
    divFeedbackHolder: TWebHTMLDiv;
    divFeedbackForm: TWebHTMLDiv;
    memoFeedback: TWebMemo;
    tmrCountdown: TWebTimer;
    labelAboutVersion: TWebLabel;
    labelAboutRelease: TWebLabel;
    divSubtitle: TWebHTMLDiv;
    divSubtitleProgress: TWebHTMLDiv;
    divBefore: TWebHTMLDiv;
    divAfter: TWebHTMLDiv;
    procedure WebFormResize(Sender: TObject);
    procedure btnMessageClick(Sender: TObject);
    [async] procedure btnSubmitFeedbackClick(Sender: TObject);
    procedure btnCancelFeedbackClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnAboutOKClick(Sender: TObject);
    [async] procedure WebFormCreate(Sender: TObject);
    procedure LogActivity(Activity: String);
    [async] procedure GetSurveyData;
    procedure tmrRetryTimer(Sender: TObject);
    procedure tmrCountdownTimer(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure DisplayQuestion;
    procedure HandleInput;
    function GetNextQuestion(CurrentIndex: Integer; Options: String): Integer;
    function GetPreviousQuestion(CurrentIndex: Integer; Options: String): Integer;
    function GetRandomQuestion(CurrentIndex: Integer; Options: String): Integer;
    procedure UpdateProgress(Progress: Integer);
    [async] procedure SaveResponses(QuestionID: String; QuestionName: String; ThisResponse: String);
  private
    { Private declarations }
  public
    { Public declarations }
    AppVer: String;
    AppRel: String;
    AppRelH: String;
    ActivityLog: TStringList;
    CountdownTimer: String;
    MainState : String;
    SurveyState: String;

    ServerName: String;

    ClientID: String;
    SurveyID: String;
    SurveyName: String;
    SurveyGroup: String;
    SurveyLink: String;
    SurveyQuestionCount: Integer;

    SurveyData: TJSObject;
    SurveyQuestions: TJSArray;
    SurveyResponses: TJSObject;

    SurveyStart: String;
    SurveyFinish: String;
    CurrentResponse: String;
    LastTransmission: String;

    CurrentQuestion: TJSObject;
    CurrentQuestionID: String;
    CurrentQuestionName: String;
    CurrentQuestionType: Integer;
    CurrentQuestionIndex: Integer;

    NextQuestionIndex: Integer;
    PreviousQuestionIndex: Integer;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnAboutClick(Sender: TObject);
begin
  // Click About: Show About, Hide Main and Feedback
  LogActivity('About Button Clicked');
  divMain.ElementHandle.classList.add('HideTransition');
  divMain.ElementHandle.classList.remove('ShowTransition');
  divFeedback.ElementHandle.classList.add('HideTransition');
  divFeedback.ElementHandle.classList.remove('ShowTransition');
  divAbout.ElementHandle.classList.add('ShowTransition');
  divAbout.ElementHandle.classList.remove('HideTransition');
end;

procedure TForm1.btnAboutOKClick(Sender: TObject);
begin
  // Click About OK: Show Main, Hide About
  LogActivity('About/OK Button Clicked');
  divAbout.ElementHandle.classList.add('HideTransition');
  divAbout.ElementHandle.classList.remove('ShowTransition');
  divMain.ElementHandle.classList.add('ShowTransition');
  divMain.ElementHandle.classList.remove('HideTransition');

  // Show Activity Log in Console
//  console.log(ActivityLog.Text);
end;

procedure TForm1.btnCancelFeedbackClick(Sender: TObject);
begin
  // Click Feedback Cancel: Show Main, Hide Feedback
  LogActivity('Feedback/Cancel Button Clicked');
  divFeedback.ElementHandle.classList.add('HideTransition');
  divFeedback.ElementHandle.classList.remove('ShowTransition');
  divMain.ElementHandle.classList.add('ShowTransition');
  divMain.ElementHandle.classList.remove('HideTransition');

  // Reset Feedback text
  MemoFeedback.Lines.Text := '';
end;

procedure TForm1.btnMessageClick(Sender: TObject);
begin
  // Click Feedback: Show Feedback, Hide Main, About
  LogActivity('Feedback Button Clicked');
  divMain.ElementHandle.classList.add('HideTransition');
  divMain.ElementHandle.classList.remove('ShowTransition');
  divAbout.ElementHandle.classList.add('HideTransition');
  divAbout.ElementHandle.classList.remove('ShowTransition');
  divFeedback.ElementHandle.classList.add('ShowTransition');
  divFeedback.ElementHandle.classList.remove('HideTransition');
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
  // Next

  // Our very first question!
  if CurrentQuestionID = '' then
  begin
    // Let's calm things down a bit
    btnNext.Caption := '<i class="fa-solid fa-circle-right fa-2x" style="font-size:42px; margin-top:-4px; margin-left:-8px;"></i>';

    // Basics of a question
    CurrentQuestionIndex := 0;
    CurrentQuestion := TJSObject(SurveyQuestions[CurrentQuestionIndex]);
    CurrentQuestionID := String(CurrentQuestion['question_id']);
    CurrentQuestionName := String(CurrentQuestion['question_name']);
    DisplayQuestion;

    // Elements may have different triggers.  We want to catch them all
    // We'll deal with multiple firing for the same event later
    asm
      divMiddle.addEventListener('change', pas.Unit1.Form1.HandleInput);
      divMiddle.addEventListener('input', pas.Unit1.Form1.HandleInput);
    end;

  end
  else
  begin
    // First thing we'll want to do now is save the response to the question that
    // was just answered, if any response was generated.
    if CurrentResponse <> '' then
    begin
      SaveResponses(CurrentQuestionID, CurrentQuestionName, CurrentResponse);
    end;

    // We've already got a question and we've got to figure out where to go next.
    // Presumably the question response has been satisfied or we'd not have gotten
    // here due to the button being disabled

    CurrentQuestionIndex := NextQuestionIndex;
    CurrentQuestion := TJSObject(SurveyQuestions[CurrentQuestionIndex]);
    CurrentQuestionID := String(CurrentQuestion['question_id']);
    CurrentQuestionName := String(CurrentQuestion['question_name']);
    DisplayQuestion;
  end;

end;

procedure TForm1.btnPreviousClick(Sender: TObject);
begin
  // TODO: Load up values from a previous response - might be non-trivial

  CurrentQuestionIndex := PreviousQuestionIndex;

  if CurrentQuestionIndex = -1 then
  begin
    asm
      window.location.reload(true);
      window.location.href=window.location.href;
    end;
  end
  else
  begin
    CurrentQuestion := TJSObject(SurveyQuestions[CurrentQuestionIndex]);
    CurrentQuestionID := String(CurrentQuestion['question_id']);
    CurrentQuestionName := String(CurrentQuestion['question_name']);
    DisplayQuestion;
  end;
end;

procedure TForm1.btnSubmitFeedbackClick(Sender: TObject);
var
  Response: TXDataClientResponse;
  ClientConn:   TXDataWebClient;
  Blob: JSValue;
  Data: JSValue;
  Elapsed: TDateTime;
  FeedbackID: String;
begin
  Elapsed := Now;
  FeedbackID := TGUID.NewGUID.ToString;

  LogActivity('[ Feedback Submission Started ]');
  btnSubmitFeedback.Caption := '<div style="font-size:16px;" class="ms-1 me-2">'+
                                 '<i class="fa-solid '+
                                   'fa-paper-plane '+
                                   'fa-xl me-2 fa-beat-fade" '+
                                   'style="--fa-beat-fade-opacity: 0.7; '+
                                          '--fa-beat-fade-scale: 1.2; '+
                                          '--fa-animation-duration: 2s;'+
                               '"></i> Send</div>';

  try
    if (ServerConn.Connected) then
    begin
      try
        ClientConn := TXDataWebClient.Create(nil);
        ClientConn.Connection := ServerConn;
        Response := await(ClientConn.RawInvokeAsync('ISurveyClientService.Feedback',[
          SurveyID,
          ClientID,
          'SC/'+Appver,
          AppRel,
          FeedbackID,
          MemoFeedback.Lines.Text,
          MainState+'/'+SurveyState+'/'+CurrentQuestionName,
          ActivityLog.Text
        ]));
        Blob := Response.Result;
        Data := Blob;
        asm
         Data = await Blob.text();
        end;
        Form1.LogActivity(String(Data));
      except on E: Exception do
        begin
          Form1.LogActivity('Feedback Error: ['+E.ClassName+'] '+E.Message);
          console.log('Feedback Error: ['+E.ClassName+'] '+E.Message);
        end;
      end;
    end;
  finally
    btnSubmitFeedback.Caption := '<div style="font-size:16px;" class="ms-1 me-2"><i class="fa-solid fa-paper-plane fa-xl me-2"></i>Send</div>';
  end;
  LogActivity('[ Feedback Submission Completed ] '+IntToStr(MillisecondsBetween(Now, Elapsed))+'ms');

  // Click Feedback Submit: Show Main, Hide Feedback
  LogActivity('Feedback/Submit Button Clicked');
  divFeedback.ElementHandle.classList.add('HideTransition');
  divFeedback.ElementHandle.classList.remove('ShowTransition');
  divMain.ElementHandle.classList.add('ShowTransition');
  divMain.ElementHandle.classList.remove('HideTransition');

  // Reset Feedback text
  MemoFeedback.Lines.Text := '';
end;

procedure TForm1.DisplayQuestion;
var
  QTitle: String;
  QFooter: String;
  Question: String;
  QType: Integer;
  QOptions: String;

  PrevButton: Boolean;
  NextButton: Boolean;

  QuestionReady: Boolean;

begin
  // display whatever question we've got selected

  PrevButton := False;
  NextButton := False;
  QuestionReady := False;
  CurrentResponse := '';

  // Here we're dealing with the different question types
  // Loop is because some question types are redirects to other
  // questions so we keep looping until we land on the final
  // question that is to be displayed

  while not(QuestionReady) do
  begin

    QTitle := SurveyName;
    if String(CurrentQuestion['question_title']) <> ''
    then QTitle := String(CurrentQuestion['question_title']);

    QFooter := 'Question '+IntToStr(CurrentQuestionIndex + 1)+' of '+IntToStr(SurveyQuestionCount);
    if String(CurrentQuestion['question_footer']) <> ''
    then QFooter := String(CurrentQuestion['question_footer']);

    Question := '';
    if String(CurrentQuestion['question']) <> ''
    then Question := String(CurrentQuestion['question']);

    QType := 2;
    if String(CurrentQuestion['question_type']) <> ''
    then QType := Integer(CurrentQuestion['question_type']);
    CurrentQuestionType := QType;

    QOptions := '';
    if String(CurrentQuestion['question_options']) <> ''
    then QOptions := String(CurrentQuestion['question_options']);

    //  0 => Undefined
    // Don't do anything, just skip right past it
    if (QType = 0) then
    begin
      NextQuestionIndex := CurrentQuestionIndex + 1;
      btnNextClick(nil);
      exit;
    end

    // 1 => Opening
    else if (QType = 1) then
    begin
      QuestionReady := True;
      PrevButton := True;
      NextButton := True;
      PreviousQuestionIndex := -1;
      NextQuestionIndex := GetNextQuestion(CurrentQuestionIndex, QOptions);
      asm
        this.SurveyStart = luxon.DateTime.now().toISO();

      end;
      CurrentResponse := SurveyStart;
    end

    // 2 => Info
    else if (QType = 2) then
    begin
      QuestionReady := True;
      PrevButton := True;
      NextButton := True;
      PreviousQuestionIndex := GetPreviousQuestion(CurrentQuestionIndex, QOptions);
      NextQuestionIndex := GetNextQuestion(CurrentQuestionIndex, QOptions);
    end

    // 3 => Closing
    else if (QType = 3) then
    begin
      QuestionReady := True;
      PrevButton := False;
      NextButton := False;
      CurrentQuestionIndex := SurveyQuestionCount;

      asm
        this.SurveyFinish = luxon.DateTime.now().toISO();
      end;

      CurrentResponse := SurveyFinish;
      SaveResponses(CurrentQuestionID, CurrentQuestionName, CurrentResponse);

      // Grand Finale Fireworks?
      if (Pos('FIREWORKS', Uppercase(QOptions)) > 0) then
      begin
        divBefore.Visible := True;
        divAfter.Visible := True;
        Form1.ElementClassName := 'overflow-hidden Custom_Fireworks';
      end;
    end

    // 4 => Disabled
    else if (QType = 4) then
    begin
      NextQuestionIndex := CurrentQuestionIndex + 1;
      btnNextClick(nil);
      exit;
    end

    // 5 => Redirect
    else if (QType = 5) then
    begin
      NextQuestionIndex := GetNextQuestion(CurrentQuestionIndex, QOptions);
      btnNextClick(nil);
      exit;
    end

    // 6 => Random
    else if (QType = 6) then
    begin
      NextQuestionIndex := getRandomQuestion(CurrentQuestionIndex, QOptions);
      btnNextClick(nil);
      exit;
    end

    // 7 => Text Multi
    else if (QType = 7) then
    begin
      QuestionReady := True;
      PrevButton := True;
      NextButton := True;
      PreviousQuestionIndex := getPreviousQuestion(CurrentQuestionIndex, QOptions);
      NextQuestionIndex := getNextQuestion(CurrentQuestionIndex, QOptions);
    end

    // 8 => Text Single
    else if (QType = 8) then
    begin
      QuestionReady := True;
      PrevButton := True;
      NextButton := True;
      PreviousQuestionIndex := getPreviousQuestion(CurrentQuestionIndex, QOptions);
      NextQuestionIndex := getNextQuestion(CurrentQuestionIndex, QOptions);
    end

    // 9 => Pick One
    else if (QType = 9) then
    begin
      QuestionReady := True;
      PrevButton := True;
      NextButton := False;
      PreviousQuestionIndex := getPreviousQuestion(CurrentQuestionIndex, QOptions);
      NextQuestionIndex := getNextQuestion(CurrentQuestionIndex, QOptions);
    end

    // 11 => Pick Many
    else if (QType = 11) then
    begin
      QuestionReady := True;
      PrevButton := True;
      NextButton := True;
      PreviousQuestionIndex := getPreviousQuestion(CurrentQuestionIndex, QOptions);
      NextQuestionIndex := getNextQuestion(CurrentQuestionIndex, QOptions);
    end

    // Unexpected? Pretend it is info and hope we can move past it
    else
    begin
      QuestionReady := True;
      NextButton := True;
      PreviousQuestionIndex := GetPreviousQuestion(CurrentQuestionIndex, QOptions);
      NextQuestionIndex := GetNextQuestion(CurrentQuestionIndex, QOptions);
    end;

  end;


  // If it isn't going to change anything then don't enable the buttons
  // This can happen when completing a section where no return is permitted
  if PreviousQuestionIndex = CurrentQuestionIndex
  then PrevButton := False;
  if NextQuestionIndex = CurrentQuestionIndex
  then NextButton := False;

  // Display Question
  divTitle.HTML.Text := QTitle;
  divMiddle.HTML.Text := Question;
  divSubTitle.HTML.Text := QFooter;

  // Activate Previous/Next buttons if necessary
  btnPrevious.Enabled := PrevButton;
  btnNext.Enabled := NextButton;

  // Progress Bar
  UpdateProgress(CurrentQuestionIndex + 1);

  // At this point, the question is displayed and we're done.
  // Nothing happens until either a prev/next button is clicked
  // And whether those are even enabled may depend on having an
  // input event fired.  For example, a "Pick One" question will
  // enable "next" once a selection has been made.

end;

function TForm1.GetNextQuestion(CurrentIndex: Integer; Options: String): Integer;
var
  uOptions: String;
  NextQ: String;
  i: Integer;
begin
  // Check options for anything that might indicate a redirect, otherwise
  // it is just the next question in the array.
  Result := CurrentIndex + 1;

  uOptions := uppercase(Options);
  if Pos('NEXT:', uOptions) > 0 then
  begin
    NextQ := Copy(uOptions, Pos('NEXT:', uOptions)+6, maxint);
    if Pos(',', NextQ) > 0
    then NextQ := Copy(NextQ, 1, Pos(',',NextQ) - 1);
    if Pos('PREV:', NextQ) > 0
    then NextQ := Copy(NextQ, 1, Pos('PREV:',NextQ) - 1);

    NextQ := Trim(NextQ);
    i := 0;
    while i < SurveyQuestions.Length do
    begin
      if TJSObject(SurveyQuestions[i])['question_name'] <> nil then
      begin
        if Uppercase(String(TJSObject(SurveyQuestions[i])['question_name'])) = NextQ
        then Result := i
      end;
      i := i + 1;
    end;
  end;

end;

function TForm1.GetPreviousQuestion(CurrentIndex: Integer; Options: String): Integer;
var
  uOptions: String;
  NextQ: String;
  i: Integer;
begin
  // Check options for anything that might indicate a redirect, otherwise
  // it is just the next question in the array.
  Result := CurrentIndex -1;

  uOptions := uppercase(Options);
  if Pos('PREV:', uOptions) > 0 then
  begin
    NextQ := Copy(uOptions, Pos('PREV:', uOptions)+6, maxint);
    if Pos(',', NextQ) > 0
    then NextQ := Copy(NextQ, 1, Pos(',',NextQ) - 1);
    if Pos('NEXT:', NextQ) > 0
    then NextQ := Copy(NextQ, 1, Pos('NEXT:',NextQ) - 1);

    NextQ := Trim(NextQ);
    i := 0;
    while i < SurveyQuestions.Length do
    begin
      if TJSObject(SurveyQuestions[i])['question_name'] <> nil then
      begin
        if Uppercase(String(TJSObject(SurveyQuestions[i])['question_name'])) = NextQ
        then Result := i
      end;
      i := i + 1;
    end;
  end;

end;

function TForm1.GetRandomQuestion(CurrentIndex: Integer; Options: String): Integer;
var
  uOptions: String;
  NextQ: String;
  Choices: String;
  Weights: String;
  ChoicesList: TStringList;
  WeightsList: TStringList;
  i: Integer;
  Weight: Double;

begin
  // Note: this seems to be far more complicated than one would normally expect
  // The idea though is to have a list of pages and a separate list of weights
  // where the weights are like 0.5, 0.25, 0.25
  // So we have to add up all the weights and then use the portion of the total
  // to get the individual weights.  This is to be able to handle as much bad
  // input data as possible.


  // Check options for anything that might indicate a redirect, otherwise
  // it is just the next question in the array.
  Result := CurrentIndex + 1;

  uOptions := uppercase(Options);

  // Figure out what our Choices are
  if Pos('CHOICES:', uOptions) > 0 then
  begin
    Choices := Copy(uOptions, Pos('CHOICES:', uOptions)+9, maxint);
    if Pos('WEIGHTS:', Choices) > 0
    then Choices := Copy(Choices, 1, Pos('WEIGHTS:',Choices) - 1);
    Choices := Trim(Choices);
  end;

  // Figure out what our Weights are
  if Pos('WEIGHTS:', uOptions) > 0 then
  begin
    Weights := Copy(uOptions, Pos('WEIGHTS:', uOptions)+9, maxint);
    if Pos('CHOICES:', Weights) > 0
    then Weights := Copy(Weights, 1, Pos('CHOICES:',Weights) - 1);
    Weights := Trim(Weights);
  end;

  // See if we can get list of questions
  ChoicesList := TStringList.Create;
  ChoicesList.StrictDelimiter := True;
  ChoicesList.Delimiter := ',';
  ChoicesList.DelimitedText := Choices;
  if ChoicesList.Count = 0 then exit;

  // get list of weights
  WeightsList := TStringList.Create;
  WeightsList.StrictDelimiter := True;
  WeightsList.Delimiter := ',';
  WeightsList.DelimitedText := Weights;

  // If we don't have a matching list, create an even split
  if WeightsList.Count <> ChoicesList.Count then
  begin
    WeightsList.Text := '';
    for i := 0 to ChoicesList.Count -1 do
    begin
      WeightsList.Add(FloatToStr(1.0 / double(ChoicesList.Count)));
    end;
  end;

  // Check that we've got numbers for them all
  Weight := 0.0;
  for i := 0 to WeightsList.Count -1 do
  begin
    if StrToFloatDef(Trim(WeightsList[i]), 0.0) = 0.0
    then WeightsList[i] := FloatToStr(1.0 / double(WeightsList.Count));

    Weight := Weight + StrToFloat(WeightsList[i]);
  end;

  // Alright.  Got a list of q's and a list of w's and a TotalWeight
  Weight := Weight * Random;

  // Find out who our winner is
  i := 0;
  NextQ := '';
  while NextQ = '' do
  begin
    if StrToFloat(WeightsList[i]) >= Weight
    then NextQ := Trim(ChoicesList[i])
    else Weight := Weight - StrToFloat(WeightsList[i]);
    i := i + 1;
  end;

  // If we don't have a winner, give up
  if NextQ = '' then exit;

  // If we do hava a winner, we need to find it in the list of questions
  i := 0;
  while i < SurveyQuestions.Length do
  begin
    if TJSObject(SurveyQuestions[i])['question_name'] <> nil then
    begin
      if Uppercase(String(TJSObject(SurveyQuestions[i])['question_name'])) = NextQ
      then Result := i
    end;
    i := i + 1;
  end;

  ChoicesList.Free;
  WeightsList.Free;

end;

procedure TForm1.GetSurveyData;
var
  Response: TXDataClientResponse;
  Data: JSValue;
  Blob: JSValue;
  SurveyTime: String;
  Countdown: String;
begin

  // An indicator that something is going on.  Likely happens to fast to
  // ever be seen, but maybe for a really large survey download...
  btnNext.Caption := '<i class="fa-solid fa-spinner fa-spin fa-2x" style="font-size:42px; margin-top:-4px; margin-left:-8px;"></i>';

  // Development server or Production server?
  if GetQueryParam('Development') <> '' then
  begin
    ServerName := 'http://localhost:2001/tms/xdata';
    LogActivity('Development Mode Specified');
    LogActivity('Connecting to '+ServerName);
  end
  else
  begin
    ServerName := 'https://carnival.500foods.com:10101/500Surveys';
    LogActivity('Connecting to '+ServerName);
  end;

  // See if we've got a SurveyID as a parameter?
  if GetQueryParam('SurveyID') = '' then
  begin
    LogActivity('No Survey Specified');
    exit;
  end
  else
  begin
    SurveyID := GetQueryParam('SurveyID');
    LogActivity('SurveyID: '+SurveyID);
    LogActivity('ClientID: '+ClientID);
  end;

  // Try and establish a connection to the server
  if not(ServerConn.Connected) then
  begin
    ServerConn.URL := ServerName;
    try
      await(ServerConn.OpenAsync);
    except on E: Exception do
      begin
        LogActivity('Connnection Error: ['+E.ClassName+'] '+E.Message);
        console.log('Connnection Error: ['+E.ClassName+'] '+E.Message);
        tmrRetry.Enabled := True;
      end;
    end;
  end;

  // We've got a connection, let's make the request
  if (ServerConn.Connected) then
  begin
    try
      Response := await(ClientConn.RawInvokeAsync('ISurveyClientService.GetSurvey', [
        SurveyID,
        ClientID,
        'SC/'+AppVer,
        AppRel
      ]));
      Blob := Response.Result;
      Data := Blob;
      asm
        Data = await Blob.text();
      end;
    except on E: Exception do
      begin
        LogActivity('Survey Download Error: ['+E.ClassName+'] '+E.Message);
        console.log('Survey Download Error: ['+E.ClassName+'] '+E.Message);
        tmrRetry.Enabled := True;
      end;
    end;
  end;

  // Do we have any data?
  if (Length(String(Data)) > 0) then
  begin
    // Yes we do!
    SurveyData := TJSJSON.parseObject(String(Data));
//    console.log(TJSJSON.stringify(SurveyData));


    // Extract some basic information
    SurveyID := String(SurveyData['SurveyID']);
    SurveyName := String(SurveyData['SurveyName']);
    SurveyGroup := String(SurveyData['SurveyGroup']);
    SurveyLink := String(SurveyData['SurveyLink']);

    // If we don't have a SurveyName, then we've got nothing.
    if ((SurveyName = 'undefined') or (SurveyID = '')) then exit;

    // Make a note of it
    LogActivity('');
    LogActivity('Survey Retrieved:');
    LogActivity('- ID: '+SurveyID);
    LogActivity('- Group: '+SurveyGroup);
    LogActivity('- Name: '+SurveyName);
    LogActivity('- Link: '+SurveyLink);
    LogActivity('');


    // Let's Update the UI.
    // First, we can set the About and Feedback values.

    divAboutTitle.HTML.Text := String(SurveyData['About-Title']);
    divAboutContent.HTML.Text := '<div class="InnerContent">'+String(SurveyData['About-Content'])+'</div>';

    divFeedbackTitle.HTML.Text := String(SurveyData['Feedback-Title']);
    divFeedbackForm.HTML.Text := '<div class="FeedbackContent">'+String(SurveyData['Feedback-Content'])+'</div>';


    // Then, we need to figure out the availability:
    // - Pre: Availability is in future (countdown until survey starts)
    // - Post: Availability is in the past (survey is done)
    // - Pause: More than one availability and we're between them (survey is paused)
    // - Active: Ready to go
    // Default to active if no availability data is present

    SurveyTime := 'Active';

    if (SurveyData['Availability'] <> nil) then
    begin

      SurveyTime := '';
      Countdown := '';

      asm
        var rows = JSON.parse(this.SurveyData['Availability']);
        if (rows.length > 0) {
          var now = luxon.DateTime.now();
          var next = luxon.DateTime.now().plus({years: 100});

          for (var i = 0; i < rows.length; i++) {
            var start  = luxon.DateTime.fromISO(rows[i]['opening']);
            var finish  = luxon.DateTime.fromISO(rows[i]['closing']);

            if ((start < now) && (finish > now)) {
              SurveyTime += 'Active ';
              next = finish;
            }
            else if (start > now) {
              SurveyTime += 'Pre ';
              if (next > start) {
                next = start;
              }
            }
            else if (finish < now) {
              SurveyTime += 'Post ';
              next = finish;
            }
          }

          Countdown = next.toISO();

          if (SurveyTime == '') {
            SurveyTime = 'Active';
          }
          else if (SurveyTime.indexOf('Active') > -1) {
            SurveyTime = 'Active';
          }
          else if ((SurveyTime.indexOf('Pre') > -1) && (SurveyTime.indexOf('Post') == -1)) {
            SurveyTime = 'Pre';
            Countdown = next.toISO();
          }
          else if ((SurveyTime.indexOf('Post') > -1) && (SurveyTime.indexOf('Pre') == -1)) {
            SurveyTime = 'Post';
          }
          else {
            SurveyTime = 'Pause';
            Countdown = next.toISO();
          }
        }
      end;

      if SurveyTime = '' then SurveyTime := 'Active';

    end;


    // Having done all that, now let's override it if we've been told to do so
    if GetQueryParam('Status') <> '' then
    begin
      SurveyTime := GetQueryParam('Status');
    end;

    CountdownTimer := Countdown;
    SurveyTime := Trim(Uppercase(SurveyTime));

    if (SurveyTime = 'PRE') then
    begin
      LogActivity('Survey State: '+SurveyTime);
      LogActivity('Countdown To: '+Countdown);
      divTitle.HTML.Text := String(SurveyData['Banner-Pre-Title']);
      divSubTitle.HTML.Text := String(SurveyData['Banner-Pre-Footer']);
      divMiddle.HTML.Text := '<div class="InnerContent">'+String(SurveyData['Banner-Pre-Content'])+'</div>';
      tmrCountdown.Enabled := True;
      Exit;
    end

    else if (SurveyTime = 'PAUSE') then
    begin
      LogActivity('Survey State: '+SurveyTime);
      LogActivity('Countdown To: '+Countdown);
      divTitle.HTML.Text := String(SurveyData['Banner-Pause-Title']);
      divSubTitle.HTML.Text := String(SurveyData['Banner-Pause-Footer']);
      divMiddle.HTML.Text := '<div class="InnerContent">'+String(SurveyData['Banner-Pause-Content'])+'</div>';
      tmrCountdown.Enabled := True;
      Exit;
    end

    else if (SurveyTime = 'POST') then
    begin
      LogActivity('Survey State: '+SurveyTime);
      divTitle.HTML.Text := String(SurveyData['Banner-Post-Title']);
      divSubTitle.HTML.Text := String(SurveyData['Banner-Post-Footer']);
      divMiddle.HTML.Text := '<div class="InnerContent">'+String(SurveyData['Banner-Post-Content'])+'</div>';
      tmrCountdown.Enabled := False;
      Exit;
    end;


    // Only choice left is that we're ACTIVE.
    LogActivity('Survey State: '+SurveyTime);

    divTitle.HTML.Text := String(SurveyData['Banner-Title']);
    divSubTitle.HTML.Text := String(SurveyData['Banner-Footer']);
    divMiddle.HTML.Text := '<div class="InnerContent">'+String(SurveyData['Banner-Content'])+'</div>';
    tmrCountdown.Enabled := False;


    // Go and get some questions
    if (ServerConn.Connected) then
    begin
      try
        Blob := nil;
        Data := nil;
        Response := await(ClientConn.RawInvokeAsync('ISurveyClientService.GetQuestions', [
          SurveyID,
          ClientID,
          'SC/'+AppVer,
          AppRel
        ]));
        Blob := Response.Result;
        Data := Blob;
        asm
          Data = await Blob.text();
        end;
      except on E: Exception do
        begin
          LogActivity('Survey Download Error: ['+E.ClassName+'] '+E.Message);
          console.log ('Survey Download Error: ['+E.ClassName+'] '+E.Message);
        end;
      end;
    end;

    // Do we have any Questions?
    if (Length(String(Data)) > 0) and (String(Data) <> 'null') then
    begin
      // Yes we do!
      SurveyQuestions := TJSArray(TJSJSON.parseObject(String(Data)));

      SurveyQuestionCount := 0;
      if SurveyQuestions.length > 0 then
      begin
        SurveyQuestionCount := SurveyQuestions.Length;
        SurveyState := 'Loaded';
        LogActivity('Questions Returned: '+IntToStr(SurveyQuestions.Length));
      end
      else
      begin
        LogActivity('No Questions Returned');
      end;

    end
    else
    begin
      LogActivity('No Questions Returned');
    end;
  end;
end;

procedure TForm1.HandleInput;
var
  selectioncount: integer;
  selectionvalue: string;
begin

  // This is invoked from a Javascript Event, so it has forgotten that we're on Form1
  // so it seems we need to reference it explicitly.

  selectioncount := 0;

  // Pick One
  if (Form1.CurrentQuestionType = 9) then
  begin
    asm
      var choices = divMiddle.getElementsByTagName('input');
      for( var i = 0; i < choices.length; i++){
        if (choices[i].checked) {
          selectioncount += 1;
          selectionvalue += choices[i].value+' ';
        }
      }
    end;

    // With this type, all we're looking for is one selection.
    // As this is a radio button, none are selected by default, but
    // once selected, not possible to unselect it.

    if selectioncount = 1 then
    begin
      Form1.CurrentResponse := Trim(selectionvalue);
      Form1.btnNext.Enabled := True;
    end;
  end


  // Text Multi
  else if Form1.CurrentQuestionType = 7 then
  begin
    asm
      var choices = divMiddle.getElementsByTagName('textarea');
      for( var i = 0; i < choices.length; i++){
        selectionvalue += choices[i].value+' ';
      }
    end;

    // With this type, all we're looking for is a block of text.
    Form1.CurrentResponse := Trim(selectionvalue);

  end


  // Text Single
  else if Form1.CurrentQuestionType = 8 then
  begin
    asm
      var choices = divMiddle.getElementsByTagName('input');
      for( var i = 0; i < choices.length; i++){
        selectionvalue += choices[i].value+' ';
      }
    end;

    // With this type, all we're looking for is a line of text.
    Form1.CurrentResponse := Trim(selectionvalue);

  end


  // Pick Many
  else if (Form1.CurrentQuestionType = 11) then
  begin
    asm
      var choices = divMiddle.getElementsByTagName('input');
      for( var i = 0; i < choices.length; i++){
        if (choices[i].checked) {
          if (selectioncount > 0) {
           selectionvalue += ','+'"'+choices[i].value+'"';
          }
          else {
           selectionvalue = '"'+choices[i].value+'"';
          }
          selectioncount += 1;
        }
      }
    end;

    // Might be a series of checkboxes, so string them all together

    Form1.CurrentResponse := '['+selectionvalue+']';
    Form1.btnNext.Enabled := True;
  end;

end;

procedure TForm1.LogActivity(Activity: String);
begin
  // Add timestamped entry to the Activity Log
  ActivityLog.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now)+'  '+Activity);
end;

procedure TForm1.SaveResponses(QuestionID: String; QuestionName: String; ThisResponse: String);
var
  Response: TXDataClientResponse;
  ClientConn:   TXDataWebClient;
  Blob: JSValue;
  Data: JSValue;
  Elapsed: TDateTime;
  Duration: String;
begin
  Elapsed := Now;

  LogActivity('Saving Responses.');

  // How much time has been spent on the survey so far?
  asm
    var start = luxon.DateTime.fromISO(this.SurveyStart);
    var now = luxon.DateTime.now();
    var coded = now.diff(start).shiftTo('hours','minutes','seconds','milliseconds').toObject();
    Duration = String(coded['hours']).padStart(2,'0')+':'+String(coded['minutes']).padStart(2,'0')+':'+String(coded['seconds']).padStart(2,'0');
  end;

  SurveyResponses['SurveyID'] := SurveyID;
  SurveyResponses['ClientID'] := ClientID;
  SurveyResponses['Started']  := SurveyStart;
  SurveyResponses['Finished'] := SurveyFinish;
  SurveyResponses['Duration'] := Duration;

  SurveyResponses[Trim(QuestionID)+':'+Trim(QuestionName)] := ThisResponse;

  if TJSJSON.stringify(SurveyResponses) <> LastTransmission then
  begin
    LastTransmission := TJSJSON.stringify(SurveyResponses);
    try
      if (ServerConn.Connected) then
      begin
        try
          ClientConn := TXDataWebClient.Create(nil);
          ClientConn.Connection := ServerConn;
          Response := await(ClientConn.RawInvokeAsync('ISurveyClientService.SaveResponses',[
            SurveyID,
            ClientID,
            'SC/'+AppVer,
            AppRel,
            TJSJSON.stringify(SurveyResponses),
            CurrentQuestionName
          ]));
          Blob := Response.Result;
          Data := Blob;
          asm
           Data = await Blob.text();
          end;
          Form1.LogActivity(String(Data));
        except on E: Exception do
          begin
            Form1.LogActivity('SaveResponses Error: ['+E.ClassName+'] '+E.Message);
            console.log('SaveResponses Error: ['+E.ClassName+'] '+E.Message);
          end;
        end;
      end;
    finally
    end;
    LogActivity('Responses Saved. '+IntToStr(MillisecondsBetween(Now, Elapsed))+'ms');
  end
  else
  begin
    LogActivity('Responses Skipped. '+IntToStr(MillisecondsBetween(Now, Elapsed))+'ms');
  end;
end;

procedure TForm1.tmrCountdownTimer(Sender: TObject);
var
  DisplayTime: String;
begin
  if CountdownTimer = '' then
  begin
    tmrCountdown.Enabled := False;
  end
  else
  begin
    DisplayTime := '';
    asm
      var start  = luxon.DateTime.fromISO(this.CountdownTimer);
      var now = luxon.DateTime.now();
      var coded = start.diff(now).shiftTo('days','hours','minutes','seconds','milliseconds').toObject();
      DisplayTime = coded['days']+'d '+String(coded['hours']).padStart(2,'0')+'h '+String(coded['minutes']).padStart(2,'0')+'m '+String(coded['seconds']).padStart(2,'0')+'s ';
      if (now > start) {
        window.location.reload(true);
        window.location.href=window.location.href;
      }
    end;
    divSubtitle.HTML.Text := DisplayTime;
  end;
end;

procedure TForm1.tmrRetryTimer(Sender: TObject);
begin
  tmrRetry.Enabled := False;
  tmrRetry.Tag := tmrRetry.Tag + 1;

  if tmrRetry.Tag < 10 then
  begin
    GetSurveyData;
  end;

end;

procedure TForm1.UpdateProgress(Progress: Integer);
begin
  divSubTitleProgress.Top := 0;
  divSubTitleProgress.Left := 0;
  divSubTitleProgress.Height := divSubTitleHolder.Height;
  divSubTitleProgress.Width := Trunc((Progress / SurveyQuestionCount) * divSubTitleHolder.Width);
end;

procedure TForm1.WebFormCreate(Sender: TObject);
var
  StorageKey: String;
  StorageValue: String;
begin
  // Output Version Information
  asm
    this.AppVer = ProjectName.replaceAll('_','.').substr(ProjectName.indexOf('_')+1);
    this.AppRel = luxon.DateTime.fromJSDate(new Date(document.lastModified)).toISO();
    this.AppRelH = luxon.DateTime.fromJSDate(new Date(document.lastModified)).toFormat('yyyy-MMM-dd');
  end;

  // Display in the UI in case nothing else is loaded
  divAboutContent.HTML.Text := '<div><pre>'+
                                 'AppVersion: '+AppVer+'<br />'+
                                 'AppRelease: '+AppRelH+'<br />'+
                                 'TMSWEBCore: '+Application.Version+
                               '</pre></div>';

  // Also display on the About page
  labelAboutVersion.HTML := '<div style="font-size:11px;">Version<br />'+AppVer+'</div>';
  labelAboutRelease.HTML := '<div style="font-size:11px;">Released<br />'+AppRelH+'</div>';;

  // Initialize the Activity Log and add the version information
  ActivityLog := TStringList.Create;
  LogActivity('SurveyApp Initializing');
  LogActivity('');
  LogActivity('AppVersion: '+AppVer);
  LogActivity('AppRelease: '+AppRelH);
  LogActivity('TMSWEBCore: '+Application.Version);
  LogActivity('');

  // Various UI element settings
  memoFeedback.ElementHandle.setAttribute('maxlength', '5000');

  // Set window Title - Presumably will be changed by the Survey that is loaded
  Caption := 'SurveyApp '+AppVer;

  // Just keeping track of where things are at for the main form
  MainState := 'Start';

  // Where are we at in the survey
  SurveyState := 'Initializing';

  // Survey Information
  SurveyName := 'Missing Name';
  SurveyGroup := 'Missing Group';

  // Initialize Progress
  SurveyQuestionCount := 1;
  UpdateProgress(0);

  // Initialize Responses
  SurveyResponses := TJSObject.new;

  // Have we been here before? Let's try and use the same ClientID if possible.
  // If not, generate a new GUID to use as a client ID and store if for next time.
  if GetQueryParam('SurveyID') = ''
  then StorageKey := 'SurveyApp-NoSurvey'
  else StorageKey := 'SurveyApp-'+GetQueryParam('SurveyID');
  StorageValue := '';
  asm
    if (localStorage.getItem(StorageKey) !== null) {
      StorageValue = localStorage.getItem(StorageKey);
    }
  end;
  if StorageValue = ''
  then ClientID := TGUID.NewGUID.toString
  else ClientID := StorageValue;
  StorageValue := ClientID;
  asm
    localStorage.setItem(StorageKey, StorageValue);
  end;

  // Get the survey
  await(GetSurveyData);

  // We're ready to go
  if SurveyState <> 'Initializing' then
  begin
    btnNext.Enabled := True;
    btnNext.Caption := '<i class="fa-solid '+
                               'fa-circle-right '+
                               'fa-2x fa-beat-fade" '+
                               'style="--fa-beat-fade-opacity: 0.7; '+
                                      '--fa-beat-fade-scale: 1.2; '+
                                      '--fa-animation-duration: 2s;'+
                                      'font-size: 42px; '+
                                      'margin-top: -4px; '+
                                      'margin-left: -8px; '+
                       '"></i>';
  end
  else
  begin
    btnNext.Enabled := False;
    btnNext.Caption := '<i class="fa-solid fa-circle-right fa-2x" style="font-size:42px; margin-top:-4px; margin-left:-8px;"></i>';
  end;

  // Show the main elements
  divMiddle.ElementHandle.classList.replace('d-none','d-flex');
  divTitle.ElementHandle.classList.replace('d-none','d-flex');
  divSubTitle.ElementHandle.classList.replace('d-none','d-flex');

  // Show the startup info on the console
  console.log(ActivityLog.Text);
end;

procedure TForm1.WebFormResize(Sender: TObject);
var
  PageWidth: Integer;
  PageHeight: Integer;
const
  MaxWidth = 510;
  MaxHeight = 910;
  MainMargin = 5;
begin
  // Centering and strecthing the main form to fit within / fill entire page
  // Constrained (likely) on desktops or wide displays to keep a similar look

  PageWidth := Form1.Width;
  PageHeight := Form1.Height;

  divMain.Height := min(PageHeight, MaxHeight) - 2*(MainMargin);
  divMain.Width := min(PageWidth, MaxWidth) - 2*(MainMargin);
  divMain.Top := (PageHeight - divMain.Height) div 2;
  divMain.Left := (PageWidth - divMain.Width) div 2;

  // About and Feedback are sized and positioned to mirror main div
  divFeedback.Width := divMain.Width;
  divFeedback.Height := divMain.Height;
  divFeedback.Top := divMain.Top;
  divFeedback.Left := divMain.Left;

  divAbout.Width := divMain.Width;
  divAbout.Height := divMain.Height;
  divAbout.Top := divMain.Top;
  divAbout.Left := divMain.Left;

  // About and Feedback initial defaults set for transitioning mechanism
  if (MainState = 'Start') then
  begin
    divFeedback.ElementHandle.style.setProperty('opacity', '0');
    divFeedback.ElementHandle.style.setProperty('pointer-events', 'none');
    divAbout.ElementHandle.style.setProperty('opacity', '0');
    divAbout.ElementHandle.style.setProperty('pointer-events', 'none');
    MainState := 'Open';
  end;

end;

end.
