sub init()
'    di = CreateObject("roDeviceInfo")
'    uiRes = di.GetUIResolution()
'    print uiRes
'    m.rect = m.top.findNode("rectangle")
'    centerX = (uiRes.width - m.rect.width) / 2
'    centerY = (uiRes.height - m.rect.height) / 2
'    m.rect.translation = [centerX, centerY]
'    
    m.label = m.top.findNode("buttonTextLabel")
'    labelX = (m.rect.width - m.label.width) / 2
'    labelY = (m.rect.height - m.label.height) / 2
'    m.label.translation = [labelX,labely]
    
    m.button = m.top.findNode("button")
end sub

function setText(txt as String) as void
    m.label.text = txt
end function

function getButtonNode() as Object
    return m.button
end function