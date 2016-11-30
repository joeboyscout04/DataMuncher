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
import Foundation

class CoreDataManager: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    var storeCoordinator:NSPersistentStoreCoordinator
    let errorDomain = "self.edu.CoreDataManager"
    let errorTitle = NSLocalizedString("Error", comment: "")
    let exerciseDataLoadErrorCode = 100
    let foodDataLoadErrorCode = 200
    let categoryDataLoadErrorCode = 300
    
    static let coreDataInitializedNotificaitonKey = "CoreDataInitialized"
    static let exerciseDataLoadedNotificationKey = "ExerciseDataLoaded"
    static let foodDataLoadedNotificationKey = "FoodDataLoaded"
    static let categoriesDataLoadedNotificationKey = "CategoriesDataLoaded"
    
    var categoryDataLoaded = false
    var foodDataLoaded = false
    var exerciseDataLoaded = false
    
    private let foodQueue = DispatchQueue(label: "foodQueue")
    private let exerciseQueue = DispatchQueue(label: "exerciseQueue")
    private let categoryQueue = DispatchQueue(label: "categoryQueue")

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
    
    
    func batchLoadData(resource:String,entity:String,errorCode:Int, notificationKey:String,queue:DispatchQueue) {
        
        queue.async {
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = self.storeCoordinator
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let path = Bundle.main.path(forResource: resource, ofType: "json") {
                var dataBox:NSData? = nil
                
                NSLog("Get data from file \(resource)")
                
                do {
                    dataBox = try NSData(contentsOfFile: path, options:[NSData.ReadingOptions.alwaysMapped,NSData.ReadingOptions.uncached])
                }
                catch{
                    self.showErrorAlert(errorString: "Data with contents of file failed")
                }
                
                if let data = dataBox as Data? {
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)  as! [[String:Any]]
                        
                        //turn it into data that we want to save
                        //batch it up
                        NSLog("Begin batch insert of \(resource) to \(entity)")
                        let totalCount = json.count
                        
                        context.perform({
                            
                            var index = 0
                            let batchCount = 100
                            while(index < totalCount - 1){
                                
                                autoreleasepool {
                                    
                                    let addToIndex = totalCount - index < batchCount ? totalCount - index - 1 : batchCount
                                    let newIndex = index + addToIndex
                                    let arraySlice = json[index...newIndex]
                                    for exercise in arraySlice {
                                        
                                        let newExerciseObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! JsonParsedObject
                                        newExerciseObject.updateFromJson(jsonDict: exercise)
                                    }
                                    index = newIndex
                                }
                                
                                
                                do{
                                    try context.save()
                                }
                                catch {
                                    self.showErrorAlert(errorString: "Failure to save \(entity) data")
                                }
                                
                                
                                //go ahead and fire the notification for the views to reload, we'll keep on parsing while there's something to look at.
                                DispatchQueue.main.async {
                                    let notification = NSNotification(name: NSNotification.Name(rawValue: notificationKey), object: nil) as Notification
                                    NotificationQueue.default.enqueue(notification, postingStyle: NotificationQueue.PostingStyle.asap)
                                }
                                
                                context.reset()
                            }
                            if(entity == "ExerciseItem"){
                              self.exerciseDataLoaded = true
                            }
                            else if(entity == "FoodItem"){
                                self.foodDataLoaded = true
                            }
                            else if(entity == "FoodCategoryItem"){
                                self.categoryDataLoaded = true
                            }
                            NSLog("The data from \(resource) was loaded into CoreData Entity \(entity)")
                            
                        })
                    }
                    catch {
                        self.showErrorAlert(errorString: "The \(entity) data failed to load into CoreData")
                    }
                }
                else {
                    self.showErrorAlert(errorString: "The resource \(resource) couldn't be turned into data.")
                }
            }
            else{
                self.showErrorAlert(errorString: "The \(resource) path wasn't valid")
            }
        }
    }
    
    
    func loadExerciseData() {
        
        batchLoadData(resource: "exercisesStatic", entity: "ExerciseItem", errorCode: exerciseDataLoadErrorCode,notificationKey: CoreDataManager.exerciseDataLoadedNotificationKey, queue: exerciseQueue)
    }
    
    func loadFoodData() {
        
        batchLoadData(resource: "foodStatic", entity: "FoodItem", errorCode: foodDataLoadErrorCode, notificationKey: CoreDataManager.foodDataLoadedNotificationKey, queue: foodQueue)
    }
    
    func loadCategoryData() {
        
        batchLoadData(resource: "categoriesStatic", entity: "FoodCategoryItem", errorCode: categoryDataLoadErrorCode, notificationKey: CoreDataManager.categoriesDataLoadedNotificationKey, queue: categoryQueue)
        
    }
    
    func loadData() {
        //load the data
        loadExerciseData()
        loadFoodData()
        loadCategoryData()
        
        //send a notification when it's done.
        
    }
    
    func showErrorAlert(errorString:String) {
        DispatchQueue.main.async {
            NSLog(errorString)
            let alert = DBAlertController(title: self.errorTitle, message: errorString, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
            })
            alert.addAction(okAction)
            alert.show()
        }
    }
}
