sub init()
    m.top.SetFocus(true)
    setVideo()
'    font  = CreateObject("roSGNode", "Font")
'    'font.uri = "pkg:/fonts/font.ttf"
'    font.size = 24
'    m.label.font = font
    
'    m.textEditTextEmail = m.top.findNode("textEditBoxEmail")
'    'm.textEditTextEmail.setFocus(true)
'    m.textEditTextEmail.active = true
'    m.textEditTextEmail.visible = false

    m.layoutGroup = m.top.findNode("layoutGroup")
    m.rectangle = m.top.findNode("rect")
    m.labelWelcome = m.top.findNode("labelWelcome")
    m.labelWelcome.font.size = 115
    m.editTextButton = m.top.findNode("editTextButton")
    m.editTextButton.observeField("buttonSelected","showKeyboard")
    m.editTextButton.setFocus(true)
    
    
    m.textLabel = m.top.findNode("hintlabel")
    'm.textLabel.color = "0xB4B4B1ff"
    m.keyboard = m.top.findNode("keyboard")
    
        
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonNext.observeField("buttonSelected","goToSelectScreen")
    m.buttonNext.setFocus(false)
    
    m.button = m.top.findNode("loginButton")
    print m.button
   ' m.button.setText("Next")
    'm.customButton = m.button.getButtonNode()
    
    print m.customButton
    
    
End sub

'method called to go to Select Account screen
sub goToSelectScreen()

    if checkInternetConnection()
        baseUrl = getApiBaseUrl()
        finalUrl = baseUrl + "accounts" + "?email=zoe@barbershop.io"
        m.signUpApi = createObject("roSGNode","FetchMerchantApiHandler")
        m.signUpApi.setField("uri",finalUrl)
        m.signUpApi.observeField("content","onFetchMerchant")
        m.signUpApi.control = "RUN"
    else
        printValue("No Network")
    end if
    
end sub

function onFetchMerchant()

    printValue("onFetchMerchant success")
    
    hideViews()

    m.selectScreen = m.top.createChild("SelectAccount")
    print m.top.selectScreen
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)


end function



sub hideViews()
    m.layoutGroup.visible = false
end sub


'method to let user enter and display registered email id
sub showKeyboard()
    m.keyboard.visible = true
    m.keyboard.setFocus(true)
    m.editTextButton.setFocus(false)
    m.buttonNext.visible = false
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
                m.editTextButton.setFocus(false)
                m.buttonNext.setFocus(true)
            end if
        else if key = "up"
            if m.buttonNext.hasFocus()
                m.buttonNext.setFocus(false)
                m.editTextButton.setFocus(true)
            end if
        else if key = "play"  'change event on back press
                emailId = m.keyboard.text
                m.textLabel.text = emailId
                m.textLabel.color = "0x1c2833ff"
                m.keyboard.visible = false
                m.buttonNext.visible = true
                m.buttonNext.setFocus(true)
        else if key = "back"
                 m.selectScreen.setFocus(false)
                 m.selectScreen.visible = false
                 m.layoutGroup.visible = true
                 m.editTextButton.setFocus(true)
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