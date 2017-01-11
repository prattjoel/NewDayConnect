//
//  Video+CoreDataProperties.swift
//  NewDayConnect
//
//  Created by Joel on 1/10/17.
//  Copyright © 2017 Joel Pratt. All rights reserved.
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video");
    }

    @NSManaged public var title: String
    @NSManaged public var thumbnail: String
    @NSManaged public var videoID: String

}
