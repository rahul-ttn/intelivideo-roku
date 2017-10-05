sub init()
      m.top.SetFocus(true)
      m.posterRect = m.top.findNode("posterRect") 
      m.rectangle = m.top.findNode("rectangle")
      m.labelViewAll = m.top.findNode("labelViewAll")
      m.posterVod = m.top.findNode("posterVod") 
      m.rectNew = m.top.findNode("rectNew") 
      m.labelDescription = m.top.findNode("labelDescription") 
      m.posterFav = m.top.findNode("posterFav") 
      m.labelItemCount = m.top.findNode("labelItemCount") 
      m.rectNew = m.top.findNode("rectNew") 
      m.rectItemCount = m.top.findNode("rectItemCount") 
      m.rectTimer = m.top.findNode("rectTimer")
      m.posterTimer = m.top.findNode("posterTimer")
      m.labelMediaTime = m.top.findNode("labelMediaTime")
      m.posterArrow = m.top.findNode("posterArrow")
      
      labelViewAllX = (m.rectangle.width - m.labelViewAll.width) / 2
      labelViewAllY = (m.rectangle.height - m.labelViewAll.height) / 2
      m.labelViewAll.translation = [labelViewAllX , labelViewAllY]
        
      posterArrowX = (m.rectangle.width - m.posterArrow.width) / 2
      posterArrowY = ((m.rectangle.height - m.posterArrow.height) / 2 ) + 50
      m.posterArrow.translation = [posterArrowX , posterArrowY]
    
End sub


function itemContentChanged() as void
    itemData = m.top.itemContent
    if itemData.isViewAll 
         m.labelViewAll.visible = true
         m.posterArrow.visible = true
         m.rectangle.visible = false
    else
         m.labelViewAll.visible = false
         m.posterArrow.visible = false
         m.rectangle.visible = true
    end if
    
    m.posterVod.uri = itemData.imageUri
    m.labelDescription.text = itemData.title
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
        m.labelMediaTime.text = itemData.mediaTime
    end if
    
    if itemData.isItem
        'show Item count
        m.rectTimer.visible = false
        m.rectItemCount.visible = true
        m.labelItemCount.text = StrI(itemData.count) + " Items"
        itemCountLabelWidth = Len(m.labelItemCount.text) * 18
        m.rectItemCount.width = itemCountLabelWidth 
    end if
    
  end function