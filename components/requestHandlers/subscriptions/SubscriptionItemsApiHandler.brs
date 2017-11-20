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
        
        'collection json parsing
        if response.collections <> invalid
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
                    productModel.small = productItem.images.horizontal_cover_art.small
                else if productItem.images.vertical_cover_art <> invalid
                    productModel.is_vertical_image = true
                    productModel.small = productItem.images.vertical_cover_art.small
                else if productItem.images.banner_image <> invalid
                    productModel.is_vertical_image = false
                    productModel.small = productItem.images.banner_image.small
                end if
                
                productArray.Push(productModel)
            end for
            
            if m.top.dataType = "feature"
                browseCatalogModel.featuredProductsArray = productArray
            else if m.top.dataType = "popular"
                browseCatalogModel.popularProductsArray = productArray
            else if m.top.dataType = "recent"
                browseCatalogModel.recentlyAddedProductsArray = productArray
            end if 
            
            pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
            pageInfoModel.total_items = response.collections.page_info.total_items
            pageInfoModel.total_pages = response.collections.page_info.total_pages
            pageInfoModel.first_page = response.collections.page_info.first_page
            pageInfoModel.last_page = response.collections.page_info.last_page
            pageInfoModel.previous_page = response.collections.page_info.previous_page
            pageInfoModel.next_page = response.collections.page_info.next_page
            pageInfoModel.out_of_bounds = response.collections.page_info.out_of_bounds
            browseCatalogModel.collectionPageInfo =  pageInfoModel 
            
        end if
        
        'media json parsing
        if response.media <> invalid
            medias = response.media.items
            mediaArray = CreateObject("roArray", medias.count(), false)
            for each mediaItem in medias
                mediaModel = CreateObject("roSGNode", "MediaDataModel")
                mediaModel.resource_id = mediaItem.resource_id
                mediaModel.type = mediaItem.type
                mediaModel.title = mediaItem.title
                mediaModel.duration = mediaItem.duration
                mediaModel.small = mediaItem.cover_art.small
                mediaModel.created_at = mediaItem.created_at
                mediaModel.description = mediaItem.description
                
                
                if mediaItem.type = "Video" OR mediaItem.type = "Audio"
                    mediaModel.is_media = true
                else
                    mediaModel.is_media = false
                end if
                mediaModel.is_item = false
                
                mediaArray.Push(mediaModel)
            end for
            
            if m.top.dataType = "feature"
                browseCatalogModel.featuredMediaArray = mediaArray
            else if m.top.dataType = "popular"
                browseCatalogModel.popularMediaArray = mediaArray
            else if m.top.dataType = "recent"
                browseCatalogModel.recentlyAddedMediaArray = mediaArray
            end if 
            
            pageModel = CreateObject("roSGNode", "PageInfoModel")
            pageModel.total_items = response.media.page_info.total_items
            pageModel.total_pages = response.media.page_info.total_pages
            pageModel.first_page = response.media.page_info.first_page
            pageModel.last_page = response.media.page_info.last_page
            pageModel.previous_page = response.media.page_info.previous_page
            pageModel.next_page = response.media.page_info.next_page
            pageModel.out_of_bounds = response.media.page_info.out_of_bounds
            browseCatalogModel.mediaPageInfo =  pageModel
            
        end if
    else 
        browseCatalogModel.error = apiErrorMessage()
        browseCatalogModel.success = false
    end if
    
    m.top.content = browseCatalogModel

end sub