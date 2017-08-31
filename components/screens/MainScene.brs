' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.isLoggedIn = true
    if(m.isLoggedIn)
      moveToLoginScreen()
    end if
End sub

sub moveToLoginScreen()
    m.loginScreen = m.top.createChild("LoginScreen")
    m.loginScreen.visible = true
    m.top.setFocus(false)
    m.loginScreen.setFocus(true)
End sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    return result 
End function
