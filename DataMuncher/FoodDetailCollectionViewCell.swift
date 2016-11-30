//
//  FoodDetailCollectionViewCell.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit

class FoodDetailCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var containingView: UIView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

}
