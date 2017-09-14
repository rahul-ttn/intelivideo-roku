sub init()
 m.top.functionName = "callUserApiHandler"
end sub

sub callUserApiHandler()
     response = callGetApi(m.top.uri)
     if(response <> invalid)
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseApiResponse(json)
     else
        userApiModel = CreateObject("roSGNode", "AuthTokenModel")
        userApiModel.success = false
        m.top.content = userApiModel
     end if
end sub

sub parseApiResponse(response As Object)
    userApiModel = CreateObject("roSGNode", "UserApiModel")
    if(m.responseCode = 200)
        userApiModel.success = true
        appConfigModel = CreateObject("roSGNode", "AppConfigModel")
        appConfigModel.base_theme = response.app_config.base_theme
        appConfigModel.primary_color = response.app_config.primary_color
        appConfigModel.secondary_color = response.app_config.secondary_color
        appConfigModel.display_categories = response.app_config.display_categories
        appConfigModel.privacy_policy = response.app_config.privacy_policy
        appConfigModel.terms_of_service = response.app_config.terms_of_service
        userApiModel.appConfigModel = appConfigModel
        
        userModel = CreateObject("roSGNode", "UserModel")
        userModel.id = response.user.id
        userModel.first_name = response.user.first_name
        userModel.last_name = response.user.last_name
        userModel.email = response.user.email
        userModel.company = response.user.company
        userModel.account_id = response.user.account_id
        userApiModel.userModel = userModel
       
    else if(response.error <> invalid)
        userApiModel.success = false
        userApiModel.error = response.error
    end if
    m.top.content = userApiModel
    
    print userApiModel
end sub