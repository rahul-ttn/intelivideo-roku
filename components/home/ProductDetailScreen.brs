sub init()
    m.top.SetFocus(true)
    m.BUTTONTEXT = 25
End sub

sub getProductId()
    m.productId = m.top.product_id
    initFields()
    initFocus()
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
    m.descLabel = m.top.findNode("descLabel")
    
    'favourite button-> configuration
    favButtonOuterRectangle = m.top.findNode("favButtonOuterRectangle")
    m.favButtonrectangle = m.top.findNode("favButtonrectangle")
    m.buttonFav = m.top.findNode("buttonFav")
    m.favPoster = m.top.findNode("favPoster")
    m.favbuttonLabel = m.top.findNode("favbuttonLabel")
    m.favbuttonLabel.font.size = m.BUTTONTEXT
    
    favPosterX = (m.favButtonrectangle.width  - m.favPoster.width) / 2
    favPosterY = (m.favButtonrectangle.height  - m.favPoster.height) / 2 
    m.favPoster.translation = [favPosterX, favPosterY]
    
    m.listRectangle = m.top.findNode("listRectangle")
    m.productLabelList = m.top.findNode("productLabelList")  
    

    m.thumbnailPoster = m.top.findNode("thumbnailPoster")
    m.nameLabel = m.top.findNode("nameLabel")
    m.typeLabel = m.top.findNode("typeLabel")
    m.longDescriptionLabel = m.top.findNode("longDescriptionLabel")

    'play button right-> configuration
    m.playButtonOuterRectangle = m.top.findNode("playButtonOuterRectangle")
    m.playButtonrectangle = m.top.findNode("playButtonrectangle")
    m.buttonPlay = m.top.findNode("buttonPlay")
    m.playPoster = m.top.findNode("playPoster")
    m.playbuttonLabel = m.top.findNode("playbuttonLabel")
    m.playbuttonLabel.font.size = m.BUTTONTEXT
    
    playPosterX = (m.playButtonrectangle.width  - m.playPoster.width) / 2
    playPosterY = (m.playButtonrectangle.height  - m.playPoster.height) / 2 
    m.playPoster.translation = [playPosterX, playPosterY]
    
    'favourite button on right-> configuration
    m.favButtonOuterRightRectangle = m.top.findNode("favButtonOuterRightRectangle")
    m.favButtonRightrectangle = m.top.findNode("favButtonRightrectangle")
    m.buttonFavRight = m.top.findNode("buttonFavRight")
    m.favPosterRight = m.top.findNode("favPosterRight")
    m.favbuttonLabelRight = m.top.findNode("favbuttonLabelRight")
    m.favbuttonLabelRight.font.size = m.BUTTONTEXT
    
    favPosterRightX = (m.favButtonRightrectangle.width  - m.favPosterRight.width) / 2
    favPosterRightY = (m.favButtonRightrectangle.height  - m.favPosterRight.height) / 2 
    m.favPosterRight.translation = [favPosterRightX, favPosterRightY]

    m.moreButtonrectangle = m.top.findNode("moreButtonrectangle")
    m.buttonMore = m.top.findNode("buttonMore")
    m.labelMore = m.top.findNode("labelMore")
    
    m.moreButtonrectangleRight = m.top.findNode("moreButtonrectangleRight")
    m.buttonMoreRight = m.top.findNode("buttonMoreRight")
    m.labelMoreRight = m.top.findNode("labelMoreRight")
    
End sub

sub initFocus()
    'initializing the currentFocus id 
    m.currentFocusID ="buttonFav"
    
    'up-down-left-right  
    m.focusIDArray = {"buttonFav":"N-productLabelList-N-buttonMore"     
                       "buttonMore":"N-productLabelList-buttonFav-buttonPlay"                 
                       "productLabelList":"buttonFav-N-N-buttonPlay"     
                       "buttonPlay":"N-N-productLabelList-buttonFavRight"                   
                       "buttonFavRight":"N-buttonMoreRight-buttonPlay-N" 
                       "buttonMoreRight":"buttonFavRight-N-N-N"   
                     }
end sub

sub handlebuttonSelectedState()
    if m.currentFocusID ="buttonFav"
        setButtonFocusedState(m.favButtonrectangle)
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.moreButtonrectangle)
        setMoreUnselectedState(m.moreButtonrectangleRight)
    else if m.currentFocusID ="buttonMore"
        setButtonUnFocusedState(m.favButtonrectangle)
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreSelectedState(m.moreButtonrectangle)
        setMoreUnselectedState(m.moreButtonrectangleRight)
    else if m.currentFocusID ="productLabelList"
        setButtonUnFocusedState(m.favButtonrectangle)
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.moreButtonrectangle)
        setMoreUnselectedState(m.moreButtonrectangleRight)
    else if m.currentFocusID ="buttonPlay"
        setButtonUnFocusedState(m.favButtonrectangle)
        setButtonFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.moreButtonrectangle)
        setMoreUnselectedState(m.moreButtonrectangleRight)
    else if m.currentFocusID ="buttonFavRight"
        setButtonUnFocusedState(m.favButtonrectangle)
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.moreButtonrectangle)
        setMoreUnselectedState(m.moreButtonrectangleRight)
    else if m.currentFocusID ="buttonMoreRight"
        setButtonUnFocusedState(m.favButtonrectangle)
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.moreButtonrectangle)
        setMoreSelectedState(m.moreButtonrectangleRight)
    end if
end sub

sub setButtonFocusedState(selectedRectangle as object)
    selectedRectangle.color = "0xffffffff"
end sub

sub setButtonUnFocusedState(unfocusedRectangle as object)
    unfocusedRectangle.color = "0x858585ff"
end sub

sub setMoreSelectedState(selectedMore as object)
    selectedMore.color = "0x858585ff"
end sub

sub setMoreUnselectedState(unfocusedMore as object)
    unfocusedMore.color = "0xffffffff"
end sub

sub getProductDetails()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "products/"+ StrI(m.productId).Trim() +"?per_page=100&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
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
        m.titleLabel.text = m.productDetailModel.title
        m.descLabel.text = m.productDetailModel.description
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
   mediaModel = m.productDetailModel.objects[m.productLabelList.itemFocused]
   m.thumbnailPoster.uri = mediaModel.small
   m.nameLabel.text = mediaModel.title
   m.longDescriptionLabel.text = mediaModel.description
   if mediaModel.type = "Video" OR mediaModel.type = "Audio"
       m.typeLabel.text = getMediaTimeFromSeconds(mediaModel.duration)
   else
       m.typeLabel.text = "Document"
   end if
   
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
        if key="up" OR key="down" OR key="left" OR key="right" Then
            handleFocus(key)
            handlebuttonSelectedState()
            return true
        else if key = "back"
            m.top.visible = false
        end if
    end if
    return result 
End function