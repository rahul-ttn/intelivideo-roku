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
    m.isMediaContent = false
    m.contentArray = CreateObject("roArray", 0, true)
end sub

sub setData()
    m.titleText = m.top.titleText
    m.heading.text =  m.titleText
    m.searchQuery = m.top.searchQuery
    print "m.searchQuery >>>> ";m.searchQuery
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
     if m.titleText = featuredProducts()
        callFeatureProductsApi()
    else if m.titleText = featuredMedia()
        callFeatureMediaApi()
    else if m.titleText = popularProducts()
        callPopularProductsApi()
    else if m.titleText = popularMedia()
        callPopularMediaApi()
    else if m.titleText = recentlyAddedProducts()
        callRecentlyAddedProductsApi()
    else if m.titleText = recentlyAddedMedia()
        callRecentlyAddedMediaApi()
    else if m.titleText = featuredRecent()
        callRecentlyViewedApi()
    else if m.titleText = myFavorites()
        callMyFavoriteApi()
    else if m.titleText = searchProducts()
        m.heading.text = m.titleText + " for " + Chr(34) + m.searchQuery + Chr(34)
        callProductSearchApi()
    else if m.titleText = searchMedia()
        m.heading.text = m.titleText + " for " + Chr(34) + m.searchQuery + Chr(34)
        callMediaSearchApi()
    end if
end sub

sub callRecentlyViewedApi()
    baseUrl = getApiBaseUrl() +"recent?per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.recentlyViewedApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.recentlyViewedApi.setField("uri",baseUrl)
    m.recentlyViewedApi.setField("dataType","recent")
    m.recentlyViewedApi.observeField("content","onMediaResponse")
    m.recentlyViewedApi.control = "RUN"
    showProgressDialog()
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

sub callMyFavoriteApi()
    baseUrl = getApiBaseUrl() + "favorites?per_page="+ Stri(m.perPageItems).Trim() +"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.myFavoriteApi = createObject("roSGNode","GetFavoriteApiHandler")
    m.myFavoriteApi.setField("uri",baseUrl)
    m.myFavoriteApi.observeField("content","onMediaResponse")
    m.myFavoriteApi.control = "RUN"
    showProgressDialog()
end sub

sub callProductSearchApi()
    baseUrl = getApiBaseUrl() + "search/products?search_query="+ m.searchQuery.ToStr() +"&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    baseUrl = baseUrl.EncodeUri()
    print "search baseUrl >>>> ";baseUrl.EncodeUri()
    m.productSearchApi = createObject("roSGNode","FeatureProductApiHandler")
    m.productSearchApi.setField("uri",baseUrl)
    m.productSearchApi.setField("dataType","search")
    m.productSearchApi.observeField("content","onProductsResponse")
    m.productSearchApi.control = "RUN"
    showProgressDialog()
end sub

sub callMediaSearchApi()
    baseUrl = getApiBaseUrl() + "search/media?search_query="+ m.searchQuery.ToStr() +"&per_page="+Stri(m.perPageItems).Trim()+"&page_number="+Stri(m.pageNumber).Trim()+"&access_token=" + getValueInRegistryForKey("authTokenValue")
    baseUrl = baseUrl.EncodeUri()
    m.MediaSearchApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.MediaSearchApi.setField("uri",baseUrl)
    m.MediaSearchApi.setField("dataType","search")
    m.MediaSearchApi.observeField("content","onMediaResponse")
    m.MediaSearchApi.control = "RUN"
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
        if m.titleText = featuredProducts()
            m.apiModel = m.featureProductApi.content
        else if m.titleText = featuredMedia()
            m.apiModel = m.featureMediaApi.content
        else if m.titleText = popularProducts()
            m.apiModel = m.popularProductApi.content
        else if m.titleText = popularMedia()
            m.apiModel = m.popularMediaApi.content
        else if m.titleText = recentlyAddedProducts()
            m.apiModel = m.recentAddedProductApi.content
        else if m.titleText = recentlyAddedMedia()
            m.apiModel = m.recentAddedMediaApi.content
        else if m.titleText = featuredRecent()
            m.apiModel = m.recentlyViewedApi.content
        else if m.titleText = myFavorites()
            m.apiModel = m.myFavoriteApi.content
        else if m.titleText = searchProducts()
            m.apiModel = m.productSearchApi.content
        else if m.titleText = searchMedia()
            m.apiModel = m.MediaSearchApi.content
        end if

        if m.apiModel <> invalid AND m.apiModel.success
            showList()
        end if
end sub

sub showList()
    m.list.visible = true
    m.list.SetFocus(false)
    m.list.unobserveField("rowItemSelected")
    m.list.unobserveField("rowItemFocused")
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
    if m.titleText = featuredProducts()
        m.resultArray = m.apiModel.featuredProductsArray
        m.isMediaContent = false
    else if m.titleText = featuredMedia()
        m.resultArray = m.apiModel.featuredMediaArray
        m.isMediaContent = true
    else if m.titleText = popularProducts()
        m.resultArray = m.apiModel.popularProductsArray
        m.isMediaContent = false
    else if m.titleText = popularMedia()
        m.resultArray = m.apiModel.popularMediaArray
        m.isMediaContent = true
    else if m.titleText = recentlyAddedProducts()
        m.resultArray = m.apiModel.recentlyAddedProductsArray
        m.isMediaContent = false
    else if m.titleText = recentlyAddedMedia()
        m.resultArray = m.apiModel.recentlyAddedMediaArray
        m.isMediaContent = true
    else if m.titleText = featuredRecent()
        m.resultArray = m.apiModel.recentMediaArray
        m.isMediaContent = true
    else if m.titleText = "My Content"
        m.resultArray = m.myContentArray
        m.isMediaContent = false
    else if m.titleText = searchProducts()
        m.resultArray = m.apiModel.searchProductsArray
        m.isMediaContent = false
    else if m.titleText = searchMedia()
        m.resultArray = m.apiModel.searchMediaArray
        m.isMediaContent = true
    end if
    m.contentArray.Append(m.resultArray)
end sub

function onRowItemSelected() as void
        print "***** Some's wish is ********";m.list.rowItemSelected
        row = m.list.rowItemSelected[0]
        col = m.list.rowItemSelected[1]
'        print "**********Row is *********";row
'        print "**********col is *********";col
        m.focusedItem = [row,col]
        if m.list.itemComponentName = "Home3xListItemLayout"
            num = 3
        else
            num = 2
        end if
        arrayIndex = (num * row) + col
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
                if m.isMediaContent
                    rowItem.id = dataObjet.resource_id
                else
                    rowItem.id = dataObjet.product_id
                    rowItem.count = dataObjet.media_count
                end if
                
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                
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
    callSelectedApi()
end sub









