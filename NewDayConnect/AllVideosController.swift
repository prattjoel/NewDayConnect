//
//  AllVideosController.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit

class AllVideosController: UITableViewController {
    
    @IBOutlet weak var allVideosTableView: UITableView!
    
    
    var videos = [VideoFromDownload]()
    var videoID: String!
    var video: VideoFromDownload!
    var stack = CoreDataStack(modelName: "Model")
    var videoToSave: Video!
    var favoriteVideos = [Video]()
    var tableViewDatasource = AllVideosDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allVideosTableView.dataSource = tableViewDatasource
        allVideosTableView.delegate = self
        
        YouTubeClient.sharedInstance().getVideos { (success, result, error) in
            if success {
                
                print("success")
                
                if let videosArray = result {
                    
                    DispatchQueue.main.async {
                        self.tableViewDatasource.videos = videosArray
                        self.allVideosTableView.reloadData()
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



//        guard let videosInContext = try! videosFromContext(context: stack?.context) else {
//            print("No videos in context")
//            return
//        }
//
//        if videosInContext.count > 0 {
//            playerView.load(withVideoId: videosInContext[0].videoID)
//        } else {
//
//            YouTubeClient.sharedInstance().getVideos { (success, result, error) in
//                if success {
//
//                    print("success")
//
//                    if let videosArray = result {
//
//                        self.videos = videosArray
//
//                        self.video = self.videos[0]
//
//                        self.videoID = self.video.videoID
//
//                        DispatchQueue.main.async {
//                            self.playerView.load(withVideoId: self.videoID)
//                        }
//                    } else {
//                        print("could not get videos from results")
//
//
//                    }
//                } else {
//                    print("error with getVideos Request: \(error)")
//                }
//            }
//        }


