sub init()
 m.top.functionName = "callUserApiHandler"
end sub

sub callUserApiHandler()
     response = callGetApi(m.top.uri)
     if response <> invalid
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseApiResponse(json)
     else
        userApiModel = CreateObject("roSGNode", "AuthTokenModel")
        userApiModel.success = false
        m.top.content = userApiModel
     end if
end sub

sub parseApiResponse(response As Object)
    userApiModel = CreateObject("roSGNode", "UserApiModel")
    if m.responseCode = 200
        userApiModel.success = true
        appConfigModel = CreateObject("roSGNode", "AppConfigModel")
        appConfigModel.base_theme = response.app_config.base_theme
        appConfigModel.primary_color = response.app_config.primary_color
        appConfigModel.secondary_color = response.app_config.secondary_color
        appConfigModel.display_categories = response.app_config.display_categories
        appConfigModel.privacy_policy = response.app_config.privacy_policy
        appConfigModel.terms_of_service = response.app_config.terms_of_service
        userApiModel.appConfigModel = appConfigModel
        
        userModel = CreateObject("roSGNode", "UserModel")
        userModel.id = response.user.id
        userModel.first_name = response.user.first_name
        userModel.last_name = response.user.last_name
        userModel.email = response.user.email
        userModel.company = response.user.company
        userModel.account_id = response.user.account_id
        userApiModel.userModel = userModel
        
        productsItems = response.products.items
        productArray = CreateObject("roArray", productsItems.count(), false)
        for each productItem in productsItems
            productModel = CreateObject("roSGNode", "ProductDataModel")
            productModel.product_id = productItem.product_id
            productModel.title = productItem.title
            productModel.media_count = productItem.media_count
            productModel.created_at = productItem.created_at
            if productItem.images <>invalid
                if productItem.images.horizontal_cover_art <> invalid
                    productModel.small = productItem.images.horizontal_cover_art.small
                else if productItem.images.banner_image <> invalid
                    productModel.small = productItem.images.banner_image.small
                end if
            end if
            productArray.Push(productModel)
        end for
        userApiModel.productsArray = productArray
        
        subsItems = response.subscriptions.items
        subsArray = CreateObject("roArray", subsItems.count(), false)
        for each subsItem in subsItems
            subsModel = CreateObject("roSGNode", "ProductDataModel")
            subsModel.product_id = subsItem.product_id
            subsModel.title = subsItem.title
            subsModel.media_count = subsItem.media_count
            subsModel.created_at = subsItem.created_at
            if subsItem.images <>invalid
                if subsItem.images.horizontal_cover_art <> invalid
                    subsModel.small = subsItem.images.horizontal_cover_art.small
                else if subsItem.images.banner_image <> invalid
                    subsModel.small = subsItem.images.banner_image.small
                end if
            end if
            
            subsArray.Push(subsModel)
        end for
        userApiModel.subscriptionsArray = subsArray
       
    else 
        userApiModel.success = false
        userApiModel.error = apiErrorMessage()
    end if
    m.top.content = userApiModel
    
    print userApiModel
end sub