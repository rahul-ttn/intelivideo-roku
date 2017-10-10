function handleFocus(keyEvent)
      handleCurrentFocus(keyEvent,m.currentFocusID)
end function

function handleCurrentFocus(keyEvent,currentFocusId)
      print "currentFocusId  >";currentFocusId
      focusIDs = getFocusMapIds(currentFocusId)      
      ids = focusIDs.Split("-")  
      if keyEvent = "up" then
         changeFocus(ids[0],keyEvent)
      else if keyEvent = "down" then
          changeFocus(ids[1],keyEvent)
      else if keyEvent = "left" then
           changeFocus(ids[2],keyEvent)
      else if keyEvent = "right" then
           changeFocus(ids[3],keyEvent)
      end if
end function

function changeFocus(focusNodeId,keyEvent)
    if focusNodeId <> invalid and focusNodeId <> "N" 
        focusEle = m.top.findNode(focusNodeId)
        focusEle.SetFocus(true)
        setFocusId(focusEle)     
     end if
end function


function setFocusId(focusNode)
    m.currentFocusID = focusNode.id
end function

function getFocusMapIds(focusId)
     return m.focusIDArray[focusId]
end function
