sub init()
    m.top.SetFocus(true)
    m.screenName = homeScreen()
    m.isSVOD = false
    m.counter = 0
    m.counterMaxValue = 9
    m.numOfColumns = 2
    m.isRefreshScreen = false
    m.top.getScene().isRefreshOnBack = false
    
    initFields()
    hideFields()
    callUserApi()
    setValueInRegistryForKey("isHome","true")
    m.switchAccount = invalid
    print "Home screen init >>> "
End sub

sub fromPasswordScreen()
    m.passwordScreen = m.top.isFromPasswordScreen
    m.passwordScreen = invalid
end sub

sub callUserApi()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "user?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.userApi = createObject("roSGNode","UserApiHandler")
        m.userApi.setField("uri",baseUrl)
        m.userApi.observeField("content","onUserApiResponse")
        m.userApi.control = "RUN"
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub onUserApiResponse()
    userApiModel = m.userApi.content
    if userApiModel.success
        showFields()
        m.appConfig =  m.userApi.content.appConfigModel
        m.userData =  m.userApi.content.userModel
        m.productsAarray = m.userApi.content.productsArray
        m.subsAarray = m.userApi.content.subscriptionsArray
        
        m.top.getScene().appConfigContent = m.appConfig
        if m.isRefreshScreen = false
            initNavigationBar()
        end if
        
        if m.subsAarray.count() > 0
            m.top.getScene().myContent = m.productsAarray
            m.isSVOD = true
            callHomeSVODApis()
        else if m.productsAarray.count() > 0
            m.top.getScene().myContent = []
            m.isSVOD = false
            showTVODData()
        else
        
    end if
    else
        hideProgressDialog()
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub showTVODData()
    hideProgressDialog()
    homeRowList() 
end sub

sub callHomeSVODApis()
    if checkInternetConnection()
        callMyFavoriteApi()
        callRecentlyViewedApi()
        callFeatureProductsApi()
        callFeatureMediaApi()
        callPopularProductsApi()
        callPopularMediaApi()
        callRecentlyAddedProductsApi()
        callRecentlyAddedMediaApi()   
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub updateCounter()
    m.counter = m.counter + 1
    print "m.counter >> ";m.counter
end sub

sub callRecentlyViewedApi()
    baseUrl = getApiBaseUrl() +"recent?per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.recentlyViewedApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.recentlyViewedApi.setField("uri",baseUrl)
    m.recentlyViewedApi.setField("dataType","recent")
    m.recentlyViewedApi.observeField("content","onMediaResponse")
    m.recentlyViewedApi.control = "RUN"
end sub

sub callFeatureProductsApi()
    baseUrl = getApiBaseUrl() + "lists/featured?content_type=product&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.featureProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.featureProductApi.setField("uri",baseUrl)
    m.featureProductApi.setField("dataType","feature")
    m.featureProductApi.observeField("content","onProductsResponse")
    m.featureProductApi.control = "RUN"
end sub

sub callFeatureMediaApi()
    baseUrl = getApiBaseUrl() + "lists/featured?content_type=media&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.featureMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.featureMediaApi.setField("uri",baseUrl)
    m.featureMediaApi.setField("dataType","feature")
    m.featureMediaApi.observeField("content","onMediaResponse")
    m.featureMediaApi.control = "RUN"
end sub

sub callPopularProductsApi()
    baseUrl = getApiBaseUrl() + "lists/popular?content_type=product&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.popularProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.popularProductApi.setField("uri",baseUrl)
    m.popularProductApi.setField("dataType","popular")
    m.popularProductApi.observeField("content","onProductsResponse")
    m.popularProductApi.control = "RUN"
end sub

sub callPopularMediaApi()
    baseUrl = getApiBaseUrl() + "lists/popular?content_type=media&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.popularMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.popularMediaApi.setField("uri",baseUrl)
    m.popularMediaApi.setField("dataType","popular")
    m.popularMediaApi.observeField("content","onMediaResponse")
    m.popularMediaApi.control = "RUN"
end sub

sub callRecentlyAddedProductsApi()
    baseUrl = getApiBaseUrl() + "lists/recent?content_type=product&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.recentAddedProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.recentAddedProductApi.setField("uri",baseUrl)
    m.recentAddedProductApi.setField("dataType","recentAdded")
    m.recentAddedProductApi.observeField("content","onProductsResponse")
    m.recentAddedProductApi.control = "RUN"
end sub

sub callRecentlyAddedMediaApi()
    baseUrl = getApiBaseUrl() + "lists/recent?content_type=media&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.recentAddedMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.recentAddedMediaApi.setField("uri",baseUrl)
    m.recentAddedMediaApi.setField("dataType","recentAdded")
    m.recentAddedMediaApi.observeField("content","onMediaResponse")
    m.recentAddedMediaApi.control = "RUN"
end sub

sub callMyFavoriteApi()
    baseUrl = getApiBaseUrl() + "favorites?per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.myFavoriteApi = createObject("roSGNode","GetFavoriteApiHandler")
    m.myFavoriteApi.setField("uri",baseUrl)
    m.myFavoriteApi.observeField("content","onFavApiResponse")
    m.myFavoriteApi.control = "RUN"
end sub

sub callBasedOnFavoriteApi(id as Integer, dataType as String)
    print "dataObjet.item_type = ";dataType
    if dataType = "media"
        baseUrl = getApiBaseUrl() + "media/"+ StrI(id).Trim() +"/related?per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
        m.basedOnFavoriteApi = createObject("roSGNode","FeatureMediaApiHandler")
        m.basedOnFavoriteApi.setField("uri",baseUrl)
        m.basedOnFavoriteApi.setField("dataType","related")
        m.basedOnFavoriteApi.observeField("content","onMediaResponse")
        m.basedOnFavoriteApi.control = "RUN"
    else if dataType = "product"
        baseUrl = getApiBaseUrl() + "products/"+ StrI(id).Trim() +"/related?per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
        m.basedOnFavoriteApi = createObject("roSGNode","FeatureProductApiHandler")
        m.basedOnFavoriteApi.setField("uri",baseUrl)
        m.basedOnFavoriteApi.setField("dataType","related")
        m.basedOnFavoriteApi.observeField("content","onMediaResponse")
        m.basedOnFavoriteApi.control = "RUN"
    end if
end sub

sub onProductsResponse()
    updateCounter()
    getData()
end sub

sub onMediaResponse()
    updateCounter()
    getData()
end sub

sub onFavApiResponse()
    m.myFavoriteApiModel = m.myFavoriteApi.content
    if m.myFavoriteApiModel.success
        if m.myFavoriteApiModel.items.count() > 0
            index = Rnd(m.myFavoriteApiModel.items.count())
            m.basedOnFavId = index-1
            dataObjet = m.myFavoriteApiModel.items[m.basedOnFavId]
            if dataObjet.item_type = "product"
                callBasedOnFavoriteApi(dataObjet.product_id, dataObjet.item_type)
            else if dataObjet.item_type = "media"
                callBasedOnFavoriteApi(dataObjet.resource_id, dataObjet.item_type)
            end if
        else
            m.counterMaxValue = m.counterMaxValue-1
        end if
    else
        m.counterMaxValue = m.counterMaxValue-1 
    end if
    updateCounter()
    getData()
end sub

sub getData()
    if m.counter = m.counterMaxValue
        m.counter = 0
        m.Error_text.visible = false
        hideProgressDialog()
        m.recentlyViewedApiModel = m.recentlyViewedApi.content
        
        m.featureProductsApiModel = m.featureProductApi.content
        m.featureMediaApiModel = m.featureMediaApi.content
        
        m.popularProductApiModel = m.popularProductApi.content
        m.popularMediaApiModel = m.popularMediaApi.content
        
        m.recentAddedProductApiModel = m.recentAddedProductApi.content
        m.recentAddedMediaApiModel = m.recentAddedMediaApi.content
        
        m.myFavoriteApiModel = m.myFavoriteApi.content
        if m.basedOnFavoriteApi <> invalid
            m.basedOnFavoriteApiModel = m.basedOnFavoriteApi.content
        end if
        
        if m.myFavoriteApiModel.success OR m.featureProductsApiModel.success OR m.featureMediaApiModel.success OR m.popularProductApiModel.success OR m.popularMediaApiModel.success OR m.recentAddedProductApiModel.success OR m.recentAddedMediaApiModel.success
            homeRowList() 
        else
            print "featureProductApiModel.fail"
            m.counter = 0
            showRetryDialog(networkErrorTitle(), networkErrorMessage())
        end if
    end if
end sub

function getGridRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         if m.isSVOD
            if m.recentlyViewedApiModel <> invalid AND m.recentlyViewedApiModel.success AND m.recentlyViewedApiModel.recentMediaArray.count() <> 0
                row = parentContentNode.CreateChild("ContentNode")
                row.title = featuredRecent()
                print "m.recentlyViewedApiModel.recentMediaArray.Count()  >>> ";m.recentlyViewedApiModel.recentMediaArray.Count()
                for index = 0 to m.recentlyViewedApiModel.recentMediaArray.Count()-1
                    rowItem = row.CreateChild("HomeRowListItemData")
                    dataObjet = m.recentlyViewedApiModel.recentMediaArray[index]
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
                if m.recentlyViewedApiModel.recentMediaArray.Count() >= 10
                    rowItem = row.CreateChild("HomeRowListItemData")
                    rowItem.isViewAll = true
                end if
             end if
         
            if m.featureProductsApiModel <> invalid AND m.featureProductsApiModel.success AND m.featureProductsApiModel.featuredProductsArray.count() <> 0
                row = parentContentNode.CreateChild("ContentNode")
                row.title = featuredProducts()
                for index= 0 to m.featureProductsApiModel.featuredProductsArray.Count()-1
                    rowItem = row.CreateChild("HomeRowListItemData")
                    dataObjet = m.featureProductsApiModel.featuredProductsArray[index]
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
                if m.featureProductsApiModel.featuredProductsArray.Count() >= 10
                    rowItem = row.CreateChild("HomeRowListItemData")
                    rowItem.isViewAll = true
                end if
            end if
         
         if m.featureMediaApiModel <> invalid AND m.featureMediaApiModel.success AND m.featureMediaApiModel.featuredMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = featuredMedia()
            for index= 0 to m.featureMediaApiModel.featuredMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.featureMediaApiModel.featuredMediaArray[index]
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
            if m.featureMediaApiModel.featuredMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.popularProductApiModel <> invalid AND m.popularProductApiModel.success AND m.popularProductApiModel.popularProductsArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = popularProducts()
            for index= 0 to m.popularProductApiModel.popularProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.popularProductApiModel.popularProductsArray[index]
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
            if m.popularProductApiModel.popularProductsArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.popularMediaApiModel <> invalid AND m.popularMediaApiModel.success AND m.popularMediaApiModel.popularMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = popularMedia()
            for index= 0 to m.popularMediaApiModel.popularMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.popularMediaApiModel.popularMediaArray[index]
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
            if m.popularMediaApiModel.popularMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.recentAddedProductApiModel <> invalid AND m.recentAddedProductApiModel.success AND m.recentAddedProductApiModel.recentlyAddedProductsArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = recentlyAddedProducts()
            for index= 0 to m.recentAddedProductApiModel.recentlyAddedProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.recentAddedProductApiModel.recentlyAddedProductsArray[index]
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
            if m.recentAddedProductApiModel.recentlyAddedProductsArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.recentAddedMediaApiModel <> invalid AND m.recentAddedMediaApiModel.success AND m.recentAddedMediaApiModel.recentlyAddedMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = recentlyAddedMedia()
            for index= 0 to m.recentAddedMediaApiModel.recentlyAddedMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.recentAddedMediaApiModel.recentlyAddedMediaArray[index]
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
            if m.recentAddedMediaApiModel.recentlyAddedMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.basedOnFavoriteApiModel <> invalid AND m.basedOnFavoriteApiModel.success AND m.basedOnFavoriteApiModel.relatedMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = basedOnFavorites()
            for index = 0 to m.basedOnFavoriteApiModel.relatedMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                  dataObjet = m.basedOnFavoriteApiModel.relatedMediaArray[index]
                  rowItem.created_at = dataObjet.created_at
                  rowItem.title = dataObjet.title
                  rowItem.coverBgColor = m.appConfig.primary_color
                  rowItem.imageUri = dataObjet.small
                  rowItem.isMedia = dataObjet.is_media
                  rowItem.isItem = dataObjet.is_item
                  rowItem.isViewAll = false
                  
                  if dataObjet.is_item
                    rowItem.id = dataObjet.product_id
                    rowItem.count = dataObjet.media_count
                    rowItem.is_vertical_image = dataObjet.is_vertical_image
                  else
                    rowItem.id = dataObjet.resource_id
                    rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                  end if
                  
                  if getPostedVideoDayDifference(dataObjet.created_at) < 11
                        rowItem.isNew = true
                  else
                        rowItem.isNew = false
                  end if
            end for
            if m.basedOnFavoriteApiModel.relatedMediaArray.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         
         if m.myFavoriteApiModel <> invalid AND m.myFavoriteApiModel.success AND m.myFavoriteApiModel.items.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = myFavorites()
            for index = 0 to m.myFavoriteApiModel.items.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                  dataObjet = m.myFavoriteApiModel.items[index]
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
                    
                  else if dataObjet.item_type = "media"
                    rowItem.id = dataObjet.resource_id
                    rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                  end if
                  
                  if getPostedVideoDayDifference(dataObjet.created_at) < 11
                        rowItem.isNew = true
                  else
                        rowItem.isNew = false
                  end if
            end for
            if m.myFavoriteApiModel.items.Count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
         
         if m.productsAarray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = myContent()
            if m.productsAarray.count() >= 10
                n = 9
            else
                n = m.productsAarray.count()-1
            end if
            for index= 0 to n
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.productsAarray[index]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
                rowItem.coverBgColor = m.appConfig.primary_color
                rowItem.isMedia = false
                rowItem.isViewAll = false
                rowItem.is_vertical_image = dataObjet.is_vertical_image
                rowItem.isItem = dataObjet.is_item
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
            end for
            if m.productsAarray.count() >= 10
                rowItem = row.CreateChild("HomeRowListItemData")
                rowItem.isViewAll = true
            end if
         end if
             
         else                                          'else case for TVOD
            if m.productsAarray.count() < 9
                m.homeRowList.itemComponentName = "Home2xListItemLayout"
                m.homeRowList.itemSize = [200 * 9 + 100, 600]
                m.homeRowList.rowHeights = [600]
                m.homeRowList.rowItemSize = [ [675, 572] ]
                numberOfRows = (m.productsAarray.count() + 1) \ 2 
                n = 1
                m.numOfColumns = 2
            else
                m.homeRowList.itemComponentName = "Home3xListItemLayout"
                m.homeRowList.itemSize = [200 * 9 + 100, 445]
                m.homeRowList.rowHeights = [445]
                m.homeRowList.rowItemSpacing = [ [100, 0] ]
                m.homeRowList.rowItemSize = [ [448, 445] ]
                numberOfRows = (m.productsAarray.count() + 2) \ 3 
                n = 2
                m.numOfColumns = 3
            end if
            
            ind = 0
            for numRows = 0 to numberOfRows-1
                row = parentContentNode.CreateChild("ContentNode")
                for index = 0 to n
                      if ind < m.productsAarray.count()
                          rowItem = row.CreateChild("HomeRowListItemData")  
                          dataObjet = m.productsAarray[ind]
                          rowItem.id = dataObjet.product_id
                          rowItem.title = dataObjet.title
                          rowItem.imageUri = dataObjet.small
                          rowItem.count = dataObjet.media_count
                          rowItem.coverBgColor = m.appConfig.primary_color
                          rowItem.isMedia = false
                          rowItem.isItem = dataObjet.is_item
                          rowItem.is_vertical_image = dataObjet.is_vertical_image
                          if getPostedVideoDayDifference(dataObjet.created_at) < 11
                              rowItem.isNew = true
                          else
                              rowItem.isNew = false
                          end if
                      ind = ind + 1
                      end if
                end for 
'                if m.productsAarray.count() >= 7
'                    rowItem = row.CreateChild("HomeRowListItemData")
'                    rowItem.isViewAll = true
'                end if  
            end for 
         end if
         
         if m.isRefreshScreen
            startUpdateFocusTimer()
         end if
         
         return parentContentNode 
end function

sub updateFocus()
    m.isRefreshScreen = false
    m.homeRowList.setFocus(true)
    m.homeRowList.jumpToRowItem = m.focusedItem
end sub

sub startUpdateFocusTimer()
    m.updateFocusTimer = m.top.findNode("updateFocusTimer")
    m.updateFocusTimer.control = "start"
    m.updateFocusTimer.ObserveField("fire","updateFocus")
end sub

sub initFields() 
    homeBackground = m.top.FindNode("homeBackground")
    homeBackground.color = homeBackground() 
    m.Error_text  = m.top.FindNode("Error_text")
    m.homeRowList = m.top.FindNode("homeRowList")  
    m.navBar = m.top.FindNode("NavigationBar") 
End sub

sub hideFields()
    m.homeRowList.visible = false
    m.navBar.visible = false
End sub

sub showFields()
    m.homeRowList.visible = true
    m.navBar.visible = true 
End sub

sub manageNavBar()
    if getValueInRegistryForKey("isCategoryValue") <> "true"
        m.buttonCategoryOpen.visible = false
    end if
End sub

sub homeRowList()
    m.homeRowList.visible = true
    m.homeRowList.SetFocus(false)
    m.homeRowList.unobserveField("rowItemSelected")
    m.homeRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.homeRowList.content = getGridRowListContent()
End sub

function onRowItemSelected() as void
        row = m.homeRowList.rowItemSelected[0]
        col = m.homeRowList.rowItemSelected[1]
'        print "**********Row is *********";row
'        print "**********col is *********";col
'        print "itemFocused >>> ";m.homeRowList.itemFocused
        m.focusedItem = [row,col]
        if col >= 10
            goTViewAllScreen(m.homeRowList.content.getChild(m.homeRowList.itemFocused).title)
        else
            listTitle = m.homeRowList.content.getChild(m.homeRowList.itemFocused).title
            if m.isSVOD = false
                index = (m.numOfColumns*row) + col
                goToTVODProductDetailScreen(index)
            else if listTitle = myFavorites()
                goToFavDetail(listTitle, col)
            else if listTitle = basedOnFavorites()
                goToBasedOnFavDetail(listTitle, col)
            else if listTitle = featuredRecent() OR listTitle = featuredMedia() OR listTitle = popularMedia() OR listTitle = recentlyAddedMedia()
                goToMediaDetailScreen(listTitle, col)
            else
                goToProductDetailScreen(listTitle, col)
            end if
        end if  
end function

sub goToBasedOnFavDetail(listTitle as String, column as Integer)
    if m.basedOnFavoriteApiModel.relatedMediaArray[column].is_item
        goToProductDetailScreen(listTitle, column)
    else
        goToMediaDetailScreen(listTitle, column)
    end if
end sub

sub goToFavDetail(listTitle as String, column as Integer)
'    col = m.myFavoriteApiModel.items.count()-1-column
'    print "m.myFavoriteApiModel.items.count()-1-column >> "; col
    if m.myFavoriteApiModel.items[column].item_type = "product"
        goToProductDetailScreen(listTitle, column)
    else
        goToMediaDetailScreen(listTitle, column)
    end if
end sub

sub goToTVODProductDetailScreen(index as integer)
    m.productDetail = m.top.createChild("ProductDetailScreen")
    m.top.setFocus(false)
    m.productDetail.setFocus(true)
    m.productDetail.product_id = m.productsAarray[index].product_id
end sub

sub goToProductDetailScreen(titleText as String, column as Integer)
    m.productDetail = m.top.createChild("ProductDetailScreen")
    m.top.setFocus(false)
    m.productDetail.setFocus(true)
    if titleText = featuredProducts()
        m.productDetail.product_id = m.featureProductsApiModel.featuredProductsArray[column].product_id
    else if titleText = popularProducts()
        m.productDetail.product_id = m.popularProductApiModel.popularProductsArray[column].product_id
    else if titleText = recentlyAddedProducts()
        m.productDetail.product_id = m.recentAddedProductApiModel.recentlyAddedProductsArray[column].product_id
    else if titleText = myFavorites()
        m.productDetail.product_id = m.myFavoriteApiModel.items[column].product_id
    else if titleText = myContent()
        m.productDetail.product_id = m.productsAarray[column].product_id
    else if titleText = basedOnFavorites()
        m.productDetail.product_id = m.basedOnFavoriteApiModel.relatedMediaArray[column].product_id
    end if
end sub

sub goToMediaDetailScreen(titleText as String, column as Integer)
    m.mediaDetail = m.top.createChild("MediaDetailScreen")
    m.top.setFocus(false)
    m.mediaDetail.setFocus(true)
    if titleText = featuredMedia()
        m.mediaDetail.resource_id = m.featureMediaApiModel.featuredMediaArray[column].resource_id
    else if titleText = popularMedia()
        m.mediaDetail.resource_id = m.popularMediaApiModel.popularMediaArray[column].resource_id
    else if titleText = recentlyAddedMedia()
        m.mediaDetail.resource_id = m.recentAddedMediaApiModel.recentlyAddedMediaArray[column].resource_id
    else if titleText = myFavorites()
        m.mediaDetail.resource_id = m.myFavoriteApiModel.items[column].resource_id
    else if titleText = featuredRecent()
        m.mediaDetail.resource_id = m.recentlyViewedApiModel.recentMediaArray[column].resource_id
    else if titleText = basedOnFavorites()
        m.mediaDetail.resource_id = m.basedOnFavoriteApiModel.relatedMediaArray[column].resource_id  
    end if
end sub

sub goTViewAllScreen(titleText as String)
    if titleText = myFavorites()
        m.viewAllScreen = m.top.createChild("FavoriteViewAll")
    else if titleText = basedOnFavorites()
        m.viewAllScreen = m.top.createChild("BasedOnFavoriteViewAll")
        dataObjet = m.myFavoriteApiModel.items[m.basedOnFavId]
        if dataObjet.item_type = "product"
            m.viewAllScreen.itemId = dataObjet.product_id
            m.viewAllScreen.isProduct = true
        else if dataObjet.item_type = "media"
            m.viewAllScreen.itemId = dataObjet.resource_id
            m.viewAllScreen.isProduct = false
        end if
    else
        m.viewAllScreen = m.top.createChild("ViewAllScreen")
    end if
    
    m.top.setFocus(false)
    m.viewAllScreen.setFocus(true)
    m.viewAllScreen.titleText = titleText
    m.viewAllScreen.primaryColor = m.appConfig.primary_color
    if titleText = myContent()
        m.viewAllScreen.contentArray = m.productsAarray
    end if
    
end sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "onkeyevent Home Screen  key >";key
        if key = "right" 
            print "key = right"
            m.homeRowList.setFocus(true)
            m.homeRowList.translation = [260, 60]
            m.buttonHomeClose.uri = "pkg:/images/$$RES$$/Home Focused.png" 
            showCloseState()
            result = true
        else if key = "left" 
            print "key = left"
            row = m.homeRowList.rowItemFocused[0]
            col = m.homeRowList.rowItemFocused[1]
            if col = 0 AND m.homeRowList.hasFocus()
                m.homeRowList.setFocus(false)
                m.homeRowList.translation = [480, 60]
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
            setValueInRegistryForKey("isHome","true")
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
            else if m.viewAllScreen <> invalid
                m.viewAllScreen.setFocus(false)
                m.viewAllScreen = invalid
                if m.top.getScene().isRefreshOnBack
                    updateScreen()
                else
                    m.homeRowList.setFocus(true)
                    m.homeRowList.jumpToRowItem = m.focusedItem
                end if
                result = true
            else if m.mediaDetail <> invalid
                m.mediaDetail.setFocus(false)
                m.mediaDetail = invalid
                if m.top.getScene().isRefreshOnBack
                    updateScreen()
                else
                    m.homeRowList.setFocus(true)
                    m.homeRowList.jumpToRowItem = m.focusedItem
                end if
                result = true
            else if m.productDetail <> invalid
                m.productDetail.setFocus(false)
                m.productDetail = invalid
                if m.top.getScene().isRefreshOnBack
                    updateScreen()
                else
                    m.homeRowList.setFocus(true)
                    m.homeRowList.jumpToRowItem = m.focusedItem
                end if
                result = true
            else
                print "Switch Account invalid else block";m.top.getParent().getChildCount()
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
    if m.isSVOD
        showProgressDialog()
        callHomeSVODApis()
    else
        callUserApi()
    end if
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
    callUserApi()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub
