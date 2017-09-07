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
    
'    labelX = (300 - m.countryTextLabel.width)/2
'    m.countryTextLabel.transalation = [labelX,320]
'    
'    accountNameLabelX = (300 - m.accountNameLabel.width) / 2
'    accountNameLabelY = (300 - m.accountNameLabel.height) / 2
'    m.accountNameLabel.translation = [accountNameLabelX,accountNameLabelY]
'    
  end function
