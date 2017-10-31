sub init()
    m.top.setFocus(true)
    m.heading = m.top.findNode("labelHeading")
    m.list = m.top.findNode("list") 
    m.Error_text  = m.top.FindNode("Error_text")
    m.parentRectangle = m.top.FindNode("parentRectangle")
    m.parentRectangle.color = homeBackground() 
    m.appConfig =  m.top.getScene().appConfigContent  
    m.pagination = false 
    m.perPageItems =10
    m.pageNumber =1
    m.isMediaContent = false
    m.contentArray = CreateObject("roArray", 0, true)
    m.primaryColor = m.appConfig.primary_color
end sub

sub setCategoryData()
    print "Set Category called"
    m.categoryId = m.top.categoryId
    m.heading.text = m.top.categoryHeading
    callCategoriesApi()
    m.list.setFocus(true)
end sub

sub callCategoriesApi()
    baseUrl = getApiBaseUrl() + "categories/"+m.categoryId+"/items?per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.itemCategoryApi = createObject("roSGNode","CategoryItemApiHandler")
    m.itemCategoryApi.setField("uri",baseUrl)
    m.itemCategoryApi.observeField("content","onCategoryItemsApiResponse")
    m.itemCategoryApi.control = "RUN"
    showProgressDialog()
end sub 

sub onCategoryItemsApiResponse()
    print "Category Item Api response called"
    hideProgressDialog()
    m.categoryItemsModel = m.itemCategoryApi.content
    if m.categoryItemsModel <> invalid and m.categoryItemsModel.success
        m.resultArray = m.categoryItemsModel.items
        m.contentArray.Append(m.resultArray)
        showCategoriesList()
    end if
end sub

sub showCategoriesList()
    m.list.visible = true
    m.list.unobserveField("rowItemSelected")
    m.list.unobserveField("rowItemFocused")
    m.list.ObserveField("rowItemSelected", "onRowItemSelected")
    m.list.ObserveField("rowItemFocused", "onRowItemFocused")   
    m.list.content = getGridRowListContent()
    m.list.setFocus(true)
    if m.pagination
     m.list.jumpToRowItem = m.focusedItem
    end if
end sub

function onRowItemSelected() as void
        row = m.list.rowItemSelected[0]
        col = m.list.rowItemSelected[1]
        m.focusedItem = [row,col]
        if m.list.itemComponentName = "Home3xListItemLayout"
            num = 3
        else
            num = 2
        end if
        
        arrayIndex = (num * row) + col
        
        if m.contentArray[arrayIndex].item_type = "products"
            m.isMediaContent = false
        else if m.contentArray[arrayIndex].item_type = "media"
            m.isMediaContent = true
        end if
        if m.isMediaContent
            m.mediaDetail = m.top.createChild("MediaDetailScreen")
            m.top.setFocus(false)
            m.mediaDetail.setFocus(true)
            m.mediaDetail.resource_id = m.contentArray[arrayIndex].resource_id
        else
            m.productDetail = m.top.createChild("ProductDetailScreen")
            m.top.setFocus(false)
            m.productDetail.setFocus(true)
            m.productDetail.product_id = m.contentArray[arrayIndex].product_id
        end if
end function

function onRowItemFocused() as void
        row = m.list.rowItemFocused[0]
        col = m.list.rowItemFocused[1]
        m.focusedItem = [row,col]
        if row = m.numberOfRows - 1 And not m.categoryItemsModel.pageInfo.last_page 
          m.pagination = true
          m.pageNumber = m.categoryItemsModel.pageInfo.next_page
          callCategoriesApi()  
        end if
end function

function getGridRowListContent() as object

    if m.contentArray.count() < 9
        m.list.itemComponentName = "Home2xListItemLayout"
        m.list.itemSize = [200 * 9 + 100, 600]
        m.list.rowHeights = [600]
        m.list.rowItemSize = [ [675, 572] ]
        m.numberOfRows = (m.contentArray.count() + 1) \ 2 
        n = 1
    else 
        m.list.itemComponentName = "Home3xListItemLayout"
        m.list.itemSize = [200 * 9 + 100, 445]
        m.list.rowHeights = [445]
        m.list.rowItemSpacing = [ [150, 0] ]
        m.list.rowItemSize = [ [448, 445] ]
        m.numberOfRows = (m.contentArray.count() + 2) \ 3 
        n = 2
    end if
    
    ind = 0
    parentContentNode = CreateObject("roSGNode", "ContentNode") 
    for numRows = 0 to m.numberOfRows-1
        row = parentContentNode.CreateChild("ContentNode")
        row.title = ""
        for index = 0 to n
            if ind < m.contentArray.count()
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.contentArray[ind]
                if dataObjet.item_type = "product"
                    rowItem.id = dataObjet.resource_id
                    rowItem.count = dataObjet.media_count
                else if dataObjet.item_type = "media"
                    rowItem.id = dataObjet.product_id
                    'rowItem.count = dataObjet.media_count
                end if
                
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.thumbnail
                rowItem.coverBgColor = m.primaryColor
                rowItem.isMedia = dataObjet.is_media
                rowItem.isItem = dataObjet.is_item
                
                if dataObjet.is_media
                    rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                else
                    rowItem.mediaTime = ""
                end if
                
                rowItem.isViewAll = false
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
                ind = ind + 1
            end if
        end for
    end for
    return parentContentNode
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        print "onKeyEvent press of CategoryViewAll ";key
        if key = "left" or key = "right" or key = "up" or key = "down"
            return true
        else if key = "back"
            if m.mediaDetail <> invalid
                m.mediaDetail.setFocus(false)
                m.mediaDetail = invalid
                m.list.setFocus(true)
                m.list.jumpToRowItem = m.focusedItem
                result = true
            else if m.productDetail <> invalid
                m.productDetail.setFocus(false)
                m.productDetail = invalid
                m.list.setFocus(true)
                m.list.jumpToRowItem = m.focusedItem
                result = true
            else
                m.top.visible = false
                result = false
            end if
        end if
    end if
    return result 
End function

Function showRetryDialog(title ,message)
  m.Error_text.visible = true
  m.Error_text.text = networkErrorMessage()
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

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub

sub onRetry()
    callCategoriesApi()
end sub









