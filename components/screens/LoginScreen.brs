sub init()
    m.top.SetFocus(true)
    setVideo()
    m.parentRectangle = m.top.findNode("parentRectangle")
    m.oopsLabel = m.top.findNode("oopsLabel")
    m.oopsLabel.font.size = 115
    m.labelWelcome = m.top.findNode("labelWelcome")
    m.labelWelcome.font.size = 115
    m.errorLabel = m.top.findNode("errorLabel")
    
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
    email = m.textLabel.text
    'if emailValidation(email)
        if checkInternetConnection()
            baseUrl = getApiBaseUrl()
            finalUrl = baseUrl + "accounts" + "?email=zoe@barbershop.io"
            m.fetchMerchantApi = createObject("roSGNode","FetchMerchantApiHandler")
            m.fetchMerchantApi.setField("uri",finalUrl)
            m.fetchMerchantApi.observeField("content","onFetchMerchant")
            m.fetchMerchantApi.control = "RUN"
            showHideSpinner(true)
        else
            printValue("No Network")
        end if
'    else
'        showHideError(true)
'    end if
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

function showHideSpinner(flag as boolean) as void
      if flag
            print "???????????????????????????"
            'm.busyspinner.poster.loadStatus = "ready"
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


function onFetchMerchant()
    printValue("onFetchMerchant success")
    
    print  m.fetchMerchantApi.content.accountsArray
    
    hideViews()
    for each model in m.fetchMerchantApi.content.accountsArray
        print model;"/////////////////////////////////////////////////////////////////////////"
    end for  

    m.selectScreen = m.top.createChild("SelectAccount")
    print m.top.selectScreen
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)
    m.selectScreen.content = m.fetchMerchantApi.content.accountsArray
end function



sub hideViews()
    m.parentRectangle.visible = false
end sub


'method to let user enter and display registered email id
sub showKeyboard()
    m.keyboard.visible = true
    m.keyboard.setFocus(true)
    m.editTextButton.setFocus(false)
    m.nextButtonrectangle.visible = false
    
end sub

function setVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = "pkg:/videos/login_video.mp4"
  videoContent.title = "Test Video"
  videoContent.streamformat = "mp4"
  
 
  m.video = m.top.findNode("musicvideos")
  m.video.content = videoContent
  m.video.control = "play"
  m.video.loop = true
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
        else if key = "play"  'change event on back press
                emailId = m.keyboard.text
                m.textLabel.text = emailId
                m.keyboard.visible = false
                m.nextButtonrectangle.visible = true
                handleButtonEditTextColorFocus(false)
        else if key = "back"
                 m.selectScreen.setFocus(false)
                 m.selectScreen.visible = false
                 m.parentRectangle.visible = true
                 handleButtonEditTextColorFocus(true)
                 showHideError(false)
                 showHideSpinner(false)
'             if(m.top.selectScreen <> invalid and m.top.selectScreen.visible = true)
'                m.top.selectScreen.visible = false
'                m.layoutGroup.visible = true
'                m.editTextButton.setFocus(true)
'                return true
'             end if
            return true
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