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
    m.leftParentRectangle = m.top.findNode("leftParentRectangle")
    
    m.titleRectangle = m.top.findNode("titleRectangle")
    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.font.size = 60
    
    m.favButtonOuterRectangle = m.top.findNode("favButtonOuterRectangle")
    m.favButtonrectangle = m.top.findNode("favButtonrectangle")
    m.buttonFav = m.top.findNode("buttonFav")
    m.favPoster = m.top.findNode("favPoster")
    
    favPosterX = (m.favButtonrectangle.width  - m.favPoster.width) / 2
    favPosterY = (m.favButtonrectangle.height  - m.favPoster.height) / 2 
    m.favPoster.translation = [favPosterX, favPosterY]
    
     
    m.descLabel = m.top.findNode("descLabel")
    
    m.listRectangle = m.top.findNode("listRectangle")
    m.productLabelList = m.top.findNode("productLabelList")  
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
    print "onProductDetailApiResponse() >> "
    hideProgressDialog()
    m.productDetailModel = m.productDetailApi.content
    if m.productDetailModel.success
        m.productDetailBgPoster.uri = m.productDetailModel.original
        showMediaList()
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
End sub

sub showMediaList()
    m.productLabelList.ObserveField("itemFocused", "onListItemFocused")
    m.productLabelList.ObserveField("itemSelected", "onListItemSelected")
    
    m.content = createObject("roSGNode","ContentNode")
    sectionContent=addListSectionHelper(m.content,"")
    for i = 0 To m.productDetailModel.objects.count()-1
        addListItemHelper(sectionContent,m.productDetailModel.objects[i].title)
    end for   
  
    m.productLabelList.content = m.content
    m.productLabelList.setFocus(true)
End sub

sub onListItemFocused()
   
End sub

sub onListItemSelected()
    
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

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key = "left" or key = "right"
            return true
        else if key = "back"
            m.top.visible = false
        end if
    end if
    return result 
End function