//
//  CoreDataStackManager.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import UIKit
import CoreData
import DBAlertController

class CoreDataManager: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    var storeCoordinator:NSPersistentStoreCoordinator
    let errorDomain = "self.edu.CoreDataManager"
    let errorTitle = "Error"
    let exerciseDataLoadError = 100
    let foodDataError = 200
    
    static let coreDataInitializedNotificaitonKey = "CoreDataInitialized"
    static let exerciseDataLoadedNotificationKey = "ExerciseDataLoaded"
    

    init(callback:@escaping (NSError?) -> ()) {
        
        //get the data model
        guard let modelURL = Bundle.main.url(forResource: "DataMuncher", withExtension:"momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
                
            fatalError("Error loading model and initializing ")
        }
        
        //set up the coordinator.
        let storedCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        storeCoordinator = storedCoordinator
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            
            //get the default URL here from the file manager. 
            
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            
            let docURL = urls.last
            
            //store the data into DataMuncher.sqlite
            let storeURL = docURL?.appendingPathComponent("DataMuncher.sqlite")

            do {
                try storedCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                callback(nil)
                
            } catch {
                fatalError("Error migrating store: \(error)")
            }
            
            let notification = NSNotification(name: NSNotification.Name(rawValue: CoreDataManager.coreDataInitializedNotificaitonKey), object: nil) as Notification
            NotificationQueue.default.enqueue(notification, postingStyle: NotificationQueue.PostingStyle.asap)
            
        }
    }
    
    
    func batchLoadData(resource:String,entity:String) -> NSError? {
        var error:NSError? = nil
        if let path = Bundle.main.path(forResource: resource, ofType: "json") {
            if let data = NSData.init(contentsOfFile: path) as? Data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String:AnyObject]]
                    
                    //turn it into data that we want to save
                    //batch it up
                    
                    managedObjectContext.perform({
                        
                        var index = 0
                        let batchCount = 1000
                        while(index < json.count - 1){
                            
                            
                            let addToIndex = json.count - index < batchCount ? json.count - index - 1 : batchCount
                            let newIndex = index + addToIndex
                            let arraySlice = json[index...newIndex]
                            for exercise in arraySlice {
                                
                                let newExerciseObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: self.managedObjectContext) as! JsonParsedObject
                                newExerciseObject.updateFromJson(jsonDict: exercise)
                            }
                            index = newIndex
                            
                            do{
                                try self.managedObjectContext.save()
                            }
                            catch {
                                NSLog("Failure to save \(entity) data")
                                let alert = DBAlertController(title: self.errorTitle, message: "Failure to save \(entity) data", preferredStyle: UIAlertControllerStyle.alert)
                                let okAction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
                                    alert.dismiss(animated: true, completion: {})
                                })
                                alert.addAction(okAction)
                                alert.show()
                            }
                        }
                        
                        NSLog("The data from \(resource) was loaded into CoreData Entity \(entity)")
                        
                        let notification = NSNotification(name: NSNotification.Name(rawValue: CoreDataManager.exerciseDataLoadedNotificationKey), object: nil) as Notification
                        NotificationQueue.default.enqueue(notification, postingStyle: NotificationQueue.PostingStyle.asap)
                        
                    })
                }
                catch {
                    return NSError(domain: self.errorDomain, code: exerciseDataLoadError, userInfo: [NSLocalizedDescriptionKey: "The \(entity) data failed to load into CoreData"])
                }
            }
            else {
                error = NSError(domain: self.errorDomain, code: exerciseDataLoadError, userInfo: [NSLocalizedDescriptionKey: "The resource \(resource) couldn't be turned into data."])
            }
        }
        else{
            error = NSError(domain: self.errorDomain, code: exerciseDataLoadError, userInfo: [NSLocalizedDescriptionKey: "The \(resource) path wasn't valid"])
        }
        return error
    }
    
    
    func loadExerciseData() -> NSError? {
        
        return batchLoadData(resource: "exercisesStatic", entity: "ExerciseItem")

    }
    
    func loadFoodData() -> NSError? {
        
        return batchLoadData(resource: "foodStatic", entity: "FoodItem")
        
    }
    
    func loadCategoryData() -> NSError? {
        
        return batchLoadData(resource: "categoriesStatic", entity: "FoodCategoryItem")
        
    }
    
    func loadData() {
        //load the data
        loadExerciseData()
        loadFoodData()
        loadCategoryData()
        
        //send a notification when it's done.
        
        
    }
}
