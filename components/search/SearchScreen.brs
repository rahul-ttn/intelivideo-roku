sub init()
    m.top.SetFocus(true)
    m.screenName = searchScreen()
    m.appConfig =  m.top.getScene().appConfigContent 
    m.counter = 0
    m.counterMaxValue = 2
    initNavigationBar()
    m.buttonHomeOpen.setFocus(false)
    m.buttonSearchOpen.setFocus(true)
    initFields()
    
End sub

sub initFields()
    m.searchBackground = m.top.FindNode("seacrhBackground")
    m.searchBackground.color = homeBackground()
    m.searchRightRect = m.top.FindNode("searchRightRect")
    m.Error_text  = m.top.FindNode("Error_text")
    m.Error_text.text = "Search your content via keyboard or title"
    m.searchRowList = m.top.FindNode("searchRowList")
    
    m.searchTextRectangle = m.top.findNode("searchTextRectangle")
    searchTextRectangleX = (1520 - m.searchTextRectangle.width) / 2
    m.searchTextRectangle.translation = [searchTextRectangleX, 70]
    
    m.searchTextButton = m.top.findNode("searchTextButton")
    m.searchTextButton.observeField("buttonSelected","showKeyboard")
    
    
    m.textLabel = m.top.findNode("hintlabel")
    m.keyboard = m.top.findNode("keyboard")
    m.keyboardTheme = m.top.findNode("keyboardTheme")
    keyboardX = (1920 - m.keyboardTheme.width) / 2
    m.keyboardTheme.translation = [keyboardX,450]
    
End sub

sub showKeyboard()
    m.keyboard.visible = true
    m.keyboardTheme.visible = true
    m.keyboard.setFocus(true)
    m.searchTextButton.setFocus(false)
    if m.textLabel.text = "Search" 
        m.keyboard.text = ""
    else
        m.keyboard.text = m.textLabel.text
    end if
end sub

function handleButtonSearchTextColorFocus(isSearchTextFocused as boolean) as void
    if isSearchTextFocused = false
        m.textLabel.color = "0xB4B4B1ff" 'grey color
        m.searchTextButton.setFocus(false)
        m.searchRowList.setFocus(true)
    else
        m.textLabel.color = "0x1c2833ff"  'black color
        m.searchRowList.setFocus(false)
        m.searchTextButton.setFocus(true)
    end if

end function

sub callSearchApi()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        callProductSearchApi()
        callMediaSearchApi()
    else
        m.textLabel.text = "Search"
        handleButtonSearchTextColorFocus(true)
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub updateCounter()
    m.counter = m.counter + 1
    print "m.counter >> ";m.counter
end sub

sub callProductSearchApi()
    baseUrl = getApiBaseUrl() + "search/products?search_query="+ m.searchQuery +"&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.productSearchApi = createObject("roSGNode","FeatureProductApiHandler")
    m.productSearchApi.setField("uri",baseUrl)
    m.productSearchApi.setField("dataType","search")
    m.productSearchApi.observeField("content","onSearchResponse")
    m.productSearchApi.control = "RUN"
end sub

sub callMediaSearchApi()
    baseUrl = getApiBaseUrl() + "search/media?search_query="+ m.searchQuery +"&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.MediaSearchApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.MediaSearchApi.setField("uri",baseUrl)
    m.MediaSearchApi.setField("dataType","search")
    m.MediaSearchApi.observeField("content","onSearchResponse")
    m.MediaSearchApi.control = "RUN"
end sub

sub onSearchResponse()
    updateCounter()
    getData()
end sub

sub getData()
    if m.counter = m.counterMaxValue
        m.counter = 0
        m.Error_text.visible = false
        hideProgressDialog()
        
        m.productSearchApiModel = m.productSearchApi.content
        m.MediaSearchApiModel = m.MediaSearchApi.content
        
        if m.productSearchApiModel.success AND m.MediaSearchApiModel.success
            if m.productSearchApiModel.searchProductsArray.count() = 0 AND m.MediaSearchApiModel.searchMediaArray.count() = 0
                m.Error_text.visible = true
                m.Error_text.text = "No Results Found."
            else
                searchRowList()
            end if 
        else
            m.counter = 0
            m.textLabel.text = "Search"
            handleButtonSearchTextColorFocus(true)
            showRetryDialog(networkErrorTitle(), networkErrorMessage())
        end if
    end if
end sub

sub searchRowList()
    m.searchRowList.visible = true
    m.searchRowList.SetFocus(false)
    m.searchRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.searchRowList.content = getGridRowListContent()
End sub

function onRowItemSelected() as void
        row = m.searchRowList.rowItemSelected[0]
        col = m.searchRowList.rowItemSelected[1]
        print "**********Row is *********";row
        print "**********col is *********";col
        m.focusedItem = [row,col]
        if col >= 10
            goTViewAllScreen(m.searchRowList.content.getChild(m.searchRowList.itemFocused).title)
        else
            listTitle = m.searchRowList.content.getChild(m.searchRowList.itemFocused).title
            if listTitle = searchMedia()
                goToMediaDetailScreen(col)
            else
                goToProductDetailScreen(col)
            end if
        end if  
end function

sub goToProductDetailScreen(column as Integer)
    m.productDetail = m.top.createChild("ProductDetailScreen")
    m.top.setFocus(false)
    m.productDetail.setFocus(true)
    m.productDetail.product_id = m.productSearchApiModel.searchProductsArray[column].product_id
end sub

sub goToMediaDetailScreen(column as Integer)
    m.mediaDetail = m.top.createChild("MediaDetailScreen")
    m.top.setFocus(false)
    m.mediaDetail.setFocus(true)
    m.mediaDetail.resource_id = m.MediaSearchApiModel.searchMediaArray[column].resource_id
end sub

sub goTViewAllScreen(titleText as String)
    print "m.searchQuery >>>><<<< ";m.searchQuery
    m.viewAllScreen = m.top.createChild("ViewAllScreen")
    m.top.setFocus(false)
    m.viewAllScreen.setFocus(true)
    m.viewAllScreen.titleText = titleText
    m.viewAllScreen.searchQuery = m.searchQuery
    m.viewAllScreen.primaryColor = m.appConfig.primary_color
end sub

function getGridRowListContent() as object
     parentContentNode = CreateObject("roSGNode", "ContentNode")
     if m.productSearchApiModel.searchProductsArray.count() <> 0
        row = parentContentNode.CreateChild("ContentNode")
        row.title = searchProducts()
        for index= 0 to m.productSearchApiModel.searchProductsArray.Count()-1
            rowItem = row.CreateChild("HomeRowListItemData")
            dataObjet = m.productSearchApiModel.searchProductsArray[index]
            rowItem.id = dataObjet.product_id
            rowItem.title = dataObjet.title
            rowItem.imageUri = dataObjet.small
            rowItem.count = dataObjet.media_count
            rowItem.coverBgColor = m.appConfig.primary_color
            rowItem.isMedia = dataObjet.is_media
            rowItem.isViewAll = false
            rowItem.isItem = dataObjet.is_item
            if(getPostedVideoDayDifference(dataObjet.created_at) < 11)
                rowItem.isNew = true
            else
                rowItem.isNew = false
            end if
        end for
        if m.productSearchApiModel.searchProductsArray.Count() >= 10
            rowItem = row.CreateChild("HomeRowListItemData")
            rowItem.isViewAll = true
        end if
    end if
     
     if m.MediaSearchApiModel.searchMediaArray.count() <> 0
        row = parentContentNode.CreateChild("ContentNode")
        row.title = searchMedia()
        for index= 0 to m.MediaSearchApiModel.searchMediaArray.Count()-1
            rowItem = row.CreateChild("HomeRowListItemData")
            dataObjet = m.MediaSearchApiModel.searchMediaArray[index]
            rowItem.id = dataObjet.resource_id
            rowItem.title = dataObjet.title
            rowItem.imageUri = dataObjet.small
            rowItem.coverBgColor = m.appConfig.primary_color
            rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
            rowItem.isItem = dataObjet.is_item
            rowItem.isViewAll = false
            rowItem.isMedia = dataObjet.is_media
            
            if getPostedVideoDayDifference(dataObjet.created_at) < 11
                rowItem.isNew = true
            else
                rowItem.isNew = false
            end if
        end for
        if m.MediaSearchApiModel.searchMediaArray.Count() >= 10
            rowItem = row.CreateChild("HomeRowListItemData")
            rowItem.isViewAll = true
        end if
     end if
     
     return parentContentNode 
end function


Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "on key event Search Screen  key >";key
        if key = "right"
            if m.navRectangleOpen.visible = true
                handleButtonSearchTextColorFocus(true)
                m.searchRightRect.translation = [180, 0]
                showCloseState()
                m.buttonSearchClose.uri = "pkg:/images/$$RES$$/Search Focused.png"
                
                'align search field
                searchTextRectangleX = (1740 - m.searchTextRectangle.width) / 2
                m.searchTextRectangle.translation = [searchTextRectangleX, 70]
                'align Message field
                error_textRectangleX = (1740 - m.Error_text.width) / 2
                m.Error_text.translation = [error_textRectangleX, 500]
                
            end if
            result = true
        else if key = "left"
            handleButtonSearchTextColorFocus(false)
            m.searchRowList.setFocus(false)
            m.searchRightRect.translation = [400, 0]
            initNavigationBar()
            showOpenState()
            m.rectSwitchAccountBorder.visible = false
            
            'align search field
            searchTextRectangleX = (1520 - m.searchTextRectangle.width) / 2
            m.searchTextRectangle.translation = [searchTextRectangleX, 70]
            'align Message field
            error_textRectangleX = (1520 - m.Error_text.width) / 2
            m.Error_text.translation = [error_textRectangleX, 500]
            result = true 
        else if key = "down"
            if m.buttonProfileOpen.hasFocus()
                m.rectSwitchAccountBorder.visible = true
                m.buttonSwitchAccount.setFocus(true)
            else if m.searchTextButton.hasFocus()
                handleButtonSearchTextColorFocus(false)
            end if 
            result = true 
        else if key = "up"
            if m.buttonSwitchAccount.hasFocus()
                m.rectSwitchAccountBorder.visible = false
                m.buttonSwitchAccount.setFocus(false)
                m.buttonProfileOpen.setFocus(true)
            else if m.searchRowList.hasFocus()
                handleButtonSearchTextColorFocus(true)
            end if
            result = true
        else if key = "back"
            if m.keyboard.visible
                m.searchQuery = m.keyboard.text.Trim()
                if m.searchQuery = ""
                    m.textLabel.text = "Search"
                else
                    m.textLabel.text = m.searchQuery
                    callSearchApi()
                end if 
                m.keyboard.visible = false
                m.keyboardTheme.visible = false
                handleButtonSearchTextColorFocus(true)
                result = true
            else if m.switchAccount <> invalid 
               if m.switchAccount.accountSelected
                    m.top.visible = false
                    result = false
                else
                    m.switchAccount.setFocus(false)
                    m.buttonSwitchAccount.setFocus(true)
                    m.switchAccount = invalid
                    result = true
                end if
            else if m.viewAllScreen <> invalid
                m.viewAllScreen.setFocus(false)
                m.viewAllScreen = invalid
                m.searchRowList.setFocus(true)
                m.searchRowList.jumpToRowItem = m.focusedItem
                result = true
            else if m.mediaDetail <> invalid
                m.mediaDetail.setFocus(false)
                m.mediaDetail = invalid
                m.searchRowList.setFocus(true)
                m.searchRowList.jumpToRowItem = m.focusedItem
                result = true
            else if m.productDetail <> invalid
                m.productDetail.setFocus(false)
                m.productDetail = invalid
                m.searchRowList.setFocus(true)
                m.searchRowList.jumpToRowItem = m.focusedItem
                result = true
            else
                m.top.visible = false
                result = false
            end if
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
    callSearchApi()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub