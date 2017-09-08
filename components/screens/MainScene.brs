' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.isLoggedIn = false
    if(m.isLoggedIn)
        moveToLoginScreen()
    else
        moveToHomeScreen()

    end if
End sub

sub moveToHomeScreen()
    homeScreen = m.top.createChild("HomeScreen")
    homeScreen.visible = true
    m.top.setFocus(false)
    homeScreen.setFocus(true)
End sub

sub moveToLoginScreen()
    loginScreen = m.top.createChild("LoginScreen")
    loginScreen.visible = true
    m.top.setFocus(false)
    loginScreen.setFocus(true)
End sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    return result 
End function
