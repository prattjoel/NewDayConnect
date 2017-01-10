//
//  VideoPlayerController.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit

class VideoPlayerController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var videos = [Video]()
    var videoID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YouTubeClient.sharedInstance().getVideos { (success, result, error) in
            if success {
                
                print("success")
                
                if let videosArray = result {
                    
                    self.videos = videosArray
                    
                    self.videoID = self.videos[0].VideoID
                    
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
