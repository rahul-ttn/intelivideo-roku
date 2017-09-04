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
    m.editTextButton = m.top.findNode("editTextButton")
    m.editTextButton.observeField("buttonSelected","showKeyboard")
    m.editTextButton.setFocus(true)
    
    
    m.textLabel = m.top.findNode("hintlabel")
    'm.textLabel.color = "0xB4B4B1ff"
    m.keyboard = m.top.findNode("keyboard")
    
        
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonNext.observeField("buttonSelected","goToSelectScreen")
    m.buttonNext.setFocus(false)
    
End sub

'method called to go to Select Account screen
sub goToSelectScreen()
    hideViews()
    m.selectScreen = m.top.createChild("SelectAccount")
    print m.selectScreen
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)
end sub

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
        end if
    end if
    return result 
End Function 