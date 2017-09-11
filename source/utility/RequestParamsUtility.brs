Function createAuthTokenParams(grant_type as String, email as String, password as String, account_id as String, pin as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"grant_type":grant_type, "email":email, "password":password, "account_id":account_id, "pin":pin}
    params = SimpleJSONAssociativeArray(headerValueParam)
    return params
end Function





