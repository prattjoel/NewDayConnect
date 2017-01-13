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
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var videos = [VideoFromDownload]()
    var videoID: String!
    var video: VideoFromDownload!
//    var stack = CoreDataStack(modelName: "Model")
    var videoToSave: Video!
    var favoriteVideos = [Video]()
    var tableViewDatasource = AllVideosDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        allVideosTableView.dataSource = tableViewDatasource
        allVideosTableView.delegate = self
        
        YouTubeClient.sharedInstance().getVideos { (success, result, error) in
            if success {
                
                print("success")
                
                if let videosArray = result {
                    
                    DispatchQueue.main.async {
                        self.tableViewDatasource.videos = videosArray
                        self.allVideosTableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                    
                } else {
                    print("could not get videos from results")
                }
            } else {
                print("\n error with getVideos Request: \(error) \n")
                
                self.presentAlertContoller(title: "Videos Not Found" , message: "There was a problem getting the videos.  Try again later")
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoPlayerController
        controller.video = tableViewDatasource.videos[indexPath.row]
        controller.videoID = tableViewDatasource.videos[indexPath.row].videoID
        controller.videoToSave = nil
        //controller.indicator.startAnimating()
        self.navigationController?.pushViewController(controller, animated: true)
    }
//
//    func presentAlertContoller(title: String, message: String) {
//        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        
//        alertContoller.addAction(okAction)
//        
//        present(alertContoller, animated: true, completion: nil)
//    }
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


