//
//  ExerciseItem.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class ExerciseItem: NSManagedObject {
    
    /*
     {
     "name_pl" : "",
     "hidden" : false,
     "deleted" : false,
     "downloaded" : false,
     "name_da" : "Sex, forspil",
     "photo_version" : 1,
     "custom" : false,
     "name_pt" : "",
     "oid" : 47,
     "name_no" : "Sex, forspill",
     "name_sv" : "Sex, förspel",
     "name_es" : "Sexo, preliminares",
     "lastupdated" : 1380815148,
     "name_ru" : "Секс (прелюдия)",
     "addedbyuser" : false,
     "name_de" : "Sex, Vorspiel",
     "title" : "Sex, foreplay",
     "name_fr" : "Sexe, préliminaires",
     "name_nl" : "Seks, voorspel",
     "calories" : 0.5,
     "name_it" : "Sesso, preliminari"
     },
     */
    
    
    @NSManaged var name_pl : String
//    @NSManaged var hidden : Bool
//    @NSManaged var deleted : Bool
//    @NSManaged var downloaded: Bool
    @NSManaged var name_da : String
//    @NSManaged var photoVersion: Int
//    @NSManaged var custom : Bool
    @NSManaged var name_pt : String
    @NSManaged var oid: String
    @NSManaged var name_no: String
    @NSManaged var name_sv: String
    @NSManaged var name_es: String
    @NSManaged var lastUpdated: Date
    @NSManaged var name_ru: String
//    @NSManaged var addedByUser: Bool
    @NSManaged var name_de: String
    @NSManaged var title: String
    @NSManaged var name_fr: String
    @NSManaged var name_nl: String
    @NSManaged var calories: Float
    @NSManaged var name_it: String
    
    
    
    
    func updateFromJson(jsonDict:[String:AnyObject]) {
        
        guard let newname_pl  = jsonDict["name_pl"] as?  String,
//        let newhidden = jsonDict["key"] as?  Bool,
//        let newdeleted = jsonDict["key"] as?  Bool,
//        let newdownloaded= jsonDict["key"] as?  Bool,
        let newname_da = jsonDict["name_da"] as?  String,
//        let newphotoVersion= jsonDict["key"] as?  Int,
//        let newcustom = jsonDict["key"] as?  Bool,
        let newname_pt = jsonDict["name_pt"] as?  String,
        let newoid = jsonDict["oid"] as?  Int,
        let newname_no = jsonDict["name_no"] as?  String,
        let newname_sv = jsonDict["name_sv"] as?  String,
        let newname_es = jsonDict["name_es"] as?  String,
        let newlastUpdated = jsonDict["lastupdated"] as?  Double,
        let newname_ru = jsonDict["name_ru"] as?  String,
//        let newaddedByUser= jsonDict["key"] as?  Bool,
        let newname_de = jsonDict["name_de"] as?  String,
        let newtitle = jsonDict["title"] as?  String,
        let newname_fr = jsonDict["name_fr"] as?  String,
        let newname_nl = jsonDict["name_nl"] as?  String,
        let newcalories = jsonDict["calories"] as?  Float,
        let newname_it = jsonDict["name_it"] as?  String else {
            
            NSLog("ExerciseItem: Json data failed to parse")
            return
        }
        
        self.name_pl = newname_pl
        self.name_da = newname_da
        self.name_pt = newname_pt
        self.oid = "\(newoid)"
        self.name_no = newname_no
        self.name_sv = newname_sv
        self.name_es = newname_es
        self.lastUpdated = Date(timeIntervalSince1970: newlastUpdated)
        self.name_ru = newname_ru
        self.name_de = newname_de
        self.title = newtitle
        self.name_fr  = newname_fr
        self.name_nl = newname_nl
        self.calories = newcalories
        self.name_it = newname_it
        
    }
}
