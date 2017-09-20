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
        featureMediaModel = CreateObject("roSGNode", "FeatureMediaModel")
        featureMediaModel.success = false
        m.top.content = featureMediaModel
     end if
end sub

sub parseApiResponse(response As Object)
    featureMediaModel = CreateObject("roSGNode", "FeatureMediaModel")
    featureMediaModel.success = true
    if(m.responseCode = 200)
        featureMediaModel.code = 200
        medias = response.media
        print "media >> " ; medias  
    else if(response.error <> invalid)
        featureMediaModel.error = response.error
    end if
    
    m.top.content = featureMediaModel

end sub