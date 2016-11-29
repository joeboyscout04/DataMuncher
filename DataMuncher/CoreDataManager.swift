//
//  CoreDataStackManager.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        
        //get the data model
        guard let modelURL = Bundle.main.url(forResource: "DataMuncher", withExtension:"momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                
            fatalError("Error loading model and initializing ")
        }
        
        //set up the coordinator.
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            
            //get the default URL here from the file manager. 
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            let docURL = urls.last
            
            //store the data into DataMuncher.sqlite
            let storeURL = docURL?.appendingPathComponent("DataMuncher.sqlite")
            
            do {
                try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func loadDataInBackground() {
        
        //load the data
        //send a notification when it's done. 
        
    }
}
