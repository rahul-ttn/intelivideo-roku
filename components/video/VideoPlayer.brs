sub init()
    m.top.SetFocus(true)
    m.video = m.top.findNode("videoPlayer")
    m.upNextRectangle = m.top.findNode("outerUpNextRectangle")
    m.posterUpNext = m.top.findNode("posterUpNext")
    m.labelTitle = m.top.findNode("labelTitle")
    m.upNextRectangle.visible = false
End sub

sub onResourceId()
    m.resourceId = m.top.resourceId
    addRecentlyViewedAPI()
    m.videoUri = getApiBaseUrl() +"media/"+m.resourceId+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
    setVideo()
End sub

sub setVideoArray()
    m.videoArray = m.top.videoArray
    print "VideoArray received";m.videoArray
    setVideoContentArray()
    m.video.content = m.videoContent
    m.video.contentIsPlaylist = true
    m.video.control = "play"
    m.video.enableUI = true 
    m.video.observeField("position","printPosition")
    m.video.observeField("contentIndex","updateUpNextVisibility")
    m.video.observeField("state", "OnVideoPlaybackFinished")
    m.video.setFocus(true) 
end sub

sub printPosition()
    print m.video.position;"========";m.video.contentIndex;"=====";m.video.duration
    mediaModel = m.videoContentArray[m.video.contentIndex +1]
    if m.video.contentIndex = m.videoContentArray.count()-1
        m.upNextRectangle.visible = false
    else if Int(m.video.position) = (m.video.duration - 10) or Int(m.video.duration) < 10
        m.upNextRectangle.visible = true
        m.posterUpNext.uri = mediaModel.small
        m.labelTitle.text = mediaModel.title
    end if
end sub

sub updateUpNextVisibility()
    print "m.video.nextContentIndex >";m.video.nextContentIndex
    m.video.nextContentIndex = m.video.contentIndex + 1
    m.upNextRectangle.visible = false 
end sub

function setVideo() as void
  m.videoContent = createObject("RoSGNode", "ContentNode")
  m.videoContent.url = m.videoUri
  m.videoContent.title = ""
  m.videoContent.streamformat = "hls"

  m.video.content = videoContent
  m.video.control = "play"
  m.video.enableUI = true
  m.video.observeField("state", "OnVideoPlaybackFinished")
  m.video.setFocus(true) 
end function

sub setVideoContentArray()
     m.videoContent = createObject("RoSGNode", "ContentNode")
    m.videoContentArray = CreateObject("roArray",0, true)
    for i = 0 TO m.videoArray.count() - 1 
        videoContentChild = m.videoContent.createChild("ContentNode")
        mediaModel = m.videoArray[i]
        if mediaModel.type = "Video"
            m.videoContentArray.Push(mediaModel) 
            print getApiBaseUrl() +"media/"+StrI(mediaModel.resource_id).Trim()+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
            videoContentChild.url = getApiBaseUrl() +"media/"+StrI(mediaModel.resource_id).Trim()+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
            videoContentChild.title = mediaModel.title
            videoContentChild.streamformat = "m3u8"
        else if mediaModel.type = "Audio"
            m.videoContentArray.Push(mediaModel) 
            print getApiBaseUrl() +"media/"+StrI(mediaModel.resource_id).Trim()+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
            videoContentChild.url = getApiBaseUrl() +"media/"+StrI(mediaModel.resource_id).Trim()+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
            videoContentChild.title = mediaModel.title
            videoContentChild.streamformat = "mp3"
        end if
    end for
end sub

sub OnVideoPlaybackFinished()
    if m.video.state = "finished"
        m.video.control = "stop"
        m.top.visible = false
        m.top.getParent().backPressed = 11
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