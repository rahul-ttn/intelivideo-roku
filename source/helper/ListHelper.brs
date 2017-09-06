Function addListSectionHelper(contentNode as object,sectiontext as string)
     sectionContent =contentNode.createChild("ContentNode")
     sectionContent.CONTENTTYPE = "SECTION"
     sectionContent.TITLE = sectiontext
     return sectionContent
end Function
 
sub addListItemHelper(sectionContent as object,itemtext as string)
    item = sectionContent.createChild("ContentNode")
    item.title = itemtext
end sub
