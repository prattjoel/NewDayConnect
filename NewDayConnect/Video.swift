//
//  Video.swift
//  NewDayConnect
//
//  Created by Joel on 1/9/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation

struct Video {
    let title : String
    let thumbnail: String
    let VideoID: String
    
    init(dictionary: [String: AnyObject]) {
        if let vidTitle = dictionary[YouTubeClient.ResponseKeys.Title] as? String {
            title = vidTitle
        } else {
            title = ""
            print("title not found")
        }
        
        if let nails = dictionary[YouTubeClient.ResponseKeys.Thumbnails] as? [String: AnyObject], let defaultNail = nails[YouTubeClient.ResponseKeys.DefaultThumbnail] as? [String: AnyObject], let thumbUrl = defaultNail[YouTubeClient.ResponseKeys.ThumbnailURL] as? String {
            thumbnail = thumbUrl
        } else {
            print("Thumbnails could not be found from the snippet dictionary")
            thumbnail = ""
        }
        
        if let resource = dictionary[YouTubeClient.ResponseKeys.ResourceID] as? [String: AnyObject], let vidID = resource[YouTubeClient.ResponseKeys.VideoID] as? String {
            VideoID = vidID
        } else {
            VideoID = ""
            print("video ID not found from snippet dictionary")
        }
    }
    
   static func getVideosFromResults(results: [[String: AnyObject]]) -> [Video] {
        
        var videos = [Video]()
        
        for result in results {
            
            if let snippet = result[YouTubeClient.ResponseKeys.Snippet] as? [String: AnyObject] {
                videos.append(Video(dictionary: snippet))
            } else {
                print("Snippet dictionary could not be found from result dictionary")
            }
        }
        
        return videos
    }
}
