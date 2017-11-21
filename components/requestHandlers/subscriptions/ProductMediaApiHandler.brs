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
        productMediaModel = CreateObject("roSGNode", "ProductMediaModel")
        productMediaModel.success = false
        m.top.content = productMediaModel
     end if
end sub


sub parseApiResponse(response As Object)
    productMediaModel = CreateObject("roSGNode", "ProductMediaModel")
    if m.responseCode = 200
        productMediaModel.code = 200
        productMediaModel.success = true
  
        itemsArray = CreateObject("roArray", response.items.count(), false)
        for each item in response.items
            itemModel = CreateObject("roSGNode", "MediaDataModel")
            itemModel.resource_id = item.resource_id
            itemModel.type = item.type
            itemModel.title = item.title
            itemModel.duration = item.duration
            itemModel.small = item.cover_art.small
            itemModel.created_at = item.created_at
            itemModel.description = item.description
            
            itemsArray.Push(itemModel)
        end for
        productMediaModel.items = itemsArray
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        productMediaModel.pageInfo =  pageInfoModel 
    else 
        productMediaModel.success = false
        productMediaModel.error = apiErrorMessage()
    end if
    
    m.top.content = productMediaModel

end sub
