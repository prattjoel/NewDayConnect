//
//  YouTubeConstants.swift
//  NewDayConnect
//
//  Created by Joel on 1/6/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation

extension YouTubeClient {
    
    
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.googleapis.com"
        static let ApiPath = "/youtube/v3/"
        static let ChannelsMethod = "channels"
        static let PlaylistMethod = "playlistItems"

    }
    
    struct ParamaterKeys {
        static let ApiKey = "key"
        static let Part = "part"
        static let Username = "forUsername"
        static let PlaylistID = "playlistId"
    }
    
    struct ParamaterValues {
        static let ApiKey = "AIzaSyCrqb5iEls785Jh6di5B5oIt1YklbInAxI"
        static let Details = "contentDetails"
        static let Snippet = "snippet"
        static let Username = "newdaybronx"

    }
    
    struct ResponseKeys {
        static let Items = "items"
        static let Snippet = "snippet"
        static let Content = "contentDetails"
        static let Playlists = "relatedPlaylists"
        static let Uploads = "uploads"
        static let Title = "title"
        static let Thumbnails = "thumbnails"
        static let DefaultThumbnail = "default"
        static let ThumbnailURL = "url"
        static let ResourceID = "resourceId"
        static let VideoID = "videoId"
    }
}
