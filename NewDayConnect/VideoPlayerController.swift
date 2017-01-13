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

    
    var videos = [VideoFromDownload]()
    var videoID: String?
    var video: VideoFromDownload?
    var videoToSave: Video?
    var favoriteVideos = [Video]()
    var vidInFavorites: Bool!
    var titleString: String?
    var thumbString: String?
    var idString: String?
    
    
    
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
           // indicator.stopAnimating()
            
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
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
         indicator.stopAnimating()
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        guard let stack = CoreDataStack.sharedInstance else {
//            print("Stack not found")
//            return
//        }
//        
//        if let vidID = videoID {
//            
//            playerView.load(withVideoId: vidID)
//            
//            let vidFromContext = checkDuplicateVideo(context: stack.context, vidID: vidID)
//            
//            if vidFromContext == nil {
//                vidInFavorites = false
//                isFavorited(isInFavs: vidInFavorites)
//            } else {
//                vidInFavorites = true
//                isFavorited(isInFavs: vidInFavorites)
//            }
//            
//        }
//        
//        
//    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        
        guard let stack = CoreDataStack.sharedInstance else {
            print("Stack not found")
            return
        }
        
        print("vidInFavorites is: \(vidInFavorites)")
        
        if vidInFavorites == true {
            print("videoToSave ID before deleted: \(videoToSave?.videoID)")
            stack.context.delete(videoToSave!)
            saveContext()
            vidInFavorites = false
            isFavorited(isInFavs: vidInFavorites)
            print("video deleted from context")
            print("videoToSave ID after deleted: \(videoToSave?.videoID)")

            
        } else {
            if let vid = video {
                let vidForContext = Video(inContext: stack.context, title: vid.title, thumbnail: vid.thumbnail, videoID: vid.videoID)
                addToContext(videoForContext: vidForContext)
                videoToSave = vidForContext
            } else {
                if let title = titleString, let thumb = thumbString, let id = idString {
                    
                    //print("videID of video to be saved is: \(vidFromFavs.videoID)")
                    let videoForContext = Video(inContext: stack.context, title: title, thumbnail: thumb, videoID: id)
                    videoToSave = videoForContext
                    print("saved video is: \(videoForContext)")
                    addToContext(videoForContext: videoForContext)
                } else {
                    print("no video to add when favorites button pressed")
                }
            }
        }
        
        print("vidInFavorites after calls in favButton is: \(vidInFavorites)")

        
        
    }
    
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
            print("context saved")
        } catch let error {
            print("error saving context \(error)")
        }
    }
    
    func isFavorited(isInFavs: Bool){
        
        if isInFavs {
            favoritesButton.setTitle("Delete From Favorites", for: .normal)
            
        } else {
            favoritesButton.setTitle("Add to favorites", for: .normal)
            
        }
    }
    
    func addToContext(videoForContext: Video) {
        
        favoriteVideos.append(videoForContext)
        saveContext()
        vidInFavorites = true
        isFavorited(isInFavs: vidInFavorites)
        print("video added to context")
        
    }
}
