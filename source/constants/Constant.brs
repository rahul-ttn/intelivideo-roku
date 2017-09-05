

Function getApiBaseUrl() as String
    return "https://api.intelivideo.com/api/apps/v3/"
End Function

Function getPageMarginWidth()
return 96
End Function

Function getPageMarginHeight()
return 53
End Function

Function getPageWidth()
return 1920-2*getPageMarginWidth()
End Function

Function getPageHeight()
return 1080-2*getPageMarginHeight()
End Function

Function getNoInternetTitle() as String
    return "Not Connected to the Internet"
End Function

Function getNoInternetMessage() as String
    return "You are not currently connected to the internet. Please check your connection..."
End Function

Function getErrorTitle() as String
    return "Error"
End Function


