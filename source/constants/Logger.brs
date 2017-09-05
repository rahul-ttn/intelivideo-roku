Function isDebugable() as Boolean
    return true
End Function

Function printLog(tag as String,value as Object)
    If isDebugable()=true Then
    print tag ; "  ===>  "; value
    End If
End Function