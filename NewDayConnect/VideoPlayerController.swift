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

class VideoPlayerController: UIViewController, UIWebViewDelegate {
    
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
    
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        indicator.startAnimating()
        
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
            
            playerView.load(withVideoId: vidID)
            playerView.webView!.delegate = self
            
            indicator.hidesWhenStopped = true
            
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
    
    
    //MARK: - WebView Delegate Method
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicator.stopAnimating()
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
    
}
