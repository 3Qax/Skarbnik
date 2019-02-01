//
//  PaymentListView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit

class PaymentView: UIView {
    var headerView                                  = UIView()
    var headerImage                                 = UIImageView(image: UIImage(named: "logo"))
    var headerNameLabel: UILabel                    = {
        var label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    var headerChangeStudentImageView: UIImageView   = {
        var imageView = UIImageView(image: UIImage(named: "users"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(rgb: 0xFA3CB1)
        return imageView
    }()
    var tableView                                   = UITableView()
    let blurEffect                                  = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    var delegate: PaymentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(rgb: 0xF5F5F5)
        
        self.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        headerView.addSubview(headerNameLabel)
        headerNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        headerView.addSubview(headerChangeStudentImageView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedHeaderClassLabel(sender:)))
        headerChangeStudentImageView.isUserInteractionEnabled = true
        headerChangeStudentImageView.addGestureRecognizer(tapGestureRecognizer)
        headerChangeStudentImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        headerChangeStudentImageView.layer.shouldRasterize = true
        headerChangeStudentImageView.layer.rasterizationScale = UIScreen.main.scale
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        
        self.addSubview(blurEffect)
        blurEffect.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        self.bringSubviewToFront(blurEffect)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(PendingPaymentCellView.self, forCellReuseIdentifier: "PendingCell")
        tableView.register(PaidPaymentCellView.self, forCellReuseIdentifier: "PaidCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTappedHeaderClassLabel(sender: UITapGestureRecognizer) {
        delegate?.didTappedClass()
    }
    
    func viewFor(child: Child) {
        let tmpName = NSMutableAttributedString()
        tmpName.append(NSAttributedString(string: child.name, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 26.0)!]))
        headerNameLabel.attributedText = tmpName
    }
    
    func shouldReloadHeader(for name: String) {

    }
}
