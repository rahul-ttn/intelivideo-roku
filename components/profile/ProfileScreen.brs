sub init()
    m.top.SetFocus(true)
End sub

sub onAppData()
    m.appConfig =  m.top.appConfig
    m.userData =  m.top.userData

    m.tnc = m.appConfig.terms_of_service
    m.privayPolicy = m.appConfig.privacy_policy
    
    initNavigationBar()
    m.buttonHomeOpen.setFocus(false)
    m.buttonProfileOpen.setFocus(true)
    
    'm.navButtonGroupClose.buttonSelected = 3
   initFields()
End sub

sub initFields()
    m.profileBackground = m.top.FindNode("profileBackground")
    m.profileBackground.color = homeBackground()
    m.profileLabelList = m.top.FindNode("profileLabelList")
    m.profileLeftRect = m.top.FindNode("profileLeftRect")
    m.profileRightRect = m.top.FindNode("profileRightRect")
    m.profileRightTitle = m.top.FindNode("profileRightTitle")
    m.profileRightValue = m.top.FindNode("profileRightValue")
    showProfileList()
End sub

sub showProfileList()
    m.profileLabelList.ObserveField("itemFocused", "onListItemFocused")
    m.profileLabelList.ObserveField("itemSelected", "onListItemSelected")
    addItemsInList(m.profileLabelList)
End sub

sub onListItemFocused()
    if(m.profileLabelList.itemFocused = 0)
        m.profileRightTitle.text = "MY CONTENT"
        m.profileRightValue.text = ""
    else if(m.profileLabelList.itemFocused = 1)
        m.profileRightTitle.text = "TERMS OF USE"
        m.profileRightValue.text = m.tnc
    else if(m.profileLabelList.itemFocused = 2)
        m.profileRightTitle.text = "PRIVACY POLICY"
        m.profileRightValue.text = m.privayPolicy
    else if(m.profileLabelList.itemFocused = 3)
        m.profileRightTitle.text = "CONTACT US"
        m.profileRightValue.text = "To contact support please email: support@intelivideo.com"
    else if(m.profileLabelList.itemFocused = 4)
        m.profileRightTitle.text = ""
        m.profileRightValue.text = ""
    end if
End sub

sub onListItemSelected()
    if(m.profileLabelList.itemFocused = 0)
    
    else if(m.profileLabelList.itemFocused = 1)
        m.profileRightTitle.text = "TERMS OF USE"
    else if(m.profileLabelList.itemFocused = 2)
        m.profileRightTitle.text = "PRIVACY POLICY"
    else if(m.profileLabelList.itemFocused = 3)
        m.profileRightTitle.text = "CONTACT US"
    else if(m.profileLabelList.itemFocused = 4)
         accountList = getValueInRegistryForKey("accountsValue")
         accountsArray =  accountList.Split("||")
         if accountsArray.count() = 1
            setValueInRegistryForKey("isLogin", "false")
            deleteValue("accountsDelete")
            callLoginScreen()
         else
            for index= 0 to accountsArray.count()-1
                   accountsModel = accountsArray[index]
                   accountsModel = ParseJSON(accountsModel)
                   if accountsModel.access_token = getValueInRegistryForKey("authTokenValue") 
                        accountsArray.Delete(index)
                   end if
             end for
                accountsModel = accountsArray[0]
                accountsModel = ParseJSON(accountsModel)
                setValueInRegistryForKey("selectedAccountName", accountsModel.name)
                if(accountsModel.thumbnail <> invalid)
                    setValueInRegistryForKey("selectedAccountThumb", accountsModel.thumbnail)
                end if
                setValueInRegistryForKey("authToken", accountsModel.access_token)
                setValueInRegistryForKey("refreshToken", accountsModel.refresh_token)
                homeScreen = m.top.createChild("HomeScreen")
                m.top.setFocus(false)
                homeScreen.setFocus(true) 
                accountString = accountsArray.Join("||")
                setValueInRegistryForKey("accounts", accountString)   
         end if     
    end if
End sub

sub callLoginScreen()
    m.loginScreen = m.top.createChild("LoginScreen")
    m.top.setFocus(false)
    m.loginScreen.setFocus(true)
    m.loginScreen.buttonFocus = true
end sub

sub addItemsInList(labelList)
    m.content = createObject("roSGNode","ContentNode")
'   
    sectionContent=addListSectionHelper(m.content,"")     
    addListItemHelper(sectionContent,"My Content")
    
    sectionContent=addListSectionHelper(m.content,"")
    addListItemHelper(sectionContent,"Terms of Use")
    addListItemHelper(sectionContent,"Privacy Policy")
    addListItemHelper(sectionContent,"Contact Us") 
    
    sectionContent=addListSectionHelper(m.content,"")     
    addListItemHelper(sectionContent,"Disconnect Account")   
  
    labelList.content = m.content
end sub



Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "on key event Profile Screen  key >";key
        if key = "right"
            m.profileLabelList.setFocus(true)  
            showCloseState()
            m.buttonProfileClose.uri = "pkg:/images/$$RES$$/Profile Focused.png" 
            m.profileLeftRect.translation = [180, 0]
            m.profileRightRect.translation = [880, 0]
            result = true
        else if key = "left"
            if  m.profileLabelList.hasFocus()
                m.profileLabelList.setFocus(false)
                initNavigationBar()
                m.profileLeftRect.translation = [400, 0]
                m.profileRightRect.translation = [1100, 0]
                showOpenState()
                m.rectSwitchAccountBorder.visible = false
            end if
            result = true 
        else if key = "down"
            if m.buttonProfileOpen.hasFocus()
                m.rectSwitchAccountBorder.visible = true
                m.buttonSwitchAccount.setFocus(true)
                
            end if
            result = true 
        else if key = "up"
            if m.buttonSwitchAccount.hasFocus()
                m.rectSwitchAccountBorder.visible = false
                m.buttonSwitchAccount.setFocus(false)
                m.buttonProfileOpen.setFocus(true)
                 
            end if
            result = true
        else if key = "back"
            if m.switchAccount <> invalid 
                m.switchAccount = invalid
                result = true
            else
                m.top.visible = false
                result = false
            end if
'        else 
'            print "key = else"
'            result = true
        end if           
    end if
    return result 
End Function