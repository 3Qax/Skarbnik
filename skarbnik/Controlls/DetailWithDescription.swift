//
//  DetailWithDescription.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class DetailWithDescription: UIView {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 18)
        label.textColor = UIColor.black
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 36)
        label.textColor = UIColor.pacyficBlue
        return label
    }()
    
    init(title: String, value: String) {
        
        super.init(frame: .zero)
        
        self.addSubview(descriptionLabel)
        descriptionLabel.text = title
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(25)
        }
        
        self.addSubview(valueLabel)
        valueLabel.text = value
        valueLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(-5)//-10
            make.height.equalTo(43)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
