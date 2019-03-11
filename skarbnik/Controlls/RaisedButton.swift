//
//  RaisedButton.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

class RaisedButton: UIButton {
    
    init(title: String = "Button", hight: CGFloat = 40.0) {
        super.init(frame: .zero)
        
        setTitle(title.capitalizingFirstLetter(), for: .normal)
        titleLabel!.font = UIFont(name: "PingFangTC-Light", size: 16.0)
        titleLabel!.textColor = UIColor.white
        
        backgroundColor = UIColor.catchyPink
        
        layer.cornerRadius = hight / 2.0
        
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
