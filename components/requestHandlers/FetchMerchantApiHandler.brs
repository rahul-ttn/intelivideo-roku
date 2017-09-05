sub init()
 m.top.functionName = "callFetchMerchantApi"
end sub

sub callFetchMerchantApi()
     response = callGetApi(m.top.uri)
     errorCode = response.GetResponseCode()
     responseString = response.GetString()
     json = ParseJSON(response)
     parseFetchMerchantApiResponse(json)
end sub

sub parseFetchMerchantApiResponse(response As Object)
    responseArray = response["accounts"]
    
    accountsArray = CreateObject("roArray", responseArray.count(), false)
    
    for each accounts in responseArray
        accountsModel = CreateObject("roSGNode", "AccountsModel")
        
        accountsModel.id = accounts.id
        accountsModel.name = accounts.name
        
        if(accounts.logo <> invalid)
            accountsModel.original = accounts.logo.original
            accountsModel.small = accounts.logo.small
            accountsModel.thumbnail = accounts.logo.thumbnail
        end if
        
        accountsArray.Push(accountsModel)
        
    end for
    
    merchantModel = CreateObject("roSGNode", "MerchantModel")
    merchantModel.accountsArray = accountsArray
    m.top.content = merchantModel
    
    print accountsArray

end sub