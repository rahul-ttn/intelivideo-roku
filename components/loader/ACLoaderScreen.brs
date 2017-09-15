sub init()
    m.top.backgroundUri=""
    m.top.backgroundColor="0x000000ff"
    spinner = m.top.FindNode("spinner")
    spinner.poster.uri="pkg:/images/busyspinner_hd.png"
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean
       result = false

        if press    
        if key = "back"
           result = true
        else if key = "right"
             result = true 
        else if key = "left"
             result = true 
        else if key = "down"
             result = true    
        else if key = "up"
             print "control coming hrer"
             result = true 
        end if
        end if
     print "final result status";result
    return result
end function