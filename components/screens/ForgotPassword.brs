sub init()
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
   
   
    m.editTextRectangle = m.top.findNode("editTextRectangle")
    editTextRectangleX = (1920 - m.editTextRectangle.width) / 2
    editTextRectangleY = ((1080 - m.editTextRectangle.height) / 2 ) - 30
    m.editTextRectangle.translation = [editTextRectangleX, editTextRectangleY]
    
    m.nextButtonrectangle = m.top.findNode("resetPasswordButtonrectangle")
    nextButtonrectangleX = (1920 - m.nextButtonrectangle.width) / 2
    nextButtonrectangleY = editTextRectangleY + 100
    m.nextButtonrectangle.translation = [nextButtonrectangleX,nextButtonrectangleY]
    
    m.passwordEditTextButton = m.top.findNode("passwordEditTextButton")
    m.passwordEditTextButton.observeField("buttonSelected","showKeyboardPinPad")
    m.passwordEditTextButton.setFocus(true)
    
        
    m.buttonLogin = m.top.findNode("buttonResetPassword")
    m.buttonLogin.observeField("buttonSelected","showAlertDialog")
    m.buttonLogin.setFocus(false)
    
     'initializing the currentFocus id 
    m.currentFocusID ="passwordEditTextButton"
    
    'up-down-left-right  
    m.focusIDArray = {"passwordEditTextButton":"N-buttonResetPassword-N-N"                      
                       "buttonResetPassword":"passwordEditTextButton-N-N-N"
                     }
                    
    
end sub

sub showEmailId()
    m.email = m.top.emailId
    m.textLabel.text = m.email
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
     if press
     
    print "onKeyEvent Forgot Screen : "; key
        if key="up" OR key="down" OR key="left" OR key="right" Then
                handleFocus(key)
                handleVisibility()
                return true
        else if key = "*"
             m.top.dialog.close = true
             m.passwordEditTextButton.setFocus(true)
        end if
     end if     
    return result 
End function


function handleVisibility() as void
    if m.currentFocusID = "passwordEditTextButton"
        m.textLabel.color = "0x1c2833ff"                'black text color
        m.nextButtonrectangle.color = "0xB4B4B1ff"      'greycolor
    else if m.currentFocusID = "buttonResetPassword"
        m.textLabel.color = "0xB4B4B1ff"                'grey text color
        m.nextButtonrectangle.color = "0x00CBB9FF"      'bluecolor
    end if
end function

sub showAlertDialog()
    dialog = createObject("roSGNode", "Dialog")
     dialog.backgroundUri = ""
     dialog.title = "Password Reset"
     dialog.optionsDialog = true
     dialog.message = "An email has been sent to reset your password.Press * To Dismiss"
     'm.dialogButton.visible = true
     m.top.getScene().dialog = dialog
end sub