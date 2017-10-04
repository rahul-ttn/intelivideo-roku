sub init()
    m.top.setFocus(true)
    m.list = m.top.findNode("list")
    'callPopularProductsApi()   
end sub

sub setData()
    print "set data called????????????????"
    m.titleText = m.top.titleText
    
end sub

sub setArray()
    print "set Array called????????????????"
    m.contentArray = m.top.contentArray
    print "//////////////////////";m.contentArray
    showList()
end sub

sub callPopularProductsApi()
    baseUrl = getApiBaseUrl() + "lists/popular?content_type=product&per_page=10&page_number=1&access_token=" + getValueInRegistryForKey("authTokenValue")
    m.popularProductApi = createObject("roSGNode","FeatureProductApiHandler")
    m.popularProductApi.setField("uri",baseUrl)
    m.popularProductApi.setField("dataType","popular")
    m.popularProductApi.observeField("content","onProductsResponse")
    m.popularProductApi.control = "RUN"
    showProgressDialog()
end sub

sub onProductsResponse()
    m.popularProductApiModel = m.popularProductApi.content
    if m.popularProductApiModel.success
        hideProgressDialog()
        showList()
    end if
end sub

sub showList()
    m.list.visible = true
    m.list.SetFocus(false)
    m.list.ObserveField("rowItemSelected", "onRowItemSelected")
    m.list.content = getGridRowListContent()
    m.list.setFocus(true)
end sub

function onRowItemSelected() as void
        print "***** Some's wish is ********";m.list.rowItemSelected
        row = m.list.rowItemSelected[0]
        col = m.list.rowItemSelected[1]
        print "**********Row is *********";row
        print "**********col is *********";col
        
end function

function getGridRowListContent() as object
    m.list.itemComponentName = "Home3xListItemLayout"
    m.list.itemSize = [200 * 9 + 100, 445]
    m.list.rowHeights = [445]
    m.list.rowItemSpacing = [ [150, 0] ]
    m.list.rowItemSize = [ [448, 445] ]
    numberOfRows = (m.contentArray.count() + 2) \ 3 
    n = 2
    ind = 0
    parentContentNode = CreateObject("roSGNode", "ContentNode") 
    for numRows = 0 to numberOfRows-1
        row = parentContentNode.CreateChild("ContentNode")
        row.title = ""
        for index = 0 to n
            if ind < m.contentArray.count()
                rowItem = row.CreateChild("HomeRowListItemData")
                dataObjet = m.contentArray[ind]
                rowItem.id = dataObjet.product_id
                rowItem.title = dataObjet.title
                rowItem.imageUri = dataObjet.small
                rowItem.count = dataObjet.media_count
                'rowItem.coverBgColor = m.appConfig.primary_color
                rowItem.isMedia = false
                rowItem.isItem = true
                rowItem.isViewAll = false
                if getPostedVideoDayDifference(dataObjet.created_at) < 11
                    rowItem.isNew = true
                else
                    rowItem.isNew = false
                end if
                ind = ind + 1
            end if
        end for
    end for
    return parentContentNode
end function