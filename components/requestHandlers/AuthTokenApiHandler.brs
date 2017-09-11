sub init()
 m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callPostApi(m.top.uri, m.top.header, m.top.params)
     m.responseCode = response.GetResponseCode()
     responseString = response.GetString()
     json = ParseJSON(response)
     parseApiResponse(json)
end sub

sub parseApiResponse(response As Object)
    authTokenModel = CreateObject("roSGNode", "AuthTokenModel")
    
    if(m.responseCode = 200)
        authTokenModel.access_token = response.access_token
        authTokenModel.refresh_token = response.refresh_token
    else if(response.error <> invalid)
        authTokenModel.error = response.error
    end if
    
    m.top.content = authTokenModel
    
    print authTokenModel

end sub