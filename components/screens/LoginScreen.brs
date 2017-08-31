sub init()
    m.top.SetFocus(true)
    
    m.label = m.top.findNode("labelWelcome")
'    font  = CreateObject("roSGNode", "Font")
'    'font.uri = "pkg:/fonts/font.ttf"
'    font.size = 24
'    m.label.font = font
    
'    m.textEditTextEmail = m.top.findNode("textEditBoxEmail")
'    'm.textEditTextEmail.setFocus(true)
'    m.textEditTextEmail.active = true
'    m.textEditTextEmail.visible = false

    m.editTextButton = m.top.findNode("editTextButton")
    m.textLabel = m.top.findNode("hintlabel")
    m.editTextButton.observeField("buttonSelected","showKeyboard")
    m.editTextButton.setFocus(true)
    m.keyboard = m.top.findNode("keyboard")
    
        
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonNext.observeField("buttonSelected","goToSelectScreen")
    m.buttonNext.setFocus(false)
End sub

'method called to go to Select Account screen
sub goToSelectScreen()
    m.selectScreen = m.top.createChild("SelectAccount")
    print m.selectScreen
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)
    
end sub

'method to let user enter and display registered email id
sub showKeyboard()
    
end sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    
    if(press)
        if key = "down"
            if m.textLabel.hasFocus()
                m.textLabel.setFocus(false)
                m.buttonNext.setFocus(true)
            end if
        else if key = "up"
            if m.buttonNext.hasFocus()
                m.buttonNext.setFocus(false)
                m.textLabel.setFocus(true)
            end if
        end if
    end if
    return result 
End Function 