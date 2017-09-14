
Function getCurrentTimeStamp() As Integer 
    dateObj = CreateObject("roDateTime")
    seconds = dateObj.AsSeconds()
    return seconds
end Function

Function getDeviceId() as String
    di = CreateObject("roDeviceInfo")
    return di.GetDeviceUniqueId()
End Function

Function getDeviceName() as String
    return "roku"
End Function

Function getAppVersion() as String
    return "1.0"
End Function

Function parseErrorModel(errorJson As Object,model as Object) as Object
    
End Function

sub showProgressDialog()
     dialog = createObject("roSGNode", "ProgressDialog")
     dialog.backgroundUri = ""
     dialog.title = "Alert Dialog"
     dialog.optionsDialog = true
     dialog.message = "Loading..."
     m.top.getScene().dialog = dialog
end sub

sub hideProgressDialog()
    m.top.getScene().dialog.close = true
end sub

Function SimpleJSONAssociativeArray( jsonArray As Object ) As String
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

Function checkInternetConnection() as Boolean
    checkRokuConnection = CreateObject("roDeviceInfo")
    return checkrokuconnection.GetLinkStatus()
End Function

Function getValueInRegistryForKey(key as String) As String
    registryData = createObject("roSGNode","RegistryData")
    registryData.setField(key,key)
    return registryData[key]
End Function

Function setValueInRegistryForKey(key as String, value as String)
    registryData = createObject("roSGNode","RegistryData")
    print "setValueInRegistryForKey" ; registryData
    registryData.setField(key,value)
End Function

Function SimpleFormUrlAssociativeArray( jsonArray As Object ) As String
    jsonString = ""
    
    For Each key in jsonArray
        jsonString = jsonString +  key + "="+ jsonArray[ key ] + "&"         
    Next
    
    If Right( jsonString, 1 ) = "&" Then
        jsonString = Left( jsonString, Len( jsonString ) - 1 )
    End If
       print "final string is";jsonString.EncodeUri()
    Return jsonString.EncodeUri()
End Function

Function appendParamsInUrl( jsonArray As Object ,url as String) As String
    jsonString = ""
    
    For Each key in jsonArray
        jsonString = jsonString +  key + "="+ jsonArray[ key ] + "&"         
    Next
    If Right( jsonString, 1 ) = "&" Then
        jsonString = Left( jsonString, Len( jsonString ) - 1 )
    End If
       print "final string is";jsonString.EncodeUri()
    Return url + jsonString.EncodeUri()
End Function

Function handleError(errorJson as Object,model as Object) as Object
    model.error = errorJson.error
    model.message = errorJson.message
    model.success = errorJson.success
    return model
End Function

Function setPageRectProperties(pageRect)
'Set the translation
pageRect.translation=[getPageMarginWidth(),getPageMarginHeight()]
'Set the height and width of the rectangle
pageRect.width=1920-getPageMarginWidth()*2
pageRect.height=1080-getPageMarginHeight()*2
' set the background color to transparent
pageRect.color= "0xFF000000"

End Function

function GetParentScene() as Object
   m.parentScene = m.top.GetParent()
    while m.parentScene <> invalid
        grandParent = m.parentScene.GetParent()
        if grandParent = invalid then
            exit while
        end if
        m.parentScene = grandParent
    end while
    return m.parentScene
end function



