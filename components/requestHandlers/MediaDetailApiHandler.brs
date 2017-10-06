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
        mediaModel.small = response.cover_art.original
        mediaModel.created_at = response.created_at
        mediaModel.description = response.description
    else 
        mediaModel.success = false
        mediaModel.error = apiErrorMessage()
    end if
    
    m.top.content = mediaModel

end sub