sub init()
      m.top.SetFocus(true)
      m.posterRect = m.top.findNode("posterRect") 
      m.posterVod = m.top.findNode("posterVod") 
      m.rectNew = m.top.findNode("rectNew") 
      m.labelDescription = m.top.findNode("labelDescription") 
      m.posterFav = m.top.findNode("posterFav") 
      m.labelItemCount = m.top.findNode("labelItemCount") 
      m.rectNew = m.top.findNode("rectNew") 
      m.rectItemCount = m.top.findNode("rectItemCount") 
      m.rectTimer = m.top.findNode("rectTimer")
      m.posterTimer = m.top.findNode("posterTimer")
End sub


function itemContentChanged() as void
    itemData = m.top.itemContent
    m.posterVod.uri = itemData.imageUri
    m.labelDescription.text = itemData.title
    m.labelItemCount.text = StrI(itemData.count) + " Items"
    m.posterRect.color = itemData.coverBgColor
    m.rectNew.color = itemData.coverBgColor
    m.rectItemCount.color = itemData.coverBgColor
    if itemData.isNew
        m.rectNew.visible = true
    else
        m.rectNew.visible = false
    end if
    
    if itemData.isMedia
        'show timer
        m.rectTimer.visible = true
        m.rectItemCount.visible = false
    else
        'show media count
        m.rectTimer.visible = false
        m.rectItemCount.visible = true
        itemCountLabelWidth = Len(m.labelItemCount.text) * 18
        m.rectItemCount.width = itemCountLabelWidth 
    end if
    
  end function