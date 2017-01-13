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

class VideoPlayerController: UIViewController, UIWebViewDelegate, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var videoID: String?
    var video: VideoFromDownload?
    var videoToSave: Video?
    var vidInFavorites: Bool!
    var titleString: String?
    var thumbString: String?
    var idString: String?
    let reachability = Reachability()
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true

        checkReachability()
        
        guard let stack = CoreDataStack.sharedInstance else {
            print("Stack not found")
            return
        }
        
        if let vid = videoToSave {
            titleString = vid.title
            thumbString = vid.thumbnail
            idString = vid.videoID
        }
        
        if let vidID = videoID {
            
            playerView.delegate = self
            playerView.load(withVideoId: vidID)
            
            let vidFromContext = checkDuplicateVideo(context: stack.context, vidID: vidID)
            
            if vidFromContext == nil {
                vidInFavorites = false
                isFavorited(isInFavs: vidInFavorites)
            } else {
                vidInFavorites = true
                isFavorited(isInFavs: vidInFavorites)
            }
        }
    }
    
    //MARK: - Add/Remove video from context
    
    @IBAction func addToFavorites(_ sender: Any) {
        
        guard let stack = CoreDataStack.sharedInstance else {
            print("Stack not found")
            return
        }
        
        if vidInFavorites == true {
            stack.context.delete(videoToSave!)
            saveContext()
            vidInFavorites = false
            isFavorited(isInFavs: vidInFavorites)
            
        } else {
            if let vid = video {
                let vidForContext = Video(inContext: stack.context, title: vid.title, thumbnail: vid.thumbnail, videoID: vid.videoID)
                addToContext(videoForContext: vidForContext)
                videoToSave = vidForContext
            } else {
                if let title = titleString, let thumb = thumbString, let id = idString {
                    
                    let videoForContext = Video(inContext: stack.context, title: title, thumbnail: thumb, videoID: id)
                    videoToSave = videoForContext
                    addToContext(videoForContext: videoForContext)
                } else {
                    print("no video to add when favorites button pressed")
                }
            }
        }
    }
    
    //MARK: - PlayerView Delegate Methods
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        indicator.stopAnimating()
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(" error from ytPlayer\(error)")
        presentAlertContoller(title: "Video Not Found", message: "Please try another video")
    }
    
    //MARK: - Coredata helper functions
    func checkDuplicateVideo(context: NSManagedObjectContext, vidID: String) -> Video? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Video")
        let predicate = NSPredicate(format: "videoID == %@", argumentArray: [vidID])
        fetchRequest.predicate = predicate
        
        var videosFromContext: [Video]!
        
        context.performAndWait {
            videosFromContext = try! context.fetch(fetchRequest) as! [Video]
        }
        
        if videosFromContext.count > 0 {
            return videosFromContext.first
        } else {
            return nil
        }
    }
    
    func saveContext() {
        
        do {
            try CoreDataStack.sharedInstance?.saveContext()
        } catch let error {
            print("error saving context \(error)")
        }
    }
    
    func addToContext(videoForContext: Video) {
        
        saveContext()
        vidInFavorites = true
        isFavorited(isInFavs: vidInFavorites)
    }
    
    //MARK: - UI updates
    
    func isFavorited(isInFavs: Bool){
        
        if isInFavs {
            favoritesButton.setTitle("Delete From Favorites", for: .normal)
            
        } else {
            favoritesButton.setTitle("Add to favorites", for: .normal)
            
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
        
            self.navigationController!.popViewController(animated: true)
        }
        
        alertContoller.addAction(okAction)
        present(alertContoller, animated: true, completion: nil)
    }
}
