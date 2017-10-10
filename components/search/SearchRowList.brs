sub init()
           
        m.top.SetFocus(true)
        m.top.itemComponentName = "Home3xListItemLayout"
        m.top.numRows = 3
        m.top.itemSize = [200 * 9 + 100, 445]'550  600
        m.top.rowHeights = [445]
        m.top.rowItemSize = [ [448, 445] ]
        m.top.itemSpacing = [ 0, 100 ]
        m.top.rowItemSpacing = [ [100, 0] ]
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