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
    
    var tableViewDatasource = FavoritesDatasource()
    
    //MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesTableView.dataSource = tableViewDatasource
        favoritesTableView.delegate = self
        
        let context = CoreDataStack.sharedInstance?.context
        guard let videosInContext = try! videosFromContext(context: context) else {
            print("Unable to retrieve videos from context")
            return
        }
        
        if videosInContext.count == 0 {
            presentAlertContoller(title: "No Favorites Found", message: "Select a video in the all videos tab to add it to your favorites")
        }
        
        tableViewDatasource.videos = videosInContext
        favoritesTableView.reloadData()
        
    }
    
    //MARK: - Retrieve videos from context
    
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
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "VideoPlayerController") as! VideoPlayerController
        controller.videoToSave = tableViewDatasource.videos[indexPath.row]
        controller.videoID = tableViewDatasource.videos[indexPath.row].videoID
        controller.video = nil
        navigationController?.pushViewController(controller, animated: true)
    }
}
