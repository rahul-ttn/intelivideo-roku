Function getPortConnectionTime() as integer
'time in seconds
    return 20*1000 
End Function

Function callGetApi(url as String) as object
    print "url is :";url
    return callApi(url,invalid,false,"")
End Function

Function callPostApi(url as String,headers as object,params as String) as object
    print "til post method"
    return callApi(url,headers,true,params)
End Function

'header as roAssociativeArray
Function callApi(url as String,headers as Object,isPostApi as boolean,params as String)
    print "url is :";type(params)
    print "headers are :";headers
    print "params are :";params
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.EnableEncodings(true)
    request.RetainBodyOnError(true)
    print "url that we are going to hit to servr "+url
    request.SetUrl(url)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("Authorization", "Bearer")
    request.AddHeader("X-IV-Device", "roku")
    request.AddHeader("Content-Type", "application/json")
    request.AddHeader("accept", "json")
    
    print "header while creating request ";headers
    If type(headers)="roAssociativeArray" Then
        For Each key in headers
        print "header key is "UCase(key)
        print "header value is "headers[key]
            request.AddHeader(UCase(key),headers[key])
        End For
    End If
     
    request.InitClientCertificates()   
    print url
    checkRokuConnection = CreateObject("roDeviceInfo")
    If checkrokuconnection.GetLinkStatus() Then
    
    if isPostApi = true
        requestType = request.AsyncPostFromString(params)
        print "true part request is";requestType
    else
        requestType = request.AsyncGetToString()
         print "else part request is";requestType
    end if    
        timer=createobject("roTimeSpan")
        timer.Mark()
        print timer
        If (requestType)
            while (true)
                msg = wait(getPortConnectionTime(), port)
                print "response is " ; msg
                If (type(msg) = "roUrlEvent") then
                    code = msg.GetResponseCode()
                    print "success code >> ";code
                    return msg  
                Else 
                    request.AsyncCancel()
                    print "error message >> "; msg
                    return invalid
                End If
            End while
        End If
     Else 
     print "checkrokuconnection false >>>>> "
     return invalid
     End If
     print "NHBJCBSBOBCO >>>>> "
     return invalid
    
End Function

Function SimpleJSONAssociativeArray1( jsonArray As Object ) As String
    jsonString = "{"
    
    For Each key in jsonArray
        jsonString = jsonString + Chr(34) + key + Chr(34) + ":"
        value = jsonArray[ key ]
        If Type( value ) = "roString" Then
            jsonString = jsonString + Chr(34) + value + Chr(34)
        else if Type( value ) = "String" Then
            jsonString = jsonString + Chr(34) + value + Chr(34)
        Else If Type( value ) = "roInt" Or Type( value ) = "roFloat" Then
            jsonString = jsonString + value.ToStr()
        Else If Type( value ) = "roInteger" Then
            jsonString = jsonString + value.ToStr()
        Else If Type( value ) = "roBoolean" Then
            jsonString = jsonString + IIf( value, "true", "false" )
        Else If Type( value ) = "roArray" Then
            jsonString = jsonString + SimpleJSONArray( value )
        Else If Type( value ) = "roAssociativeArray" Then
            jsonString = jsonString + SimpleJSONBuilder( value )
        End If
        jsonString = jsonString + ","
    Next
    If Right( jsonString, 1 ) = "," Then
        jsonString = Left( jsonString, Len( jsonString ) - 1 )
    End If
    
    jsonString = jsonString + "}"
    Return jsonString
End Function


Function prepareUrlWithBodyData(url as String)

End Function

Function ParseXML(str As String) As Object 'Takes in the content feed as a string
print str
    if str = invalid return invalid  'if the response is invalid, return invalid
    xml = CreateObject("roXMLElement")     
    xmlparse = xml.Parse(str)    
     
    if not xml.Parse(str) return invalid 'If the string cannot be parsed, return invalid
    return xml 'returns parsed XML if not invalid
End Function



Function HttpEncode(str As String) As String
    o = CreateObject("roUrlTransfer")
    return o.Escape(str)
End Function

'This code is written in the intent of handling multiple async calls
Function Setup()
m.pendingXfers = {}
End Function

Function GetAsync(url as String)
  newXfer = CreateObject("roUrlTransfer")
  newXfer.SetUrl(url)
  newXfer.AsyncGetToString()
  requestId = newXfer.GetIdentity().ToStr()
  m.pendingXfers[requestId] = newXfer
End Function

Function HandleUrlEvent(event as Object)
  requestId = event.GetSourceIdentity().ToStr()
  xfer = m.pendingXfers[requestId]
  if xfer <> invalid then
 ' process it
  m.pendingXfers.Delete(requestId)
  end if
End Function
