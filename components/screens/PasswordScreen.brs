sub init()
    m.top.setFocus(true)
    m.parentRectangle = m.top.findNode("parentRectangle")
    m.oopsLabel = m.top.findNode("oopsLabel")
    m.oopsLabel.font.size = 90
    m.labelWelcome = m.top.findNode("labelWelcome")
    m.labelWelcome.font.size = 90
    m.errorLabel = m.top.findNode("errorLabel")
    m.textLabel = m.top.findNode("hintlabel")
    m.textLabel.font.size = 30
    m.keyboard = m.top.findNode("keyboard")
    m.keyboard.textEditBox.secureMode = true
    m.busyspinner = m.top.findNode("exampleBusySpinner")
   ' m.busyspinner.poster.observeField("loadStatus", "showspinner")
    m.busyspinner.poster.uri = "pkg:/images/busyspinner_hd.png"
    m.pinLabel = m.top.findNode("pinLabel")
    m.forgotPasswordLabel = m.top.findNode("forgotPasswordLabel")
    'm.pinpad = m.top.findNode("pinpad")
    m.keyboardTheme = m.top.findNode("keyboardTheme")
    keyboardX = (1920 - m.keyboardTheme.width) / 2
    m.keyboardTheme.translation = [keyboardX,450]
    
'    m.pinpadTheme = m.top.findNode("pinpadTheme")
'    pinpadX = (1920 - m.pinpadTheme.width) / 2
'    pinpadY = ((1080 - m.pinpadTheme.height) / 2 ) 
'    m.pinpadTheme.translation = [pinpadX,pinpadY]
'    
    m.editTextRectangle = m.top.findNode("editTextRectangle")
    editTextRectangleX = (1920 - m.editTextRectangle.width) / 2
    editTextRectangleY = ((1080 - m.editTextRectangle.height) / 2 ) - 30
    m.editTextRectangle.translation = [editTextRectangleX, editTextRectangleY]
    
    m.nextButtonrectangle = m.top.findNode("nextButtonrectangle")
    nextButtonrectangleX = (1920 - m.nextButtonrectangle.width) / 2
    nextButtonrectangleY = editTextRectangleY + 100
    m.nextButtonrectangle.translation = [nextButtonrectangleX,nextButtonrectangleY]
    
    m.pinRectangle = m.top.findNode("pinRectangle")
    pinRectangleY = nextButtonrectangleY + 100
    m.pinRectangle.translation = [0,pinRectangleY]
    
    m.forgotPasswordRectangle = m.top.findNode("forgotPasswordRectangle")
    forgotPasswordRectangleY = pinRectangleY + 50
    m.forgotPasswordRectangle.translation = [0,forgotPasswordRectangleY]
    
    m.editTextButton = m.top.findNode("editTextButton")
    m.editTextButton.observeField("buttonSelected","showKeyboardPinPad")
    m.editTextButton.setFocus(true)
    
        
    m.buttonLogin = m.top.findNode("buttonLogin")
    m.buttonLogin.observeField("buttonSelected","goToHomeScreen")
    m.buttonLogin.setFocus(false)
    
    m.buttonLoginPin = m.top.findNode("buttonLoginPin")
    m.buttonLoginPin.observeField("buttonSelected","showPinDialog")
    m.buttonLoginPin.setFocus(false)
    
    m.buttonForgotPassword = m.top.findNode("buttonForgotPassword")
    m.buttonForgotPassword.observeField("buttonSelected","goToForgotPasswordScreen")
    m.buttonForgotPassword.setFocus(false)
    
    'initializing the currentFocus id 
    m.currentFocusID ="editTextButton"
    
    'up-down-left-right  
    m.focusIDArray = {"editTextButton":"N-buttonLogin-N-N"                      
                       "buttonLogin":"editTextButton-buttonLoginPin-N-N"     
                       "buttonLoginPin":"buttonLogin-buttonForgotPassword-N-N"                   
                       "buttonForgotPassword":"buttonLoginPin-N-N-N"    
                     }
                     
    m.pinSelected = false
    
    m.password = ""
 
end sub

sub updateSelectedAccount()
    m.editTextButton.setFocus(true)
    m.emailId = m.top.emailId
    m.account = m.top.account
    setValueInRegistryForKey("selectedAccountName", m.account.name)
    if(m.account.thumbnail <> invalid)
        setValueInRegistryForKey("selectedAccountThumb", m.account.thumbnail)
    end if
    print "m.account >>> " ; m.account
end sub

sub goToHomeScreen()
    pwd = m.password
    if pwd = ""
        showHideError(true,01)
        m.currentFocusID = "editTextButton"
        handleVisibility()
        m.editTextButton.setFocus(true)
    else if checkInternetConnection()
        baseUrl = getAuthTokenApiUrl()
        if m.pinSelected
            parmas = createAuthTokenParams("password",m.emailId,"",m.account.id,pwd)
        else
            parmas = createAuthTokenParams("password",m.emailId,pwd,m.account.id,"")
        end if
        m.authApi = createObject("roSGNode","AuthTokenApiHandler")
        
        m.authApi.setField("uri",baseUrl)
        m.authApi.setField("params",parmas)
        m.authApi.observeField("content","onAuthToken")
        m.authApi.control = "RUN"
        showProgressDialog()
    else
        printValue("No Network")
        showHideError(true,02)
        m.currentFocusID = "editTextButton"
        handleVisibility()
        m.editTextButton.setFocus(true)
        m.textLabel.font.size = 30
        if m.pinSelected
            m.textLabel.text = "PIN"
        else
            m.textLabel.text = "Password"
        end if
    end if
end sub

sub showProgressDialog()
     dialog = createObject("roSGNode", "ProgressDialog")
     dialog.backgroundUri = ""
     dialog.title = "Loading..."
     dialog.optionsDialog = true
     m.top.getScene().dialog = dialog
end sub

'Call on Authentication API response
sub onAuthToken()
   authTokenModel = m.authApi.content
   if(authTokenModel.success)
        if(getValueInRegistryForKey("isLoginValue") = "true")
            hideViews()
            m.top.getScene().dialog.close = true
            m.homeScreen = m.top.createChild("HomeScreen")
            m.top.setFocus(false)
            m.homeScreen.setFocus(true)
        else
           showHideError(true,01)
           m.top.getScene().dialog.close = true
           m.currentFocusID = "editTextButton"
           handleVisibility()
           m.editTextButton.setFocus(true)
        end if
    else
        m.top.getScene().dialog.close = true
        printValue("No Network")
            showHideError(true,02)
            m.currentFocusID = "editTextButton"
            handleVisibility()
            m.editTextButton.setFocus(true)
            m.textLabel.font.size = 30
            if m.pinSelected
                m.textLabel.text = "PIN"
            else
                m.textLabel.text = "Password"
            end if
    end if
    
end sub

sub showPinDialog()
    m.currentFocusID = "editTextButton"
    handleVisibility()
    m.editTextButton.setFocus(true)
    showHideError(false,00)
    m.textLabel.color = "0x1c2833ff"
    m.textLabel.font.size = 30
    m.pinSelected = not m.pinSelected
    
    if m.pinSelected 
        m.textLabel.text = "PIN"
        m.pinLabel.text = "Login with Password"
    else
        m.textLabel.text = "Password"
        m.pinLabel.text = "Login with PIN"
    end if
end sub

sub goToForgotPasswordScreen()
    m.parentRectangle.visible = false
    m.forgotPasswordScreen = m.top.createChild("ForgotPassword")
    print m.top.forgotPasswordScreen
    m.top.setFocus(false)
    m.forgotPasswordScreen.setFocus(true)
    m.forgotPasswordScreen.emailId = m.emailId
    m.forgotPasswordScreen.account = m.account
end sub

sub hideViews()
    m.parentRectangle.visible = false
    m.top.getScene().dialog.close = true
end sub

sub showKeyboardPinPad()
'    if m.pinSelected
'        m.pinpad.visible = true
'        m.pinpadTheme.visible = true
'        m.pinpad.setFocus(true)
'    else 
        m.keyboard.visible = true
        m.keyboardTheme.visible = true
        m.keyboard.setFocus(true)
   ' end if
   if m.textLabel.text = "Password" or m.textLabel.text = "PIN"
       m.keyboard.text = ""
   else
       m.keyboard.text = m.textLabel.text
   end if
      
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    if press
    print "onKeyEvent Password Screen : "; key
        if key="up" OR key="down" OR key="left" OR key="right" Then
            if m.keyboard.visible = false 'AND m.pinpad.visible = false
                handleFocus(key)
                handleVisibility()
                return true
            end if
        else if key = "back"
            if m.keyboard.visible
                closeKeyboard()
                
'            else if m.pinpad.visible
'                m.pinpad.visible = false
'                m.pinpadTheme.visible = false
'                m.pin = m.pinpad.pin
'                m.textLabel.text = m.pin
'                m.currentFocusID = "editTextButton"
'                handleVisibility()
'                m.editTextButton.setFocus(true)
                return true
            else if  m.forgotPasswordScreen <> invalid AND m.forgotPasswordScreen.visible
                print "Forgot password screen back" 
                m.forgotPasswordScreen.setFocus(false)
                m.forgotPasswordScreen.visible = false
                m.parentRectangle.visible = true
                m.currentFocusID = "editTextButton"
                handleVisibility()
                m.editTextButton.setFocus(true) 
                return true
            else if getValueInRegistryForKey("isHomeValue") = "true"
                
                m.top.visible = false
                return false
            else
                 print "Forgot password screen back else block";getValueInRegistryForKey("isHomeValue")
                return false
            end if 
            
        end if
    end if
    return result 
end function

sub closeKeyboard()
    m.keyboard.visible = false
    m.keyboardTheme.visible = false
    m.password = m.keyboard.text
    if m.password = ""
        m.textLabel.font.size = 30
            if m.pinSelected
                m.textLabel.text = "PIN"
            else
                m.textLabel.text = "Password"
            end if
    else
        m.textLabel.text = m.password
        count = Len(m.password) 
        astrick = ""
        for i = 0 To count-1 step +1
        astrick = astrick + "*"
        end for
        m.textLabel.text = astrick
        m.textLabel.font.size = 55
    end if
    
    m.currentFocusID = "editTextButton"
    handleVisibility()
    m.editTextButton.setFocus(true)
    
end sub

function showHideError(showError as boolean,errorCode as integer) as void
    if showError = true
        m.errorLabel.visible = true
        m.oopsLabel.visible = true
        m.labelWelcome.visible = false
        if  errorCode = 02
           m.errorLabel.text = "No Internet Connection"
        else if errorCode = 01
           m.errorLabel.text = "There was an error logging into your account. Please check your password and try again." 
        end if
    else
        m.errorLabel.visible = false
        m.oopsLabel.visible = false
        m.labelWelcome.visible = true
    end if
end function

function handleVisibility() as void
    if m.currentFocusID = "editTextButton"
        m.textLabel.color = "0x1c2833ff"                'black text color
        m.nextButtonrectangle.color = "0xB4B4B1ff"      'greycolor
        m.pinLabel.color = "0xffffffff"
        m.forgotPasswordLabel.color = "0xffffffff"
    else if m.currentFocusID = "buttonLogin"
        m.textLabel.color = "0xB4B4B1ff"                'grey text color
        m.nextButtonrectangle.color = "0x00CBB9FF"      'bluecolor
        m.pinLabel.color = "0xffffffff"
        m.forgotPasswordLabel.color = "0xffffffff"
    else if m.currentFocusID = "buttonLoginPin"
        m.textLabel.color = "0xB4B4B1ff"                'grey text color
        m.nextButtonrectangle.color = "0xB4B4B1ff"      'greycolor
        m.pinLabel.color = "0x00CBB9FF"                 'blue color
        m.forgotPasswordLabel.color = "0xffffffff"
    else if m.currentFocusID = "buttonForgotPassword"
        m.textLabel.color = "0xB4B4B1ff"                'grey text color
        m.nextButtonrectangle.color = "0xB4B4B1ff"      'greycolor
        m.pinLabel.color = "0xffffffff"                 'blue color
        m.forgotPasswordLabel.color = "0x00CBB9FF"
    end if
end function
