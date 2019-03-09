//
//  PendingPaymentCellView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

class PendingPaymentCellView: PaymentCell {
    var key: Int?
    var delegate: PendingPaymentCellProtocool?
    var remindButton    = OptionButton(title: NSLocalizedString("set_reminder_button_text", comment: ""), height: 30.0)
    var payButton       = RaisedButton(title: NSLocalizedString("pay_button_text", comment: ""), hight: 30.0)
    
    @objc func remindButtonTapped(sender: Any) {
        delegate?.didTappedRemindButton(sender: self)
    }
    
    func setup(title: String, description: String, amount: Float, currency: String) {
        setupBasicViews(withContent: {
            contentView.addSubview(descriptionLabel)
            
            //Description
            self.descriptionLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.equalToSuperview().offset(20)
                make.right.equalTo(self.amountLabel)
            })
            
            let amountFormatter = NumberFormatter()
            amountFormatter.locale = Locale.availableIdentifiers.lazy.map({Locale(identifier: $0)}).first(where: { $0.currencyCode == currency })
            amountFormatter.numberStyle = .currency
            self.amountLabel.text = amountFormatter.string(from: amount as NSNumber)
            self.titleLabel.text = title.capitalizingFirstLetter()
            self.descriptionLabel.text = description.capitalizingFirstLetter()
        })
        
        contentView.addSubview(remindButton)
        contentView.addSubview(payButton)
        
        remindButton.addTarget(self, action: #selector(remindButtonTapped(sender:)), for: .touchUpInside)
        remindButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.left.equalTo(descriptionLabel)
            make.right.equalTo(descriptionLabel.snp.centerX).offset(-5)
        }
        
        payButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
            make.left.equalTo(descriptionLabel.snp.centerX).offset(5)
            make.right.equalTo(descriptionLabel)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
