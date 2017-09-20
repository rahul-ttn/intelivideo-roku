sub init()
    m.sec=CreateObject("roRegistrySection","Authentication")
end sub
'---------------------------------------------------------------------------
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
'---------------------------------------------------------------------------
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
'---------------------------------------------------------------------------
Sub setRefreshToken()    
    m.sec.Write("refreshToken",m.top.refreshToken)
    m.sec.Flush() 'commit it
end sub

Sub getRefreshToken()   
    If m.sec.Exists("refreshToken") Then
        m.top.refreshTokenValue =  m.sec.read("refreshToken")
    else        
        m.top.refreshTokenValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
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
'---------------------------------------------------------------------------
Sub setSelectedAccountThumb()    
    m.sec.Write("selectedAccountThumb",m.top.selectedAccountThumb)
    m.sec.Flush() 'commit it
end sub

Sub getSelectedAccountThumb()   
    If m.sec.Exists("selectedAccountThumb") Then
        m.top.selectedAccountThumbValue =  m.sec.read("selectedAccountThumb")
    else        
        m.top.selectedAccountThumbValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setSelectedAccountName()    
    m.sec.Write("selectedAccountName",m.top.selectedAccountName)
    m.sec.Flush() 'commit it
end sub

Sub getSelectedAccountName()   
    If m.sec.Exists("selectedAccountName") Then
        m.top.selectedAccountNameValue =  m.sec.read("selectedAccountName")
    else        
        m.top.selectedAccountNameValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setAccounts()    
    m.sec.Write("accounts",m.top.accounts)
    m.sec.Flush() 'commit it
end sub

Sub getAccounts()   
    If m.sec.Exists("accounts") Then
        m.top.accountsValue =  m.sec.read("accounts")
    else        
        m.top.accountsValue = Invalid
    End If
end sub

Function deleteAccounts()
    m.sec.Delete("accounts")
    print "accouts deleted >> "   
End Function
'---------------------------------------------------------------------------
Sub setIsHome()    
    m.sec.Write("isHome",m.top.isHome)
    m.sec.Flush() 'commit it
end sub

Sub getIsHome()   
    If m.sec.Exists("isHome") Then
        m.top.isHomeValue =  m.sec.read("isHome")
    else        
        m.top.isHomeValue = Invalid
    End If
end sub

