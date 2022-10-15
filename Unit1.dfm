object Form1: TForm1
  Width = 960
  Height = 469
  ElementFont = efCSS
  OnCreate = WebFormCreate
  OnResize = WebFormResize
  OnShow = WebFormResize
  object divMain: TWebHTMLDiv
    Left = 8
    Top = 8
    Width = 300
    Height = 449
    ElementClassName = 'rounded border border-primary bg-light'
    ElementID = 'divMain'
    Role = ''
    object divFooter: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 401
      Width = 292
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ElementID = 'divFooter'
      Align = alBottom
      ChildOrder = 1
      ElementFont = efCSS
      Role = ''
      object btnPrevious: TWebButton
        Left = 0
        Top = 0
        Width = 44
        Height = 44
        Align = alLeft
        Caption = 
          '<i class="fa-solid fa-circle-left fa-2x" style="font-size:42px; ' +
          'margin-top:-4px; margin-left:-8px;"></i>'
        ElementClassName = 'btn btn-light btn-sm text-primary rounded-circle'
        ElementID = 'btnPrevious'
        ElementFont = efCSS
        Enabled = False
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object btnNext: TWebButton
        Left = 248
        Top = 0
        Width = 44
        Height = 44
        Align = alRight
        Caption = 
          '<i class="fa-solid fa-circle-right fa-2x" style="font-size:42px;' +
          ' margin-top:-4px; margin-left:-8px;"></i>'
        ChildOrder = 2
        ElementClassName = 'btn btn-light btn-sm text-primary rounded-circle'
        ElementID = 'btnNext'
        ElementFont = efCSS
        Enabled = False
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
      end
      object divSubTitle: TWebHTMLDiv
        AlignWithMargins = True
        Left = 48
        Top = 0
        Width = 196
        Height = 44
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 0
        ElementClassName = 
          'SubTitle rounded border border-primary bg-white d-flex align-ite' +
          'ms-center justify-content-center'
        ElementID = 'divSubtitle'
        Align = alClient
        ChildOrder = 1
        ElementFont = efCSS
        HTML.Strings = (
          'Check Survey Link')
        Role = ''
      end
    end
    object divHeader: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 292
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ElementID = 'divHeader'
      Align = alTop
      ElementFont = efCSS
      Role = ''
      object divTitle: TWebHTMLDiv
        AlignWithMargins = True
        Left = 48
        Top = 0
        Width = 196
        Height = 44
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 0
        ElementClassName = 
          'Title rounded border border-primary bg-white d-flex align-items-' +
          'center justify-content-center'
        ElementID = 'divTitle'
        Align = alClient
        ElementFont = efCSS
        HTML.Strings = (
          'No Survey Specified')
        Role = ''
      end
      object btnAbout: TWebButton
        Left = 0
        Top = 0
        Width = 44
        Height = 44
        Hint = 'About'
        Align = alLeft
        Caption = '<i class="fa-solid fa-chart-simple fa-fw fa-2x"></i>'
        ChildOrder = 1
        ElementClassName = 
          'btn btn-primary btn-sm text-white d-flex justify-content-center ' +
          'align-items-center'
        ElementID = 'btnAbout'
        ElementFont = efCSS
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = btnAboutClick
      end
      object btnMessage: TWebButton
        Left = 248
        Top = 0
        Width = 44
        Height = 44
        Hint = 'Feedback'
        Align = alRight
        Caption = '<i class="fa-solid fa-message fa-fw fa-2x"></i>'
        ChildOrder = 2
        ElementClassName = 
          'btn btn-primary btn-sm text-white d-flex justify-content-center ' +
          'align-items-center'
        ElementID = 'btnMessage'
        ElementFont = efCSS
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = btnMessageClick
      end
    end
    object divMiddle: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 52
      Width = 292
      Height = 345
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 0
      ElementClassName = 'Content'
      ElementID = 'divMiddle'
      Align = alClient
      ChildOrder = 2
      ElementFont = efCSS
      HTML.Strings = (
        
          '<div class="w-100 h-100 rounded border border-primary bg-white d' +
          '-flex align-items-center justify-content-center">'
        '  <div class="mx-3">'
        '    <p>Sorry!</p>'
        
          '    <p>No survey was found using the information in the link pro' +
          'vided.<br />'
        
          '    <p>The survey may have been updated to use a new link, or th' +
          'e survey may have been retracted entirely.</p>'
        
          '    <p>Please contact the survey provider for more information.<' +
          '/p>'
        '  </div>'
        '</div>'
        '')
      Role = ''
    end
  end
  object divAbout: TWebHTMLDiv
    Left = 326
    Top = 8
    Width = 300
    Height = 449
    ElementClassName = 'rounded border border-primary bg-light'
    ElementID = 'divAbout'
    ChildOrder = 1
    ElementFont = efCSS
    Role = ''
    object divAboutHeader: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 292
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ElementID = 'divAboutHeader'
      Align = alTop
      ElementFont = efCSS
      Role = ''
      object divAboutTitle: TWebHTMLDiv
        AlignWithMargins = True
        Left = 48
        Top = 0
        Width = 196
        Height = 44
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 0
        ElementClassName = 
          'Title rounded border border-primary bg-white d-flex align-items-' +
          'center justify-content-center'
        ElementID = 'divTitle'
        Align = alClient
        ElementFont = efCSS
        HTML.Strings = (
          'About SurveyApp')
        Role = ''
      end
      object btnAboutAbout: TWebButton
        Left = 0
        Top = 0
        Width = 44
        Height = 44
        Hint = 'About'
        Align = alLeft
        Caption = '<i class="fa-solid fa-chart-simple fa-fw fa-2x"></i>'
        ChildOrder = 1
        ElementClassName = 
          'pe-none btn btn-success btn-sm text-white d-flex justify-content' +
          '-center align-items-center'
        ElementID = 'btnAboutAbout'
        ElementFont = efCSS
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = btnAboutClick
      end
      object btnAboutMessage: TWebButton
        Left = 248
        Top = 0
        Width = 44
        Height = 44
        Hint = 'Feedback'
        Align = alRight
        Caption = '<i class="fa-solid fa-message fa-fw fa-2x"></i>'
        ChildOrder = 2
        ElementClassName = 
          'btn btn-primary btn-sm text-white d-flex justify-content-center ' +
          'align-items-center'
        ElementID = 'btnAboutMessage'
        ElementFont = efCSS
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = btnMessageClick
      end
    end
    object divAboutFooter: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 401
      Width = 292
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ElementClassName = 'd-flex justify-content-center'
      ElementID = 'divBottomFeedback'
      Align = alBottom
      ChildOrder = 1
      ElementFont = efCSS
      Role = ''
      ExplicitTop = 399
      object btnAboutOK: TWebButton
        Left = 97
        Top = 0
        Width = 97
        Height = 44
        Caption = 
          '<div style="font-size:16px;" class="ms-2 me-2"><i class="fa-soli' +
          'd fa-thumbs-up fa-xl me-1"></i> Got It!</div>'
        ElementClassName = 'btn btn-sm btn-primary me-1'
        ElementID = 'btnAboutOK'
        ElementFont = efCSS
        ElementPosition = epIgnore
        HeightPercent = 100.000000000000000000
        WidthStyle = ssAuto
        WidthPercent = 100.000000000000000000
        OnClick = btnAboutOKClick
      end
    end
    object divAboutContent: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 52
      Width = 292
      Height = 345
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 0
      ElementClassName = 
        'About rounded border border-primary bg-white d-flex align-items-' +
        'center justify-content-center'
      ElementID = 'divAboutContent'
      Align = alClient
      ChildOrder = 2
      Role = ''
      ExplicitHeight = 343
    end
  end
  object divFeedback: TWebHTMLDiv
    Left = 646
    Top = 8
    Width = 300
    Height = 449
    ElementClassName = 'rounded border border-primary bg-light'
    ElementID = 'divFeedback'
    ChildOrder = 1
    ElementFont = efCSS
    Role = ''
    object divFeedbackHeader: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 292
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ElementID = 'divFeedbackHeader'
      Align = alTop
      ElementFont = efCSS
      Role = ''
      object divFeedbackTitle: TWebHTMLDiv
        AlignWithMargins = True
        Left = 48
        Top = 0
        Width = 196
        Height = 44
        Margins.Left = 4
        Margins.Top = 0
        Margins.Right = 4
        Margins.Bottom = 0
        ElementClassName = 
          'Title rounded border border-primary bg-white d-flex align-items-' +
          'center justify-content-center'
        ElementID = 'divTitle'
        Align = alClient
        ElementFont = efCSS
        HTML.Strings = (
          'Feedback')
        Role = ''
      end
      object btnFeedbackAbout: TWebButton
        Left = 0
        Top = 0
        Width = 44
        Height = 44
        Hint = 'About'
        Align = alLeft
        Caption = '<i class="fa-solid fa-chart-simple fa-fw fa-2x"></i>'
        ChildOrder = 1
        ElementClassName = 
          'btn btn-primary btn-sm text-white d-flex justify-content-center ' +
          'align-items-center'
        ElementID = 'btnAbout'
        ElementFont = efCSS
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = btnAboutClick
      end
      object btnFeedbackFeedback: TWebButton
        Left = 248
        Top = 0
        Width = 44
        Height = 44
        Hint = 'Feedback'
        Align = alRight
        Caption = '<i class="fa-solid fa-message fa-fw fa-2x"></i>'
        ChildOrder = 2
        ElementClassName = 
          'pe-none btn btn-success btn-sm text-white d-flex justify-content' +
          '-center align-items-center'
        ElementID = 'btnMessage'
        ElementFont = efCSS
        HeightPercent = 100.000000000000000000
        WidthPercent = 100.000000000000000000
        OnClick = btnMessageClick
      end
    end
    object divBottomFeedback: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 401
      Width = 292
      Height = 44
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ElementClassName = 'd-flex justify-content-center'
      ElementID = 'divBottomFeedback'
      Align = alBottom
      ChildOrder = 1
      ElementFont = efCSS
      Role = ''
      ExplicitTop = 399
      object btnSubmitFeedback: TWebButton
        Left = 33
        Top = 0
        Width = 97
        Height = 44
        Caption = 
          '<div style="font-size:16px;" class="ms-1 me-2"><i class="fa-soli' +
          'd fa-paper-plane fa-xl me-1"></i> Submit Feedback</div>'
        ElementClassName = 'btn btn-sm btn-primary me-1'
        ElementID = 'btnSubmitFeedback'
        ElementFont = efCSS
        ElementPosition = epIgnore
        HeightPercent = 100.000000000000000000
        WidthStyle = ssAuto
        WidthPercent = 100.000000000000000000
        OnClick = btnSubmitFeedbackClick
      end
      object btnCancelFeedback: TWebButton
        Left = 136
        Top = 0
        Width = 100
        Height = 44
        Caption = 
          '<div style="font-size:16px;"  class="ms-1 me-2"><i class="fa-sol' +
          'id fa-cross fa-xmark me-1 fa-xl"></i> Cancel Feedback</div>'
        ChildOrder = 2
        ElementClassName = 'btn btn-sm btn-danger ms-1'
        ElementID = 'btnCancelFeedback'
        ElementFont = efCSS
        ElementPosition = epIgnore
        HeightPercent = 100.000000000000000000
        WidthStyle = ssAuto
        WidthPercent = 100.000000000000000000
        OnClick = btnCancelFeedbackClick
      end
    end
    object divFeedbackForm: TWebHTMLDiv
      AlignWithMargins = True
      Left = 4
      Top = 52
      Width = 292
      Height = 37
      Margins.Left = 4
      Margins.Top = 0
      Margins.Right = 4
      Margins.Bottom = 0
      ElementClassName = 'Feedback'
      ElementID = 'divFeedbackForm'
      HeightStyle = ssAuto
      Align = alTop
      ChildOrder = 2
      HTML.Strings = (
        '<div class="mx-3 mt-3 text-primary">'
        '  <p>We want to hear from you!</p>'
        
          '  <p>  We'#39'd love to get feedback on this app, the survey, indivi' +
          'dual survey questions or responses, or anything else about this ' +
          'survey experience, from your '
        'perspective.</p>'
        
          '  <p> If you wish to receive a response, please include your e-m' +
          'ail address in your message.</p>'
        '</div>')
      Role = ''
    end
    object memoFeedback: TWebMemo
      AlignWithMargins = True
      Left = 4
      Top = 93
      Width = 292
      Height = 300
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      AutoSize = False
      BiDiMode = bdLeftToRight
      BorderStyle = bsNone
      ElementClassName = 'rounded border border-primary p-2 bg-white'
      ElementID = 'memoFeedback'
      ElementFont = efCSS
      HeightPercent = 100.000000000000000000
      SelLength = 0
      SelStart = 0
      WidthPercent = 100.000000000000000000
    end
  end
end
