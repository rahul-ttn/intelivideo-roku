sub init()
m.top.setFocus(true)
m.countryTextLabel = m.top.findNode("countryTextLabel") 
End sub


function itemContentChanged() as void
    itemData = m.top.itemContent
    m.countryTextLabel.text = itemData.countryName
  end function
