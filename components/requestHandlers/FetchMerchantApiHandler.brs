sub init()
 m.top.functionName = "callFetchMerchantApi"
end sub

sub callFetchMerchantApi()
     response = callGetApi(m.top.uri)
     if(response <> invalid)
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseFetchMerchantApiResponse(json)
     else
        merchantModel = CreateObject("roSGNode", "MerchantModel")
        merchantModel.success = false
        m.top.content = merchantModel
     end if
end sub

sub parseFetchMerchantApiResponse(response As Object)
    merchantModel = CreateObject("roSGNode", "MerchantModel")
    if(m.responseCode = 200)
        merchantModel.success = true
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
        merchantModel.accountsArray = accountsArray
    else if(response.error <> invalid)
        merchantModel.success = false
        merchantModel.error = response.error
    end if
    m.top.content = merchantModel
    
end sub