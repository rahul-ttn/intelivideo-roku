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
        mediaModel = CreateObject("roSGNode", "MediaDataModel")
        mediaModel.success = false
        m.top.content = mediaModel
     end if
end sub

sub parseApiResponse(response As Object)
    mediaModel = CreateObject("roSGNode", "MediaDataModel")
    if m.responseCode = 200
        mediaModel.code = 200
        mediaModel.success = true
        
        mediaModel.resource_id = response.resource_id
        mediaModel.type = response.type
        mediaModel.title = response.title
        mediaModel.duration = response.duration
        mediaModel.small = response.cover_art.small
        mediaModel.created_at = response.created_at
        mediaModel.description = response.description
        mediaModel.favorite = response.favorite
        if response.type = "Video" OR response.type = "Audio"
            mediaModel.is_media = true
        else
            mediaModel.is_media = false
        end if
        mediaModel.is_item = false
    else 
        mediaModel.success = false
        mediaModel.error = apiErrorMessage()
    end if
    
    m.top.content = mediaModel

end sub