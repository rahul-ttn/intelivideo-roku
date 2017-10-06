sub init()
    m.top.setFocus(true)
    m.heading = m.top.findNode("labelHeading")
    m.list = m.top.findNode("list") 
    m.Error_text  = m.top.FindNode("Error_text")
    m.parentRectangle = m.top.FindNode("parentRectangle")
    m.parentRectangle.color = homeBackground()  
    m.pagination = false 
    m.perPageItems =10
    m.pageNumber =1
    m.contentArray = CreateObject("roArray", 0, true)
end sub

sub setData()
    m.titleText = m.top.titleText
    m.heading.text =  m.titleText
    if checkInternetConnection()
       callSelectedApi()
     else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub setArray()
    print "set array called "
    m.myContentArray = m.top.contentArray
    showList() 'To show list when my content is selected
end sub

sub setPrimaryColor()
    m.primaryColor = m.top.primaryColor
end sub

sub callSelectedApi()
     if m.titleText = "Featured Products"
        callFeatureProductsApi()
    else if m.titleText = "Featured Media"
        callFeatureMediaApi()
    else if m.titleText = "Popular Products"
        callPopularProductsApi()
    else if m.titleText = "Popular Media"
        callPopularMediaApi()
    else if m.titleText = "Recently Added Products"
        callRecentlyAddedProductsApi()
    else if m.titleText = "Recently Added Media"
        callRecentlyAddedMediaApi()
    end if
end sub

sub callFeatureProductsApi()
    baseUrl = getApiBaseUrl() + "lists/featured?content_type=product&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.featureProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.featureProductApi.setField("uri",baseUrl)
    m.featureProductApi.setField("dataType","feature")
    m.featureProductApi.observeField("content","onProductsResponse")
    m.featureProductApi.control = "RUN"
    showProgressDialog()
end sub

sub callFeatureMediaApi()
    baseUrl = getApiBaseUrl() + "lists/featured?content_type=media&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.featureMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.featureMediaApi.setField("uri",baseUrl)
    m.featureMediaApi.setField("dataType","feature")
    m.featureMediaApi.observeField("content","onMediaResponse")
    m.featureMediaApi.control = "RUN"
    showProgressDialog()
end sub

sub callPopularProductsApi()
    baseUrl = getApiBaseUrl() + "lists/popular?content_type=product&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.popularProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.popularProductApi.setField("uri",baseUrl)
    m.popularProductApi.setField("dataType","popular")
    m.popularProductApi.observeField("content","onProductsResponse")
    m.popularProductApi.control = "RUN"
    showProgressDialog()
end sub

sub callPopularMediaApi()
    baseUrl = getApiBaseUrl() + "lists/popular?content_type=media&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.popularMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.popularMediaApi.setField("uri",baseUrl)
    m.popularMediaApi.setField("dataType","popular")
    m.popularMediaApi.observeField("content","onMediaResponse")
    m.popularMediaApi.control = "RUN"
    showProgressDialog()
end sub

sub callRecentlyAddedProductsApi()
    baseUrl = getApiBaseUrl() + "lists/recent?content_type=product&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.recentAddedProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.recentAddedProductApi.setField("uri",baseUrl)
    m.recentAddedProductApi.setField("dataType","recentAdded")
    m.recentAddedProductApi.observeField("content","onProductsResponse")
    m.recentAddedProductApi.control = "RUN"
    showProgressDialog()
end sub

sub callRecentlyAddedMediaApi()
    baseUrl = getApiBaseUrl() + "lists/recent?content_type=media&per_page="+ Stri(m.perPageItems).Trim() +"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.recentAddedMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.recentAddedMediaApi.setField("uri",baseUrl)
    m.recentAddedMediaApi.setField("dataType","recentAdded")
    m.recentAddedMediaApi.observeField("content","onMediaResponse")
    m.recentAddedMediaApi.control = "RUN"
    showProgressDialog()
end sub

sub onProductsResponse()
    getData()
end sub

sub onMediaResponse()
    getData()
end sub


sub getData()
        hideProgressDialog()
        m.Error_text.visible = false
        if m.titleText = "Featured Products"
            m.apiModel = m.featureProductApi.content
        else if m.titleText = "Featured Media"
            m.apiModel = m.featureMediaApi.content
        else if m.titleText = "Popular Products"
            m.apiModel = m.popularProductApi.content
        else if m.titleText = "Popular Media"
            m.apiModel = m.popularMediaApi.content
        else if m.titleText = "Recently Added Products"
            m.apiModel = m.recentAddedProductApi.content
        else if m.titleText = "Recently Added Media"
            m.apiModel = m.recentAddedMediaApi.content
        end if
        
        if  m.apiModel.success
            showList() 
        end if
end sub

sub showList()
    m.list.visible = true
    m.list.SetFocus(false)
    m.list.ObserveField("rowItemSelected", "onRowItemSelected")
    m.list.ObserveField("rowItemFocused", "onRowItemFocused")
    setContentArray()    
    m.list.content = getGridRowListContent()
    m.list.setFocus(true)
    if m.pagination
     m.list.jumpToRowItem = m.focusedItem
    end if
end sub

sub setContentArray()
    if m.titleText = "Featured Products"
        m.resultArray = m.apiModel.featuredProductsArray
    else if m.titleText = "Featured Media"
        m.resultArray = m.apiModel.featuredMediaArray
    else if m.titleText = "Popular Products"
        m.resultArray = m.apiModel.popularProductsArray
    else if m.titleText = "Popular Media"
        m.resultArray = m.apiModel.popularMediaArray
    else if m.titleText = "Recently Added Products"
        m.resultArray = m.apiModel.recentlyAddedProductsArray
    else if m.titleText = "Recently Added Media"
        m.resultArray = m.apiModel.recentlyAddedMediaArray
    else if m.titleText = "My Content"
        m.resultArray = m.myContentArray
    end if
    'if m.pagination
        print "m.contentArray.count()-----------------------------before append";m.contentArray.count() 
        m.contentArray.Append(m.resultArray)
        print "m.contentArray.count()-----------------------------after append";m.contentArray.count()
   ' else 
'        m.contentArraym.resultArray
'    end if
end sub

function onRowItemSelected() as void
        print "***** Some's wish is ********";m.list.rowItemSelected
        row = m.list.rowItemSelected[0]
        col = m.list.rowItemSelected[1]
        print "**********Row is *********";row
        print "**********col is *********";col
end function

function onRowItemFocused() as void
        print "***** Some's wish is ********";m.list.rowItemFocused
        row = m.list.rowItemFocused[0]
        col = m.list.rowItemFocused[1]
        print "**********Row is *********";row
        print "**********col is *********";col
        m.focusedItem = [row,col]
        if m.myContentArray = invalid
            if row = m.numberOfRows - 1 And not m.apiModel.pageInfo.last_page 
              m.pagination = true
              m.pageNumber = m.apiModel.pageInfo.next_page
              callSelectedApi()  
            end if
        end if
end function

function getGridRowListContent() as object
    m.list.itemComponentName = "Home3xListItemLayout"
    m.list.itemSize = [200 * 9 + 100, 445]
    m.list.rowHeights = [445]
    m.list.rowItemSpacing = [ [150, 0] ]
    m.list.rowItemSize = [ [448, 445] ]
    print "m.contentArray.count()-----------------------------";m.contentArray.count()
    m.numberOfRows = (m.contentArray.count() + 2) \ 3 
    n = 2
    ind = 0
    parentContentNode = CreateObject("roSGNode", "ContentNode") 
    for numRows = 0 to m.numberOfRows-1
        row = parentContentNode.CreateChild("ContentNode")
        row.title = ""
        for index = 0 to n
            if ind < m.contentArray.count()
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.contentArray[ind]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
                rowItem.coverBgColor = m.primaryColor
                if m.myContentArray <> invalid
                    rowItem.isMedia = m.myContentArray[0].isMedia
                    print "m.myContentArray[0].isItem +++++";m.myContentArray[0]
                    rowItem.isItem = m.myContentArray[0].isItem
                else
                    rowItem.isMedia = dataObjet.is_media
                    rowItem.isItem = dataObjet.is_item
                end if
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
        if key = "left" or key = "right"
            return true
        else if key = "back"
            m.top.visible = false
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
    callSelectedApi()
end sub









