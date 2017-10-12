sub init()
    m.top.SetFocus(true)
    m.screenName = profileScreen()
    m.appConfig =  m.top.getScene().appConfigContent 

    m.tnc = m.appConfig.terms_of_service
    m.privayPolicy = m.appConfig.privacy_policy
    
    initNavigationBar()
    m.buttonHomeOpen.setFocus(false)
    m.buttonProfileOpen.setFocus(true)
    
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
    m.myContentRowList = m.top.FindNode("myContentRowList")
    showProfileList()
End sub

sub showProfileList()
    m.profileLabelList.ObserveField("itemFocused", "onListItemFocused")
    m.profileLabelList.ObserveField("itemSelected", "onListItemSelected")
    addItemsInList(m.profileLabelList)
End sub

sub homeRowList()
    m.myContentRowList.visible = true
    m.myContentRowList.SetFocus(false)
    m.myContentRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.myContentRowList.content = getGridRowListContent()
End sub

function getGridRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         
         m.myContentRowList.itemSize = [200 * 9 + 100, 550]'550  600
         m.myContentRowList.rowHeights = [550]
         m.myContentRowList.rowItemSize = [ [550, 500] ]
         m.myContentRowList.itemSpacing = [ 0, 80 ]
         m.myContentRowList.rowItemSpacing = [ [80, 0] ]
         
         myContentArray = m.top.getScene().myContent
         for numRows = 0 to myContentArray.Count()-1
            row = parentContentNode.CreateChild("ContentNode")
             for index = 0 to 0
                  rowItem = row.CreateChild("HomeRowListItemData")
                  dataObjet = myContentArray[numRows]
                  rowItem.id = dataObjet.product_id
                      rowItem.title = dataObjet.title
                      rowItem.imageUri = dataObjet.small
                      rowItem.count = dataObjet.media_count
                      rowItem.coverBgColor = m.appConfig.primary_color
                      rowItem.isMedia = false
                      if getPostedVideoDayDifference(dataObjet.created_at) < 11
                          rowItem.isNew = true
                      else
                          rowItem.isNew = false
                      end if
             end for     
          end for 
'          if myContentArray.Count() >= 10
'              row = parentContentNode.CreateChild("ContentNode")
'              rowItem = row.CreateChild("HomeRowListItemData")
'              rowItem.isViewAll = true
'          end if 
         return parentContentNode 
end function

function rowItemSelected() as void
        row = m.accountList.rowItemFocused[0]
        col = m.accountList.rowItemFocused[1]
'        print "**********Row is *********";row
'        print "**********col is *********";col
       
end function

sub goTViewAllScreen(titleText as String)
    m.viewAllScreen = m.top.createChild("ViewAllScreen")
    m.top.setFocus(false)
    m.viewAllScreen.setFocus(true)
    m.viewAllScreen.titleText = "My Content"
    m.viewAllScreen.primaryColor = m.appConfig.primary_color
    m.viewAllScreen.contentArray = m.top.getScene().myContent
end sub


sub onListItemFocused()
    n = 0
    if m.top.getScene().myContent.count() = 0
        n = 1
    end if
    
    if m.profileLabelList.itemFocused = 0-n
        m.profileRightTitle.text = ""
        m.profileRightValue.text = ""
        homeRowList()
    else if m.profileLabelList.itemFocused = 1-n
        m.myContentRowList.visible = false
        m.profileRightTitle.text = "TERMS OF USE"
        m.profileRightValue.text = m.tnc
    else if m.profileLabelList.itemFocused = 2-n
        m.myContentRowList.visible = false
        m.profileRightTitle.text = "PRIVACY POLICY"
        m.profileRightValue.text = m.privayPolicy
    else if m.profileLabelList.itemFocused = 3-n
        m.myContentRowList.visible = false
        m.profileRightTitle.text = "CONTACT US"
        m.profileRightValue.text = "To contact support please email: support@intelivideo.com"
    else if m.profileLabelList.itemFocused = 4-n
        m.myContentRowList.visible = false
        m.profileRightTitle.text = ""
        m.profileRightValue.text = ""
    end if
End sub

sub onListItemSelected()
    n = 0
    if m.top.getScene().myContent.count() = 0
        n = 1
    end if
    
    if m.profileLabelList.itemFocused = 0-n
        
    else if m.profileLabelList.itemFocused = 1-n
        m.profileRightTitle.text = "TERMS OF USE"
    else if m.profileLabelList.itemFocused = 2-n
        m.profileRightTitle.text = "PRIVACY POLICY"
    else if m.profileLabelList.itemFocused = 3-n
        m.profileRightTitle.text = "CONTACT US"
    else if m.profileLabelList.itemFocused = 4-n
         accountList = getValueInRegistryForKey("accountsValue")
         accountsArray =  accountList.Split("||")
         if accountsArray.count() = 1
            setValueInRegistryForKey("isLogin", "false")
            deleteValue("accountsDelete")
            callLoginScreen()
         else
            for index= 0 to accountsArray.count()-1
                   accountsModel = accountsArray[index]
                   if accountsModel <> invalid
                       accountsModel = ParseJSON(accountsModel)
                       if accountsModel.access_token = getValueInRegistryForKey("authTokenValue") 
                            accountsArray.Delete(index)
                       end if
                   else
                       accountsArray.Delete(index) 
                   end if
             end for
                accountsModel = accountsArray[0]
                accountsModel = ParseJSON(accountsModel)
                setValueInRegistryForKey("selectedAccountName", accountsModel.name)
                if accountsModel.thumbnail <> invalid
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
'    for i = 0 To m.top.getScene().getChildCount() Step +1
'        child = m.top.getScene().getChild(i)
'        m.top.getScene().removeChild(child)
'    end for
    m.loginScreen = m.top.createChild("LoginScreen")
    m.top.setFocus(false)
    m.loginScreen.setFocus(true)
    m.loginScreen.buttonFocus = true
end sub

sub addItemsInList(labelList)
    m.content = createObject("roSGNode","ContentNode")
    print "m.top.getScene().myContent >>> ";m.top.getScene().myContent
    if m.top.getScene().myContent <> invalid AND m.top.getScene().myContent.count() > 0
        print "My Content Label List >>> ";m.top.getScene().myContent.count()
        sectionContent=addListSectionHelper(m.content,"")
        addListItemHelper(sectionContent,"My Content")
    end if     
    
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
            if m.profileLabelList.hasFocus() AND m.myContentRowList.visible
                m.profileLabelList.setFocus(false)
                m.myContentRowList.setFocus(true)
            else
                m.profileLabelList.setFocus(true)  
                showCloseState()
                m.buttonProfileClose.uri = "pkg:/images/$$RES$$/Profile Focused.png" 
                m.profileLeftRect.translation = [180, 0]
                m.profileRightRect.translation = [880, 0]
            end if
            result = true
        else if key = "left"
            if  m.profileLabelList.hasFocus()
                m.profileLabelList.setFocus(false)
                initNavigationBar()
                m.profileLeftRect.translation = [400, 0]
                m.profileRightRect.translation = [1100, 0]
                showOpenState()
                m.rectSwitchAccountBorder.visible = false
            else if m.myContentRowList.hasFocus()
                m.profileLabelList.setFocus(true)
                m.myContentRowList.setFocus(false)
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
               if m.switchAccount.accountSelected
                    m.top.visible = false
                    result = false
                else
                    m.switchAccount.setFocus(false)
                    m.buttonSwitchAccount.setFocus(true)
                    m.switchAccount = invalid
                    result = true
                end if
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