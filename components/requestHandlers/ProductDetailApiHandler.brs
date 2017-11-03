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
        productDetailModel = CreateObject("roSGNode", "ProductDetailModel")
        productDetailModel.success = false
        m.top.content = productDetailModel
     end if
end sub

sub parseApiResponse(response As Object)
    productDetailModel = CreateObject("roSGNode", "ProductDetailModel")
    if m.responseCode = 200
        productDetailModel.code = 200
        productDetailModel.success = true
        productDetailModel.product_id = response.product.product_id
        productDetailModel.title = response.product.title
        productDetailModel.favorite = response.product.favorite
        
        if response.product.long_description <> invalid
            productDetailModel.description = response.product.long_description
        else
            productDetailModel.description = response.product.description
        end if
        
        productDetailModel.media_count = response.product.media_count
        if response.product.images.horizontal_cover_art <> invalid
            productDetailModel.original = response.product.images.horizontal_cover_art.small
        else if response.product.images.banner_image <> invalid
            productDetailModel.original = response.product.images.banner_image.small
        end if
        productDetailModel.created_at = response.product.created_at
        
        mediaObjects = response.media.objects
        mediaArray = CreateObject("roArray", mediaObjects.count(), false)
        for each productItem in mediaObjects
            mediaModel = CreateObject("roSGNode", "MediaDataModel")
            mediaModel.resource_id = productItem.resource_id
            mediaModel.title = productItem.title
            mediaModel.type = productItem.type
            mediaModel.duration = productItem.duration
            mediaModel.small = productItem.cover_art.small
            mediaModel.created_at = productItem.created_at
            mediaModel.description = productItem.description
            mediaModel.favorite = productItem.favorite
            
            mediaArray.Push(mediaModel)
            
        end for
        productDetailModel.objects = mediaArray
    else 
        productDetailModel.error = apiErrorMessage()
        productDetailModel.success = false
    end if
    
    m.top.content = productDetailModel

end sub