sub init()
    m.top.setFocus(true)
    setVideo()
    m.selectAccLabel = m.top.findNode("switchAccountLabel")
    m.selectAccLabel.font.size = 90
    
    m.accountsArray = getValueInRegistryForKey("accountsValue").Split("||")
    print "m.accountsArray >>> ";m.accountsArray
    
    m.accountList = m.top.findNode("switchAccountList")
    m.accountList.setFocus(true)
    m.accountList.ObserveField("rowItemFocused", "onRowItemFocused")
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

function onRowItemFocused() as void
        print "***** Some's wish is ********";m.accountList.rowItemFocused
        row = m.accountList.rowItemFocused[0]
        col = m.accountList.rowItemFocused[1]
'        print "**********Row is *********";row
'        print "**********col is *********";col
end function

    
function rowItemSelected() as void
        row = m.accountList.rowItemFocused[0]
        col = m.accountList.rowItemFocused[1]
'        print "**********Row is *********";row
'        print "**********col is *********";col
        goToPasswordScreen(m.accountsArray[col])
end function

function setVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = "pkg:/videos/login_video.mp4"
  videoContent.title = ""
  videoContent.streamformat = "mp4"
  
 
  m.video = m.top.findNode("musicvideos")
  m.video.content = videoContent
  m.video.control = "play"
  m.video.loop = true
  m.video.retrievingBar.visible = false
   m.video.retrievingTextColor = "0xffffff00"
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
         if key = "back"
           return false
         end if           
    end if
    return result 
end function