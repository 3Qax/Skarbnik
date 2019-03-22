//
//  UIColorExtensions.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit

//A way to init a color using hex values
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

//Define custom colors
extension UIColor {
    
    static let catchyPink = UIColor(rgb: 0xEB6F92)//FA3CB1
    static let pacyficBlue = UIColor(rgb: 0x42509F)//00A1E6
    static let backgroundGrey = UIColor(rgb: 0xF5F5F5)
    static let darkGrey = UIColor(rgb: 0xAAAAAA)
    
    
}
