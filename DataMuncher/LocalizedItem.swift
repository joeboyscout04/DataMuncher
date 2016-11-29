//
//  LocalizedItem.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import CoreData

class LocalizedItem: UniqueItem {
    
    //localizations
    @NSManaged var name_pl : String
    @NSManaged var name_da : String
    @NSManaged var name_pt : String
    @NSManaged var name_no: String
    @NSManaged var name_sv: String
    @NSManaged var name_es: String
    @NSManaged var name_ru: String
    @NSManaged var name_de: String
    @NSManaged var name_fr: String
    @NSManaged var name_nl: String
    @NSManaged var name_it: String
    @NSManaged var name_fi : String
    
    override func updateFromJson(jsonDict: [String : AnyObject]) {
        
        super.updateFromJson(jsonDict: jsonDict)
        
        //localizations
        if let newname_pl  = jsonDict["name_pl"] as?  String {
            self.name_pl = newname_pl
        }
        if let newname_da = jsonDict["name_da"] as?  String {
            self.name_da = newname_da
        }
        if let newname_pt = jsonDict["name_pt"] as?  String{
            self.name_pt = newname_pt
        }
        if let newname_no = jsonDict["name_no"] as?  String{
            self.name_no = newname_no
        }
        if let newname_sv = jsonDict["name_sv"] as?  String{
            self.name_sv = newname_sv
        }
        if let newname_es = jsonDict["name_es"] as?  String {
            self.name_es  = newname_es
        }
        if let newname_ru = jsonDict["name_ru"] as?  String{
            self.name_ru = newname_ru
        }
        if let newname_de = jsonDict["name_de"] as?  String{
            self.name_de = newname_de
        }
        if let newname_fr = jsonDict["name_fr"] as?  String {
            self.name_fr = newname_fr
        }
        if let newname_nl = jsonDict["name_nl"] as?  String{
            self.name_nl = newname_nl
        }
        if let newname_it = jsonDict["name_it"] as?  String{
            self.name_it  = newname_it
        }
        if let newname_fi = jsonDict["name_fi"] as?  String{
            self.name_fi  = newname_fi
        }
    }
    
    
    func nameFromLocalization() -> String? {
        
        var localizedName:String? = nil
        
        let deviceLanguages = NSLocale.preferredLanguages
        let firstLanguage = deviceLanguages.first!
        NSLog("The device language is \(firstLanguage)")
        
        let keyString = "name_\(firstLanguage)"
        
        let localizedNameBox = self.value(forKey: keyString)
        localizedName = localizedNameBox as? String

        return localizedName
    }
    
}
