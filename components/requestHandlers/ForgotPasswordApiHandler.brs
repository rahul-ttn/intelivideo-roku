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
        baseModel = CreateObject("roSGNode", "BaseModel")
        baseModel.success = false
        m.top.content = baseModel
     end if
end sub

sub parseApiResponse(response As Object)
    baseModel = CreateObject("roSGNode", "BaseModel")
    
    if(m.responseCode = 200)
        baseModel.success = true
        baseModel.message = response.message
    else if(response.error <> invalid)
        baseModel.success = false
        baseModel.error = response.error
    end if
    
    m.top.content = baseModel

end sub