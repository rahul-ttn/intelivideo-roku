sub init()
    m.top.functionName = "callApiHandler"
end sub

sub callApiHandler()
     response = callGetApi(m.top.uri)
     if response <> invalid
        m.responseCode = response.GetResponseCode()
        responseString = response.GetString()
        json = ParseJSON(response)
        parseApiResponse(json)
     else
        categoryApiModel = CreateObject("roSGNode", "BaseCategoryModel")
        categoryApiModel.success = false
        m.top.content = categoryApiModel
     end if
end sub

sub parseApiResponse(response As Object)
    categoryApiModel = CreateObject("roSGNode", "BaseCategoryModel")
    if m.responseCode = 200
        categoryApiModel.success = true
        categoryItems = response.categories
        
        categoryArray = CreateObject("roArray", categoryItems.count(), false)
        for each categoryItem in categoryItems
            categoryItemModel = CreateObject("roSGNode", "BaseCategoryItemModel")
            categoryItemModel.id = categoryItem.id
            categoryItemModel.name = categoryItem.name
            
            categoryArray.Push(categoryItemModel)
        end for
        categoryApiModel.baseCategoriesArray = categoryArray 
    else 
        categoryApiModel.success = false
        categoryApiModel.error = apiErrorMessage()
    end if
    m.top.content = categoryApiModel
    
    print categoryApiModel
end sub
