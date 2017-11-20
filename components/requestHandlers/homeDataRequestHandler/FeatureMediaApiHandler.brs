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
        featureMediaModel = CreateObject("roSGNode", "FeatureMediaModel")
        featureMediaModel.success = false
        m.top.content = featureMediaModel
     end if
end sub

sub parseApiResponse(response As Object)
    featureMediaModel = CreateObject("roSGNode", "FeatureMediaModel")
    if m.responseCode = 200
        featureMediaModel.code = 200
        featureMediaModel.success = true
        if m.top.dataType = "search"
            medias = response.media.results
        else
            medias = response.media
        end if
        
        mediaArray = CreateObject("roArray", medias.count(), false)
        for each mediaItem in medias
            mediaModel = CreateObject("roSGNode", "MediaDataModel")
            mediaModel.resource_id = mediaItem.resource_id
            mediaModel.type = mediaItem.type
            mediaModel.title = mediaItem.title
            mediaModel.duration = mediaItem.duration
            mediaModel.small = mediaItem.cover_art.small
            mediaModel.created_at = mediaItem.created_at
            mediaModel.description = mediaItem.description
            mediaModel.favorite = mediaItem.favorite
            
'            if mediaItem.horizontal_cover_art <> invalid
'                mediaModel.is_vertical_image = false
'                mediaModel.small = mediaItem.horizontal_cover_art.small
'            else if mediaItem.vertical_cover_art <> invalid
'                mediaModel.is_vertical_image = true
'                mediaModel.small = mediaItem.vertical_cover_art.small
'            else if mediaItem.banner_image <> invalid
'                mediaModel.is_vertical_image = false
'                mediaModel.small = mediaItem.banner_image.small
'            end if
            
            if mediaItem.type = "Video" OR mediaItem.type = "Audio"
                mediaModel.is_media = true
            else
                mediaModel.is_media = false
            end if
            mediaModel.is_item = false
            
            mediaArray.Push(mediaModel)
        end for
        
        if m.top.dataType = "feature"
            featureMediaModel.featuredMediaArray = mediaArray
        else if m.top.dataType = "popular"
            featureMediaModel.popularMediaArray = mediaArray
        else if m.top.dataType = "recentAdded"
            featureMediaModel.recentlyAddedMediaArray = mediaArray
        else if m.top.dataType = "related"
            featureMediaModel.relatedMediaArray = mediaArray
        else if m.top.dataType = "recent"
            featureMediaModel.recentMediaArray = mediaArray
        else if m.top.dataType = "search"
            featureMediaModel.searchMediaArray = mediaArray
            response = response.media
        end if 
        
        pageInfoModel = CreateObject("roSGNode", "PageInfoModel")
        pageInfoModel.total_items = response.page_info.total_items
        pageInfoModel.total_pages = response.page_info.total_pages
        pageInfoModel.first_page = response.page_info.first_page
        pageInfoModel.last_page = response.page_info.last_page
        pageInfoModel.previous_page = response.page_info.previous_page
        pageInfoModel.next_page = response.page_info.next_page
        pageInfoModel.out_of_bounds = response.page_info.out_of_bounds
        featureMediaModel.pageInfo =  pageInfoModel 
    else 
        featureMediaModel.success = false
        featureMediaModel.error = apiErrorMessage()
    end if
    
    m.top.content = featureMediaModel

end sub