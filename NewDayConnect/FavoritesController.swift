//
//  FavoritesController.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesController: UITableViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var videos = [VideoFromDownload]()
    var videoID: String!
    var video: VideoFromDownload!
//    var stack = CoreDataStack(modelName: "Model")
    var videoToSave: Video!
    var favoriteVideos = [Video]()
    var tableViewDatasource = FavoritesDatasource()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.dataSource = tableViewDatasource
        favoritesTableView.delegate = self
        
        let context = CoreDataStack.sharedInstance?.context
        guard let videosInContext = try! videosFromContext(context: context) else {
            print("No videos in context")
            return
        }
        
        print("number of videos in context: \(videosInContext.count)")
        
        tableViewDatasource.videos = videosInContext
        favoritesTableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoPlayerController
        controller.videoToSave = tableViewDatasource.videos[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
