sub init()
    m.top.SetFocus(true)
    m.posterRect = m.top.findNode("posterRect") 
    m.posterVod = m.top.findNode("posterVod")
    m.labelTitle = m.top.findNode("labelTitle") 
    m.rectTimer = m.top.findNode("rectTimer")
    m.labelMediaTime = m.top.findNode("labelMediaTime")
End sub


function itemContentChanged() as void
    itemData = m.top.itemContent
    m.posterRect.color = itemData.coverBgColor
    m.posterVod.uri = itemData.imageUri
    m.labelTitle.text = itemData.title
     if itemData.isMedia
        m.rectTimer.visible = true
        m.labelMediaTime.text = itemData.mediaTime
     else
        m.rectTimer.visible = false
    end if
end function