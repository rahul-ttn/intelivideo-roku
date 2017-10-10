sub init()
    m.top.SetFocus(true)
    m.BUTTONTEXT = 25
    m.appConfig =  m.top.getScene().appConfigContent
    m.counter = 0
    m.counterMaxValue = 2
    m.isDocument = false
End sub

sub getResourceId()
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
    m.focusIDArray = { "buttonMore":"N-buttonPlay-N-N"  
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
    m.labelMore = m.top.findNode("labelMore")
    
    m.relatedMediaRowList  = m.top.FindNode("relatedMediaRowList")
    m.relatedMediaRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    
    
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
        
    m.documentInfoLabel = m.top.findNode("documentInfoLabel")
    m.documentInfoLabel.font.size = 30 
End sub

sub showMoreLabel()
    m.moreButtonrectangle.visible = true
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
    m.playButtonOuterRectangle.translation = [200,520]
    m.favButtonOuterRightRectangle.translation = [390,520]
    m.documentInfoLabel.visible = false
end sub

sub showFavDescText()
    m.playButtonOuterRectangle.visible = false
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
        m.mediaDetailApi.observeField("content","onApiResponse")
        m.mediaDetailApi.control = "RUN"
        getRelatedMedia()
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
End sub

sub getRelatedMedia()
    baseUrl = getApiBaseUrl() + "media/"+ StrI(m.resourceId).Trim() +"/related?per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.relatedMediaApi = createObject("roSGNode","FeatureMediaApiHandler")
    m.relatedMediaApi.setField("uri",baseUrl)
    m.relatedMediaApi.setField("dataType","related")
    m.relatedMediaApi.observeField("content","onApiResponse")
    m.relatedMediaApi.control = "RUN"
end sub

sub onApiResponse()
    updateCounter()
    if m.counter = m.counterMaxValue
        m.counter = 0
        m.Error_text.visible = false
        hideProgressDialog()
        m.mediaDetailRectangle.visible = true
        onMediaDetailApiResponse()
        onRelatedMediaApiResponse()
        
        'initializing the currentFocus id 
        if m.isDocument
            m.currentFocusID ="buttonFavRight"
            initFocusWithout()
        else
            m.currentFocusID ="buttonPlay"
            initFocus()
        end if
        
        handlebuttonSelectedState()
        m.buttonPlay.SetFocus(true)
        
        startMoreTimer()
    end if
end sub

sub onMediaDetailApiResponse()
    mediaDetailModel = m.mediaDetailApi.content
    if mediaDetailModel.success
        m.mediaDetailBgPoster.uri = mediaDetailModel.small
        m.labelTitle.text = mediaDetailModel.title
        m.descLabel.text = mediaDetailModel.description
  
        if mediaDetailModel.is_media
            m.isDocument = false
            m.labelMediaTime.text = getMediaTimeFromSeconds(mediaDetailModel.duration)
            showPlayFavButton()
        else
            m.isDocument = true
            m.labelMediaTime.text = "Document"
            showFavDescText()
        end if            
    else
        showRetryDialog(mediaDetailModel.error, networkErrorMessage())
    end if
End sub

sub onRelatedMediaApiResponse()
    m.relatedMediaModel = m.relatedMediaApi.content
    if m.relatedMediaModel.success
        if m.relatedMediaModel.relatedMediaArray.count() <> 0
            relatedContentList()
        end if
    end if
end sub

sub relatedContentList()
    m.relatedMediaRowList.visible = true
    m.relatedMediaRowList.SetFocus(false)
    m.relatedMediaRowList.content = getGridRowListContent()
end sub

sub startMoreTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("more_timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","setFocusArray")
end sub

sub setFocusArray()
    if m.descLabel.isTextEllipsized
        print "entered when more is visible >>>>>>>"
        m.focusIDArray.AddReplace("buttonPlay","buttonMore-relatedMediaRowList-N-buttonFavRight")
        m.focusIDArray.AddReplace("buttonFavRight","buttonMore-relatedMediaRowList-buttonPlay-N")
    else
        print "entered when more is not visible >>>>>>>" 
        m.focusIDArray.AddReplace("buttonPlay","N-relatedMediaRowList-N-buttonFavRight")
        m.focusIDArray.AddReplace("buttonFavRight","N-relatedMediaRowList-buttonPlay-N")
    end if
end sub

function getGridRowListContent() as object
    parentContentNode = CreateObject("roSGNode", "ContentNode")
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
        setButtonFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.labelMore)
    else if m.currentFocusID ="buttonFavRight"
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.labelMore)
    else if m.currentFocusID ="relatedMediaRowList"
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreUnselectedState(m.labelMore)
    else if m.currentFocusID ="buttonMore"
        setButtonUnFocusedState(m.playButtonrectangle)
        setButtonUnFocusedState(m.favButtonRightrectangle)
        setMoreSelectedState(m.labelMore)
    end if
end sub

sub setButtonFocusedState(selectedRectangle as object)
    selectedRectangle.color = "0xffffffff"
end sub

sub setButtonUnFocusedState(unfocusedRectangle as object)
    unfocusedRectangle.color = "0x858585ff"
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