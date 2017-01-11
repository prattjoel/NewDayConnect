//
//  Video+CoreDataClass.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import CoreData

@objc(Video)
public class Video: NSManagedObject {
    
    convenience init(inContext context: NSManagedObjectContext, title: String, thumbnail: String, videoID: String) {
        if let ent = NSEntityDescription.entity(forEntityName: "Video", in: context) {
            self.init(entity: ent, insertInto: context)
            self.title = title
            self.thumbnail = thumbnail
            self.videoID = videoID
        } else {
            fatalError("Unable to find Entity")
            
        }
    }
}
