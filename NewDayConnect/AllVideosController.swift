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
    
    var tableViewDatasource = AllVideosDataSource()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        allVideosTableView.dataSource = tableViewDatasource
        allVideosTableView.delegate = self
        
        YouTubeClient.sharedInstance().getVideos { (success, result, error) in
            if success {
                
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
                
                self.presentAlertContoller(title: "Videos Not Found" , message: "There was a problem getting the videos.  Please try again later")
            }
        }
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoPlayerController
        controller.video = tableViewDatasource.videos[indexPath.row]
        controller.videoID = tableViewDatasource.videos[indexPath.row].videoID
        controller.videoToSave = nil
        navigationController?.pushViewController(controller, animated: true)
    }
}
