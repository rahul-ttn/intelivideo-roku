sub init()
    m.top.setFocus(true)
    m.screenName = categoryScreen()
    m.appConfig =  m.top.getScene().appConfigContent 
    
    initNavigationBar()
    m.buttonHomeOpen.setFocus(false)
    m.buttonCategoryOpen.setFocus(true)
    initFields()
end sub

sub initFields()
    m.categoryBackground = m.top.FindNode("categoryBackground")
    m.categoryBackground.color = homeBackground()
    m.parentCategoryRect = m.top.findNode("parentCategoryRect")
    m.categoryLabelList = m.top.findNode("categoryLabelList")
    m.categoriesRowList = m.top.findNode("categoriesRowList")
    m.categoriesRowList.ObserveField("rowItemSelected", "onRowItemSelected")
    m.Error_text  = m.top.FindNode("Error_text")
    callBaseCategoryApi()
End sub

sub callBaseCategoryApi()
    if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        baseUrl = getApiBaseUrl() + "categories?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.baseCategoryApi = createObject("roSGNode","CategoriesApiHandler")
        m.baseCategoryApi.setField("uri",baseUrl)
        m.baseCategoryApi.observeField("content","onCategoryBaseApiResponse")
        m.baseCategoryApi.control = "RUN"
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub onCategoryBaseApiResponse()
     baseCategoryApiModel = m.baseCategoryApi.content
     hideProgressDialog()
    if baseCategoryApiModel.success
        m.baseCategoryArray =  baseCategoryApiModel.baseCategoriesArray
        showBaseCategoryList() 
    else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
    end if
end sub

sub showBaseCategoryList()
    m.categoryLabelList.ObserveField("itemFocused", "onListItemFocused")
    m.categoryLabelList.ObserveField("itemSelected", "onListItemSelected")
    m.content = createObject("roSGNode","ContentNode")
    sectionContent=addListSectionHelper(m.content,"")
    for i = 0 To m.baseCategoryArray.count()-1
        addListItemHelper(sectionContent,m.baseCategoryArray[i].name)
    end for   
    m.categoryLabelList.content = m.content
    'm.categoryLabelList.setFocus(true)
End sub

sub onListItemFocused()
   if checkInternetConnection()
        m.Error_text.visible = false
        showProgressDialog()
        itemId = m.baseCategoryArray[m.categoryLabelList.itemFocused].id
        baseUrl = getApiBaseUrl() + "categories/"+itemId+"?access_token=" + getValueInRegistryForKey("authTokenValue")
        m.itemCategoryApi = createObject("roSGNode","CategorySingleApiHandler")
        m.itemCategoryApi.setField("uri",baseUrl)
        m.itemCategoryApi.observeField("content","onCategorySingleApiResponse")
        m.itemCategoryApi.control = "RUN"
   else
        showRetryDialog(networkErrorTitle(), networkErrorMessage())
   end if
End sub

sub onListItemSelected()
End sub

sub onCategorySingleApiResponse()
    hideProgressDialog()
    print 
    if m.itemCategoryApi.content <> invalid
        if m.itemCategoryApi.content.success
            m.categoryItemApiContent = m.itemCategoryApi.content
            m.categoriesRowList.content = invalid
            categoryItemRowList() 
        end if
    end if 
end sub

sub categoryItemRowList()
    m.categoriesRowList.visible = true
    m.categoriesRowList.SetFocus(false)
    m.categoriesRowList.content = getGridRowListContent()
End sub

function getGridRowListContent() as object
         parentContentNode = CreateObject("roSGNode", "ContentNode")
         
         m.categoriesRowList.itemSize = [200 * 9 + 100, 550]'550  600
         m.categoriesRowList.rowHeights = [550]
         m.categoriesRowList.rowItemSize = [ [550, 500] ]
         m.categoriesRowList.itemSpacing = [ 0, 80 ]
         m.categoriesRowList.rowItemSpacing = [ [80, 0] ]
         
         categoryItemArray = m.categoryItemApiContent.items
         if categoryItemArray.count() >= 10
                n = 9
            else
                n = categoryItemArray.count()-1
         end if
         for numRows = 0 to n
            row = parentContentNode.CreateChild("ContentNode")
             for index = 0 to 0
                  rowItem = row.CreateChild("HomeRowListItemData")
                  dataObjet = categoryItemArray[numRows]
                  rowItem.created_at = dataObjet.created_at
                  rowItem.title = dataObjet.title
                  rowItem.coverBgColor = m.appConfig.primary_color
                  rowItem.imageUri = dataObjet.thumbnail
                  rowItem.isMedia = dataObjet.is_media
                  rowItem.isItem = dataObjet.is_item
                  rowItem.isViewAll = false
                  
                  if dataObjet.item_type = "product"
                    rowItem.id = dataObjet.product_id
                    rowItem.count = dataObjet.media_count
                    rowItem.is_vertical_image = dataObjet.is_vertical_image
                    if getPostedVideoDayDifference(dataObjet.created_at) < 11
                        rowItem.isNew = true
                    else
                        rowItem.isNew = false
                    end if
                  else if dataObjet.item_type = "media"
                    rowItem.id = dataObjet.resource_id
                    rowItem.mediaTime = getMediaTimeFromSeconds(dataObjet.duration)
                  end if
                      
             end for     
          end for 
          if categoryItemArray.Count() >= 10
              row = parentContentNode.CreateChild("ContentNode")
              rowItem = row.CreateChild("HomeRowListItemData")
              rowItem.isViewAll = true
          end if 
         return parentContentNode 
end function

sub onRowItemSelected()
    row = m.categoriesRowList.rowItemSelected[0]
    col = m.categoriesRowList.rowItemSelected[1]
    m.focusedItem = [row,col]
    if row >= 10
        goToViewAllScreen(m.categoryItemApiContent.name,m.categoryItemApiContent.id)
    else
        selectedItem = m.categoryItemApiContent.items[row]
        if selectedItem.item_type = "product"
            goToProductDetailScreen(selectedItem.product_id)
        else if selectedItem.item_type = "media"
            goToMediaDetailScreen(selectedItem.resource_id)
        end if
    end if  
end sub

sub goToViewAllScreen(categoryName as String,id as String)
    m.categoryViewAll = m.top.createChild("CategoryViewAll")
    m.top.setFocus(false)
    m.categoryViewAll.setFocus(true)
    m.categoryViewAll.categoryId = id
    m.categoryViewAll.categoryHeading = categoryName
end sub

sub goToProductDetailScreen(id as Integer)
    m.productDetail = m.top.createChild("ProductDetailScreen")
    m.top.setFocus(false)
    m.productDetail.setFocus(true)
    m.productDetail.product_id = id
end sub

sub goToMediaDetailScreen(id as Integer)
    m.mediaDetail = m.top.createChild("MediaDetailScreen")
    m.top.setFocus(false)
    m.mediaDetail.setFocus(true)
    m.mediaDetail.resource_id = id
end sub

Function onKeyEvent(key as String,press as Boolean) as Boolean
    result = false
    if press
    print "on key event Profile Screen  key >";key
        if key = "right"
            if m.categoryLabelList.hasFocus()
                m.categoryLabelList.setFocus(false)
                m.categoriesRowList.setFocus(true)
            else if m.categoriesRowList.hasFocus()
                m.categoriesRowList.setFocus(true)
            else
                m.categoryLabelList.setFocus(true) 
                m.categoriesRowList.setFocus(false) 
                showCloseState()
'                m.buttonProfileClose.uri = "pkg:/images/$$RES$$/Profile Focused.png" 
'                m.profileLeftRect.translation = [180, 0]
'                m.profileRightRect.translation = [880, 0]
            end if
            result = true
        else if key = "left"
            if  m.categoryLabelList.hasFocus()
                m.categoryLabelList.setFocus(false)
                initNavigationBar()
'                m.profileLeftRect.translation = [400, 0]
'                m.profileRightRect.translation = [1100, 0]
                showOpenState()
'                m.rectSwitchAccountBorder.visible = false
            else if m.categoriesRowList.hasFocus()
                m.categoryLabelList.setFocus(true)
                m.categoriesRowList.setFocus(false)
            end if
            result = true 
        else if key = "down"
            if m.buttonProfileOpen.hasFocus()
                m.rectSwitchAccountBorder.visible = true
                m.buttonSwitchAccount.setFocus(true)
                
            end if
            result = true 
        else if key = "up"
'            if m.buttonSwitchAccount.hasFocus()
'                m.rectSwitchAccountBorder.visible = false
'                m.buttonSwitchAccount.setFocus(false)
'                m.buttonProfileOpen.setFocus(true)
'                 
'            end if
            result = true
        else if key = "back"
'            if m.switchAccount <> invalid 
'               if m.switchAccount.accountSelected
'                    m.top.visible = false
'                    result = false
'                else
'                    m.switchAccount.setFocus(false)
'                    m.buttonSwitchAccount.setFocus(true)
'                    m.switchAccount = invalid
'                    result = true
'                end if
'            else if m.viewAllScreen <> invalid
'                m.viewAllScreen.setFocus(false)
'                m.viewAllScreen = invalid
'                m.categoriesRowList.setFocus(true)
'                m.myContentRowList.jumpToRowItem = m.focusedItem
'                result = true
'            else if m.productDetail <> invalid
'                m.productDetail.setFocus(false)
'                m.productDetail = invalid
'                m.categoriesRowList.setFocus(true)
'                m.categoriesRowList.jumpToRowItem = m.focusedItem
'                result = true
'            else
'                m.top.visible = false
'                result = false
'            end if
'        else 
'            print "key = else"
'            result = true
        end if           
    end if
    return result 
End Function


Function showRetryDialog(title ,message)
  m.Error_text.visible = true
  m.Error_text.text = message
  
  
  dialog = createObject("roSGNode", "Dialog") 
  dialog.backgroundUri = "" 
  dialog.title = title
  dialog.optionsDialog = true 
  dialog.iconUri = ""
  dialog.message = message
  dialog.width = 1200
  dialog.buttons = ["Retry"]
  dialog.optionsDialog = true
  dialog.observeField("buttonSelected", "startTimer") 'The field is set when the dialog close field is set,
  m.top.getScene().dialog = dialog
end Function

sub onRetry()
    callBaseCategoryApi()
end sub

sub startTimer()
    m.top.getScene().dialog.close = true
    m.testtimer = m.top.findNode("timer")
    m.testtimer.control = "start"
    m.testtimer.ObserveField("fire","onRetry")
end sub