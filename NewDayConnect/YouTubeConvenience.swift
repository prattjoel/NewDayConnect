//
//  YouTubeConvenience.swift
//  NewDayConnect
//
//  Created by Joel on 1/9/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation

extension YouTubeClient {
    
    func getVideos(completionHandlerForGetVdeos: @escaping (Bool, [VideoFromDownload]?, NSError?) -> Void) {
        var playlistID = ""
        
        getPlaylistID { (success, result, error) in
            if success {
                guard let ID = result  else {
                    print("could not get ID from result in getPlaylistID")
                    return
                }
                
                playlistID = ID
                
                self.getVideosFromPlaylist(playlistID: playlistID, completionHandlerForGetVideosFromPlaylist: completionHandlerForGetVdeos)

            } else {
                print("error getting playlistID: \(error)")
                completionHandlerForGetVdeos(false, nil, NSError(domain: "getVideos", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get videos from playlist ID"]))
            }
        }
    }
    
    func getVideosFromPlaylist(playlistID: String, completionHandlerForGetVideosFromPlaylist: @escaping (Bool, [VideoFromDownload]?, NSError?) -> Void) -> Void {

        
        let paramaters: [String: Any] = [
            ParamaterKeys.ApiKey: ParamaterValues.ApiKey,
            ParamaterKeys.Part: ParamaterValues.Snippet,
            ParamaterKeys.PlaylistID: "\(playlistID)",
            ParamaterKeys.NumberOfVedeos: ParamaterValues.NumberOfVideos
        ]
        
        taskForGetMethod(method: Constants.PlaylistMethod, parameters: paramaters as [String : AnyObject]) { result, error in
            guard error == nil else {
                completionHandlerForGetVideosFromPlaylist(false, nil, error)
                return
            }
            
            guard let results = result as? [String: AnyObject] else {
                completionHandlerForGetVideosFromPlaylist(false, nil, NSError(domain: "getVideosFromPlaylist", code: 1, userInfo: [NSLocalizedDescriptionKey: "No result from getVideosFromPlaylist"]))
                return
            }
            
           // print("result from getVideosFromPlaylist: \n \(results) \n")
            
            guard let itemsArray = results[ResponseKeys.Items] as? [[String: AnyObject]] else {
                completionHandlerForGetVideosFromPlaylist(false, nil, NSError(domain: "getVideosFromPlaylist", code: 1, userInfo: [NSLocalizedDescriptionKey: "No items from result from getVideosFromPlaylist"]))
                return
            }
            
//            guard let itemsDict = itemsArray[0] as? [String: AnyObject] else {
//                completionHandlerForGetVideosFromPlaylist(false, nil, NSError(domain: "getVideosFromPlaylist", code: 1, userInfo: [NSLocalizedDescriptionKey: "No items dictionary from itemsArray in getVideosFromPlaylist"]))
//                return
//            }
            
           let videos = VideoFromDownload.getVideosFromResults(results: itemsArray)
            
           // print(" videos from getVideosFromPlaylist: \(videos)")
            
            completionHandlerForGetVideosFromPlaylist(true, videos, nil)
            
        }
    }
    
    func getPlaylistID (completionHandlerForGetPlaylistID: @escaping (Bool, String?, NSError?) -> Void) -> Void {
        
        let paramaters: [String: String] = [
            ParamaterKeys.ApiKey: ParamaterValues.ApiKey,
            ParamaterKeys.Part: "\(ParamaterValues.Details),\(ParamaterValues.Snippet)",
            ParamaterKeys.Username: ParamaterValues.Username
        ]
        
        taskForGetMethod(method: Constants.ChannelsMethod, parameters: paramaters as [String: AnyObject]) { result, error in
            
            guard error == nil else {
                completionHandlerForGetPlaylistID(false, nil, error)
                return
            }
            
            guard let result = result as? [String: AnyObject] else {
                completionHandlerForGetPlaylistID(false, nil, NSError(domain: "getPlaylistID", code: 1, userInfo: [NSLocalizedDescriptionKey: "No result from getPlaylistID request"]))
                return
            }
            
            print("results from getPlaylistID: \n \(result) \n")
            
            guard let itemsArray = result[ResponseKeys.Items] as? [AnyObject] else {
                completionHandlerForGetPlaylistID(false, nil, NSError(domain: "getPlaylistID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get items for getPlaylistID request"]))
                return
            }
            
            
            print("\n items: \(itemsArray) \n")
            
            guard let itemsDict = itemsArray[0] as? [String: AnyObject] else {
                completionHandlerForGetPlaylistID(false, nil, NSError(domain: "getPlaylistID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get items dictionaryfor getPlaylistID request"]))
                return
            }
            
            guard let content = itemsDict[ResponseKeys.Content] as? [String: AnyObject] else {
                completionHandlerForGetPlaylistID(false, nil, NSError(domain: "getPlaylistID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get content details for getPlaylistID request"]))
                return
            }
            
            guard let playlists = content[ResponseKeys.Playlists] as? [String: AnyObject] else {
                completionHandlerForGetPlaylistID(false, nil, NSError(domain: "getPlaylistID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get playlists for getPlaylistID request"]))
                return
            }
            
            guard let playlistID = playlists[ResponseKeys.Uploads] as? String else {
                completionHandlerForGetPlaylistID(false, nil, NSError(domain: "getPlaylistID", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not get playlist ID for getPlaylistID request"]))
                return
            }
            
            print("\n playlist ID: \(playlistID) \n")
            completionHandlerForGetPlaylistID(true, playlistID, nil)
        }
    }
}
