sub init()
 m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callPostApi(m.top.uri, m.top.header, m.top.params)
     if response <> invalid
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
    authTokenModel.code = m.responseCode
    if m.responseCode = 200
        authTokenModel.success = true
        authTokenModel.code = m.responseCode
        
        if m.top.dataType = "create_account"
            authTokenModel.access_token = response.user.token.access_token
            authTokenModel.refresh_token = response.user.token.refresh_token
        else
            authTokenModel.access_token = response.access_token
            authTokenModel.refresh_token = response.refresh_token
        end if
        
        setValueInRegistryForKey("isLogin", "true")
        setValueInRegistryForKey("authToken", response.access_token)
        setValueInRegistryForKey("refreshToken", response.refresh_token)
    else if response <> invalid AND response.error <> invalid
        authTokenModel.success = false
        authTokenModel.error = response.error
        setValueInRegistryForKey("isLogin", "false")
    else
        authTokenModel.success = false
        setValueInRegistryForKey("isLogin", "false")
    end if
    m.top.content = authTokenModel

end sub