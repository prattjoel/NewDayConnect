//
//  FavoritesDatasource.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import UIKit

class FavoritesDatasource: NSObject, UITableViewDataSource {
    
    var videos = [Video]()
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = videos[indexPath.row]
        
        let id = "FavoritesCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = video.title
        
        return cell
    }
}
