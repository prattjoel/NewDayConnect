//
//  VideoPlayerController.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class VideoPlayerController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var videos = [VideoFromDownload]()
    var videoID: String!
    var video: VideoFromDownload!
    var stack = CoreDataStack(modelName: "Model")
    var videoToSave: Video!
    var favoriteVideos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videosInContext = try! videosFromContext(context: stack?.context) else {
            print("No videos in context")
            return
        }
        
        if videosInContext.count > 0 {
            playerView.load(withVideoId: videosInContext[0].videoID)
        } else {
            
            YouTubeClient.sharedInstance().getVideos { (success, result, error) in
                if success {
                    
                    print("success")
                    
                    if let videosArray = result {
                        
                        self.videos = videosArray
                        
                        self.video = self.videos[0]
                        
                        self.videoID = self.video.videoID
                        
                        DispatchQueue.main.async {
                            self.playerView.load(withVideoId: self.videoID)
                        }
                    } else {
                        print("could not get videos from results")
                        
                        
                    }
                } else {
                    print("error with getVideos Request: \(error)")
                }
            }
        }
    }
    @IBAction func addToFavorites(_ sender: Any) {
        videoToSave = Video(inContext: stack!.context, title: video.title, thumbnail: video.thumbnail, videoID: video.videoID)
        favoriteVideos.append(videoToSave)
        saveContext()
    }
    
    func videosFromContext(context: NSManagedObjectContext?) throws -> [Video]? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        
        var videosFromContext: [Video]?
        var fetchError: Error?
        
        context?.performAndWait {
            do {
                videosFromContext = try context?.fetch(fetchRequest) as! [Video]?
            } catch let error {
                fetchError = error
            }
        }
        
        guard let vids = videosFromContext else {
            throw fetchError!
        }
        
        return vids
    }
    
    func saveContext() {
        
        do {
            try stack?.saveContext()
            print("context saved")
        } catch let error {
            print("error saving context \(error)")
        }
    }
    
}
