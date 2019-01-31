//
//  PaymentCellView.swift
//  tableviewtest
//
//  Created by Jakub Towarek on 22/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//
import UIKit
import SnapKit

class PaymentCell: UITableViewCell {
    
    var titleLabel: UILabel! = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont(name: "HelveticaNeue", size: 22.0)
    return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        label.textColor = UIColor(rgb: 0x78C0E5)
        return label
    }()
    var amountLabel: UILabel! = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)
        label.textColor = UIColor(rgb: 0xFA3CB1)
        return label
    }()
    var tapFunc: (() -> ())?
    
    @objc func handleTap() {
        if let tapFunc = tapFunc {
            tapFunc()
        } else {
            print("Tapped")
        }
    }

    func setupBasicViews(withContent: () -> ()) {
        
        let tapGestureRecoginzer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGestureRecoginzer)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        //Title
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5).priority(.required)
            make.left.equalToSuperview().offset(20)
        }
        
        //Amount
        self.amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        self.amountLabel.setContentHuggingPriority(.required, for: .vertical)
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).priority(.required)
            make.right.equalToSuperview().offset(-self.separatorInset.left)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        withContent()
    }
    
}
