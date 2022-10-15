unit Unit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,

  JS,
  Web,

  WEBLib.Graphics,
  WEBLib.Controls,
  WEBLib.Forms,
  WEBLib.Dialogs,
  WEBLib.WebCtrls,

  Vcl.Controls, Vcl.StdCtrls, WEBLib.StdCtrls;

type
  TForm1 = class(TWebForm)
    divMain: TWebHTMLDiv;
    divFooter: TWebHTMLDiv;
    divHeader: TWebHTMLDiv;
    btnPrevious: TWebButton;
    btnNext: TWebButton;
    divTitle: TWebHTMLDiv;
    divSubTitle: TWebHTMLDiv;
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
    divFeedbackForm: TWebHTMLDiv;
    memoFeedback: TWebMemo;
    procedure WebFormResize(Sender: TObject);
    procedure btnMessageClick(Sender: TObject);
    procedure btnSubmitFeedbackClick(Sender: TObject);
    procedure btnCancelFeedbackClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnAboutOKClick(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure LogActivity(Activity: String);
  private
    { Private declarations }
  public
    { Public declarations }
    MainState: String;
    SurveyState: String;
    ActivityLog: TStringList;
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
  console.log(ActivityLog.Text);
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

procedure TForm1.btnSubmitFeedbackClick(Sender: TObject);
begin
  // Click Feedback Submit: Show Main, Hide Feedback
  LogActivity('Feedback/Submit Button Clicked');
  divFeedback.ElementHandle.classList.add('HideTransition');
  divFeedback.ElementHandle.classList.remove('ShowTransition');
  divMain.ElementHandle.classList.add('ShowTransition');
  divMain.ElementHandle.classList.remove('HideTransition');

  // Reset Feedback text
  MemoFeedback.Lines.Text := '';
end;

procedure TForm1.LogActivity(Activity: String);
begin
  // Add timestamped entry to the Activity Log
  ActivityLog.Add(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now)+'  '+Activity);
end;

procedure TForm1.WebFormCreate(Sender: TObject);
var
  AppVer: String;
  AppRel: String;
begin
  // Output Version Information
  asm
    AppVer = ProjectName;
    AppRel = document.lastModified;
  end;

  // Display in the UI in case nothing else is loaded
  divAboutContent.HTML.Text := '<div>'+
                                 'AppVersion: '+AppVer+'<br />'+
                                 'AppRelease: '+AppRel+'<br />'+
                                 'TMSWEBCore: '+Application.Version+
                               '</div>';

  // Initialize the Activity Log and add the version information
  ActivityLog := TStringList.Create;
  LogActivity('SurveyApp Initializing');
  LogActivity('');
  LogActivity('AppVersion: '+AppVer);
  LogActivity('AppRelease: '+AppRel);
  LogActivity('TMSWEBCore: '+Application.Version);
  LogActivity('');
  console.log(ActivityLog.Text);

  // Just keeping track of where things are at for the main form
  MainState := 'Start';

  // Where are we at in the actual survey
  SurveyState := 'Initializing';

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
  end;
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
