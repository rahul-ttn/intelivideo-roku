sub init()
    m.sec=CreateObject("roRegistrySection","Authentication")
end sub

Sub setSelectedAccount()    
    m.sec.Write("selectedAccount",m.top.selectedAccount)
    m.sec.Flush() 'commit it
end sub

Sub getSelectedAccount()   
    If m.sec.Exists("selectedAccount") Then
        m.top.selectedAccountValue =  m.sec.read("selectedAccount")
    else        
        m.top.selectedAccountValue = Invalid
    End If
end sub

Sub setAuthToken()    
    m.sec.Write("authToken",m.top.authToken)
    m.sec.Flush() 'commit it
end sub

Sub getAuthToken()   
    If m.sec.Exists("authToken") Then
        m.top.authTokenValue =  m.sec.read("authToken")
    else        
        m.top.authTokenValue = Invalid
    End If
end sub

Sub setLoginStatus()    
    m.sec.Write("isLogin",m.top.isLogin)
    m.sec.Flush() 'commit it
end sub

Sub getLoginStatus()   
    If m.sec.Exists("isLogin") Then
        m.top.isLoginValue =  m.sec.read("isLogin")
    else        
        m.top.isLoginValue = Invalid
    End If
end sub