Function createFetchMerchantParams(email as String) as Object
    headerParam = CreateObject("roAssociativeArray")
    headerValueParam = CreateObject("roAssociativeArray")
    headerValueParam = {"email":email}
    params = SimpleFormUrlAssociativeArray(headerValueParam)
    return params
end Function





