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
    
    let kvoContentOffset = "contentOffset"
    var originalCellWidth = 0.0
    
    
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
        
        self.theCollectionView.addObserver(self, forKeyPath: kvoContentOffset, options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
        
        let viewWidth = self.view.frame.size.width - 2.0*flowLayout.minimumInteritemSpacing
        let spacing = flowLayout.minimumInteritemSpacing
        
        let newWidth = (viewWidth - spacing)/2.0
        originalCellWidth = Double(newWidth)
        
        flowLayout.itemSize = CGSize(width: newWidth, height: newWidth)
    }
    
    deinit {
        self.theCollectionView.removeObserver(self, forKeyPath: kvoContentOffset)
    }

    func initializeDataModel() {
        
        if let food = foodItem {
            
            nutritionData = [
                             NutritionData(title: NSLocalizedString("Calories", comment: ""), image: UIImage(named:"calories_icon")!, data: food.calories, color:UIColor(hexString:"3399ff")),
                             NutritionData(title: NSLocalizedString("Fat", comment: ""), image: UIImage(named:"fat_icon")!, data: food.fat, color:UIColor(hexString:"996633")),
                             NutritionData(title: NSLocalizedString("Protein", comment: ""), image: UIImage(named:"protein_icon")!, data: food.protein, color:UIColor(hexString:"b30000")),
                             NutritionData(title: NSLocalizedString("Carbohydrates", comment: ""), image: UIImage(named:"carbohydrates_icon")!, data: food.carbohydrates, color:UIColor(hexString:"cc9900")),
                             NutritionData(title: NSLocalizedString("Cholesterol", comment: ""), image: UIImage(named:"cholesterol_icon")!, data: food.cholesterol, color:UIColor(hexString:"cccc00")),
                            NutritionData(title: NSLocalizedString("Sodium", comment: ""), image: UIImage(named:"sodium_icon")!, data: food.sodium, color:UIColor(hexString:"b3b3b3")),
                            NutritionData(title: NSLocalizedString("Potassium", comment: ""), image: UIImage(named:"potassium_icon")!, data: food.potassium, color:UIColor(hexString:"ff9933")),
                            NutritionData(title: NSLocalizedString("Fiber", comment: ""), image: UIImage(named:"fiber_icon")!, data: food.fiber, color:UIColor(hexString:"336600"))
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
            collectionCell.containingView.backgroundColor = dataItem.color.withAlphaComponent(0.5)
            collectionCell.detailTitleLabel.text = dataItem.title
            collectionCell.iconView.image = dataItem.image
            collectionCell.numberLabel.text = formatter.string(from: NSNumber(value:dataItem.data))
            
            cell = collectionCell
        }
        return cell
    }
    
    
    //MARK: KVO Animations
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == kvoContentOffset){
            if let value = change?[NSKeyValueChangeKey.newKey] as? CGPoint {
                
                if(value.y < 0){
                    //we're pulling down on the scroll
                    
                    let visibleCells = self.theCollectionView.visibleCells
                    
                    for cell in visibleCells {
                    
                        if let detailCell = cell as? FoodDetailCollectionViewCell {
                            UIView.animate(withDuration: 0.1, animations: {
                                detailCell.bottomConstraint.constant = value.y
                                detailCell.topConstraint.constant = value.y
                                detailCell.leadingConstraint.constant = value.y
                                detailCell.trailingConstraint.constant = value.y
                                detailCell.layoutIfNeeded()
                            })
                        }
                    }
                }
                
                
                
            }
        }
    }
    
}


