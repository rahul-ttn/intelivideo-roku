sub init()
 m.top.functionName = "callUserApiHandler"
end sub

sub callUserApiHandler()
     response = callGetApi(m.top.uri)
     m.responseCode = response.GetResponseCode()
     responseString = response.GetString()
     json = ParseJSON(response)
     parseApiResponse(json)
end sub

sub parseApiResponse(response As Object)
    userApiModel = CreateObject("roSGNode", "UserApiModel")
    
    if(m.responseCode = 200)
        userApiModel.primary_color = response.app_config.primary_color
    else if(response.error <> invalid)
        userApiModel.error = response.error
    end if
    
    m.top.content = userApiModel
    
    print userApiModel

end sub