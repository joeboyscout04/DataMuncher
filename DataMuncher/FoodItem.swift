//
//  DataModel.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class FoodItem: NSManagedObject,JsonParsedObject {
    
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
    
    //identifiers
    @NSManaged var oid: String
    @NSManaged var lastUpdated: Date //date in unix time
    @NSManaged var categoryId: Int16
    @NSManaged var oCategoryId: Int16
    @NSManaged var servingCategory: Int16
    
    //strings
    @NSManaged var title: String
    @NSManaged var pcsText: String //"Serving"
    @NSManaged var brand: String
    @NSManaged var language: String
    
    //data
    @NSManaged var pcsInGram: Float
    @NSManaged var cholesterol: Float
    @NSManaged var gramsPerServing: Float
    @NSManaged var sugar: Float
    @NSManaged var fiber: Float
    @NSManaged var fat: Float
    @NSManaged var sodium: Float
    @NSManaged var calories: Float
    @NSManaged var saturatedFat: Float
    @NSManaged var potassium: Float

    @NSManaged var carbohydrates: Float
    @NSManaged var protein: Float
    @NSManaged var defaultSize: Float
    @NSManaged var unsaturatedFat: Float
    
    //ignore these for now
    
//    @NSManaged var downloaded: Bool
//    @NSManaged var sourceId: Int16
//    @NSManaged var showMeasurement: Int16
//    @NSManaged var mlInGram: Float
//    @NSManaged var addedByUser: Bool
//    @NSManaged var wasDeleted: Bool
//    @NSManaged var hidden: Bool
//    @NSManaged var custom: Bool
//    @NSManaged var typeOfMeasurement: Int16
//    @NSManaged var showOnlySameType: Int16

    
    
    func updateFromJson(jsonDict:[String:AnyObject]) {
        
        //This JSON parsing is really tedious...
        //TODO: implement JSON parsing library Groot
        //check each key so that we allow partial data (use CoreData defaults to fill in partials)
        //TODO: Possibly we should not allow the data at all if there is no oid?
        
        
        //identifiers 
        if let newCategoryId = jsonDict["categoryid"] as? Int16 {
            self.categoryId = newCategoryId
        }
        
        if let newoCategoryId = jsonDict["ocategoryid"] as? Int16 {
            self.oCategoryId = newoCategoryId
        }
        
        if let newservingCategory = jsonDict["servingcategory"] as? Int16{
            self.servingCategory = newservingCategory
        }

        //strings
        if let newLanguage = jsonDict["language"] as? String {
            self.language = newLanguage
        }
        if let newPcsText = jsonDict["pcstext"] as? String {
            self.pcsText = newPcsText
        }
        if let newtitle = jsonDict["title"] as? String {
            self.title = newtitle
        }
        if let newbrand = jsonDict["brand"] as? String{
            self.brand = newbrand
        }
        
        
        //data
        
        if let newPcsInGram = jsonDict["pcsingram"] as? Float {
            self.pcsInGram = newPcsInGram
        }
        if let newCholesterol = jsonDict["cholesterol"] as? Float {
            self.cholesterol = newCholesterol
        }
        
        if let newGramsPerServing = jsonDict["gramsperserving"] as? Float {
            self.gramsPerServing = newGramsPerServing
        }
        if let newSugar = jsonDict["sugar"] as? Float {
            self.sugar = newSugar
        }
        if let newFiber = jsonDict["fiber"] as? Float {
            self.fiber = newFiber
        }
        if let newFat = jsonDict["fat"] as? Float{
            self.fat = newFat
        }
        if let newSodium = jsonDict["sodium"] as? Float {
            self.sodium = newSodium
        }
        if let newcalories = jsonDict["calories"] as? Float{
            self.calories = newcalories
        }
        if let newsaturatedFat = jsonDict["saturatedfat"] as? Float {
            self.saturatedFat = newsaturatedFat
        }
        if let newpotassium = jsonDict["potassium"] as? Float {
            self.potassium = newpotassium
        }
        if let newcarbohydrates = jsonDict["carbohydrates"] as? Float {
            self.carbohydrates = newcarbohydrates
        }
        if let newprotein = jsonDict["protein"] as? Float{
            self.protein = newprotein
        }
        if let newdefaultSize = jsonDict["defaultsize"] as? Float{
            self.defaultSize = newdefaultSize
        }
        if let newunsaturatedFat = jsonDict["unsaturatedfat"] as? Float {
            self.unsaturatedFat = newunsaturatedFat
            return
        }
        
        //don't parse these, we don't need them right now.
        //        let newDownloaded = jsonDict["downloaded"] as? Bool,
        //        let newSourceId = jsonDict["source_id"] as? Int16,
        //        let newShowMeasurement = jsonDict["showMeasurement"] as? Int16,
        //        let newMlInGram = jsonDict["mlingram"] as? Float,
        //        let newAddedByUser = jsonDict["addedbyuser"] as? Bool,
        //        let newWasDeleted = jsonDict["deleted"] as? Bool,
        //        let newhidden = jsonDict["hidden"] as? Bool,
        //        let newcustom = jsonDict["custom"] as? Bool,
        //        let newtypeOfMeasurement = jsonDict["typeofmeasurement"] as? Int16,
        //        let newshowOnlySameType = jsonDict["showonlysametype"] as? Int16,
        
        NSLog("DataModel: Json data was updated")
    }
}
