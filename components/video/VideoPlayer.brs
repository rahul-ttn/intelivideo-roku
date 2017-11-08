sub init()
    m.top.SetFocus(true)
    m.video = m.top.findNode("videoPlayer")
End sub

sub onVideoUri()
    m.videoUri = m.top.uri
End sub

sub onResourceId()
    m.resourceId = m.top.resourceId
    addRecentlyViewedAPI()
    m.videoUri = getApiBaseUrl() +"media/"+m.resourceId+"/streaming_url?access_token="+getValueInRegistryForKey("authTokenValue")
    setVideo()
End sub

function setVideo() as void
  ? "set video node >>>>>"
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = m.videoUri
  videoContent.title = ""
  videoContent.streamformat = "m3u8"

  m.video.content = videoContent
  m.video.control = "play"
  m.video.enableUI = true
  m.video.observeField("state", "OnVideoPlaybackFinished")
  m.video.setFocus(true)
  
  
  
end function

sub OnVideoPlaybackFinished()
    if m.video.state = "finished"
    onKeyEvent("back",true)
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