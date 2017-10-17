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
    m.categoryLabelList = m.top.findNode("categoryLabelList")
    m.Error_text  = m.top.FindNode("Error_text")
    callBaseCategoryApi()
End sub

sub callBaseCategoryApi()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "categories?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.baseCategoryApi = createObject("roSGNode","CategoriesApiHandler")
        m.baseCategoryApi.setField("uri",baseUrl)
        m.baseCategoryApi.observeField("content","onCategoryBaseApiResponse")
        m.baseCategoryApi.control = "RUN"
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub onCategoryBaseApiResponse()
     baseCategoryApiModel = m.baseCategoryApi.content
     hideProgressDialog()
    if baseCategoryApiModel.success
        m.baseCategoryArray =  baseCategoryApiModel.baseCategoriesArray
        showBaseCategoryList() 
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub showBaseCategoryList()
    m.categoryLabelList.ObserveField("itemFocused", "onListItemFocused")
    m.categoryLabelList.ObserveField("itemSelected", "onListItemSelected")
    m.content = createObject("roSGNode","ContentNode")
    sectionContent=addListSectionHelper(m.content,"")
    for i = 0 To m.baseCategoryArray.count()-1
        addListItemHelper(sectionContent,m.baseCategoryArray[i].name)
    end for   
    m.categoryLabelList.content = m.content
    m.categoryLabelList.setFocus(true)
End sub

sub onListItemFocused()
'   m.mediaModel = m.productDetailModel.objects[m.productLabelList.itemFocused]
'   m.thumbnailPoster.uri = m.mediaModel.small
'   m.nameLabel.text = m.mediaModel.title
'   m.longDescriptionLabel.text = m.mediaModel.description
'   startMoreTimer()
End sub

sub onListItemSelected()
   
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


Function showRetryDialog(title ,message)
  m.Error_text.visible = true
  m.Error_text.text = message
  
  
  dialog = createObject("roSGNode", "Dialog") 
  dialog.backgroundUri = "" 
  dialog.title = title
  dialog.optionsDialog = true 
  dialog.iconUri = ""
  dialog.message = message
  dialog.width = 1200
  dialog.buttons = ["Retry"]
  dialog.optionsDialog = true
  dialog.observeField("buttonSelected", "startTimer") 'The field is set when the dialog close field is set,
  m.top.getScene().dialog = dialog
end Function

sub onRetry()
    callBaseCategoryApi()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub