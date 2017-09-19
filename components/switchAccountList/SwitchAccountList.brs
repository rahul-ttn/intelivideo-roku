sub init()
    m.top.SetFocus(true)
        m.top.itemComponentName = "SelectAccountListItemsLayout"
        m.top.numRows = 1
        m.top.itemSize = [200 * 9 + 100, 100]
       ' m.top.itemSize = [1500, 100]
        m.top.rowHeights = [400]'no effect
        m.top.rowItemSize = [ [300, 360] ] 'changed the size of each item in a row
        m.top.itemSpacing = [ 0, 200 ]
        m.top.rowItemSpacing = [ [300, 200] ] 'set the spacing of each item in row
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
