sub init()
           
        m.top.SetFocus(true)
        m.top.itemComponentName = "RelatedMediaItemLayout"
        m.top.numRows = 1
        m.top.itemSize = [200 * 9 + 100, 330]'550  600
        m.top.rowHeights = [330]
        m.top.rowItemSize = [ [546, 307] ]
        m.top.itemSpacing = [ 0, 100 ]
        m.top.rowItemSpacing = [ [150, 0] ]
        m.top.rowLabelOffset = [ [0, 20] ]
        m.top.rowFocusAnimationStyle = "floatingFocus"
        m.top.vertFocusAnimationStyle = "fixedFocus"
        m.top.showRowLabel = [true]
        m.top.rowLabelColor="0xffffffff"
        m.top.visible = true
        m.top.SetFocus(true)
        'm.top.focusBitmapUri="pkg:/images/focus_border.9.png"
        m.top.drawFocusFeedbackOnTop = true
        m.top.drawFocusFeedback = true
end sub