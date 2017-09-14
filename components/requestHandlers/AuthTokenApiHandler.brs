sub init()
 m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callPostApi(m.top.uri, m.top.header, m.top.params)
     if(response <> invalid)
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseApiResponse(json)
     else
        authTokenModel = CreateObject("roSGNode", "AuthTokenModel")
        authTokenModel.success = false
        m.top.content = authTokenModel
     end if
end sub

sub parseApiResponse(response As Object)
    authTokenModel = CreateObject("roSGNode", "AuthTokenModel")
    
    if(m.responseCode = 200)
        authTokenModel.success = true
        authTokenModel.access_token = response.access_token
        authTokenModel.refresh_token = response.refresh_token
        
        setValueInRegistryForKey("isLogin", "true")
        setValueInRegistryForKey("authToken", response.access_token)
    else if(response.error <> invalid)
        authTokenModel.success = false
        authTokenModel.error = response.error
        setValueInRegistryForKey("isLogin", "false")
    end if
    
    m.top.content = authTokenModel

end sub