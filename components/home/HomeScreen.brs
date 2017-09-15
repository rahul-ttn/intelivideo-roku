sub init()
    m.top.SetFocus(true)
    m.isProgressDialog = false
    initFields()
    hideFields()
    callUserApi()
    setValueInRegistryForKey("isHome","true")
End sub

sub callUserApi()
    if checkInternetConnection()
        showProgressDialog()
        print "caling user API"
        baseUrl = getApiBaseUrl() + "user?access_token=" + getValueInRegistryForKey("authTokenValue")
        print "baseUrl " ; baseUrl
        m.userApi = createObject("roSGNode","UserApiHandler")
        m.userApi.setField("uri",baseUrl)
        m.userApi.observeField("content","onUserApiResponse")
        m.userApi.control = "RUN"
    else
        showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub onUserApiResponse()
    userApiModel = m.userApi.content
    if(userApiModel.success)
        hideProgressDialog()
        showFields()
    
        m.appConfig =  m.userApi.content.appConfigModel
        m.userData =  m.userApi.content.userModel
    
        initNavigationBar()
        homeRowList() 
    else
        hideProgressDialog()
        showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub showLoader()
        m.loaderScreen = m.top.createChild("ACLoaderScreen")
        m.loaderScreen.visible = true
        m.top.setFocus(false)
        m.loaderScreen.setFocus(true)
end sub

sub hideLoader()
        m.loaderScreen.visible = false
        m.top.setFocus(true)
        m.loaderScreen.setFocus(false)
        if(m.buttonHomeOpen <> invalid AND m.buttonHomeOpen <> "")
            m.buttonHomeOpen.SetFocus(true)
        end if
end sub

sub initFields() 
    homeBackground = m.top.FindNode("homeBackground")
    homeBackground.color = homeBackground() 
    m.countryRowList = m.top.FindNode("homeRowList")  
    m.navBar = m.top.FindNode("NavigationBar") 
End sub

sub hideFields()
    m.countryRowList.visible = false
    m.navBar.visible = false
End sub

sub showFields()
    m.countryRowList.visible = true
    m.navBar.visible = true
End sub

sub manageNavBar()
    if getValueInRegistryForKey("isCategoryValue") <> "true"
        m.buttonCategoryOpen.visible = false
    end if
End sub

sub homeRowList()
    m.countriesArray = ["India", "Pakistan", "Sri Lanks","South Africa","Australia","West Indies","New Zealand","England","Zimbawe","Kenya","Nepal","America"]
     
    m.countryRowList.SetFocus(false)
    m.countryRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.countryRowList.content = getGridRowListContent()
    
End sub

function getGridRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         for numRows = 0 to 2
            row = parentContentNode.CreateChild("ContentNode")
            titleText = "This is Row " + numRows.toStr()
            row.title = titleText
            
                   for index= 0 to m.countriesArray.Count()-1
                          rowItem = row.CreateChild("HomeRowListItemData")
                          rowItem.countryName = m.countriesArray[index]       
                   end for
                   
         end for
         return parentContentNode 
end function

function onRowItemSelected() as void
        print "***** Some's wish is ********";m.countryRowList.rowItemFocused
        row = m.countryRowList.rowItemFocused[0]
        col = m.countryRowList.rowItemFocused[1]
        print "**********Row is *********";row
        print "**********col is *********";col
end function

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "onkeyevent Home Screen  key >";key
        if key = "right" 
            print "key = right"
            m.countryRowList.setFocus(true)
            m.countryRowList.translation = [350, 60]
            showCloseState()
            result = true
        else if key = "left" 
            print "key = left"
            row = m.countryRowList.rowItemFocused[0]
            col = m.countryRowList.rowItemFocused[1]
            if col = 0 AND m.countryRowList.hasFocus()
                m.countryRowList.setFocus(false)
                m.countryRowList.translation = [500, 60]
                initNavigationBar()
                showOpenState()
                m.rectSwitchAccountBorder.visible = false  
            end if
            result = true
         else if key = "down" 
            print "key = down"
            if m.buttonProfileOpen.hasFocus()
                m.rectSwitchAccountBorder.visible = true
                m.buttonSwitchAccount.setFocus(true)
                
            end if
            result = true 
         else if key = "up" 
            print "key = up"
            if m.buttonSwitchAccount.hasFocus()
                m.rectSwitchAccountBorder.visible = false
                m.buttonSwitchAccount.setFocus(false)
                m.buttonProfileOpen.setFocus(true)
                
            end if
            result = true 
         else if key = "back"
             m.top.visible = false
            'ExitUserInterface()
            result = false
'         else 
'            print "key = else"
'            result = true
        end if           
    end if
    return result 
End Function 

Sub ExitUserInterface()
    print "closing app"
    'End
End Sub