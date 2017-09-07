sub init()
    m.top.setFocus(true)
    m.parentRectangle = m.top.findNode("parentRectangle")
    m.oopsLabel = m.top.findNode("oopsLabel")
    m.oopsLabel.font.size = 115
    m.labelWelcome = m.top.findNode("labelWelcome")
    m.labelWelcome.font.size = 115
    m.errorLabel = m.top.findNode("errorLabel")
    
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
    
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    return result 
end function
