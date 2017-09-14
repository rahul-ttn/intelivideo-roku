sub init()
    m.top.setFocus(true)
    
    m.selectAccLabel = m.top.findNode("selectAccLabel")
    m.selectAccLabel.font.size = 90
    m.accountList = m.top.findNode("selectAccountList")
    m.accountList.setFocus(true)
    
    m.accountList.ObserveField("rowItemFocused", "onRowItemFocused")
    m.accountList.ObserveField("rowItemSelected", "rowItemSelected")
    
        
end sub

'getting array from Login Screen
sub showAccountsArray()
    m.emailId = m.top.emailID
    m.accountsArray = m.top.content
    m.accountList.content = getHorizontalRowListContent()   
end sub

function getHorizontalRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         print parentContentNode
         for numRows = 0 to 0
            row = parentContentNode.CreateChild("ContentNode")
            print row
            row.title = ""
            for index= 0 to m.accountsArray.count()-1
                   rowItem = row.CreateChild("SelectAccountListItemsData")
                   accountsModel = m.accountsArray[index]
                   rowItem.countryName = accountsModel.name
                   rowItem.imageUri = accountsModel.thumbnail
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

function goToPasswordScreen(account as object) as void
    hideViews()
    m.passwordScreen = m.top.createChild("PasswordScreen")
    print m.top.passwordScreen
    m.top.setFocus(false)
    m.passwordScreen.setFocus(true)
    m.passwordScreen.emailId = m.emailId
    m.passwordScreen.account = account
end function

function hideViews() as void
    m.accountList.visible = false
    m.selectAccLabel.visible = false
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
             if key = "back"
                if m.passwordScreen <> invalid AND m.passwordScreen.visible
                    print "Slect Account true part of back key"
                    m.passwordScreen.setFocus(false)
                    m.passwordScreen.visible = false
                    m.accountList.visible = true
                    m.selectAccLabel.visible = true
                    m.accountList.setFocus(true)
                    return true
                else if getValueInRegistryForKey("isHomeValue") = "true"
                    m.top.visible = false
                    return false
                else 
                    print "Slect Account else part of back key"
                    return false
                end if
                'return false
             end if           
    end if
    return result 
end function

