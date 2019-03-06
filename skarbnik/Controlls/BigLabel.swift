//
//  BigLabel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 06/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class BigLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = UIColor(rgb: 0x00A1E6)
        self.font = UIFont(name: "PingFangTC-Regular", size: 36)
        
        self.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

