//
//  DataModel.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class FoodItem: NSManagedObject {
    
    /*
 {
 "downloaded" : false,
 "pcsingram" : 228,
 "language" : "da_DK",
 "source_id" : 2,
 "showmeasurement" : 2,
 "cholesterol" : 0.034,
 "gramsperserving" : 228,
 "categoryid" : 60,
 "sugar" : 0,
 "fiber" : 0,
 "mlingram" : 0,
 "pcstext" : "Piece",
 "lastupdated" : 1380280595,
 "addedbyuser" : false,
 "fat" : 17,
 "sodium" : 0.543,
 "deleted" : false,
 "ocategoryid" : 60,
 "hidden" : false,
 "custom" : false,
 "calories" : 277,
 "oid" : 11927314,
 "servingcategory" : 88,
 "saturatedfat" : 5.46,
 "potassium" : 0.146,
 "brand" : "",
 "carbohydrates" : 18.24,
 "typeofmeasurement" : 0,
 "title" : "Kyllingesandwich",
 "protein" : 12.9,
 "defaultsize" : 366,
 "showonlysametype" : 0,
 "unsaturatedfat" : 10.35
 },
 */
    
    
//    @NSManaged var downloaded: Bool
    @NSManaged var pcsInGram: Int
    @NSManaged var language: String
//    @NSManaged var sourceId: Int
//    @NSManaged var showMeasurement: Int
    @NSManaged var cholesterol: Float
    @NSManaged var gramsPerServing: Float
    @NSManaged var categoryId: Int
    @NSManaged var sugar: Float
    @NSManaged var fiber: Float
//    @NSManaged var mlInGram: Float
    @NSManaged var pcsText: String //"Serving"
    @NSManaged var lastUpdated: Date //date in unix time
//    @NSManaged var addedByUser: Bool
    @NSManaged var fat: Float
    @NSManaged var sodium: Float
//    @NSManaged var wasDeleted: Bool
    @NSManaged var oCategoryId: Int
//    @NSManaged var hidden: Bool
//    @NSManaged var custom: Bool
    @NSManaged var calories: Float
    @NSManaged var oid: Int
    @NSManaged var servingCategory: Int
    @NSManaged var saturatedFat: Float
    @NSManaged var potassium: Float
    @NSManaged var brand: String
    @NSManaged var carbohydrates: Float
//    @NSManaged var typeOfMeasurement: Int
    @NSManaged var title: String
    @NSManaged var protein: Float
    @NSManaged var defaultSize: Float
//    @NSManaged var showOnlySameType: Int
    @NSManaged var unsaturatedFat: Float
    
    
    func updateFromJson(jsonDict:[String:AnyObject]) {
        
        
        guard //let newDownloaded = jsonDict["downloaded"] as? Bool,
            let newPcsInGram = jsonDict["pcsingram"] as? Int,
            let newLanguage = jsonDict["language"] as? String,
//        let newSourceId = jsonDict["source_id"] as? Int,
//        let newShowMeasurement = jsonDict["showMeasurement"] as? Int,
        let newCholesterol = jsonDict["cholesterol"] as? Float,
        let newGramsPerServing = jsonDict["gramsperserving"] as? Float,
        let newCategoryId = jsonDict["categoryid"] as? Int,
        let newSugar = jsonDict["sugar"] as? Float,
        let newFiber = jsonDict["fiber"] as? Float,
//        let newMlInGram = jsonDict["mlingram"] as? Float,
        let newPcsText = jsonDict["pcstext"] as? String,
        let newLastUpdated = jsonDict["lastupdated"] as? Date,
//        let newAddedByUser = jsonDict["addedbyuser"] as? Bool,
        let newFat = jsonDict["fat"] as? Float,
        let newSodium = jsonDict["sodium"] as? Float,
//        let newWasDeleted = jsonDict["deleted"] as? Bool,
        let newoCategoryId = jsonDict["ocategoryid"] as? Int,
//        let newhidden = jsonDict["hidden"] as? Bool,
//        let newcustom = jsonDict["custom"] as? Bool,
        let newcalories = jsonDict["calories"] as? Float,
        let newoid = jsonDict["oid"] as? Int,
        let newservingCategory = jsonDict["servingcategory"] as? Int,
        let newsaturatedFat = jsonDict["saturatedfat"] as? Float,
        let newpotassium = jsonDict["potassium"] as? Float,
        let newbrand = jsonDict["brand"] as? String,
        let newcarbohydrates = jsonDict["carbohydrates"] as? Float,
//        let newtypeOfMeasurement = jsonDict["typeofmeasurement"] as? Int,
        let newtitle = jsonDict["title"] as? String,
        let newprotein = jsonDict["protein"] as? Float,
        let newdefaultSize = jsonDict["defaultsize"] as? Float,
//        let newshowOnlySameType = jsonDict["showonlysametype"] as? Int,
        let newunsaturatedFat = jsonDict["unsaturatedfat"] as? Float else {
        
            NSLog("FoodItem: Json data failed to parse")
            return
        }
        
//        self.downloaded = newDownloaded
        self.pcsInGram = newPcsInGram
        self.language = newLanguage
//        self.sourceId = newSourceId
//        self.showMeasurement = newShowMeasurement
        self.cholesterol = newCholesterol
        self.gramsPerServing = newGramsPerServing
        self.categoryId = newCategoryId
        self.sugar = newSugar
        self.fiber = newFiber
//        self.mlInGram = newMlInGram
        self.pcsText = newPcsText
        self.lastUpdated = newLastUpdated
//        self.addedByUser = newAddedByUser
        self.fat = newFat
        self.sodium = newSodium
//        self.wasDeleted = newWasDeleted
        self.oCategoryId = newoCategoryId
//        self.hidden = newhidden
//        self.custom = newcustom
        self.calories = newcalories
        self.oid = newoid
        self.servingCategory = newservingCategory
        self.saturatedFat = newsaturatedFat
        self.potassium = newpotassium
        self.brand = newbrand
        self.carbohydrates = newcarbohydrates
//        self.typeOfMeasurement = newtypeOfMeasurement
        self.title = newtitle
        self.protein = newprotein
        self.defaultSize = newdefaultSize
//        self.showOnlySameType = newshowOnlySameType
        self.unsaturatedFat = newunsaturatedFat
        
        NSLog("DataModel: Json data was updated")
    }
}
