//
//  MainViewController.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/28/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit

class MainViewController : UITabBarController {
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.coreDataWasInitialized(_:)), name: NSNotification.Name(rawValue: "CoreDataInitialized"), object: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func coreDataWasInitialized(_ notification: Foundation.Notification){
        
        fatalError("Core data finished")
    }
    
    
    
}
