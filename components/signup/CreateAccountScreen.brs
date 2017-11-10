sub init()
    m.top.SetFocus(true)
    m.appConfig = m.top.getScene().appConfigContent
    m.editFieldType = "email"
    initFields()
End sub

sub initFields()
    m.accountLogo = m.top.findNode("accountLogo")
    accountLogoX = (1920 - m.accountLogo.width) / 2
    m.accountLogo.translation = [accountLogoX,120]
    
    m.labelNewWay = m.top.findNode("labelNewWay")
    m.labelNewWay.font.size = 60
    
    m.labelDiscription = m.top.findNode("labelDiscription")
    m.labelDiscription.text = "You new subscription will provide you with Instant Access to the content you want. After creating an account, you can select a plan to watch anywhere on any device, anytime."
    labelDiscriptionX = (1920 - m.labelDiscription.width) / 2
    m.labelDiscription.translation = [labelDiscriptionX,430]
    
    m.loginRectangle = m.top.findNode("loginRectangle")
    m.loginRectangle.color = m.appConfig.non_focus_color
    
    m.loginButton = m.top.findNode("loginButton")
    m.loginButton.observeField("buttonSelected","showLoginScreen")
    m.loginButton.setFocus(false)
    
    m.emailRectangle = m.top.findNode("emailRectangle")
    emailRectangleX = (1920 - m.emailRectangle.width) / 2
    m.emailRectangle.translation = [emailRectangleX,600]
    
    m.emailButton = m.top.findNode("emailButton")
    m.emailButton.observeField("buttonSelected","showKeyboard")
    m.emailButton.setFocus(true)
    
    m.passwordRectangle = m.top.findNode("passwordRectangle")
    passwordRectangleX = (1920 - m.passwordRectangle.width) / 2
    m.passwordRectangle.translation = [passwordRectangleX,700]
    
    m.passwordButton = m.top.findNode("passwordButton")
    m.passwordButton.observeField("buttonSelected","showKeyboard")
    m.passwordButton.setFocus(true)
    
    m.createAccountRectangle = m.top.findNode("createAccountRectangle")
    m.createAccountRectangle.color = m.appConfig.non_focus_color
    createAccountRectangleX = (1920 - m.createAccountRectangle.width) / 2
    m.createAccountRectangle.translation = [createAccountRectangleX,830]
    
    m.createAccountButton = m.top.findNode("createAccountButton")
    m.createAccountButton.observeField("buttonSelected","createAccount")
    m.createAccountButton.setFocus(false)
    
    m.emailHintlabel = m.top.findNode("emailHintlabel")
    m.passwordHintlabel = m.top.findNode("passwordHintlabel")
    
    m.keyboard = m.top.findNode("keyboard")
    m.keyboardTheme = m.top.findNode("keyboardTheme")
    keyboardX = (1920 - m.keyboardTheme.width) / 2
    m.keyboardTheme.translation = [keyboardX,450]
    
    'initializing the currentFocus id 
    m.currentFocusID ="emailButton"
    
    'up-down-left-right  
    m.focusIDArray = {"loginButton":"N-emailButton-N-N"                      
                       "emailButton":"loginButton-passwordButton-N-N"     
                       "passwordButton":"emailButton-createAccountButton-N-N"
                       "createAccountButton":"passwordButton-N-N-N"                     
                     }
    handleVisibility()
end sub

sub onCreateAccountScreen()
    m.emailButton.setFocus(true)
end sub

sub createAccount()
    isValid()
end sub

Function isValid() as boolean
    if NOT emailValidation(m.emailHintlabel.text)
        showNetworkErrorDialog("Invalid Email" ,"Please enter valid email")
        m.createAccountButton.setFocus(false)
        m.emailButton.setFocus(true)
        m.currentFocusID ="emailButton"
        handleVisibility()
        return false
    else if NOT passwordValidation(m.passwordHintlabel.text)
        showNetworkErrorDialog("Invalid Password" ,"Please enter valid password")
        m.createAccountButton.setFocus(false)
        m.passwordButton.setFocus(true)
        m.currentFocusID ="passwordButton"
        handleVisibility()
        return false
    else
        return true
    end if
end Function

sub showKeyboard()
    m.keyboard.visible = true
    m.keyboardTheme.visible = true
    if m.emailButton.hasFocus()
        m.editFieldType = "email"
        m.keyboard.textEditBox.secureMode = false
        m.emailButton.setFocus(false)
        if m.emailHintlabel.text = "Email" 
            m.keyboard.text = ""
        else
            m.keyboard.text = m.emailHintlabel.text
        end if
    else if m.passwordButton.hasFocus()
        m.editFieldType = "password"
        m.keyboard.textEditBox.secureMode = true
        m.passwordButton.setFocus(false)
        if m.passwordHintlabel.text = "Password" 
            m.keyboard.text = ""
        else
            m.keyboard.text = m.passwordHintlabel.text
        end if
    end if
    m.keyboard.setFocus(true)
end sub

function handleVisibility() as void
    if m.currentFocusID = "loginButton"
        m.loginRectangle.color = m.appConfig.primary_color
        m.emailHintlabel.color = "0xB4B4B1ff"
        m.passwordHintlabel.color = "0xB4B4B1ff"
        m.createAccountRectangle.color = m.appConfig.non_focus_color
    else if m.currentFocusID = "emailButton"
        m.loginRectangle.color = m.appConfig.non_focus_color
        m.emailHintlabel.color = "0x000000ff"
        m.passwordHintlabel.color = "0xB4B4B1ff"
        m.createAccountRectangle.color = m.appConfig.non_focus_color
    else if m.currentFocusID = "passwordButton"
        m.loginRectangle.color = m.appConfig.non_focus_color
        m.emailHintlabel.color = "0xB4B4B1ff"
        m.passwordHintlabel.color = "0x000000ff"
        m.createAccountRectangle.color = m.appConfig.non_focus_color
    else if m.currentFocusID = "createAccountButton"
        m.loginRectangle.color = m.appConfig.non_focus_color
        m.emailHintlabel.color = "0xB4B4B1ff"
        m.passwordHintlabel.color = "0xB4B4B1ff"
        m.createAccountRectangle.color = m.appConfig.primary_color
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key="up" OR key="down" OR key="left" OR key="right" Then
            handleFocus(key)
            handleVisibility()
            return true
        else if key = "back"
            if m.keyboard.visible
                closeKeyBoard()
                return true
            else
                m.top.visible = false
                return false
            end if
        end if
    end if
    return result 
End function

sub closeKeyBoard()
    m.keyboard.visible = false
    m.keyboardTheme.visible = false
    m.keyboard.setFocus(false)
    if m.editFieldType = "email"
        m.emailButton.setFocus(true)
        enteredText = m.keyboard.text
        if enteredText = ""
            m.emailHintlabel.text = "Email"
        else
            m.emailHintlabel.text = enteredText
        end if
    else if m.editFieldType = "password"
        m.passwordButton.setFocus(true)
        enteredText = m.keyboard.text
        if enteredText = ""
            m.passwordHintlabel.text = "Password"
            m.passwordHintlabel.font.size = 30
        else
            m.passwordHintlabel.text = enteredText
            count = Len(enteredText) 
            astrick = ""
            for i = 0 To count-1 step +1
            astrick = astrick + "*"
            end for
            m.passwordHintlabel.text = astrick
            m.passwordHintlabel.font.size = 60
        end if
    end if 
end sub