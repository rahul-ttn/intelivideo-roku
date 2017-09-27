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
    if(m.responseCode = 200)
        featureMediaModel.code = 200
        featureMediaModel.success = true
        medias = response.media
        mediaArray = CreateObject("roArray", medias.count(), false)
        for each mediaItem in medias
            mediaModel = CreateObject("roSGNode", "MediaDataModel")
            mediaModel.resource_id = mediaItem.resource_id
            mediaModel.type = mediaItem.type
            mediaModel.title = mediaItem.title
            mediaModel.duration = mediaItem.duration
            mediaModel.small = mediaItem.cover_art.small
            mediaModel.created_at = mediaItem.cover_art.created_at
            
            mediaArray.Push(mediaModel)
        end for
        
        if m.top.dataType = "feature"
            featureMediaModel.featuredMediaArray = mediaArray
        else if m.top.dataType = "popular"
            featureMediaModel.popularMediaArray = mediaArray
        else if m.top.dataType = "recentAdded"
            featureMediaModel.recentlyAddedMediaArray = mediaArray
        end if 
        print "mediaArray >>> ";mediaArray
    else if(response.error <> invalid)
        featureMediaModel.success = false
        featureMediaModel.error = response.error
    end if
    
    m.top.content = featureMediaModel

end sub