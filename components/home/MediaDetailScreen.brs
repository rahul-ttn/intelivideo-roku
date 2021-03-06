sub init()
    print "Media detail init >> "
    m.top.SetFocus(true)
    m.BUTTONTEXT = 25
    m.appConfig =  m.top.getScene().appConfigContent
    m.isFav = false
    m.counter = 0
    m.counterMaxValue = 2
    m.isDocument = false
    
End sub

sub getResourceId()
    print "Media detail getResourceId >> "
    m.resourceId = m.top.resource_id
    initFields()
    getMediaDetails()
End sub

sub initFocus()
    'up-down-left-right  
    m.focusIDArray = { "buttonMore":"N-buttonPlay-N-N"
                       "buttonPlay":"buttonMore-relatedMediaRowList-N-buttonFavRight"                   
                       "buttonFavRight":"buttonMore-relatedMediaRowList-buttonPlay-N" 
                       "relatedMediaRowList":"buttonPlay-N-N-N"   
                     }
end sub

sub initFocusWithout()
    'up-down-left-right  
    m.focusIDArray = { "buttonMore":"N-buttonFavRight-N-N"  
                       "buttonPlay":"buttonMore-relatedMediaRowList-N-buttonFavRight"                   
                       "buttonFavRight":"buttonMore-relatedMediaRowList-N-N" 
                       "relatedMediaRowList":"buttonFavRight-N-N-N"   
                     }
end sub

sub initFields() 
    mediaDetailBackground = m.top.FindNode("mediaDetailBackground")
    mediaDetailBackground.color = homeBackground() 
    m.mediaDetailRectangle = m.top.FindNode("mediaDetailRectangle")
    m.mediaDetailBgPoster = m.top.FindNode("mediaDetailBgPoster")
    m.Error_text  = m.top.FindNode("Error_text")
    m.labelTitle  = m.top.FindNode("labelTitle")
    m.labelMediaTime  = m.top.FindNode("labelMediaTime")
    m.descLabel = m.top.findNode("descLabel")
    m.descLabel.observeField("isTextEllipsized","showMoreLabel")
    
    m.moreButtonrectangle = m.top.findNode("moreButtonrectangle")
    m.buttonMore = m.top.findNode("buttonMore")
    m.buttonMore.observeField("buttonSelected", "showMediaMoreScreen")
    m.labelMore = m.top.findNode("labelMore")
    
    m.relatedMediaRowList  = m.top.FindNode("relatedMediaRowList")
    m.relatedMediaRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    
    
     'play button right-> configuration
    m.playButtonOuterRectangle = m.top.findNode("playButtonOuterRectangle")
    m.playButtonrectangle = m.top.findNode("playButtonrectangle")
    
    m.buttonPlay = m.top.findNode("buttonPlay")
    m.buttonPlay.unobserveField("buttonSelected")
    m.buttonPlay.observeField("buttonSelected", "onButtonPlay")
    
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
    m.buttonFavRight.unobserveField("buttonSelected")
    m.buttonFavRight.observeField("buttonSelected", "onButtonFavorite")
    
    m.favPosterRight = m.top.findNode("favPosterRight")
    m.favbuttonLabelRight = m.top.findNode("favbuttonLabelRight")
    m.favbuttonLabelRight.font.size = m.BUTTONTEXT
    
    favPosterRightX = (m.favButtonRightrectangle.width  - m.favPosterRight.width) / 2
    favPosterRightY = (m.favButtonRightrectangle.height  - m.favPosterRight.height) / 2 
    m.favPosterRight.translation = [favPosterRightX, favPosterRightY]
        
    m.documentInfoLabel = m.top.findNode("documentInfoLabel")
    m.documentInfoLabel.font.size = 30 
End sub

sub onButtonFavorite()
    m.top.getScene().isRefreshOnBack = true
    if m.isFav
        m.isFav = false
        setButtonFocusedState(m.favButtonRightrectangle, true)
        deleteFavMediaAPI()
    else
        m.isFav = true
        addFavMediaAPI()
        m.favButtonRightrectangle.color = favButtonFocusColor()
    end if
end sub

sub addFavMediaAPI()
    baseUrl = getApiBaseUrl() +"favorites?access_token=" + getValueInRegistryForKey("authTokenValue")
    parmas = createRecentlyViewedParams(StrI(m.resourceId),"media")
    m.addFavMediaApi = createObject("roSGNode","AddRecentlyViewedApiHandler")
    m.addFavMediaApi.setField("uri",baseUrl)
    m.addFavMediaApi.setField("params",parmas)
    m.addFavMediaApi.control = "RUN"
end sub

sub deleteFavMediaAPI()
    baseUrl = getApiBaseUrl() +"favorites?access_token=" + getValueInRegistryForKey("authTokenValue")
    parmas = createRecentlyViewedParams(StrI(m.resourceId),"media")
    m.deleteFavMediaAPI = createObject("roSGNode","AddRecentlyViewedApiHandler")
    m.deleteFavMediaAPI.setField("uri",baseUrl)
    m.deleteFavMediaAPI.setField("params",parmas)
    m.deleteFavMediaAPI.setField("isDelete",true)
    m.deleteFavMediaAPI.control = "RUN"
end sub

function favButtonFocusColor() as String
    return m.appConfig.primary_color + "CC"
end function

sub onButtonPlay()
    print "onButtonPlay() >>>>> "
    m.videoPlayer = m.top.createChild("VideoPlayer")
    m.videoPlayer.setFocus(true)
    m.videoPlayer.resourceId = StrI(m.resourceId).Trim()
    
End sub

sub showMoreLabel()
    m.moreButtonrectangle.visible = true
end sub

sub showMediaMoreScreen()
    m.mediaMoreScreen = m.top.createChild("MoreScreen")
    m.top.setFocus(false)
    m.mediaMoreScreen.setFocus(true)
    m.mediaMoreScreen.titleText = m.labelTitle.text
    m.mediaMoreScreen.moreText = m.descLabel.text
end sub

sub setButtonFocusedState(selectedRectangle as object, isFavButton as boolean)
    if m.isFav AND isFavButton
        selectedRectangle.color = favButtonFocusColor()
    else
        selectedRectangle.color = "0xffffffff"
    end if
end sub

sub setButtonUnFocusedState(unfocusedRectangle as object, isFavButton as boolean)
    if m.isFav AND isFavButton
        unfocusedRectangle.color = m.appConfig.primary_color
    else
        unfocusedRectangle.color = "0x858585ff"
    end if
    
end sub

sub setMoreSelectedState(selectedMore as object)
    selectedMore.color = m.appConfig.primary_color
end sub

sub setMoreUnselectedState(unfocusedMore as object)
    unfocusedMore.color = "0xffffffff"
end sub 

sub updateCounter()
    m.counter = m.counter + 1
    print "m.counter >> ";m.counter
end sub

sub showPlayFavButton()
    m.playButtonOuterRectangle.visible = true
    m.favButtonOuterRightRectangle.visible = true
    m.playButtonOuterRectangle.translation = [200,520]
    m.favButtonOuterRightRectangle.translation = [390,520]
    m.documentInfoLabel.visible = false
end sub

sub showFavDescText()
    m.playButtonOuterRectangle.visible = false
    m.favButtonOuterRightRectangle.visible = true
    
    
    m.favButtonOuterRightRectangle.translation = [200,520]
    m.documentInfoLabel.visible = true
    m.documentInfoLabel.translation = [390,520]
end sub

sub getMediaDetails()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "media/"+ StrI(m.resourceId).Trim() +"?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.mediaDetailApi = createObject("roSGNode","MediaDetailApiHandler")
        m.mediaDetailApi.setField("uri",baseUrl)
        m.mediaDetailApi.observeField("content","onMediaDetailApiResponse")
        m.mediaDetailApi.control = "RUN"
        
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
End sub

sub getRelatedMedia()
    baseUrl = getApiBaseUrl() + "media/"+ StrI(m.resourceId).Trim() +"/related?per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.relatedMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.relatedMediaApi.setField("uri",baseUrl)
    m.relatedMediaApi.setField("dataType","related")
    m.relatedMediaApi.observeField("content","onRelatedMediaApiResponse")
    m.relatedMediaApi.control = "RUN"
end sub

'sub onApiResponse()
'    updateCounter()
'    if m.counter = m.counterMaxValue
'        m.counter = 0
'        m.Error_text.visible = false
'        hideProgressDialog()
'        m.mediaDetailRectangle.visible = true
'        onMediaDetailApiResponse()
'        onRelatedMediaApiResponse()
'        
'        
'        'initializing the currentFocus id 
'        if m.isDocument
'            m.currentFocusID ="buttonFavRight"
'            initFocusWithout()
'            handlebuttonSelectedState()
'            m.buttonFavRight.SetFocus(true)
'        else
'            m.currentFocusID ="buttonPlay"
'            initFocus()
'            handlebuttonSelectedState()
'            m.buttonPlay.SetFocus(true)
'        end if
'        
'        startMoreTimer()
'    end if
'end sub

sub onMediaDetailApiResponse()
    m.mediaDetailModel = m.mediaDetailApi.content
    if m.mediaDetailModel <> invalid AND m.mediaDetailModel.success
        getRelatedMedia()
        m.mediaDetailBgPoster.uri = m.mediaDetailModel.small
        m.labelTitle.text = m.mediaDetailModel.title
        m.descLabel.text = m.mediaDetailModel.description       
    else
        hideProgressDialog()
        showRetryDialog(apiErrorMessage(), networkErrorMessage())
    end if
End sub

sub onRelatedMediaApiResponse()
    m.relatedMediaModel = m.relatedMediaApi.content
    if m.relatedMediaModel <> invalid AND m.relatedMediaModel.success
        if m.relatedMediaModel.relatedMediaArray.count() <> 0
            relatedContentList()
        end if
        
        m.Error_text.visible = false
        hideProgressDialog()
        m.mediaDetailRectangle.visible = true
        
        if m.mediaDetailModel.is_media
            m.isDocument = false
            m.labelMediaTime.text = getMediaTimeFromSeconds(m.mediaDetailModel.duration)
            showPlayFavButton()
        else
            m.isDocument = true
            m.labelMediaTime.text = "Document"
            showFavDescText()
        end if
        
        if m.mediaDetailModel.favorite
            m.isFav = true
            if m.isDocument
                setButtonUnFocusedState(m.favButtonRightrectangle, true)
            else
                setButtonFocusedState(m.favButtonRightrectangle, true)
            end if
        else
            m.isFav = false
            if m.isDocument
                setButtonUnFocusedState(m.favButtonRightrectangle, true)
            else
                setButtonFocusedState(m.favButtonRightrectangle, true)
            end if
        end if     
        
        if m.isDocument
            m.currentFocusID ="buttonFavRight"
            initFocusWithout()
            handlebuttonSelectedState()
            m.buttonFavRight.SetFocus(true)
        else
            m.currentFocusID ="buttonPlay"
            initFocus()
            handlebuttonSelectedState()
            m.buttonPlay.SetFocus(true)
        end if
        
        startMoreTimer()
    
    else
        hideProgressDialog()
        showRetryDialog(apiErrorMessage(), networkErrorMessage())
    end if
end sub

sub relatedContentList()
    m.relatedMediaRowList.visible = true
    m.relatedMediaRowList.SetFocus(false)
    m.relatedMediaRowList.content = getGridRowListContent()
    m.relatedMediaRowList.jumpToRowItem = [0,0]
end sub

sub startMoreTimer()
    m.testtimer = m.top.findNode("more_timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","setFocusArray")
end sub

sub setFocusArray()
    if m.descLabel.isTextEllipsized
        print "entered when more is visible >>>>>>>"
        if m.relatedMediaModel.relatedMediaArray.Count() = 0
            m.focusIDArray.AddReplace("buttonPlay","buttonMore-N-N-buttonFavRight")
            m.focusIDArray.AddReplace("buttonFavRight","buttonMore-N-buttonPlay-N")
        else 
            m.focusIDArray.AddReplace("buttonPlay","buttonMore-relatedMediaRowList-N-buttonFavRight")
            m.focusIDArray.AddReplace("buttonFavRight","buttonMore-relatedMediaRowList-buttonPlay-N")
        end if
    else
        print "entered when more is not visible >>>>>>>" 
        if m.relatedMediaModel.relatedMediaArray.Count() = 0
            m.focusIDArray.AddReplace("buttonPlay","N-N-N-buttonFavRight")
            m.focusIDArray.AddReplace("buttonFavRight","N-N-buttonPlay-N")
        else
            m.focusIDArray.AddReplace("buttonPlay","N-relatedMediaRowList-N-buttonFavRight")
            m.focusIDArray.AddReplace("buttonFavRight","N-relatedMediaRowList-buttonPlay-N") 
        end if
    end if
end sub

function getGridRowListContent() as object
    parentContentNode = CreateObject("roSGNode", "ContentNode")
    if m.relatedMediaModel <> invalid
        row = parentContentNode.CreateChild("ContentNode")
        row.title = "Related Content"
         for index= 0 to m.relatedMediaModel.relatedMediaArray.Count()-1
            rowItem = row.CreateChild("RelatedMediaItemData")
            dataObjet = m.relatedMediaModel.relatedMediaArray[index]
            rowItem.id = dataObjet.resource_id
            rowItem.title = dataObjet.title
            rowItem.imageUri = dataObjet.small
            rowItem.coverBgColor = m.top.getScene().appConfigContent.primary_color
            rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
            rowItem.isViewAll = false
            if dataObjet.type = "Video" OR dataObjet.type = "Audio"
                rowItem.isMedia = true
            else
                rowItem.isMedia = false
            end if
        end for
    end if
'    if m.relatedMediaModel.relatedMediaArray.Count() = 0
'       m.focusIDArray.AddReplace("buttonPlay","buttonMore-N-N-buttonFavRight")
'        m.focusIDArray.AddReplace("buttonFavRight","buttonMore-N-buttonPlay-N") 
'    else
'        m.focusIDArray.AddReplace("buttonPlay","buttonMore-relatedMediaRowList-N-buttonFavRight")
'        m.focusIDArray.AddReplace("buttonFavRight","buttonMore-relatedMediaRowList-buttonPlay-N") 
'    end if
    return parentContentNode 
end function

function onRowItemSelected() as void
    row = m.relatedMediaRowList.rowItemSelected[0]
    col = m.relatedMediaRowList.rowItemSelected[1]
    print "**********Row is *********";row
    print "**********col is *********";col
    m.resourceId = m.relatedMediaModel.relatedMediaArray[col].resource_id
    getMediaDetails()
end function

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
    getMediaDetails()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub

sub handlebuttonSelectedState()
    if m.currentFocusID ="buttonPlay"
        setButtonFocusedState(m.playButtonrectangle, false)
        setButtonUnFocusedState(m.favButtonRightrectangle, true)
        setMoreUnselectedState(m.labelMore)
    else if m.currentFocusID ="buttonFavRight"
        setButtonUnFocusedState(m.playButtonrectangle, false)
        setButtonFocusedState(m.favButtonRightrectangle, true)
        setMoreUnselectedState(m.labelMore)
    else if m.currentFocusID ="relatedMediaRowList"
        setButtonUnFocusedState(m.playButtonrectangle, false)
        setButtonUnFocusedState(m.favButtonRightrectangle, true)
        setMoreUnselectedState(m.labelMore)
    else if m.currentFocusID ="buttonMore"
        setButtonUnFocusedState(m.playButtonrectangle, false)
        setButtonUnFocusedState(m.favButtonRightrectangle, true)
        setMoreSelectedState(m.labelMore)
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ? "focus is in Media Details screen >>>>>>>>> "
        if key="up" OR key="down" OR key="left" OR key="right" Then
            handleFocus(key)
            handlebuttonSelectedState()
            return true
        else if key = "back"
            print "Media Detail Screen back press >>>> "
            if m.mediaMoreScreen <> invalid
                m.mediaMoreScreen.setFocus(false)
                m.mediaMoreScreen = invalid
                m.buttonMore.setFocus(true)
                return true
            else if m.videoPlayer <> invalid
                m.videoPlayer.setFocus(false)
                m.videoPlayer = invalid
                m.buttonPlay.setFocus(true)
                return true
            else
                m.top.visible = false
                return false
            end if
        end if
    end if
    return result 
End function