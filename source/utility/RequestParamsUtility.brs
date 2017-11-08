Function createAuthTokenParams(grant_type as String, email as String, password as String, account_id as String, pin as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"grant_type":grant_type, "email":email, "password":password, "account_id":account_id, "pin":pin}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function

Function createRefreshTokenParams(grant_type as String, refresh_token as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"grant_type":grant_type, "refresh_token":refresh_token}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function

Function createForgetPasswordParams(email as String, merchant_id as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"email":email, "merchant_id":merchant_id}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function

Function createAccountDetailsJson(name as String, id as String, thumbnail as String, access_token as String, refresh_token as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"name":name, "id":id, "thumbnail":thumbnail, "access_token":access_token, "refresh_token":refresh_token}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function

Function createRecentlyViewedParams(item_id as String, item_type as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"item_id":item_id, "item_type":item_type}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function

Function createAccountParams(email as String, password as String, iat as Integer) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"email":email, "password":password, "send_user_welcome_email":"false", "iat":iat}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function


