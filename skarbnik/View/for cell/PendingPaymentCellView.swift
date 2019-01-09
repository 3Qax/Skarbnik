//
//  PendingPaymentCellView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import Material

class PendingPaymentCellView: PaymentCell {
    var remindButton: IconButton = {
        let btn = IconButton(title: "PRZYPOMNIJ", titleColor: UIColor.init(rgb: 0xFA3CB1))
        
        btn.pulseColor = UIColor.init(rgb: 0xFA3CB1)
        btn.backgroundColor = Color.clear
        btn.borderColor = UIColor.init(rgb: 0xFA3CB1)
        
        btn.borderWidthPreset = .border2
        btn.cornerRadiusPreset = .cornerRadius4
        
        btn.titleLabel?.font = UIFont(name: "PingFangTC-Light", size: 18.0)
        
        return btn
    }()
    var payButton: IconButton = {
        let btn = IconButton(title: "ZAPŁAĆ", titleColor: UIColor.white)
        
        btn.pulseColor = UIColor.white
        btn.backgroundColor = UIColor.init(rgb: 0xFA3CB1)
        btn.borderColor = UIColor.init(rgb: 0xFA3CB1)
        
        btn.cornerRadiusPreset = .cornerRadius4
        
        btn.titleLabel?.font = UIFont(name: "PingFangTC-Light", size: 18.0)
        
        return btn
    }()
    
    func setup(_ title: String, _ description: String, _ amount: Float) {
        setupBasicViews(withContent: {
            self.amountLabel.text = String.localizedStringWithFormat("%.2f%@", amount, "zł")
            self.titleLabel.text = title.capitalizingFirstLetter()
            titleLabel.sizeToFit()
            self.descriptionLabel.text = description.capitalizingFirstLetter()
            descriptionLabel.sizeToFit()
        })
        
        contentView.addSubview(remindButton)
        contentView.addSubview(payButton)
        
        remindButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.left.right.equalTo(descriptionLabel)
            make.height.equalTo(30)
        }
        
        payButton.snp.makeConstraints { (make) in
            make.top.equalTo(remindButton.snp.bottom).offset(5)
            make.left.right.equalTo(descriptionLabel)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
