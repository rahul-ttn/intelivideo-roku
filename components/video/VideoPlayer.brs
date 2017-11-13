sub init()
    m.top.SetFocus(true)
    m.video = m.top.findNode("videoPlayer")
    m.upNextRectangle = m.top.findNode("outerUpNextRectangle")
    m.posterUpNext = m.top.findNode("posterUpNext")
    m.labelTitle = m.top.findNode("labelTitle")
   ' m.audioPoster = m.top.findNode("audioPoster")
    m.upNextRectangle.visible = false
End sub

sub onResourceId()
    m.resourceId = m.top.resourceId
    addRecentlyViewedAPI()
    m.videoUri = getApiBaseUrl() +"media/"+m.resourceId+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
    setVideo()
End sub

'This method is called when play event is launched from MediaDetailsScreen 
function setVideo() as void
  m.vidContent = createObject("RoSGNode", "ContentNode")
  m.vidContent.url = m.videoUri
  m.vidContent.title = ""
  m.vidContent.streamformat = "hls"

  m.video.content = m.vidContent
  m.video.control = "play"
  m.video.enableUI = true
  m.video.observeField("state", "OnVideoPlaybackFinished")
  m.video.setFocus(true) 
end function

'This method is called when play button is clicked from ProductDetailScreen
sub setVideoArray()
    m.videoArray = m.top.videoArray
    addRecentlyViewedAPI()
    m.resourceIdSelected = m.top.resourceIdSelected
    setVideoContentArray()
    for i=0 To m.videoIndexArray.count() -1
        if m.resourceIdSelected = m.videoIndexArray[i].resource_id
           m.indexSelected = i
        end if
    end for
    playVideo()
end sub

sub setVideoContentArray()
    m.videoContentArray = CreateObject("roArray",0, true) 'array to store videoContent for every node with different model
    m.videoIndexArray = CreateObject("roArray",0, true) 'array to store only id of elements that are of type either video or audio 
    for i = 0 TO m.videoArray.count() - 1 
        videoContentChild = createObject("RoSGNode", "ContentNode")
        mediaModel = m.videoArray[i]
        if mediaModel.type = "Video" or mediaModel.type = "Audio"
'            if mediaModel.type = "Audio"
'                m.audioPoster.visible = true
'                m.audioPoster.uri = mediaModel.small
'            end if
            m.videoIndexArray.push(mediaModel)
            
            videoContentChild.url = getApiBaseUrl() +"media/"+StrI(mediaModel.resource_id).Trim()+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
            videoContentChild.title = mediaModel.title
            videoContentChild.streamformat = "hls"
            m.videoContentArray.Push(videoContentChild) 
        end if
    end for
end sub

sub playVideo()
     print "resourceIdSelected used to Play video >";m.resourceIdSelected
     m.video.content = m.videoContentArray[m.indexSelected]
    'm.video.contentIsPlaylist = true
    m.video.control = "play"
    m.video.enableUI = true 
    m.upNextRectangle.visible = false 
    m.video.observeField("position","printPosition")
    m.video.observeField("state", "OnVideoPlaybackFinished")
    m.video.setFocus(true) 
end sub 

sub printPosition()
    print m.video.position;"=============";m.video.duration
    mediaModel = m.videoIndexArray[m.indexSelected + 1]
    if m.indexSelected = m.videoContentArray.count()-1
        m.upNextRectangle.visible = false
    else if Int(m.video.position) = (m.video.duration - 10) or Int(m.video.duration) < 10
        m.upNextRectangle.visible = true
        m.posterUpNext.uri = mediaModel.small
        m.labelTitle.text = mediaModel.title
    end if
end sub

sub OnVideoPlaybackFinished()
    if m.video.state = "finished"
        m.video.control = "stop"
        if m.indexSelected < m.videoContentArray.count()
            m.indexSelected = m.indexSelected + 1
            playVideo()
        else   
            m.top.visible = false
            m.top.getParent().backPressed = 11
        end if
    end if
end sub

sub addRecentlyViewedAPI()
    m.top.getScene().isRefreshOnBack = true
    baseUrl = getApiBaseUrl() +"recent?access_token=" + getValueInRegistryForKey("authTokenValue")
    parmas = createRecentlyViewedParams(m.resourceId,"media")
    m.recentlyViewedApi = createObject("roSGNode","AddRecentlyViewedApiHandler")
    m.recentlyViewedApi.setField("uri",baseUrl)
    m.recentlyViewedApi.setField("params",parmas)
    m.recentlyViewedApi.control = "RUN"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key="up" OR key="down" OR key="left" OR key="right" Then
            return true
        else if key = "ok"
            return true
        else if key = "back"
            m.video.control = "stop"
            m.top.visible = false
            return false
        end if
    end if
    return result 
End function

sub onRetry()
    m.video.control = "resume"
    print "m.video.duration ";m.video.duration
end sub

sub startTimer()
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub