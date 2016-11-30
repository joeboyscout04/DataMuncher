//
//  ViewController.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class FoodViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var foods:[FoodItem] = []
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(FoodViewController.fetchData(note:)),
                                               name: NSNotification.Name(rawValue: CoreDataManager.foodDataLoadedNotificationKey), object: nil)
        self.navigationItem.title = "Foods"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //check to see if the data's loaded already, we could either start the fetch from a notification or from appearance.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let stack = appDelegate.dataStack{
            if(stack.foodDataLoaded){
                fetchDataAndShowError(displayError: true)
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
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath)
        if let foodCell = cell as? FoodTableViewCell {
            
            let food = foods[indexPath.row]
            
            foodCell.titleLabel.text = food.title
            
            cell = foodCell
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier! == "FoodDetailSegue") {

            let destination = segue.destination as! FoodDetailViewController
            let indexpath = tableView.indexPathForSelectedRow!
            let selectedObject = foods[indexpath.row]
            
            destination.foodItem = selectedObject

        }
        else {
            NSLog("Unknown Segue \(segue.identifier)")
        }
    }

    
    //MARK: - Core Data Retrieval
    
    func fetchDataAndShowError(displayError:Bool){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodItem")
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            foods = results as! [FoodItem]
            spinner.stopAnimating()
        }
        catch let error as NSError {
            
            if(displayError){
                showError(error: error)
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    func fetchData(note: Notification) {
        
        fetchDataAndShowError(displayError: true)
        
    }
}



