sub init()
    m.top.SetFocus(true)
End sub

sub setData()
    m.titleText = m.top.titleText
    m.moreText = m.top.moreText
    initField()
end sub

sub initField()
    m.labelHeading = m.top.FindNode("labelHeading")
    m.labelHeading.text = m.titleText
    m.labeMore = m.top.FindNode("labeMore")
    m.labeMore.text = m.moreText
    m.labeMore.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key="up" OR key="down" OR key="left" OR key="right" Then
            return true
        else if key = "back"
            m.top.visible = false
        end if
    end if
    return result 
End function
