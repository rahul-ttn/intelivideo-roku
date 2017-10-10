sub init()
    m.top.SetFocus(true)
End sub

sub getResourceId()
    m.resourceId = m.top.resource_id
    initFields()
    getMediaDetails()
End sub

sub initFields() 
    mediaDetailBackground = m.top.FindNode("mediaDetailBackground")
    mediaDetailBackground.color = homeBackground() 
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
End sub

sub showMoreLabel()
    m.moreButtonrectangle.visible = true
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
        
        getRelatedMedia()
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
End sub

sub onMediaDetailApiResponse()
    hideProgressDialog()
    mediaDetailModel = m.mediaDetailApi.content
    if mediaDetailModel.success
        m.mediaDetailBgPoster.uri = mediaDetailModel.small
        m.labelTitle.text = mediaDetailModel.title
        m.descLabel.text = mediaDetailModel.description
  
        if mediaDetailModel.is_media
            m.labelMediaTime.text = getMediaTimeFromSeconds(mediaDetailModel.duration)
        else
            m.labelMediaTime.text = "Document"
        end if            
    else
        showRetryDialog(mediaDetailModel.error, networkErrorMessage())
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

sub onRelatedMediaApiResponse()
    m.relatedMediaModel = m.relatedMediaApi.content
    if m.relatedMediaModel.success
        if m.relatedMediaModel.relatedMediaArray.count() <> 0
            relatedContentList()
        end if
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub relatedContentList()
    m.relatedMediaRowList.visible = true
    m.relatedMediaRowList.SetFocus(true)
    m.relatedMediaRowList.content = getGridRowListContent()
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