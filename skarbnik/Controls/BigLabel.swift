//
//  BigLabel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 06/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class BigLabel: UILabel {
    
    enum FontStyle: String {
        case ultraLight = "PingFangSC-Ultralight"
        case light = "PingFangSC-Light"
        case thin = "PingFangSC-Thin"
        case regular = "PingFangSC-Regular"
        case medium = "PingFangSC-Medium"
        case semibold = "PingFangSC-Semibold"
    }
    
    init(text: String, fontSize: Int = 36, fontStyle: FontStyle = .regular) {
        super.init(frame: .zero)
        
        self.text = text
        self.textColor = UIColor.pacyficBlue
        self.font = UIFont(name: fontStyle.rawValue, size: CGFloat(fontSize))
        
        self.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

