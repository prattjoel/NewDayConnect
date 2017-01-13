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
    var refresh = UIRefreshControl()
    let reachability = Reachability()

    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refresh.addTarget(self, action: #selector(refreshPage), for: UIControlEvents.valueChanged)
        allVideosTableView.addSubview(refresh)
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        allVideosTableView.dataSource = tableViewDatasource
        allVideosTableView.delegate = self
        
        checkReachability()
        loadVideos()
    }
    
    //MARK: - Methods for getting videos
    func loadVideos() {
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
                
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                
            }
        }
    }
    
    func refreshPage(){
        loadVideos()
        if refresh.isRefreshing {
            refresh.endRefreshing()
        }
    }
    
    func checkReachability(){
        
        if let reach = reachability {
            reach.whenUnreachable = { reachability in
                
                DispatchQueue.main.async {
                    print("no connection")
                    self.indicator.stopAnimating()
                    self.presentAlertContoller(title: "No Internet", message: "There's no internet connection.  Please check your connection and try again")
                }
                
                reach.stopNotifier()
            }
            
            do {
                try reach.startNotifier()
            } catch {
                print("could not start reachability notifier")
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
