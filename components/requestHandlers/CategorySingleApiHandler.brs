sub init()
    m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callGetApi(m.top.uri)
     if response <> invalid
        print "Response valid SINGLE API HANDLER"
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseApiResponse(json)
     else
        print "Response not valid SINGLE API HANDLER"
        singleCategoryModel = CreateObject("roSGNode", "SingleCategoryModel")
        singleCategoryModel.success = false
        m.top.content = singleCategoryModel
     end if
end sub

sub parseApiResponse(response As Object)
    singleCategoryModel = CreateObject("roSGNode", "SingleCategoryModel")
    if m.responseCode = 200
        singleCategoryModel.code = 200
        singleCategoryModel.success = true
        singleCategoryModel.id = response.id
        singleCategoryModel.name = response.name
        
        itemArray = CreateObject("roArray", response.categorized.items.count(), false)
        for each item in response.categorized.items
            categoryItemModel = CreateObject("roSGNode", "CategoryItemArrayModel")
            categoryItemModel.created_at = item.created_at
            categoryItemModel.title = item.title
            categoryItemModel.item_type = item.item_type
            
            if item.item_type = "product"
                categoryItemModel.product_id = item.product_id
                categoryItemModel.media_count = item.media_count
                categoryItemModel.is_media = false
                categoryItemModel.is_item = true
                if item.images <> invalid
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
        
        if response.children <> invalid
            childrenArray = CreateObject("roArray", response.children.count(), false)
            for each child in response.children
                childrenItemModel = CreateObject("roSGNode", "CategoryChildrenItemModel")
                childrenItemModel.id = child.id
                childrenItemModel.name = child.name
                childrenArray.push(childrenItemModel)
            end for
            singleCategoryModel.children = childrenArray 
        end if
        
    else 
        print "SINGLE API HANDLER FAILURE>>>>>>"
        singleCategoryModel.success = false
        singleCategoryModel.error = apiErrorMessage()
    end if
    
    m.top.content = singleCategoryModel

end sub

