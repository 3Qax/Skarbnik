//
//  LightSearchBar.swift
//  skarbnik
//
//  Created by Jakub Towarek on 24/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit



class LightSearchBar: UISearchBar {
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        searchBarStyle = .minimal
        
        // Configure text field
        let textField = value(forKey: "searchField") as! UITextField
        
        // This will remove the border style, we need to do this
        // in order to configure border style through `textField.layer`
        // otherwise we'll have 2 borders.
        // You can remove `textField.borderStyle = .none` to see it yourself.
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.clipsToBounds = true
        textField.layer.borderWidth = 0.0
        textField.textColor = UIColor.catchyPink
        
        textField.font = UIFont(name: "PingFangTC-Light", size: 18.0)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .search
        
        textField.leftView = nil
        
        self.setContentHuggingPriority(.init(200), for: .horizontal)
    }
    
}
