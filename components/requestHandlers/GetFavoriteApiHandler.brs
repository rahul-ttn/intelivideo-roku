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
        singleCategoryModel = CreateObject("roSGNode", "FavoriteModel")
        singleCategoryModel.success = false
        m.top.content = singleCategoryModel
     end if
end sub

sub parseApiResponse(response As Object)
    singleCategoryModel = CreateObject("roSGNode", "FavoriteModel")
    if m.responseCode = 200
        singleCategoryModel.code = 200
        singleCategoryModel.success = true
        
        itemArray = CreateObject("roArray", response.items.count(), false)
        for each item in response.items
            categoryItemModel = CreateObject("roSGNode", "CategoryItemArrayModel")
            categoryItemModel.created_at = item.created_at
            categoryItemModel.title = item.title
            categoryItemModel.item_type = item.item_type
            
            if item.item_type = "product"
                categoryItemModel.product_id = item.product_id
                categoryItemModel.media_count = item.media_count
                categoryItemModel.is_media = false
                categoryItemModel.is_item = true
                if item.images.horizontal_cover_art <> invalid
                    categoryItemModel.is_vertical_image = false
                    categoryItemModel.thumbnail = item.images.horizontal_cover_art.thumbnail
                else if item.images.vertical_cover_art <> invalid
                    categoryItemModel.is_vertical_image = true
                    categoryItemModel.thumbnail = item.images.vertical_cover_art.thumbnail
                else if item.images.banner_image <> invalid
                    categoryItemModel.is_vertical_image = false
                    categoryItemModel.thumbnail = item.images.banner_image.thumbnail
                end if
            else if item.item_type = "media"
                categoryItemModel.resource_id = item.resource_id
                categoryItemModel.type = item.type
                categoryItemModel.duration = item.duration
                categoryItemModel.is_item = false
                categoryItemModel.thumbnail = item.cover_art.thumbnail
                if item.type = "Video" OR item.type = "Audio"
                    categoryItemModel.is_media = true
                else
                    categoryItemModel.is_media = false
                end if  
            end if
            
            itemArray.Push(categoryItemModel)
        end for
        singleCategoryModel.items = itemArray
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        singleCategoryModel.pageInfo =  pageInfoModel 
        
    else 
        singleCategoryModel.success = false
        singleCategoryModel.error = apiErrorMessage()
    end if
    
    m.top.content = singleCategoryModel

end sub

