sub init()
    m.top.SetFocus(true)
    m.textEditTextEmail = m.top.findNode("textEditBoxEmail")
    m.textEditTextEmail.setFocus(true)
    
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonNext.observeField("buttonSelected","goToSelectScreen")
    m.buttonNext.setFocus(false)
End sub

sub goToSelectScreen()
    m.selectScreen = m.top.createChild("SelectAccount")
    m.selectScreen.visible = true
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)
end sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    
    if(press)
        if key = "down"
            if m.textEditTextEmail.hasFocus()
                m.textEditTextEmail.setFocus(false)
                m.buttonNext.setFocus(true)
            end if
        else if key = "up"
            if m.buttonNext.hasFocus()
                m.buttonNext.setFocus(false)
                m.textEditTextEmail.setFocus(true)
            end if
        end if
    end if
    return result 
End Function 