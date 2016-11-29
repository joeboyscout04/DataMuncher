//
//  ExerciseViewController.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class ExerciseViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var exercises:[ExerciseItem] = []
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ExerciseViewController.fetchExerciseData(note:)),
                                                         name: NSNotification.Name(rawValue: CoreDataManager.exerciseDataLoadedNotificationKey), object: nil)
        
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
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath)
        if let exerciseCell = cell as? ExerciseTableViewCell {
            
            let exercise = exercises[indexPath.row]
            
            exerciseCell.titleLabel.text = exercise.title
            
            cell = exerciseCell
        }
        
        return cell
    }
    
    //MARK: - Core Data Retrieval
    
    func fetchExerciseData(note: Notification) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseItem")
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            exercises = results as! [ExerciseItem]
        }
        catch let error as NSError {
            
            showError(error: error)
        }
        
        self.tableView.reloadData()
        
    }
}
