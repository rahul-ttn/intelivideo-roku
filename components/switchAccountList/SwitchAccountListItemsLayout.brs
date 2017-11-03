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
    if itemData.showAddAccount
        print "case 1"
        m.posterBackground.visible = false
        m.accountNameLabel.visible = true
        m.accountNameLabel.text = "+"
        m.accountNameLabel.color = "0x858585"
        m.accountNameLabel.font.size = 100
    else if itemData.showThumbnail AND NOT itemData.showAddAccount 
        print "case 2"
        m.accountNameLabel.visible = false
        m.posterBackground.visible = true
        m.posterBackground.uri = itemData.imageUri
    else if NOT itemData.showThumbnail AND NOT itemData.showAddAccount
        print "case 3" 
        m.posterBackground.visible = false
        m.accountNameLabel.visible = true
        m.accountNameLabel.text = itemData.countryName
    end if
  end function
