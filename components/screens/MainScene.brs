' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.isLoggedIn = getValueInRegistryForKey("isLoginValue")
    
    
    print "m.isLoggedIn " ; m.isLoggedIn
    if m.isLoggedIn = "true"
       moveToHomeScreen()
    else
       moveToLoginScreen()
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
    loginScreen.buttonFocus = true
End sub

'function setMyContent(data as object)
'    m.Global.myContent = data
'end function
'
'function getMyContent() as object
'    return m.Global.myContent
'end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
 
    return result 
End function
