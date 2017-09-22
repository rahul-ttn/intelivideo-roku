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
    else
        'show media count
    end if
    
  end function