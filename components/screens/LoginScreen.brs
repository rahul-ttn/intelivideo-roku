sub init()
    m.top.SetFocus(true)
    m.textEditTextEmail = m.top.findNode("textEditBoxEmail")
    m.textEditTextEmail.setFocus(true)
End sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    
    return result 
End Function 