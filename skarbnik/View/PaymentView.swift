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
            
            label.text = ""
            label.font = UIFont(name: "HelveticaNeue-Light", size: 29.0)
            label.textColor = Color.blue.base
            label.textAlignment = .right
            return label
        }()
    var tableView = UITableView()
    
    var delegate: PaymentViewProtocol?
    
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedHeaderClassLabel(sender:)))
        headerClassLabel.isUserInteractionEnabled = true
        headerClassLabel.addGestureRecognizer(tapGestureRecognizer)
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
    
    @objc func didTappedHeaderClassLabel(sender: UITapGestureRecognizer) {
        delegate?.didTappedClass()
    }
    
    func viewForUser(name: String, className: String) {
        let tmpName = NSMutableAttributedString()
        tmpName.append(NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 26.0)!]))
        headerNameLabel.attributedText = tmpName
        
        let tmpClassName = NSMutableAttributedString()
        tmpClassName.append(NSAttributedString(string: className, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 29.0)!]))
        headerClassLabel.attributedText = tmpClassName
    }
    
    func shouldReloadHeader(for name: String) {

    }
}
