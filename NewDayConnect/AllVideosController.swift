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
    var refreshPull = UIRefreshControl()
    let reachability = Reachability()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshPull.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshPull.addTarget(self, action: #selector(refreshPage(sender:)), for: UIControlEvents.valueChanged)
        allVideosTableView.refreshControl = refreshPull
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        allVideosTableView.dataSource = tableViewDatasource
        allVideosTableView.delegate = self
        
        checkReachability()
        loadVideos(completion: nil)
    }
    
    //MARK: - Methods for getting videos
    func loadVideos(completion: (()->Void)?) {
        
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
                
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.presentAlertContoller(title: "Videos Not Found" , message: "There was a problem getting the videos.  Please try again later")
                }
            }
            
        }
        completion?()
    }
    
    func refreshPage(sender: UIRefreshControl){
        
        loadVideos {
            
            self.delay(time: 1.0, completion: {
                if self.refreshPull.isRefreshing {
                    self.refreshPull.endRefreshing()
                }
            })
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
    
    override func presentAlertContoller(title: String, message: String) {
        let alertContoller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        
        alertContoller.addAction(okAction)
        present(alertContoller, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoPlayerController
        controller.video = tableViewDatasource.videos[indexPath.row]
        controller.videoID = tableViewDatasource.videos[indexPath.row].videoID
        controller.videoToSave = nil
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func delay(time: Double, completion: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: completion)
    }
    
}
