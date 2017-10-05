sub init()
    m.top.SetFocus(true)
End sub

sub getProductId()
    m.productId = m.top.product_id
    initFields()
    getProductDetails()
End sub

sub initFields() 
    productDetailBackground = m.top.FindNode("productDetailBackground")
    productDetailBackground.color = homeBackground() 
    m.productDetailBgPoster = m.top.FindNode("productDetailBgPoster")
    m.Error_text  = m.top.FindNode("Error_text")
End sub

sub getProductDetails()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "products/"+ StrI(m.productId).Trim() +"?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.productDetailApi = createObject("roSGNode","ProductDetailApiHandler")
        m.productDetailApi.setField("uri",baseUrl)
        m.productDetailApi.observeField("content","onProductDetailApiResponse")
        m.productDetailApi.control = "RUN"
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
End sub

sub onProductDetailApiResponse()
    hideProgressDialog()
    productDetailModel = m.productDetailApi.content
    if productDetailModel.success
        m.productDetailBgPoster.uri = productDetailModel.original
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
End sub

Function showRetryDialog(title ,message)
    m.Error_text.visible = true
    m.Error_text.text = message

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
    getProductDetails()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub