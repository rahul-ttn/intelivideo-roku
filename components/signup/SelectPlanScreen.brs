sub init()
    m.top.setFocus(true)
    initFields()
end sub

sub initFields()
    m.parentRectangle = m.top.findNode("rectangleouter")
    m.posterBackground = m.top.findNode("posterBackground")
    m.labelTitle = m.top.findNode("labelTitle")
    m.labelSubTitle = m.top.findNode("labelSubTitle")
    
        
end sub

