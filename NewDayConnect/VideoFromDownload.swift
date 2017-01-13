//
//  VideoFromDownload.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation

struct VideoFromDownload {
    let title: String
    let thumbnail: String
    let videoID: String
    
    
    //Mark: - Initialize VideoFromDownload
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
            videoID = vidID
        } else {
            videoID = ""
            print("video ID not found from snippet dictionary")
        }
    }
    
    // Get dictionary from array of dictionaries to use in initialization
    static func getVideosFromResults(results: [[String: AnyObject]]) -> [VideoFromDownload] {
        
        var videos = [VideoFromDownload]()
        
        for result in results {
            
            if let snippet = result[YouTubeClient.ResponseKeys.Snippet] as? [String: AnyObject] {
                videos.append(VideoFromDownload(dictionary: snippet))
            } else {
                print("Snippet dictionary could not be found from result dictionary")
            }
        }
        
        return videos
    }
    
}
