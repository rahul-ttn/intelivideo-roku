sub init()
    m.top.SetFocus(true)
        m.top.itemComponentName = "SelectAccountListItemsLayout"
        m.top.numRows = 3
        m.top.itemSize = [200 * 9 + 100, 100]
        m.top.rowHeights = [100]
        m.top.rowItemSize = [ [200, 100] ]
        m.top.itemSpacing = [ 0, 120 ]
        m.top.rowItemSpacing = [ [20, 0] ]
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
