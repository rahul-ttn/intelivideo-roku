sub init()
    m.top.SetFocus(true)
    print "Home init"
    initNavigationBar()
    print "Home Navigation"
    initFields()
End sub

sub initFields()
    homeBackground = m.top.FindNode("homeBackground")
    homeBackground.color = homeBackground()
    
    m.countryRowList = m.top.FindNode("homeRowList")
    
    homeRowList() 
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
        if key = "right"
            m.countryRowList.setFocus(true)
            m.countryRowList.translation = [350, 60]
            showCloseState()
            result = true
        else if key = "left"
            row = m.countryRowList.rowItemFocused[0]
            col = m.countryRowList.rowItemFocused[1]
            if col = 0
                m.countryRowList.setFocus(false)
                m.countryRowList.translation = [500, 60]
                initNavigationBar()
                showOpenState()
                result = true
            end if
         else if key = "down"
            if m.buttonProfileOpen.hasFocus()
                m.rectSwitchAccountBorder.visible = true
                m.buttonSwitchAccount.setFocus(true)
                result = true 
            end if
         else if key = "up"
            if m.buttonSwitchAccount.hasFocus()
                m.rectSwitchAccountBorder.visible = false
                m.buttonSwitchAccount.setFocus(false)
                m.buttonProfileOpen.setFocus(true)
                result = true 
            end if
        end if           
    end if
    return result 
End Function 