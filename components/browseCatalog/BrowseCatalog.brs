sub init()
    m.top.SetFocus(true)
    m.appConfig = m.top.getScene().appConfigContent
    m.counter = 0
    m.counterMaxValue = 1
    m.isContentLoaded = false
    
    initFields()
End sub

sub onSubId()
    m.subscriptionId = m.top.subscriptionId
    callBrowseApis()
end sub

sub initFields() 
    homeBackground = m.top.FindNode("homeBackground")
    homeBackground.color = homeBackground() 
    m.Error_text  = m.top.FindNode("Error_text")
    m.homeRowList = m.top.FindNode("homeRowList")  
    
    bannerBackground = m.top.FindNode("bannerBackground")
    bannerBackground.color = m.appConfig.primary_color

    m.loginRectangle = m.top.findNode("loginRectangle")
    m.loginRectangle.color = m.appConfig.non_focus_color
    loginRectangleX = (1920 - m.loginRectangle.width) / 2
    m.loginRectangle.translation = [loginRectangleX,120]
    
    m.loginButton = m.top.FindNode("loginButton")
    

End sub

sub callBrowseApis()
    if checkInternetConnection()
        showProgressDialog()
        getFeatureData()
        getPopularData()
        getRecentlyAddedData()
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub getFeatureData()
    baseUrl = getApiBaseUrl() + "store/" + StrI(m.appConfig.account_id).Trim() + "/subscriptions/" + m.subscriptionId.Trim() + "/featured?src_system=roku" 
    m.featureApi = createObject("roSGNode","SubscriptionItemsApiHandler")
    m.featureApi.setField("uri",baseUrl)
    m.featureApi.setField("dataType","feature")
    m.featureApi.observeField("content","onApiResponse")
    m.featureApi.control = "RUN"
end sub

sub getPopularData()
    baseUrl = getApiBaseUrl() + "store/" + StrI(m.appConfig.account_id).Trim() + "/subscriptions/" + m.subscriptionId.Trim() + "/popular?src_system=roku" 
    m.popularApi = createObject("roSGNode","SubscriptionItemsApiHandler")
    m.popularApi.setField("uri",baseUrl)
    m.popularApi.setField("dataType","popular")
    m.popularApi.observeField("content","onApiResponse")
    m.popularApi.control = "RUN"
end sub

sub getRecentlyAddedData()
    baseUrl = getApiBaseUrl() + "store/" + StrI(m.appConfig.account_id).Trim() + "/subscriptions/" + m.subscriptionId.Trim() + "/recent?src_system=roku" 
    m.recentApi = createObject("roSGNode","SubscriptionItemsApiHandler")
    m.recentApi.setField("uri",baseUrl)
    m.recentApi.setField("dataType","recent")
    m.recentApi.observeField("content","onApiResponse")
    m.recentApi.control = "RUN"
end sub

sub updateCounter()
    m.counter = m.counter + 1
    print "m.counter >> ";m.counter
end sub

sub onApiResponse()
    updateCounter()
    if m.counter = m.counterMaxValue
        m.counter = 0
        m.Error_text.visible = false
        hideProgressDialog()
        
        m.featureApiModel = m.featureApi.content
        m.popularApiModel = m.popularApi.content
        m.recentApiModel = m.recentApi.content
        
        if m.featureApiModel <> invalid AND m.featureApiModel.success OR m.popularApiModel <> invalid AND m.popularApiModel.success OR m.recentApiModel <> invalid AND m.recentApiModel.success
            homeRowList() 
        else
            m.counter = 0
            showRetryDialog(networkErrorTitle(), networkErrorMessage())
        end if
    end if
end sub

sub homeRowList()
    m.homeRowList.visible = true
    m.homeRowList.SetFocus(true)
    m.homeRowList.unobserveField("rowItemSelected")
    m.homeRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.homeRowList.content = getGridRowListContent()
End sub

function getGridRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
   
            if m.featureApiModel <> invalid AND m.featureApiModel.success AND m.featureApiModel.featuredProductsArray.count() <> 0
                print "feature Product >>> "
                m.isContentLoaded = true
                row = parentContentNode.CreateChild("ContentNode")
                row.title = featuredProducts()
                for index= 0 to m.featureApiModel.featuredProductsArray.Count()-1
                    rowItem = row.CreateChild("HomeRowListItemData")
                    dataObjet = m.featureApiModel.featuredProductsArray[index]
                    rowItem.id = dataObjet.product_id
                    rowItem.title = dataObjet.title
                    rowItem.imageUri = dataObjet.small
                    rowItem.count = dataObjet.media_count
                    rowItem.coverBgColor = m.appConfig.primary_color
                    rowItem.isMedia = dataObjet.is_media
                    rowItem.isViewAll = false
                    rowItem.isItem = dataObjet.is_item
                    rowItem.is_vertical_image = dataObjet.is_vertical_image
                    if(getPostedVideoDayDifference(dataObjet.created_at) < 11)
                        rowItem.isNew = true
                    else
                        rowItem.isNew = false
                    end if
                end for
                if m.featureApiModel.featuredProductsArray.Count() >= 10
                    rowItem = row.CreateChild("HomeRowListItemData")
                    rowItem.isViewAll = true
                end if
            end if
         
         if m.featureApiModel <> invalid AND m.featureApiModel.success AND m.featureApiModel.featuredMediaArray.count() <> 0
            print "Feature Media >>> "
            m.isContentLoaded = true
            row = parentContentNode.CreateChild("ContentNode")
            row.title = featuredMedia()
            for index= 0 to m.featureApiModel.featuredMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.featureApiModel.featuredMediaArray[index]
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
            if m.featureApiModel.featuredMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.popularApiModel <> invalid AND m.popularApiModel.success AND m.popularApiModel.popularProductsArray.count() <> 0
            print "Popular Product >>> "
            m.isContentLoaded = true
            row = parentContentNode.CreateChild("ContentNode")
            row.title = popularProducts()
            for index= 0 to m.popularApiModel.popularProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.popularApiModel.popularProductsArray[index]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
                rowItem.coverBgColor = m.appConfig.primary_color
                rowItem.isMedia = dataObjet.is_media
                rowItem.isItem = dataObjet.is_item
                rowItem.isViewAll = false
                rowItem.is_vertical_image = dataObjet.is_vertical_image
                
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
            end for
            if m.popularApiModel.popularProductsArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.popularApiModel <> invalid AND m.popularApiModel.success AND m.popularApiModel.popularMediaArray.count() <> 0
            print "Popular Media >>> "
            m.isContentLoaded = true
            row = parentContentNode.CreateChild("ContentNode")
            row.title = popularMedia()
            for index= 0 to m.popularApiModel.popularMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.popularApiModel.popularMediaArray[index]
                rowItem.id = dataObjet.resource_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                rowItem.coverBgColor = m.appConfig.primary_color
                rowItem.isViewAll = false
                rowItem.isItem = dataObjet.is_item
                rowItem.isMedia = dataObjet.is_media
                
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
            end for
            if m.popularApiModel.popularMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.recentApiModel <> invalid AND m.recentApiModel.success AND m.recentApiModel.recentlyAddedProductsArray.count() <> 0
            print "recently Added Product >>> "
            m.isContentLoaded = true
            row = parentContentNode.CreateChild("ContentNode")
            row.title = recentlyAddedProducts()
            for index= 0 to m.recentApiModel.recentlyAddedProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.recentApiModel.recentlyAddedProductsArray[index]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
                rowItem.coverBgColor = m.appConfig.primary_color
                rowItem.isMedia = dataObjet.is_media
                rowItem.isViewAll = false
                rowItem.isItem = dataObjet.is_item
                rowItem.is_vertical_image = dataObjet.is_vertical_image
                
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
            end for
            if m.recentApiModel.recentlyAddedProductsArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.recentApiModel <> invalid AND m.recentApiModel.success AND m.recentApiModel.recentlyAddedMediaArray.count() <> 0
            print "recently Added Media >>> "
            m.isContentLoaded = true
            row = parentContentNode.CreateChild("ContentNode")
            row.title = recentlyAddedMedia()
            for index= 0 to m.recentApiModel.recentlyAddedMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.recentApiModel.recentlyAddedMediaArray[index]
                rowItem.id = dataObjet.resource_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                rowItem.coverBgColor = m.appConfig.primary_color
                rowItem.isViewAll = false
                rowItem.isItem = dataObjet.is_item
                rowItem.isMedia = dataObjet.is_media
                
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
            end for
            if m.recentApiModel.recentlyAddedMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if

         if NOT m.isContentLoaded
            m.Error_text.visible = true
            m.Error_text.text = "There is No Content available for this account"
         end if
         
         return parentContentNode 
end function

'function onRowItemSelected() as void
'        row = m.homeRowList.rowItemSelected[0]
'        col = m.homeRowList.rowItemSelected[1]
'
'        m.focusedItem = [row,col]
'        if checkInternetConnection()
'            if col >= 10
'                'goTViewAllScreen(m.homeRowList.content.getChild(m.homeRowList.itemFocused).title)
'            else
'                listTitle = m.homeRowList.content.getChild(m.homeRowList.itemFocused).title
'                if listTitle = featuredMedia() OR listTitle = popularMedia() OR listTitle = recentlyAddedMedia()
'                    goToMediaDetailScreen(listTitle, col)
'                else
'                    goToProductDetailScreen(listTitle, col)
'                end if
'            end if  
'        else
'            showRetryDialog(networkErrorTitle(), networkErrorMessage())
'        end if
'end function
'
'sub goToProductDetailScreen(titleText as String, column as Integer)
'    m.productDetail = m.top.createChild("ProductDetailScreen")
'    m.top.setFocus(false)
'    m.productDetail.setFocus(true)
'    if titleText = featuredProducts()
'        m.productDetail.product_id = m.featureProductsApiModel.featuredProductsArray[column].product_id
'    else if titleText = popularProducts()
'        m.productDetail.product_id = m.popularProductApiModel.popularProductsArray[column].product_id
'    else if titleText = recentlyAddedProducts()
'        m.productDetail.product_id = m.recentAddedProductApiModel.recentlyAddedProductsArray[column].product_id
'    else if titleText = myFavorites()
'        m.productDetail.product_id = m.myFavoriteApiModel.items[column].product_id
'    else if titleText = myContent()
'        m.productDetail.product_id = m.productsAarray[column].product_id
'    else if titleText = basedOnFavorites()
'        m.productDetail.product_id = m.basedOnFavoriteApiModel.relatedMediaArray[column].product_id
'    end if
'end sub
'
'sub goToMediaDetailScreen(titleText as String, column as Integer)
'    m.mediaDetail = m.top.createChild("MediaDetailScreen")
'    m.top.setFocus(false)
'    m.mediaDetail.setFocus(true)
'    if titleText = featuredMedia()
'        m.mediaDetail.resource_id = m.featureMediaApiModel.featuredMediaArray[column].resource_id
'    else if titleText = popularMedia()
'        m.mediaDetail.resource_id = m.popularMediaApiModel.popularMediaArray[column].resource_id
'    else if titleText = recentlyAddedMedia()
'        m.mediaDetail.resource_id = m.recentAddedMediaApiModel.recentlyAddedMediaArray[column].resource_id
'    else if titleText = myFavorites()
'        m.mediaDetail.resource_id = m.myFavoriteApiModel.items[column].resource_id
'    else if titleText = featuredRecent()
'        m.mediaDetail.resource_id = m.recentlyViewedApiModel.recentMediaArray[column].resource_id
'    else if titleText = basedOnFavorites()
'        m.mediaDetail.resource_id = m.basedOnFavoriteApiModel.relatedMediaArray[column].resource_id  
'    end if
'end sub



function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    if press
    print "onKeyEvent Password Screen : "; key
        if key="up" OR key="down" OR key="left" OR key="right" Then
'            handleFocus(key)
'            handleVisibility()
            return true
        else if key = "back"
'            if m.createAccount <> invalid
'                m.createAccount.setFocus(false)
'                m.createAccount = invalid
'                m.createAccountButton.setFocus(true)
'                return true
'            else if m.loginScreen <> invalid
'                m.loginScreen.setFocus(false)
'                m.loginScreen = invalid
'                m.loginButton.setFocus(true)
'                return true
'            else if m.browseCatalog <> invalid
'                m.browseCatalog.setFocus(false)
'                m.browseCatalog = invalid
'                m.browseCatalogButton.setFocus(true)
'                return true
'            else
                m.top.visible = false
                return false
'            end if
        end if
    end if
    return result 
end function

Function showRetryDialog(title ,message)
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
    callBrowseApis()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub