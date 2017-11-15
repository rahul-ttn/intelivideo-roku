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
        browseCatalogModel = CreateObject("roSGNode", "BrowseCatalogModel")
        browseCatalogModel.success = false
        m.top.content = browseCatalogModel
     end if
end sub

sub parseApiResponse(response As Object)
    browseCatalogModel = CreateObject("roSGNode", "BrowseCatalogModel")
    if m.responseCode = 200
        browseCatalogModel.code = 200
        browseCatalogModel.success = true
        products = response.collections.items
        
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
                productModel.is_vertical_image = false
                productModel.small = productItem.images.horizontal_cover_art.thumbnail
            else if productItem.images.vertical_cover_art <> invalid
                productModel.is_vertical_image = true
                productModel.small = productItem.images.vertical_cover_art.thumbnail
            else if productItem.images.banner_image <> invalid
                productModel.is_vertical_image = false
                productModel.small = productItem.images.banner_image.thumbnail
            end if
            
            productArray.Push(productModel)
        end for
        
        if m.top.dataType = "feature"
            browseCatalogModel.featuredProductsArray = productArray
        else if m.top.dataType = "popular"
            browseCatalogModel.popularProductsArray = productArray
        else if m.top.dataType = "recentAdded"
            browseCatalogModel.recentlyAddedProductsArray = productArray
        end if 
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        browseCatalogModel.pageInfo =  pageInfoModel 
    else 
        browseCatalogModel.error = apiErrorMessage()
        browseCatalogModel.success = false
    end if
    
    m.top.content = browseCatalogModel

end sub