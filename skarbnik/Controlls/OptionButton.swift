//
//  OptionButton.swift
//  skarbnik
//
//  Created by Jakub Towarek on 30/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

class OptionButton: UIButton {

    init(title: String = "Button", hight: CGFloat = 40.0) {
        super.init(frame: .zero)
        
        setTitle(title.capitalizingFirstLetter(), for: .normal)
        setTitleColor(UIColor.catchyPink, for: .normal)
        titleLabel!.font = UIFont(name: "PingFangTC-Light", size: 16.0)
        
        backgroundColor = UIColor.clear//(rgb: 0xFA3CB1)
        
        layer.cornerRadius = hight / 2.0
        layer.borderColor = UIColor.catchyPink.cgColor
        layer.borderWidth = 1.0
        
        snp.makeConstraints { (make) in
            make.height.equalTo(hight)
        }
    }
    
    convenience init(_ localizedTitle: String, hight: CGFloat = 40.0) {
        self.init(title: NSLocalizedString(localizedTitle, comment: ""), hight: hight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
