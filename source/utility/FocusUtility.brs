function handleFocus(keyEvent)
      handleCurrentFocus(keyEvent,m.currentFocusID)
end function

function handleCurrentFocus(keyEvent,currentFocusId)
      focusIDs = getFocusMapIds(currentFocusId)      
      print "focusIDs => ";focusIDs
      ids = focusIDs.Split("-") 
      print ids     
      if(keyEvent = "up") then
         changeFocus(ids[0],keyEvent)
      else if(keyEvent = "down") then
          changeFocus(ids[1],keyEvent)
      else if(keyEvent = "left") then
           changeFocus(ids[2],keyEvent)
      else if(keyEvent = "right") then
           changeFocus(ids[3],keyEvent)
      end if
end function

function changeFocus(focusNodeId,keyEvent)
    print focusNodeId
    if(focusNodeId <> invalid and focusNodeId <> "N" )
        print focusNodeId
        focusEle = m.top.findNode(focusNodeId)
        focusEle.SetFocus(true)
        setFocusId(focusEle)     
     end if
end function


function setFocusId(focusNode)
    print focusNode
    m.currentFocusID = focusNode.id
    print m.currentFocusID
end function

function getFocusMapIds(focusId)
     return m.focusIDArray[focusId]
end function
