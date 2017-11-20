sub init()
    m.top.SetFocus(true)
    m.appConfig = m.top.getScene().appConfigContent
    initFields()
    getSubscription()
End sub

sub initFields()
    m.welcomeScreenBackground = m.top.findNode("welcomeScreenBackground")
    m.createAccount = m.top.findNode("CreateAccountScreen")
    m.accountLogo = m.top.findNode("accountLogo")
    accountLogoX = (1920 - m.accountLogo.width) / 2
    m.accountLogo.translation = [accountLogoX,120]
    
    m.labelNewWay = m.top.findNode("labelNewWay")
    m.labelNewWay.font.size = 60
    
    m.labelWatchAnywhere = m.top.findNode("labelWatchAnywhere")
    m.labelWatchAnywhere.font.size = 60
    
    m.labelDiscription = m.top.findNode("labelDiscription")
    'm.labelDiscription.text = "You new subscription will provide you with Instant Access to the content you want. After creating an account, you can select a plan to watch anywhere on any device, anytime."
    labelDiscriptionX = (1920 - m.labelDiscription.width) / 2
    m.labelDiscription.translation = [labelDiscriptionX,520]
    
    m.loginRectangle = m.top.findNode("loginRectangle")
    m.loginRectangle.color = m.appConfig.non_focus_color
    
    m.createAccountRectangle = m.top.findNode("createAccountRectangle")
    m.createAccountRectangle.color = m.appConfig.non_focus_color
    createAccountRectangleX = (1920 - m.createAccountRectangle.width) / 2
    m.createAccountRectangle.translation = [createAccountRectangleX,700]
    
    m.browseCatalogRectangle = m.top.findNode("browseCatalogRectangle")
    m.browseCatalogRectangle.color = m.appConfig.non_focus_color
    browseCatalogRectangleX = (1920 - m.browseCatalogRectangle.width) / 2
    m.browseCatalogRectangle.translation = [browseCatalogRectangleX,820]
    
    m.loginButton = m.top.findNode("loginButton")
    m.loginButton.observeField("buttonSelected","showLoginScreen")
    m.loginButton.setFocus(false)
    
    m.createAccountButton = m.top.findNode("createAccountButton")
    m.createAccountButton.observeField("buttonSelected","showCreateAccountScreen")
    m.createAccountButton.setFocus(true)
    
    m.browseCatalogButton = m.top.findNode("browseCatalogButton")
    m.browseCatalogButton.observeField("buttonSelected","showBrowseScreen")
    m.browseCatalogButton.setFocus(false)
    
    'initializing the currentFocus id 
    m.currentFocusID ="createAccountButton"
    
    'up-down-left-right  
    m.focusIDArray = {"loginButton":"N-createAccountButton-N-N"                      
                       "createAccountButton":"loginButton-browseCatalogButton-N-N"     
                       "browseCatalogButton":"createAccountButton-N-N-N"                      
                     }
                     
    handleVisibility()
end sub

sub getSubscription()
    if checkInternetConnection()
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "store/" + StrI(m.appConfig.account_id).Trim() + "/subscriptions?src_system=roku"
        m.subscriptionApi = createObject("roSGNode","GetSubscriptionsApiHandler")
        m.subscriptionApi.setField("uri",baseUrl)
        m.subscriptionApi.observeField("content","onSubscriptionApiResponse")
        m.subscriptionApi.control = "RUN"
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub onSubscriptionApiResponse()
    hideProgressDialog()
    subscriptionApiModel = m.subscriptionApi.content
    if subscriptionApiModel <> invalid AND subscriptionApiModel.success
        dataObject = subscriptionApiModel.items[0]
        m.subscriptionId = dataObject.product_id
        m.labelDiscription.text = dataObject.description
        m.welcomeScreenBackground.uri = dataObject.thumbnail
        setValueInRegistryForKey("subscriptionBackground", dataObject.thumbnail)
    else
        if subscriptionApiModel <> invalid AND subscriptionApiModel.error <> invalid
            showRetryDialog("Server Error", subscriptionApiModel.error)
        else
            showRetryDialog(networkErrorTitle(), networkErrorMessage())
        end if
    end if
end sub

sub onWelcomeScreen()
    m.createAccountButton.setFocus(true)
end sub

sub showLoginScreen()
    m.loginScreen = m.top.createChild("LoginScreen")
    m.loginScreen.visible = true
    m.top.setFocus(false)
    m.loginScreen.setFocus(true)
    m.loginScreen.buttonFocus = true
end sub

sub showCreateAccountScreen()
    m.createAccount.visible = true
    m.createAccount.setFocus(true)
    m.createAccount.buttonFocus = true
end sub

sub showBrowseScreen()
    m.browseCatalog = m.top.createChild("BrowseCatalog")
    m.browseCatalog.visible = true
    m.top.setFocus(false)
    m.browseCatalog.setFocus(true)
    m.browseCatalog.subscriptionId = StrI(m.subscriptionId)
end sub

function handleVisibility() as void
    if m.currentFocusID = "loginButton"
        m.loginRectangle.color = m.appConfig.primary_color
        m.createAccountRectangle.color = m.appConfig.non_focus_color
        m.browseCatalogRectangle.color = m.appConfig.non_focus_color
    else if m.currentFocusID = "createAccountButton"
        m.loginRectangle.color = m.appConfig.non_focus_color
        m.createAccountRectangle.color = m.appConfig.primary_color
        m.browseCatalogRectangle.color = m.appConfig.non_focus_color
    else if m.currentFocusID = "browseCatalogButton"
        m.loginRectangle.color = m.appConfig.non_focus_color
        m.createAccountRectangle.color = m.appConfig.non_focus_color
        m.browseCatalogRectangle.color = m.appConfig.primary_color
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    
    if press
    print "onKeyEvent Password Screen : "; key
        if key="up" OR key="down" OR key="left" OR key="right" Then
            handleFocus(key)
            handleVisibility()
            return true
        else if key = "back"
           
            if m.createAccount.visible=true
                'm.top.removeChild(m.createAccount)
                m.createAccount.visible = false
                m.createAccountButton.setFocus(true)
                return true
            else if m.loginScreen <> invalid
                m.top.removeChild(m.loginScreen)
                m.loginScreen = invalid
                m.loginButton.setFocus(true)
                return true
            else if m.browseCatalog <> invalid
                m.browseCatalog.setFocus(false)
                m.browseCatalog = invalid
                m.browseCatalogButton.setFocus(true)
                return true
            else
                m.top.visible = false
                return false
            end if
        end if
    end if
    return result 
end function

Function showRetryDialog(title ,message)
  dialog = createObject("roSGNode", "Dialog") 
  dialog.backgroundUri = "" 
  dialog.title = title
  dialog.optionsDialog = true 
  dialog.iconUri = ""
  dialog.message = message
  dialog.width = 1200
  dialog.buttons = ["Retry"]
  dialog.optionsDialog = true
  dialog.observeField("buttonSelected", "startTimer") 'The field is set when the dialog close field is set,
  m.top.getScene().dialog = dialog
end Function

sub onRetry()
    getSubscription()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub