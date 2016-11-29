//
//  ShowAlertView.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError(error: NSError) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "Error: \(error), info: \(error.userInfo)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: { (alert) in
            alertController.dismiss(animated: true, completion: {})
        })
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:{})
        
    }
}
