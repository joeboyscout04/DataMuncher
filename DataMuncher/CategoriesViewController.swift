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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check to see if the data's loaded already 
        
        fetchCategoriesData(note: Notification(name: NSNotification.Name(rawValue: CoreDataManager.categoriesDataLoadedNotificationKey)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func fetchCategoriesData(note: Notification) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodCategoryItem")
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            categories = results as! [FoodCategoryItem]
        }
        catch let error as NSError {
            
            showError(error: error)
        }
        
        self.tableView.reloadData()
        
    }
}