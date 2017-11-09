' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.isLoggedIn = getValueInRegistryForKey("isLoginValue")
    m.top.isWhiteLabel = true
    
    if m.top.isWhiteLabel
        setConfigData()
        if m.isLoggedIn = "true"
            moveToHomeScreen()
        else
            moveToWelcomeScreen()
        end if
    else
        if m.isLoggedIn = "true"
            moveToHomeScreen()
        else
            moveToWelcomeScreen()
        end if
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

sub moveToWelcomeScreen()
    welcomeScreen = m.top.createChild("WelcomeScreen")
    welcomeScreen.visible = true
    m.top.setFocus(false)
    welcomeScreen.setFocus(true)
End sub

sub setConfigData()
    appConfigModel = CreateObject("roSGNode", "AppConfigModel")
    appConfigModel.primary_color = "#14a6df"
    appConfigModel.non_focus_color = "#565656"
    appConfigModel.account_id = 1782
    appConfigModel.account_name = "ToTheNew"
    appConfigModel.account_secret_key = "y]zaByUr@BKmwk/&2bqbCfm4"
    appConfigModel.inapp_purchase_flag = true
    appConfigModel.forgot_password = true
    appConfigModel.pin_only = false
    appConfigModel.password_only = true
    m.top.appConfigContent = appConfigModel   
end sub

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
