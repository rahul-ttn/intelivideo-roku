sub init()
 m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callGetApi(m.top.uri)
     if response <> invalid
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseApiResponse(json)
     else
        featureProductModel = CreateObject("roSGNode", "FeatureProductModel")
        featureProductModel.success = false
        m.top.content = featureProductModel
     end if
end sub

sub parseApiResponse(response As Object)
    featureProductModel = CreateObject("roSGNode", "FeatureProductModel")
    if m.responseCode = 200
        featureProductModel.code = 200
        featureProductModel.success = true
        if m.top.dataType = "search"
            products = response.products.results
        else
            products = response.products
        end if
        
        productArray = CreateObject("roArray", products.count(), false)
        for each productItem in products
            productModel = CreateObject("roSGNode", "ProductDataModel")
            productModel.product_id = productItem.product_id
            productModel.title = productItem.title
            productModel.media_count = productItem.media_count
            productModel.created_at = productItem.created_at
            productModel.is_media = false
            productModel.is_item = true
            
            if productItem.images.horizontal_cover_art <> invalid
                productModel.small = productItem.images.horizontal_cover_art.small
            else if productItem.images.banner_image <> invalid
                productModel.small = productItem.images.banner_image.small
            end if
            
            productArray.Push(productModel)
        end for
        
        if m.top.dataType = "feature"
            featureProductModel.featuredProductsArray = productArray
        else if m.top.dataType = "popular"
            featureProductModel.popularProductsArray = productArray
        else if m.top.dataType = "recentAdded"
            featureProductModel.recentlyAddedProductsArray = productArray
        else if m.top.dataType = "search"
            featureProductModel.searchProductsArray = productArray
            response = response.products
        end if 
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        featureProductModel.pageInfo =  pageInfoModel 
    else 
        featureProductModel.error = apiErrorMessage()
        featureProductModel.success = false
    end if
    
    m.top.content = featureProductModel

end sub