sub init()
    m.top.setFocus(true)
    m.parentRectangle = m.top.findNode("parentRectangle")
    m.oopsLabel = m.top.findNode("oopsLabel")
    m.oopsLabel.font.size = 115
    m.labelWelcome = m.top.findNode("labelWelcome")
    m.labelWelcome.font.size = 115
    m.errorLabel = m.top.findNode("errorLabel")
    m.textLabel = m.top.findNode("hintlabel")
    m.keyboard = m.top.findNode("keyboard")
    m.busyspinner = m.top.findNode("exampleBusySpinner")
   ' m.busyspinner.poster.observeField("loadStatus", "showspinner")
    m.busyspinner.poster.uri = "pkg:/images/busyspinner_hd.png"
    m.pinLabel = m.top.findNode("pinLabel")
    m.forgotPasswordLabel = m.top.findNode("forgotPasswordLabel")
    
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
    m.editTextButton.observeField("buttonSelected","showKeyboard")
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
    
end sub

sub goToHomeScreen()
end sub

sub showPinDialog()
    m.currentFocusID = "editTextButton"
    handleVisibility()
'print "Pin dialog pressed"
'      pindialog = createObject("roSGNode", "PinDialog")
'      print pindialog
'      pindialog.backgroundUri = ""
'      pindialog.title = "Enter Pin"
'      pindialog.setFocus(true)
'      m.top.dialog = pindialog
'      print m.top.dialog
end sub

sub goToForgotPasswordScreen()
end sub

sub showKeyboard()
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    if press
        if key="up" OR key="down" OR key="left" OR key="right" Then
            handleFocus(key)
            handleVisibility()
'        else if key = "play"
'            m.userpin = m.top.dialog.pin
'            m.top.dialog.close = true
        end if
    end if
    return result 
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
