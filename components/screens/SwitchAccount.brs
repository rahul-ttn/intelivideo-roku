sub init()
    m.top.setFocus(true)
    setVideo()
    m.selectAccLabel = m.top.findNode("switchAccountLabel")
    m.selectAccLabel.font.size = 90
    
    m.accountsArray = getValueInRegistryForKey("accountsValue").Split("||")
    print "m.accountsArray >>> ";m.accountsArray
    
    m.accountList = m.top.findNode("switchAccountList")
    m.accountList.setFocus(true)
    m.accountList.ObserveField("rowItemSelected", "rowItemSelected")
    m.accountList.content = getHorizontalRowListContent() 
       
end sub

function getHorizontalRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         print parentContentNode
         for numRows = 0 to 0
            row = parentContentNode.CreateChild("ContentNode")
            print row
            row.title = ""
            rowItem = row.CreateChild("SwitchAccountListItemsData")    
            rowItem.countryName = "Add Account"
            rowItem.showAddAccount = true
            
            for index= 0 to m.accountsArray.count()-1
                   rowItem = row.CreateChild("SwitchAccountListItemsData")
                   accountsModel = m.accountsArray[index]
                   accountsModel = ParseJSON(accountsModel)
                   rowItem.countryName = accountsModel.name
                   rowItem.imageUri = accountsModel.thumbnail
                   rowItem.showAddAccount = false
                   if accountsModel.thumbnail = "" 
                        rowItem.showThumbnail = false
                   else
                        rowItem.showThumbnail = true
                   end if
             end for         
         end for
         return parentContentNode 
end function

    
function rowItemSelected() as void
        row = m.accountList.rowItemFocused[0]
        col = m.accountList.rowItemFocused[1]
'        print "**********Row is *********";row
'        print "**********col is *********";col
        if row = 0 AND col = 0
            if m.accountsArray.count() = 10
                showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
            else
                goToLoginScreen()
                m.top.accountSelected = false
            end if
        else
            'onKeyEvent("back",true)
            'goToPasswordScreen(m.accountsArray[col])
            'm.parentNode.visible = false
            m.top.accountSelected = true
            goToHomeScreen(col-1)
        end if
        
end function

sub goToHomeScreen(index as Integer)
    accountsModel = m.accountsArray[index]
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
    
end sub

sub goToLoginScreen()
    m.video.control = "stop"
    m.loginScreen = m.top.createChild("LoginScreen")
    m.top.setFocus(false)
    m.loginScreen.setFocus(true)
    m.loginScreen.buttonFocus = true
end sub

function setVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = "pkg:/videos/login_video.mp4"
  videoContent.title = "Loading..."
  videoContent.streamformat = "mp4"
  
 
  m.video = m.top.findNode("musicvideos")
  m.video.content = videoContent
  m.video.control = "play"
  m.video.loop = true
  m.video.bufferingBar.visible = false
  m.video.bufferingTextColor = "0xffffff00"
  m.video.retrievingBar.visible = false
  m.video.retrievingTextColor = "0xffffff00"
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
    print "onkeyevent Switch Account Screen  key >";key
         if key = "back"
            m.video.control = "stop"
            m.top.visible = false
           return false
         else if key = "left" or key = "right"
            return true
         end if           
    end if
    return result 
end function