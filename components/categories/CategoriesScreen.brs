sub init()
    m.top.setFocus(true)
    m.screenName = categoryScreen()
    m.appConfig =  m.top.getScene().appConfigContent 
    
    initNavigationBar()
    m.buttonHomeOpen.setFocus(false)
    m.buttonCategoryOpen.setFocus(true)
    initFields()
end sub

sub initFields()
    m.categoryBackground = m.top.FindNode("categoryBackground")
    m.categoryBackground.color = homeBackground()
    m.parentCategoryRect = m.top.findNode("parentCategoryRect")
End sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "on key event Profile Screen  key >";key
        if key = "right"
'            if m.profileLabelList.hasFocus() AND m.myContentRowList.visible
'                m.profileLabelList.setFocus(false)
'                m.myContentRowList.setFocus(true)
'            else
'                m.profileLabelList.setFocus(true)  
'                showCloseState()
'                m.buttonProfileClose.uri = "pkg:/images/$$RES$$/Profile Focused.png" 
'                m.profileLeftRect.translation = [180, 0]
'                m.profileRightRect.translation = [880, 0]
'            end if
            result = true
        else if key = "left"
'            if  m.profileLabelList.hasFocus()
'                m.profileLabelList.setFocus(false)
'                initNavigationBar()
'                m.profileLeftRect.translation = [400, 0]
'                m.profileRightRect.translation = [1100, 0]
'                showOpenState()
'                m.rectSwitchAccountBorder.visible = false
'            else if m.myContentRowList.hasFocus()
'                m.profileLabelList.setFocus(true)
'                m.myContentRowList.setFocus(false)
'            end if
            result = true 
        else if key = "down"
            if m.buttonProfileOpen.hasFocus()
                m.rectSwitchAccountBorder.visible = true
                m.buttonSwitchAccount.setFocus(true)
                
            end if
            result = true 
        else if key = "up"
'            if m.buttonSwitchAccount.hasFocus()
'                m.rectSwitchAccountBorder.visible = false
'                m.buttonSwitchAccount.setFocus(false)
'                m.buttonProfileOpen.setFocus(true)
'                 
'            end if
            result = true
        else if key = "back"
'            if m.switchAccount <> invalid 
'               if m.switchAccount.accountSelected
'                    m.top.visible = false
'                    result = false
'                else
'                    m.switchAccount.setFocus(false)
'                    m.buttonSwitchAccount.setFocus(true)
'                    m.switchAccount = invalid
'                    result = true
'                end if
'            else if m.viewAllScreen <> invalid
'                m.viewAllScreen.setFocus(false)
'                m.viewAllScreen = invalid
'                m.myContentRowList.setFocus(true)
'                m.myContentRowList.jumpToRowItem = m.focusedItem
'                result = true
'            else if m.productDetail <> invalid
'                m.productDetail.setFocus(false)
'                m.productDetail = invalid
'                m.myContentRowList.setFocus(true)
'                m.myContentRowList.jumpToRowItem = m.focusedItem
'                result = true
'            else
'                m.top.visible = false
'                result = false
'            end if
'        else 
'            print "key = else"
'            result = true
        end if           
    end if
    return result 
End Function