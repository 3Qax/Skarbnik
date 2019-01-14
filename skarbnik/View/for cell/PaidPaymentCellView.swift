//
//  PaidPaymentCellView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import Material
import SnapKit

class PaidPaymentCellView: PaymentCell {
    
    var showPhotosButton: IconButton = {
        let btn = IconButton(title: "POKAŻ ZDJĘCIA", titleColor: UIColor.init(rgb: 0xFA3CB1))
        
        btn.pulseColor = UIColor.init(rgb: 0xFA3CB1)
        btn.backgroundColor = Color.clear
        btn.borderColor = UIColor.init(rgb: 0xFA3CB1)
        
        btn.borderWidthPreset = .border2
        btn.cornerRadiusPreset = .cornerRadius4
        
        btn.titleLabel?.font = UIFont(name: "PingFangTC-Light", size: 18.0)
        
        return btn
    }()
    
    func setup(_ title: String, _ description: String, _ amount: Float) {

        setupBasicViews(withContent: {
            self.amountLabel.text = String.localizedStringWithFormat("%.2f%@", amount, "zł")
            self.amountLabel.textColor = Color.grey.base
            
            self.amountLabel.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview().offset(-5)
            })
            self.titleLabel.text = title.capitalizingFirstLetter()
            titleLabel.sizeToFit()
            self.descriptionLabel.text = description.capitalizingFirstLetter()
            descriptionLabel.sizeToFit()
        })
        
//        contentView.addSubview(showPhotosButton)
//        showPhotosButton.snp.makeConstraints { (make) in
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
//            make.left.right.equalTo(descriptionLabel)
//            make.height.equalTo(30)
//            make.bottom.equalToSuperview().offset(-5)
//        }
        
        //descriptionLabel.isHidden = true
        //showPhotosButton.isHidden = true
        
        self.contentMode = .redraw
        //self.descriptionLabel.sizeToFit()
        self.contentView.sizeToFit()
        self.setNeedsLayout()
    }
    
}
