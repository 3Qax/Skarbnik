//
//  AmountLabel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class AmountLabel: UIView {
    private let integersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 24.0)
        label.textAlignment = .left
        return label
    }()
    private let decimalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 14.0)
        label.textAlignment = .left
        return label
    }()
    private let decimalFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 2
        formatter.minimumIntegerDigits = 2
        formatter.maximumFractionDigits = 0
        
        return formatter
    }()
    
    public var textColor: UIColor = .pacyficBlue {
        didSet {
            integersLabel.textColor = textColor
            decimalLabel.textColor = textColor
        }
    }
    public var amount: Float = 0.0 {
        didSet {
            integersLabel.text = String(Int(amount.rounded(.down)))
            decimalLabel.text = decimalFormatter.string(from: Int(amount.remainder(dividingBy: 1) * 100) as NSNumber)
        }
    }
    
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubview(integersLabel)
        integersLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addSubview(decimalLabel)
        decimalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(integersLabel).offset(3)
            make.left.equalTo(integersLabel.snp.right)
            make.right.equalToSuperview()
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
