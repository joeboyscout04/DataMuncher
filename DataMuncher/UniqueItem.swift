//
//  UniqueItem.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class UniqueItem : NSManagedObject,JsonParsedObject {
    
    @NSManaged var oid: String
    @NSManaged var lastUpdated: Date //date in unix time
    
    func updateFromJson(jsonDict:[String:AnyObject]) {
        
        if let newoid = jsonDict["oid"] as? Int{
            self.oid = "\(newoid)"
        }
        if let newLastUpdated = jsonDict["lastupdated"] as? Double{
            self.lastUpdated = Date(timeIntervalSince1970: newLastUpdated)
        }
    }
}
