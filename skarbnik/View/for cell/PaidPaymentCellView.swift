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
    var delegate: PaidPaymentCellProtocool?
    var contentViewBottomConstraint: Constraint?
    private var isExpanded = false
    
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
    
    @objc func gotTapped(sender: Any) {
        delegate?.didTapped(sender: self)
    }
    
    func setup(_ title: String, _ description: String, _ amount: Float) {
        setupBasicViews(withContent: {
            self.amountLabel.text = String.localizedStringWithFormat("%.2f%@", amount, "zł")
            self.amountLabel.textColor = Color.grey.base
            self.titleLabel.text = title.capitalizingFirstLetter()
            self.descriptionLabel.text = description.capitalizingFirstLetter()
        })
        
        self.amountLabel.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-5)
        })
        
        tapFunc = toggle
    }
    
    func toggle() {
        if isExpanded {
            
            showPhotosButton.removeFromSuperview()
            descriptionLabel.removeFromSuperview()
            
            self.amountLabel.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-self.separatorInset.left)
                make.bottom.equalToSuperview().offset(-5)
            })
            
            isExpanded = false
        } else {
            contentView.addSubview(showPhotosButton)
            contentView.addSubview(descriptionLabel)
            amountLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel).priority(.required)
                make.right.equalToSuperview().offset(-self.separatorInset.left)
                make.left.equalTo(titleLabel.snp.right).offset(10)
            }
            self.descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            descriptionLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).priority(.required).labeled("Top of description to the bottom of title")
                make.left.equalToSuperview().offset(20).labeled("Left offset of description")
                make.right.equalTo(self.amountLabel).labeled("Right of description equal to amountLabel")
            }
            self.showPhotosButton.setContentCompressionResistancePriority(.required, for: .vertical)
            showPhotosButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5).priority(.required).labeled("Top of showPhotosButton to description bottom")
                make.left.right.equalTo(descriptionLabel)
                make.height.equalTo(30).priority(999)
                make.bottom.equalTo(contentView).priority(1000)
            }
            
            isExpanded = true
        }
    }
    
}
