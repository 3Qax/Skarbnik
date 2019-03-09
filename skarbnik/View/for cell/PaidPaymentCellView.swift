//
//  PaidPaymentCellView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit

class PaidPaymentCellView: PaymentCell {

    weak var tableView: UITableView?
    var delegate: PaidPaymentCellProtocool?
    let showPhotosButton    = OptionButton(title: NSLocalizedString("show_photos_button_text", comment: ""), height: 30)
    private var isExpanded  = false
    
    @objc func gotTapped(sender: Any) {
        delegate?.didTapped(sender: self)
    }
    
    func setup(title: String, description: String, amount: Float, currency: String) {
        setupBasicViews(withContent: {
            let amountFormatter = NumberFormatter()
            amountFormatter.locale = Locale.availableIdentifiers.lazy.map({Locale(identifier: $0)}).first(where: { $0.currencyCode == currency })
            amountFormatter.numberStyle = .currency
            self.amountLabel.text = amountFormatter.string(from: amount as NSNumber)
            self.amountLabel.textColor = UIColor(rgb: 0xAAAAAA)
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
            tableView?.beginUpdates()
            showPhotosButton.removeFromSuperview()
            descriptionLabel.removeFromSuperview()
            
            self.amountLabel.snp.remakeConstraints({ (make) in
                make.top.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-self.separatorInset.left)
                //make.bottom.equalToSuperview().offset(-5)
            })
            tableView?.endUpdates()
            isExpanded.toggle()
        } else {
            tableView?.beginUpdates()
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
                make.bottom.equalToSuperview().offset(-5).priority(999)
            }
            tableView?.endUpdates()
            tableView?.scrollToRow(at: (tableView?.indexPathForRow(at: self.center))!, at: .middle, animated: true)
            isExpanded.toggle()
        }
        
    }
    
}
