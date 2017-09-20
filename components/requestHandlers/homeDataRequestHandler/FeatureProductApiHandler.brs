sub init()
 m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callGetApi(m.top.uri)
     if(response <> invalid)
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
    featureProductModel.success = true
    if(m.responseCode = 200)
        featureProductModel.code = 200
        products = response.products
        productArray = CreateObject("roArray", products.count(), false)
        for each productItem in products
            productModel = CreateObject("roSGNode", "ProductDataModel")
            productModel.product_id = productItem.product_id
            productModel.title = productItem.title
            productModel.media_count = productItem.media_count
            productModel.small = productItem.images.horizontal_cover_art.small
            
            productArray.Push(productModel)
        end for
        
        if m.top.dataType = "feature"
            featureProductModel.featuredProductsArray = productArray
        else if m.top.dataType = "popular"
            featureProductModel.popularProductsArray = productArray
        else if m.top.dataType = "recentAdded"
            featureProductModel.recentlyAddedProductsArray = productArray
        end if 
        print "productArray >>> ";productArray
    else if(response.error <> invalid)
        featureProductModel.error = response.error
    end if
    
    m.top.content = featureProductModel

end sub