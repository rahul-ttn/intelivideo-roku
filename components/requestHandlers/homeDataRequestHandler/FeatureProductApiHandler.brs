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
        print "products >> " ; products
        
    else if(response.error <> invalid)
        featureProductModel.error = response.error
    end if
    
    m.top.content = featureProductModel

end sub