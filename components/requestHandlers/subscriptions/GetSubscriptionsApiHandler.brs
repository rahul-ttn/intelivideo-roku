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
        subscriptionModel = CreateObject("roSGNode", "GetSubscriptionModel")
        subscriptionModel.success = false
        m.top.content = subscriptionModel
     end if
end sub

sub parseApiResponse(response As Object)
    subscriptionModel = CreateObject("roSGNode", "GetSubscriptionModel")
    if m.responseCode = 200
        subscriptionModel.code = 200
        subscriptionModel.success = true
        
        itemArray = CreateObject("roArray", response.items.count(), false)
        for each item in response.items
            itemModel = CreateObject("roSGNode", "SubscriptionItemModel")
            itemModel.product_id = item.product_id
            itemModel.key = item.key
            itemModel.title = item.title
            itemModel.description = item.description
            itemModel.long_description = item.long_description
            
            if item.images <> invalid AND item.images.horizontal_cover_art <> invalid
                itemModel.thumbnail = item.images.horizontal_cover_art.thumbnail
            else if item.images <> invalid AND item.images.vertical_cover_art <> invalid
                itemModel.thumbnail = item.images.vertical_cover_art.thumbnail
            else if item.images <> invalid AND item.images.banner_image <> invalid
                itemModel.thumbnail = item.images.banner_image.thumbnail
            end if
            
            priceArray = CreateObject("roArray", item.prices.count(), false)
            for each price in item.prices
                priceModel = CreateObject("roSGNode", "pricesModel")
                priceModel.price_id = price.price_id
                priceModel.amount = price.amount
                priceModel.recurring_amount = price.recurring_amount
                priceModel.trial_days = price.trial_days
                priceModel.frequency = price.frequency
                priceModel.button_text = price.button_text
                priceModel.name = price.name
                priceModel.external_mapping_id = price.external_mapping_id
                
                priceArray.Push(priceModel)
            end for
            
            itemModel.prices = priceArray
            itemArray.Push(itemModel)
        end for
        subscriptionModel.items = itemArray
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        subscriptionModel.pageInfo =  pageInfoModel 
        
    else if response <> invalid AND response.error <> invalid
        subscriptionModel.success = false
        subscriptionModel.error = response.error
    else
        subscriptionModel.success = false
    end if
 
    m.top.content = subscriptionModel

end sub

