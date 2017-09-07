sub init()
    m.top.setFocus(true)
    m.countryTextLabel = m.top.findNode("countryTextLabel") 
    m.parentRectangle = m.top.findNode("parentRectangle")
    m.posterBackground = m.top.findNode("posterBackground")
    m.accountNameLabel = m.top.findNode("accountNameLabel")
   End sub


function itemContentChanged() as void
    itemData = m.top.itemContent
    m.countryTextLabel.text = itemData.countryName
  
    if itemData.showThumbnail
        m.posterBackground.uri = itemData.imageUri
    else
        m.accountNameLabel.text = itemData.countryName
    end if
  end function
