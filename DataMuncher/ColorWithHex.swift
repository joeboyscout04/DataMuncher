//
//  ColorWithHex.swift
//  DataMuncher
//
//  Created by Joseph Elliott on 11/29/16.
//  Copyright © 2016 Joseph Elliott. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexString: String) {

        var cleanString = hexString.replacingOccurrences(of: "#", with: "")

        if (cleanString.characters.count == 6) {
            cleanString = cleanString.appending("ff")
        }
        
        var baseValue: UInt32 = 0
        Scanner(string: cleanString).scanHexInt32(&baseValue)

        let red = Double(((baseValue >> 24) & 0xFF))/255.0
        let green = Double(((baseValue >> 16) & 0xFF))/255.0
        let blue = Double(((baseValue >> 8) & 0xFF))/255.0
        let alpha = Double(((baseValue >> 0) & 0xFF))/255.0
        
        
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        
    }
}
