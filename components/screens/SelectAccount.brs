sub init()
    m.top.setFocus(true)
    m.countriesArray = ["India", "Pakistan", "Sri Lanks","South Africa","Australia","West Indies","New Zealand","England","Zimbawe","Kenya","Nepal","America"]
    
    m.selectAccLabel = m.top.findNode("selectAccLabel")
    m.accountList = m.top.findNode("selectAccountList")
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
            for index= 0 to m.countriesArray.Count()-1
                   rowItem = row.CreateChild("SelectAccountListItemsData")
                   print rowItem
                   rowItem.countryName = m.countriesArray[index]
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
        goToPasswordScreen()
end function

function goToPasswordScreen() as void
    hideViews()
    m.passwordScreen = m.top.createChild("PasswordScreen")
    print m.top.passwordScreen
    m.top.setFocus(false)
    m.passwordScreen.setFocus(true)
end function

function hideViews() as void
    m.accountList.visible = false
    m.selectAccLabel.visible = false
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
             if key = "back"
                
             end if           
    end if
    return result 
end function

