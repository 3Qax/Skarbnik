//
//  PaymentCellView.swift
//  tableviewtest
//
//  Created by Jakub Towarek on 22/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//
import UIKit
import Material
import SnapKit

class PaymentCell: UITableViewCell {
    
    var titleLabel: UILabel! = {
    let label = UILabel()
    label.numberOfLines = 0 //odpowiada za zawijanie tekstu w obrębie UILabel
    label.font = UIFont(name: "HelveticaNeue", size: 22.0)
    return label
}()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 //odpowiada za zawijanie tekstu w obrębie UILabel
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        label.textColor = UIColor(rgb: 0x78C0E5)
        return label
    }()
    var amountLabel: UILabel! = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0 //odpowiada za zawijanie tekstu w obrębie UILabel
        label.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)
        label.textColor = UIColor(rgb: 0xFA3CB1)
        return label
    }()

    func setupBasicViews(withContent: () -> ()) {
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        //Title
        self.titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(amountLabel.snp.left).offset(10)
        }
        
        //Amount
        self.amountLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-self.separatorInset.left)
        }
        
        //self.wrapper.setNeedsLayout()
        
        withContent()
    }
    
}
