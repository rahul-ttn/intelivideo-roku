sub init()
           
        m.top.SetFocus(true)
        m.top.itemComponentName = "HomeRowListItemLayout"
        m.top.numRows = 3
        m.top.itemSize = [200 * 9 + 100, 600]'550  600
        m.top.rowHeights = [600]
        m.top.rowItemSize = [ [550, 500] ]
        m.top.itemSpacing = [ 0, 100 ]
        m.top.rowItemSpacing = [ [150, 0] ]
        m.top.rowLabelOffset = [ [0, 20] ]
        m.top.rowFocusAnimationStyle = "floatingFocus"
        m.top.vertFocusAnimationStyle = "floatingFocus"
        m.top.showRowLabel = [true]
        m.top.rowLabelColor="0xa0b033ff"
        m.top.visible = true
        m.top.SetFocus(true)
        'm.top.focusBitmapUri="pkg:/images/focus_border.9.png"
        m.top.drawFocusFeedbackOnTop = true
        m.top.drawFocusFeedback = true
end sub