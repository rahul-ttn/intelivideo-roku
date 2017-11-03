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
        categoryItemModel = CreateObject("roSGNode", "CategoryItemModel")
        categoryItemModel.success = false
        m.top.content = categoryItemModel
     end if
end sub

sub parseApiResponse(response As Object)
    categoryItemModel = CreateObject("roSGNode", "CategoryItemModel")
    if m.responseCode = 200
        categoryItemModel.code = 200
        categoryItemModel.success = true
  
        objectsItemsArray = CreateObject("roArray", response.items.count(), false)
        for each item in response.items
            itemModel = CreateObject("roSGNode", "CategoryItemArrayModel")
            itemModel.created_at = item.created_at
            itemModel.title = item.title
            itemModel.item_type = item.item_type
            itemModel.favorite = item.favorite
            
            if item.item_type = "product"
                itemModel.product_id = item.product_id
                itemModel.media_count = item.media_count
                itemModel.is_media = false
                itemModel.is_item = true
                if item.images.horizontal_cover_art <> invalid
                    itemModel.is_vertical_image = false
                    itemModel.thumbnail = item.images.horizontal_cover_art.thumbnail
                else if item.images.vertical_cover_art <> invalid
                    itemModel.is_vertical_image = true
                    itemModel.thumbnail = item.images.vertical_cover_art.thumbnail
                else if item.images.banner_image <> invalid
                    itemModel.is_vertical_image = false
                    itemModel.thumbnail = item.images.banner_image.thumbnail
                end if
            else if item.item_type = "media"
                itemModel.resource_id = item.resource_id
                itemModel.type = item.type
                itemModel.duration = item.duration
                itemModel.is_item = false
                itemModel.thumbnail = item.cover_art.thumbnail
                if item.type = "Video" OR item.type = "Audio"
                    itemModel.is_media = true
                else
                    itemModel.is_media = false
                end if  
            end if
            
            objectsItemsArray.Push(itemModel)
        end for
        categoryItemModel.items = objectsItemsArray
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        categoryItemModel.pageInfo =  pageInfoModel 
    else 
        categoryItemModel.success = false
        categoryItemModel.error = apiErrorMessage()
    end if
    
    m.top.content = categoryItemModel

end sub
