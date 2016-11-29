//
//  JsonParsedObject.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

protocol JsonParsedObject {
    
    func updateFromJson(jsonDict:[String:AnyObject])
}
