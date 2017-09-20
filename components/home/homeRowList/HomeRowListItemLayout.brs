sub init()
      m.top.SetFocus(true)
      m.posterVod = m.top.findNode("posterVod") 
      m.labelNew = m.top.findNode("labelNew") 
      m.labelDescription = m.top.findNode("labelDescription") 
      m.posterFav = m.top.findNode("posterFav") 
      m.labelItemCount = m.top.findNode("labelItemCount") 
End sub


function itemContentChanged() as void
    itemData = m.top.itemContent
    m.posterVod.uri = itemData.imageUri
    m.labelDescription.text = itemData.title
    m.labelItemCount.text = StrI(itemData.count) + " Items"
  end function