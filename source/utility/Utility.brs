
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
     dialog.title = "Loading..."
     dialog.optionsDialog = true
     m.top.getScene().dialog = dialog
end sub

sub hideProgressDialog()
    if m.top.getScene().dialog <> invalid
        m.top.getScene().dialog.close = true
    end if
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
    registryData.setField(key,value)
End Function

Function deleteValue(key as String)
    registryData = createObject("roSGNode","RegistryData")
    registryData.setField(key,key)
end Function

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

Function showNetworkErrorDialog(title ,message)
  dialog = createObject("roSGNode", "Dialog") 
  dialog.backgroundUri = "" 
  dialog.title = title
  dialog.optionsDialog = true 
  dialog.iconUri = ""
  dialog.message = message
  dialog.width = 1200
  dialog.buttons = ["OK"]
  dialog.observeField("buttonSelected", "hideProgressDialog") 'The field is set when the dialog close field is set,
  m.top.getScene().dialog = dialog
end Function

function getPostedVideoDayDifference(postedEpochTime as Integer) as Integer
    if postedEpochTime = 0
        return 100
    end if
    
    todaysDate = CreateObject("roDateTime")
    todaysDateEpochTime = todaysDate.asSeconds()
    
    timeDifferenceDate = todaysDateEpochTime - postedEpochTime
    day =  (timeDifferenceDate/3600) / 24
    return day
end function

function getMediaTimeFromSeconds(totalSeconds as Integer) as String   
    seconds = totalSeconds MOD 60
    minutes = (totalSeconds \ 60) MOD 60
    hours = totalSeconds \ 3600
    
    hoursStr = hours.toStr()
    if hours > 9
        hoursStr = hoursStr
    else
        hoursStr = "0"+hoursStr
    end if
    
    
    minutesStr = minutes.toStr()
     if minutes > 9
        minutesStr = minutesStr
     else
        minutesStr = "0"+minutesStr
     end if
    
    secondsStr = seconds.toStr()
    if seconds > 9
        secondsStr = secondsStr
    else
        secondsStr = "0"+secondsStr
    end if 

    if hours > 0 
        return  hoursStr + ":" +  minutesStr + ":" + secondsStr
    else if  minutes > 0 
        return minutesStr + ":" + secondsStr
    else  
        return "00:" + secondsStr
    end if
    
end function

Function generateCipher(sUrlAsMessage as String,secretKey as String) as String
    If sUrlAsMessage=invalid Then
        return "Not A Valid Encryption"
    End IF
     
    cipher = CreateObject("roEVPCipher") 
    result = cipher.Setup(true, "bf-cbc", secretKey, "", 1)
    If result = 0 Then 
        message = CreateObject("roByteArray") 
        message.fromAsciiString(sUrlAsMessage)
        result = cipher.Process(message)
        print "encrypted cipher >>> "result
        return result.toBase64String()  
    else 
        return "Not A Valid Encryption"
    End if
End Function


Function generateHMAC(sUrlAsMessage as String,secretKey as String) as String
    If sUrlAsMessage=invalid Then
        return "Not A Valid Encryption"
    End IF
     
    hmac = CreateObject("roHMAC") 
    privateKey = CreateObject("roByteArray") 
    privateKey.fromAsciiString(secretKey)
    result = hmac.Setup("sha1", privateKey)
    If result = 0 Then 
        message = CreateObject("roByteArray") 
        message.fromAsciiString(sUrlAsMessage)
        result = hmac.Process(message)
        print "encrypted hmac >>> "result
        return result.toBase64String()  
    else 
        return "Not A Valid Encryption"
    End if
End Function

