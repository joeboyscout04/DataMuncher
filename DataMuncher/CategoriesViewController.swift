//
//  CategoriesViewController.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories:[FoodCategoryItem] = []
    
    //MARK: - CoreData
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        context.persistentStoreCoordinator = appDelegate.dataStack?.storeCoordinator
        
        //set the merge policy
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        //disable undo for performance benefit
        context.undoManager = nil
        
        return context
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(CategoriesViewController.fetchCategoriesData(note:)),
                                               name: NSNotification.Name(rawValue: CoreDataManager.categoriesDataLoadedNotificationKey), object: nil)
        
        self.navigationItem.title = "Categories"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check to see if the data's loaded already, we could either start the fetch from a notification or from appearance.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let stack = appDelegate.dataStack{
            if(stack.categoryDataLoaded){
                fetchCategoriesDataAndShowError(displayError: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier! == "CategoryFoodSegue") {
            
            let destination = segue.destination as! FoodViewController
            let indexpath = tableView.indexPathForSelectedRow!
            let selectedCategory = categories[indexpath.row]
            
            destination.foodSubset = true
            
            //data weirdness...if servingscategory is 0, then it's a letter
            if(selectedCategory.servingsCategory == 0){
                //get the foods for the selected item and assign them
                destination.foods = foodsForLetter(category: selectedCategory)
            }
            else {
            
                //get the foods for the selected item and assign them
                destination.foods = foodsForCategory(category: selectedCategory)
                
            }
            
            //TODO: Sort out using localization
            
        }
        else {
            NSLog("Unknown Segue \(segue.identifier)")
        }
    }

    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)
        if let categoryCell = cell as? CategoryTableViewCell {
            
            let category = categories[indexPath.row]
            
            categoryCell.titleLabel.text = category.categoryName
            
            cell = categoryCell
        }
        
        return cell
    }
    
    //MARK: - Core Data Retrieval
    
    func fetchCategoriesDataAndShowError(displayError:Bool){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodCategoryItem")
        
        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            categories = results as! [FoodCategoryItem]
        }
        catch let error as NSError {
            
            if(displayError){
                showError(error: error)
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    func fetchCategoriesData(note: Notification) {
        
       fetchCategoriesDataAndShowError(displayError: true)
        
    }
    
    func foodsForCategory(category:FoodCategoryItem) -> [FoodItem] {
        
        var foundFoods:[FoodItem] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodItem")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let filter = NSPredicate(format: "categoryId == %@", category.oid)
        fetchRequest.predicate = filter
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            foundFoods = results as! [FoodItem]
        }
        catch let error as NSError {
            showError(error: error)
        }
        
        return foundFoods
    }
    
    func foodsForLetter(category:FoodCategoryItem) -> [FoodItem] {
        
        var foundFoods:[FoodItem] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodItem")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let filter = NSPredicate(format: "title BEGINSWITH[c] %@", category.categoryName)
        fetchRequest.predicate = filter
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            foundFoods = results as! [FoodItem]
        }
        catch let error as NSError {
            showError(error: error)
        }
        
        return foundFoods
    }
}
