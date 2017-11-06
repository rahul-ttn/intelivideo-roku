sub init()
    m.sec=CreateObject("roRegistrySection","Authentication")
    m.addNumber="1"
end sub


Function deleteToken()
   m.sec.delete("authToken")
   'temporary deleting all keys here. We will remove these once we figure out ideal condition to perform deletion of values for these keys
   m.sec.delete("authTokenValue")
'   m.sec.delete("")
'   m.sec.delete("")
'   m.sec.delete("")
'   'm.sec.delete("stadium_key_isAcceptedTermAndCondition")
'   value = m.sec.read(getKeyToken())    
End Function


'---------------------------------------------------------------------------
Sub setSelectedAccount()    
    m.sec.Write("selectedAccount"+m.addNumber,m.top.selectedAccount)
    m.sec.Flush() 'commit it
end sub

Sub getSelectedAccount()   
    If m.sec.Exists("selectedAccount"+m.addNumber) Then
        m.top.selectedAccountValue =  m.sec.read("selectedAccount"+m.addNumber)
    else        
        m.top.selectedAccountValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setAuthToken()    
    m.sec.Write("authToken"+m.addNumber,m.top.authToken)
    m.sec.Flush() 'commit it
end sub

Sub getAuthToken()   
    If m.sec.Exists("authToken"+m.addNumber) Then
        m.top.authTokenValue =  m.sec.read("authToken"+m.addNumber)
    else        
        m.top.authTokenValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setRefreshToken()    
    m.sec.Write("refreshToken"+m.addNumber,m.top.refreshToken)
    m.sec.Flush() 'commit it
end sub

Sub getRefreshToken()   
    If m.sec.Exists("refreshToken"+m.addNumber) Then
        m.top.refreshTokenValue =  m.sec.read("refreshToken"+m.addNumber)
    else        
        m.top.refreshTokenValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setLoginStatus()    
    m.sec.Write("isLogin"+m.addNumber,m.top.isLogin)
    m.sec.Flush() 'commit it
end sub

Sub getLoginStatus()   
    If m.sec.Exists("isLogin"+m.addNumber) Then
        m.top.isLoginValue =  m.sec.read("isLogin"+m.addNumber)
    else        
        m.top.isLoginValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setSelectedAccountThumb()    
    m.sec.Write("selectedAccountThumb"+m.addNumber,m.top.selectedAccountThumb)
    m.sec.Flush() 'commit it
end sub

Sub getSelectedAccountThumb()   
    If m.sec.Exists("selectedAccountThumb"+m.addNumber) Then
        m.top.selectedAccountThumbValue =  m.sec.read("selectedAccountThumb"+m.addNumber)
    else        
        m.top.selectedAccountThumbValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setSelectedAccountName()    
    m.sec.Write("selectedAccountName"+m.addNumber,m.top.selectedAccountName)
    m.sec.Flush() 'commit it
end sub

Sub getSelectedAccountName()   
    If m.sec.Exists("selectedAccountName"+m.addNumber) Then
        m.top.selectedAccountNameValue =  m.sec.read("selectedAccountName"+m.addNumber)
    else        
        m.top.selectedAccountNameValue = Invalid
    End If
end sub
'---------------------------------------------------------------------------
Sub setAccounts()    
    m.sec.Write("accounts"+m.addNumber,m.top.accounts)
    m.sec.Flush() 'commit it
end sub

Sub getAccounts()   
    If m.sec.Exists("accounts"+m.addNumber) Then
        m.top.accountsValue =  m.sec.read("accounts"+m.addNumber)
    else        
        m.top.accountsValue = Invalid
    End If
end sub

Function deleteAccounts()
    m.sec.Delete("accounts"+m.addNumber)
    print "accouts deleted >> "   
End Function
'---------------------------------------------------------------------------
Sub setIsHome()    
    m.sec.Write("isHome"+m.addNumber,m.top.isHome)
    m.sec.Flush() 'commit it
end sub

Sub getIsHome()   
    If m.sec.Exists("isHome"+m.addNumber) Then
        m.top.isHomeValue =  m.sec.read("isHome"+m.addNumber)
    else        
        m.top.isHomeValue = Invalid
    End If
end sub

