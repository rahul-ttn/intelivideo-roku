sub init()
    m.top.SetFocus(true)
    setVideo()
End sub

sub onVideoUri()
    m.videoUri = m.top.uri
    'setVideo()
End sub

sub onResourceId()
    m.resourceId = m.top.resourceId
    addRecentlyViewedAPI()
End sub

function setVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = "pkg:/videos/login_video.mov"
  videoContent.title = ""
  videoContent.streamformat = "mov"
  
  m.video = m.top.findNode("videoPlayer")
  m.video.content = videoContent
  m.video.control = "play"
  m.video.loop = false
  m.video.bufferingBar.visible = false
  m.video.bufferingTextColor = "0xffffff00"
  m.video.retrievingBar.visible = false
  m.video.retrievingTextColor = "0xffffff00"
end function

sub addRecentlyViewedAPI()
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
        else if key = "back"
            m.video.control = "stop"
            m.top.visible = false
            return false
        end if
    end if
    return result 
End function