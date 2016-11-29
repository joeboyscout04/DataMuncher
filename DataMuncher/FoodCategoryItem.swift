//
//  FoodCategoryItem.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class FoodCategoryItem: LocalizedItem {
    
    /*
     {
     "category" : "Nuts",
     "headcategoryid" : 7,
     "name_fi" : "",
     "name_it" : "Frutta secca",
     "name_pt" : "",
     "name_no" : "",
     "servingscategory" : 68,
     "name_pl" : "Orzechy",
     "name_da" : "Nødder",
     "oid" : 93,
     "photo_version" : 1,
     "lastupdated" : 1380814481,
     "name_nl" : "",
     "name_fr" : "Noix",
     "name_ru" : "Орехи",
     "name_sv" : "Nötter",
     "name_es" : "Frutos secos",
     "name_de" : "Nüsse"
     },
     */
    
    //identifiers
    @NSManaged var headCategoryId: Int16
    @NSManaged var servingsCategory: Int16

    //data
    @NSManaged var categoryName : String //name of the category
    

    override func updateFromJson(jsonDict:[String:AnyObject]) {
        
        super.updateFromJson(jsonDict: jsonDict)
        
        //identifiers
        if  let newheadCategoryId = jsonDict["headcategoryid"] as?  Int16 {
            self.headCategoryId = newheadCategoryId
        }
        if  let newservingscategory = jsonDict["servingscategory"] as?  Int16 {
            self.servingsCategory = newservingscategory
        }
        
        if let newCategoryName = jsonDict["category"] as? String {
            self.categoryName = newCategoryName
        }
        
    }
}
