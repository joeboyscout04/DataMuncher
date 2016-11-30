//
//  FoodDetailViewController.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit

struct NutritionData {
    
    var title = ""
    var image = UIImage()
    var data:Float = 0.0
    var color = UIColor.darkGray
    
}

class FoodDetailViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    //outlets
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var foodItemTitleLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    
    //data
    var foodItem:FoodItem? = nil
    var nutritionData:[NutritionData] = []
    
    let formatter:NumberFormatter = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodItemTitleLabel.text = foodItem?.title
        self.brandLabel.text = foodItem?.brand
        
        formatter.numberStyle = NumberFormatter.Style.decimal;
        formatter.minimumIntegerDigits = 1;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 0;
        
        //display two cells per row
        
        self.theCollectionView.contentInset = UIEdgeInsetsMake(0, flowLayout.minimumInteritemSpacing, 0, flowLayout.minimumInteritemSpacing)
        
        initializeDataModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
        
        let viewWidth = self.view.frame.size.width - 2.0*flowLayout.minimumInteritemSpacing
        let spacing = flowLayout.minimumInteritemSpacing
        
        let newWidth = (viewWidth - spacing)/2.0
        
        flowLayout.itemSize = CGSize(width: newWidth, height: newWidth)
    }

    func initializeDataModel() {
        
        if let food = foodItem {
            
            nutritionData = [NutritionData(title: NSLocalizedString("Fat", comment: ""), image: UIImage(named:"fat_icon")!, data: food.fat, color:UIColor(hexString:"996633")),
                             NutritionData(title: NSLocalizedString("Calories", comment: ""), image: UIImage(named:"calories_icon")!, data: food.calories, color:UIColor(hexString:"3399ff")),
                             NutritionData(title: NSLocalizedString("Cholesterol", comment: ""), image: UIImage(named:"cholesterol_icon")!, data: food.cholesterol, color:UIColor(hexString:"cccc00"))
            ]
        }
    }
    
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nutritionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodDetailCollectionViewCell", for: indexPath)
        if let collectionCell = cell as? FoodDetailCollectionViewCell {
            let dataItem = nutritionData[indexPath.row]
            collectionCell.contentView.backgroundColor = dataItem.color
            collectionCell.detailTitleLabel.text = dataItem.title
            collectionCell.iconView.image = dataItem.image
            collectionCell.numberLabel.text = formatter.string(from: NSNumber(value:dataItem.data))
            
            cell = collectionCell
        }
        return cell
    }
}

    
