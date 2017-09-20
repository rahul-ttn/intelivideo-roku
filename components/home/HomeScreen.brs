sub init()
    m.top.SetFocus(true)
    m.isProgressDialog = false
    m.counter = 0
    m.counterMaxValue = 6
    
    initFields()
    hideFields()
    callUserApi()
    setValueInRegistryForKey("isHome","true")
    m.switchAccount = invalid
End sub

sub callUserApi()
    if checkInternetConnection()
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "user?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.userApi = createObject("roSGNode","UserApiHandler")
        m.userApi.setField("uri",baseUrl)
        m.userApi.observeField("content","onUserApiResponse")
        m.userApi.control = "RUN"
    else
        showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub onUserApiResponse()
    userApiModel = m.userApi.content
    if(userApiModel.success)
        showFields()
    
        m.appConfig =  m.userApi.content.appConfigModel
        m.userData =  m.userApi.content.userModel
    
        initNavigationBar()
        
        callHomeDataApis()
    else
        hideProgressDialog()
        showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub callHomeDataApis()
    if checkInternetConnection()
        callFeatureProductsApi()
        callFeatureMediaApi()
        callPopularProductsApi()
        callPopularMediaApi()
        callRecentlyAddedProductsApi()
        callRecentlyAddedMediaApi()
    else
        showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub updateCounter()
    m.counter = m.counter + 1
    print "m.counter >> ";m.counter
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

sub onProductsResponse()
    updateCounter()
    getData()
end sub

sub onMediaResponse()
    updateCounter()
    getData()
end sub

sub getData()
    if m.counter = m.counterMaxValue
        hideProgressDialog()
        m.featureProductsApiModel = m.featureProductApi.content
        m.featureMediaApiModel = m.featureMediaApi.content
        
        m.popularProductApiModel = m.popularProductApi.content
        m.popularMediaApiModel = m.popularMediaApi.content
        
        m.recentAddedProductApiModel = m.recentAddedProductApi.content
        m.recentAddedMediaApiModel = m.recentAddedMediaApi.content
        
        if(m.featureProductsApiModel.success AND m.featureMediaApiModel.success AND m.popularProductApiModel.success AND m.popularMediaApiModel.success AND m.recentAddedProductApiModel.success AND m.recentAddedMediaApiModel.success)
            homeRowList() 
        else
            print "featureProductApiModel.fail"
            showNetworkErrorDialog(networkErrorTitle(), networkErrorMessage())
        end if
    end if
end sub

function getGridRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         if m.featureProductsApiModel.featuredProductsArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = "Featured Products"
            for index= 0 to m.featureProductsApiModel.featuredProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.featureProductsApiModel.featuredProductsArray[index]
                print "dataObjet >>> ";dataObjet
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
            end for
         end if
         
         if m.featureMediaApiModel.featuredMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = "Featured Media"
            for index= 0 to m.mediaApiModel.featureMediaApiModel.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.featureMediaApiModel.featuredMediaArray[index]
                rowItem.id = dataObjet.resource_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.duration
            end for
         end if
         
         if m.popularProductApiModel.popularProductsArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = "Popular Products"
            for index= 0 to m.popularProductApiModel.popularProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.popularProductApiModel.popularProductsArray[index]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
            end for
         end if
         
         if m.popularMediaApiModel.popularMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = "Popular Media"
            for index= 0 to m.popularMediaApiModel.popularMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.popularMediaApiModel.popularMediaArray[index]
                rowItem.id = dataObjet.resource_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.duration
            end for
         end if
         
         if m.recentAddedProductApiModel.recentlyAddedProductsArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = "Recently Added Products"
            for index= 0 to m.recentAddedProductApiModel.recentlyAddedProductsArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.recentAddedProductApiModel.recentlyAddedProductsArray[index]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
            end for
         end if
         
         if m.recentAddedMediaApiModel.recentlyAddedMediaArray.count() <> 0
            row = parentContentNode.CreateChild("ContentNode")
            row.title = "Recently Added Media"
            for index= 0 to m.recentAddedMediaApiModel.recentlyAddedMediaArray.Count()-1
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.recentAddedMediaApiModel.recentlyAddedMediaArray[index]
                rowItem.id = dataObjet.resource_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.duration
            end for
         end if
         return parentContentNode 
end function

sub showLoader()
        m.loaderScreen = m.top.createChild("ACLoaderScreen")
        m.loaderScreen.visible = true
        m.top.setFocus(false)
        m.loaderScreen.setFocus(true)
end sub

sub hideLoader()
        m.loaderScreen.visible = false
        m.top.setFocus(true)
        m.loaderScreen.setFocus(false)
        if(m.buttonHomeOpen <> invalid AND m.buttonHomeOpen <> "")
            m.buttonHomeOpen.SetFocus(true)
        end if
end sub

sub initFields() 
    homeBackground = m.top.FindNode("homeBackground")
    homeBackground.color = homeBackground() 
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
    m.homeRowList.SetFocus(false)
    m.homeRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.homeRowList.content = getGridRowListContent()
End sub



function onRowItemSelected() as void
        print "***** Some's wish is ********";m.homeRowList.rowItemFocused
        row = m.homeRowList.rowItemFocused[0]
        col = m.homeRowList.rowItemFocused[1]
        print "**********Row is *********";row
        print "**********col is *********";col
end function

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "onkeyevent Home Screen  key >";key
        if key = "right" 
            print "key = right"
            m.homeRowList.setFocus(true)
            m.homeRowList.translation = [350, 60]
            showCloseState()
            result = true
        else if key = "left" 
            print "key = left"
            row = m.homeRowList.rowItemFocused[0]
            col = m.homeRowList.rowItemFocused[1]
            if col = 0 AND m.homeRowList.hasFocus()
                m.homeRowList.setFocus(false)
                m.homeRowList.translation = [500, 60]
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
                m.switchAccount = invalid
                result = true
            else
                m.top.visible = false
                result = false
            end if
        end if           
    end if
    return result 
End Function 

Sub ExitUserInterface()
    print "closing app"
    'End
End Sub