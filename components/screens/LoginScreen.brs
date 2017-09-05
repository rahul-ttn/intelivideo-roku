sub init()
    m.top.SetFocus(true)
    
    m.label = m.top.findNode("labelWelcome")
'    font  = CreateObject("roSGNode", "Font")
'    'font.uri = "pkg:/fonts/font.ttf"
'    font.size = 24
'    m.label.font = font
    
'    m.textEditTextEmail = m.top.findNode("textEditBoxEmail")
'    'm.textEditTextEmail.setFocus(true)
'    m.textEditTextEmail.active = true
'    m.textEditTextEmail.visible = false

    m.editTextButton = m.top.findNode("editTextButton")
    m.editTextButton.observeField("buttonSelected","showKeyboard")
    m.editTextButton.setFocus(true)
    
    
    m.textLabel = m.top.findNode("hintlabel")
    m.keyboard = m.top.findNode("keyboard")
    
        
    m.buttonNext = m.top.findNode("buttonNext")
    m.buttonNext.observeField("buttonSelected","goToSelectScreen")
    m.buttonNext.setFocus(false)
End sub

'method called to go to Select Account screen
sub goToSelectScreen()
    
    baseUrl = getApiBaseUrl()
    finalUrl = baseUrl + "accounts" + "?email=zoe@barbershop.io"
    m.signUpApi = createObject("roSGNode","FetchMerchantApiHandler")
    m.signUpApi.setField("uri",finalUrl)
    m.signUpApi.observeField("content","onFetchMerchant")
    m.signUpApi.control = "RUN"
    
end sub

function onFetchMerchant()

    print "onFetchMerchant success"
    
    m.selectScreen = m.top.createChild("SelectAccount")
    print m.selectScreen
    m.top.setFocus(false)
    m.selectScreen.setFocus(true)

end function

'method to let user enter and display registered email id
sub showKeyboard()
    m.keyboard.visible = true
    m.keyboard.setFocus(true)
    m.editTextButton.setFocus(false)
    m.buttonNext.visible = false
end sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    
    if(press)
        if key = "down"
            if m.editTextButton.hasFocus()
                m.editTextButton.setFocus(false)
                m.buttonNext.setFocus(true)
            end if
        else if key = "up"
            if m.buttonNext.hasFocus()
                m.buttonNext.setFocus(false)
                m.editTextButton.setFocus(true)
            end if
        else if key = "play"  'change event on back press
                emailId = m.keyboard.text
                m.textLabel.text = emailId
                m.textLabel.textColor = "0x1c2833ff"
                m.keyboard.visible = false
                m.buttonNext.visible = true
                m.buttonNext.setFocus(true)
        end if
    end if
    return result 
End Function 