sub init()
 m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callPostApi(m.top.uri, m.top.header, m.top.params)
     errorCode = response.GetResponseCode()
     print "errorCode " ; errorCode
     responseString = response.GetString()
     json = ParseJSON(response)
     parseApiResponse(json)
end sub

sub parseApiResponse(response As Object)
    authTokenModel = CreateObject("roSGNode", "AuthTokenModel")
    
    
    m.top.content = authTokenModel
    
    print authTokenModel

end sub