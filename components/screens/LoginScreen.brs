sub init()
    m.top.SetFocus(true)
    setVideo()
    m.parentRectangle = m.top.findNode("parentRectangle")
    m.oopsLabel = m.top.findNode("oopsLabel")
    m.oopsLabel.font.size = 115
    m.labelWelcome = m.top.findNode("labelWelcome")
    m.labelWelcome.font.size = 115
    m.errorLabel = m.top.findNode("errorLabel")
    m.keyboardTheme = m.top.findNode("keyboardTheme")
    keyboardX = (1920 - m.keyboardTheme.width) / 2
    m.keyboardTheme.translation = [keyboardX,450]
    
    m.editTextRectangle = m.top.findNode("editTextRectangle")
    editTextRectangleX = (1920 - m.editTextRectangle.width) / 2
    editTextRectangleY = ((1080 - m.editTextRectangle.height) / 2 ) - 30
    m.editTextRectangle.translation = [editTextRectangleX, editTextRectangleY]
    
    m.nextButtonrectangle = m.top.findNode("nextButtonrectangle")
    nextButtonrectangleX = (1920 - m.nextButtonrectangle.width) / 2
    m.nextButtonrectangle.translation = [nextButtonrectangleX,editTextRectangleY + 100]
    
    m.editTextButton = m.top.findNode("editTextButton")
    m.editTextButton.observeField("buttonSelected","showKeyboard")
    m.editTextButton.setFocus(true)
    
    
    m.textLabel = m.top.findNode("hintlabel")
    m.keyboard = m.top.findNode("keyboard")
    
        
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonNext.observeField("buttonSelected","goToSelectScreen")
    m.buttonNext.setFocus(false)
    
    m.busyspinner = m.top.findNode("exampleBusySpinner")
   ' m.busyspinner.poster.observeField("loadStatus", "showspinner")
    m.busyspinner.poster.uri = "pkg:/images/busyspinner_hd.png"
    
    'm.busyspinner.poster.loadStatus = "none"
   
End sub

'method called to go to Select Account screen
sub goToSelectScreen()
    m.email = m.textLabel.text
    if emailValidation(m.email)
        if checkInternetConnection()
            baseUrl = getApiBaseUrl()
            'finalUrl = baseUrl + "accounts" + "?email="+m.email
            finalUrl = baseUrl + "accounts" + "?email=zoe@barbershop.io"
            m.fetchMerchantApi = createObject("roSGNode","FetchMerchantApiHandler")
            m.fetchMerchantApi.setField("uri",finalUrl)
            m.fetchMerchantApi.observeField("content","onFetchMerchant")
            m.fetchMerchantApi.control = "RUN"
            'showHideSpinner(true)
            showProgressDialog()
        else
            printValue("No Network")
        end if
    else
        showHideError(true)
    end if
end sub

function showHideError(showError as boolean) as void
    if showError = true
        m.errorLabel.visible = true
        m.oopsLabel.visible = true
        m.labelWelcome.visible = false
    else
        m.errorLabel.visible = false
        m.oopsLabel.visible = false
        m.labelWelcome.visible = true
    end if
end function

sub loginScreenAppeared()
    m.editTextButton.setFocus(true)
end sub

function showHideSpinner(flag as boolean) as void
      if flag
            m.busyspinner.visible = true
            m.nextButtonrectangle.visible = false
      else 
            m.busyspinner.visible = false
            m.nextButtonrectangle.visible = true
      end if
end function

sub showspinner()
      if(m.busyspinner.poster.loadStatus = "ready")
        m.busyspinner.visible = true
      end if
end sub

sub showProgressDialog()
     dialog = createObject("roSGNode", "ProgressDialog")
     dialog.backgroundUri = ""
     dialog.title = "Alert Dialog"
     dialog.optionsDialog = true
     dialog.message = "Loading..."
     m.top.getScene().dialog = dialog
end sub

function onFetchMerchant()  
    hideViews()
    
    m.selectScreen = m.top.createChild("SelectAccount")
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)
    'm.selectScreen.emailID = m.email
    m.selectScreen.emailID = "zoe@barbershop.io"
    m.selectScreen.content = m.fetchMerchantApi.content.accountsArray
end function



sub hideViews()
    m.parentRectangle.visible = false
    m.top.getScene().dialog.close = true
end sub


'method to let user enter and display registered email id
sub showKeyboard()
    m.keyboard.visible = true
    m.keyboardTheme.visible = true
    m.keyboard.setFocus(true)
    m.editTextButton.setFocus(false)
    m.nextButtonrectangle.visible = true
    
end sub

function setVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = "pkg:/videos/login_video.mp4"
  videoContent.title = ""
  videoContent.streamformat = "mp4"
  
 
  m.video = m.top.findNode("musicvideos")
  m.video.content = videoContent
  m.video.control = "play"
  m.video.loop = true
  m.video.retrievingBar.visible = false
   m.video.retrievingTextColor = "0xffffff00"
end function

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if(press)
        if key = "down"
            if m.editTextButton.hasFocus()
                handleButtonEditTextColorFocus(false)
            end if
        else if key = "up"
            if m.buttonNext.hasFocus()
                handleButtonEditTextColorFocus(true)
            end if
        else if key = "back"
                if m.keyboard.visible
                    emailId = m.keyboard.text
                    m.textLabel.text = emailId
                    m.keyboard.visible = false
                    m.keyboardTheme.visible = false
                    m.nextButtonrectangle.visible = true
                    handleButtonEditTextColorFocus(true)
                    result = true
                else if m.selectScreen <> invalid AND m.selectScreen.visible
                    m.selectScreen.setFocus(false)
                    m.selectScreen.visible = false
                    m.parentRectangle.visible = true
                    handleButtonEditTextColorFocus(true)
                    m.textLabel.text = "Account Email"
                    showHideError(false)
                    result = true
                else 
                    result = false
                end if
                 
                 'showHideSpinner(false)
'             if(m.top.selectScreen <> invalid and m.top.selectScreen.visible = true)
'                m.top.selectScreen.visible = false
'                m.layoutGroup.visible = true
'                m.editTextButton.setFocus(true)
'                return true
'             end if
        end if
    end if
    return result 
End Function 


function handleButtonEditTextColorFocus(isEditTextFocused as boolean) as void
    if isEditTextFocused = false
        m.nextButtonrectangle.color = "0x00CBB9FF" 'blue color
        m.textLabel.color = "0xB4B4B1ff" 'grey color
        m.editTextButton.setFocus(false)
        m.buttonNext.setFocus(true)
    else
        m.nextButtonrectangle.color = "0xB4B4B1ff" 'grey color
        m.textLabel.color = "0x1c2833ff"  'black color
        m.buttonNext.setFocus(false)
        m.editTextButton.setFocus(true)
    end if

end function