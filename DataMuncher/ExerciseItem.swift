//
//  ExerciseItem.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class ExerciseItem: LocalizedItem {
    
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
    
    
    //data
    @NSManaged var title: String
    @NSManaged var calories: Float
    
    
    //ignore these for the time being
    //    @NSManaged var addedByUser: Bool
    //    @NSManaged var photoVersion: Int
    //    @NSManaged var custom : Bool
    //    @NSManaged var hidden : Bool
    //    @NSManaged var deleted : Bool
    //    @NSManaged var downloaded: Bool
    
    
    override func updateFromJson(jsonDict:[String:AnyObject]) {
        
        super.updateFromJson(jsonDict: jsonDict)
        
        //data
        if  let newcalories = jsonDict["calories"] as?  Float {
            self.calories = newcalories
        }
        if let newtitle = jsonDict["title"] as?  String{
            self.title = newtitle
        }
        
    }
}
