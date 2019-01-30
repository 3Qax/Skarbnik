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
    var index: Int?
    var delegate: PendingPaymentCellProtocool?
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
    var payButton = RaisedButton(title: "Zapłać", hight: 30.0)
    
    @objc func remindButtonTapped(sender: Any) {
        delegate?.didTappedRemindButton(sender: self)
    }
    
    func setup(_ title: String, _ description: String, _ amount: Float) {
        setupBasicViews(withContent: {
            contentView.addSubview(descriptionLabel)
            
            //Description
            self.descriptionLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.equalToSuperview().offset(20)
                make.right.equalTo(self.amountLabel)
            })
            
            self.amountLabel.text = String.localizedStringWithFormat("%.2f%@", amount, "zł")
            self.titleLabel.text = title.capitalizingFirstLetter()
            self.descriptionLabel.text = description.capitalizingFirstLetter()
        })
        
        contentView.addSubview(remindButton)
        contentView.addSubview(payButton)
        
        remindButton.addTarget(self, action: #selector(remindButtonTapped(sender:)), for: .touchUpInside)
        remindButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.left.right.equalTo(descriptionLabel)
            make.height.equalTo(30)
        }
        
        payButton.snp.makeConstraints { (make) in
            make.top.equalTo(remindButton.snp.bottom).offset(5)
            make.left.right.equalTo(descriptionLabel)
//            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
