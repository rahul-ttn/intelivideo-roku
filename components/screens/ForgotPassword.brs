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
    m.passwordEditTextButton.observeField("buttonSelected","showKeyboard")
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
     m.showDialog = false            
    
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
            if m.keyboard.visible = false
                handleFocus(key)
                handleVisibility()
                return true
            end if                
        else if key = "back"
            if m.keyboard.visible
                m.keyboard.visible = false
                m.emailEntered = m.keyboard.text
                m.textLabel.text = m.emailEntered
                m.currentFocusID ="passwordEditTextButton"
                handleVisibility()
                m.passwordEditTextButton.setFocus(true)
                return true
            else if  m.showDialog
                'm.top.dialog.close = true
                return false
            end if
            return false
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

sub showKeyboard()
     m.keyboard.visible = true
     m.keyboard.setFocus(true)
     m.keyboard.text = m.email
end sub

sub showAlertDialog()
    if m.textLabel.text = "" or not emailValidation(m.textLabel.text)
        print "EMAIL validation Forgot PAssword screen";emailValidation(m.textLabel.text)
        showHideError(true)
    else
         dialog = createObject("roSGNode", "Dialog")
         dialog.backgroundUri = ""
         dialog.title = "Password Reset"
         dialog.optionsDialog = false
         dialog.message = "An email has been sent to reset your password."
         'm.dialogButton.visible = true
         m.top.getScene().dialog = dialog
         m.showDialog = true
    end if
end sub


function showHideError(showError as boolean) as void
    if showError = true
        m.errorLabel.visible = true
        m.oopsLabel.visible = true
        m.labelWelcome.visible = false
    else
        m.errorLabel.visible = false
        m.oopsLabel.visible = false
        m.labelWelcome.visible = true
    end if
end function



