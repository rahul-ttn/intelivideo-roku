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
    
    m.editTextButton = m.top.findNode("editTextButton")
    m.editTextButton.observeField("buttonSelected","showKeyboardPinPad")
    m.editTextButton.setFocus(true)
    
        
    m.buttonLogin = m.top.findNode("buttonResetPassword")
    m.buttonLogin.observeField("buttonSelected","showAlertDialog")
    m.buttonLogin.setFocus(false)
    
end sub

sub showAlertDialog()
end sub