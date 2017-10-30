sub init()
    m.top.SetFocus(true)
    m.screenName = favoriteScreen()
    m.appConfig =  m.top.getScene().appConfigContent
    m.pagination = false 
    m.perPageItems =10
    m.pageNumber =1
    m.isRefreshScreen = false
    m.top.getScene().isRefreshOnBack = false
    m.favoriteItems = CreateObject("roArray", 0, true)

    initNavigationBar()
    m.buttonHomeOpen.setFocus(false)
    m.buttonFavoriteOpen.setFocus(true)
    
   initFields()
End sub

sub initFields()
    m.profileBackground = m.top.FindNode("FavoriteBackground")
    m.profileBackground.color = homeBackground()
    
    m.favoriteRowList = m.top.FindNode("favoriteRowList")
    m.favoriteRowList.visible = true
    m.favoriteRowList.SetFocus(false)
'    m.favoriteRowList.unobserveField("rowItemSelected")
'    m.favoriteRowList.unobserveField("rowItemFocused")
    m.favoriteRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.favoriteRowList.ObserveField("rowItemFocused", "onRowItemFocused")
    
    m.Error_text  = m.top.FindNode("Error_text")
    callMyFavoriteApi()
End sub

sub callMyFavoriteApi()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "favorites?per_page="+ Stri(m.perPageItems).Trim() +"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
        m.myFavoriteApi = createObject("roSGNode","GetFavoriteApiHandler")
        m.myFavoriteApi.setField("uri",baseUrl)
        m.myFavoriteApi.observeField("content","onFavoriteResponse")
        m.myFavoriteApi.control = "RUN"
    else
        if m.favoriteItems.count() = 0
            showRetryDialog(networkErrorTitle(), networkErrorMessage())
        end if
    end if
end sub

sub onFavoriteResponse()
    m.Error_text.visible = false
    hideProgressDialog()
    m.myFavoriteApiModel = m.myFavoriteApi.content
    if m.myFavoriteApiModel.success
        m.favoriteItems.Append(m.myFavoriteApiModel.items)
        if m.favoriteItems.count() = 0
            m.favoriteRowList.content = invalid
            m.Error_text.visible = true
            m.Error_text.text = "This is where you will find content that you have Favorited"
        else
            m.favoriteRowList.content = getGridRowListContent()
            if m.pagination
                m.favoriteRowList.jumpToRowItem = m.focusedItem
            end if
        end if
    else
        if m.favoriteItems.count() = 0
            m.Error_text.visible = true
            m.Error_text.text = "This is where you will find content that you have Favorited"
        end if
    end if
end sub

function onRowItemFocused() as void
        row = m.favoriteRowList.rowItemFocused[0]
        col = m.favoriteRowList.rowItemFocused[1]

        m.focusedItem = [row,col]
        if row = m.numberOfRows - 1 And not m.myFavoriteApiModel.pageInfo.last_page 
            m.pagination = true
            m.pageNumber = m.myFavoriteApiModel.pageInfo.next_page
            callMyFavoriteApi()  
        end if
end function

function onRowItemSelected() as void
        row = m.favoriteRowList.rowItemSelected[0]
        col = m.favoriteRowList.rowItemSelected[1]
        
        m.focusedItem = [row,col]
        
        index = (m.numOfColumns*row) + col
        goToFavDetail(index)
end function

sub goToFavDetail(index as Integer)
    if m.favoriteItems[index].item_type = "product"
        goToProductDetailScreen(index)
    else
        goToMediaDetailScreen(index)
    end if
end sub

sub goToProductDetailScreen(column as Integer)
    m.productDetail = m.top.createChild("ProductDetailScreen")
    m.top.setFocus(false)
    m.productDetail.setFocus(true)
    m.productDetail.product_id = m.favoriteItems[column].product_id
end sub

sub goToMediaDetailScreen(column as Integer)
    m.mediaDetail = m.top.createChild("MediaDetailScreen")
    m.top.setFocus(false)
    m.mediaDetail.setFocus(true)
    m.mediaDetail.resource_id = m.favoriteItems[column].resource_id
end sub


function getGridRowListContent() as object
     parentContentNode = CreateObject("roSGNode", "ContentNode")
        if m.favoriteItems.count() < 9
            m.favoriteRowList.itemComponentName = "Home2xListItemLayout"
            m.favoriteRowList.itemSize = [200 * 9 + 100, 600]
            m.favoriteRowList.rowHeights = [600]
            m.favoriteRowList.rowItemSize = [ [675, 572] ]
            m.numberOfRows = (m.favoriteItems.count() + 1) \ 2 
            n = 1
            m.numOfColumns = 2
        else
            m.favoriteRowList.itemComponentName = "Home3xListItemLayout"
            m.favoriteRowList.itemSize = [200 * 9 + 100, 445]
            m.favoriteRowList.rowHeights = [445]
            m.favoriteRowList.rowItemSpacing = [ [100, 0] ]
            m.favoriteRowList.rowItemSize = [ [448, 445] ]
            m.numberOfRows = (m.favoriteItems.count() + 2) \ 3 
            n = 2
            m.numOfColumns = 3
        end if
        
        ind = 0
        for numRows = 0 to m.numberOfRows-1
            row = parentContentNode.CreateChild("ContentNode")
            for index = 0 to n
                  if ind < m.favoriteItems.count()
                      rowItem = row.CreateChild("HomeRowListItemData")  
                      dataObjet = m.favoriteItems[ind]
                      rowItem.created_at = dataObjet.created_at
                  rowItem.title = dataObjet.title
                  rowItem.coverBgColor = m.appConfig.primary_color
                  rowItem.imageUri = dataObjet.thumbnail
                  rowItem.isMedia = dataObjet.is_media
                  rowItem.isItem = dataObjet.is_item
                  rowItem.isViewAll = false
                  
                  if dataObjet.item_type = "product"
                    rowItem.id = dataObjet.product_id
                    rowItem.count = dataObjet.media_count
                    rowItem.is_vertical_image = dataObjet.is_vertical_image
                    if getPostedVideoDayDifference(dataObjet.created_at) < 11
                        rowItem.isNew = true
                    else
                        rowItem.isNew = false
                    end if
                  else if dataObjet.item_type = "media"
                    rowItem.id = dataObjet.resource_id
                    rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                  end if
                  ind = ind + 1
                  end if
            end for 
        end for
        
        if m.isRefreshScreen
            startUpdateFocusTimer()
        end if
     return parentContentNode 
end function

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "onkeyevent Home Screen  key >";key
        if key = "right" 
            if m.favoriteItems.count() <> 0
                m.favoriteRowList.setFocus(true)
                m.favoriteRowList.translation = [260, 40]
                m.buttonFavoriteClose.uri = "pkg:/images/$$RES$$/Favorites Focused.png" 
                showCloseState()
            end if
            result = true
        else if key = "left" 
            print "key = left"
            row = m.favoriteRowList.rowItemFocused[0]
            col = m.favoriteRowList.rowItemFocused[1]
            if col = 0 AND m.favoriteRowList.hasFocus()
                m.favoriteRowList.setFocus(false)
                m.favoriteRowList.translation = [480, 40]
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
            else if m.mediaDetail <> invalid
                m.mediaDetail.setFocus(false)
                m.mediaDetail = invalid
                if m.top.getScene().isRefreshOnBack
                    updateScreen()
                else
                    m.favoriteRowList.setFocus(true)
                    m.favoriteRowList.jumpToRowItem = m.focusedItem
                end if
                result = true
            else if m.productDetail <> invalid
                m.productDetail.setFocus(false)
                m.productDetail = invalid
                if m.top.getScene().isRefreshOnBack
                    updateScreen()
                else
                    m.favoriteRowList.setFocus(true)
                    m.favoriteRowList.jumpToRowItem = m.focusedItem
                end if
                result = true
            else
                m.top.visible = false
                result = false
            end if
        end if           
    end if
    return result 
End Function

sub updateScreen()
    m.top.getScene().isRefreshOnBack = false
    m.isRefreshScreen = true
    showProgressDialog()
    m.favoriteItems.Clear()
    callMyFavoriteApi()
end sub

sub updateFocus()
    m.isRefreshScreen = false
    m.favoriteRowList.setFocus(true)
    m.favoriteRowList.jumpToRowItem = m.focusedItem
end sub

sub startUpdateFocusTimer()
    m.updateFocusTimer = m.top.findNode("updateFocusTimer")
    m.updateFocusTimer.control = "start"
    m.updateFocusTimer.ObserveField("fire","updateFocus")
end sub

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
    callMyFavoriteApi()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub