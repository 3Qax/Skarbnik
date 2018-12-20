//
//  PaymentListView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import Material

class PaymentView: UIView {
    var headerView = UIView()
        var headerImage = UIImageView(image: UIImage(named: "logo"))
        var headerNameLabel: UILabel = {
            var label = UILabel()
            label.textColor = UIColor.black
            label.textAlignment = .left
            return label
        }()
        var headerClassLabel: UILabel = {
            var label = UILabel()
            
            label.text = "4Ti1"
            label.fontSize = 22.0
            label.textColor = Color.blue.base
            label.textAlignment = .right
            return label
        }()
    var tableView = UITableView()
    
    var delegate: UITableViewDelegate?
    var dataSource: UITableViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Color.grey.lighten4
        
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
        
        headerView.addSubview(headerClassLabel)
        headerClassLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        tableView.register(PaymentCell.self, forCellReuseIdentifier: "payment")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shouldReloadHeader(for name: String) {
        let tmp = NSMutableAttributedString()
        tmp.append(NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 20.0)!]))
        headerNameLabel.attributedText = tmp
    }
}
