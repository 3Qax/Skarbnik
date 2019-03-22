//
//  PaymentListView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit

class PaymentView: UIView {
    var delegate: PaymentViewDelegate?
    var changeStudentIV: UIImageView                = {
        var imageView = UIImageView(image: UIImage(named: "refresh"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    var searchIV: UIImageView                       = {
        var imageView = UIImageView(image: UIImage(named: "search"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    var titleLabel: UILabel                         = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 42)
        label.text = "Skarbnik"
        label.textColor = UIColor.catchyPink
        return label
    }()
    var tableView                                   = UITableView()
    let refreshControl: UIRefreshControl            = {
        var refresh = UIRefreshControl()

        refresh.tintColor = UIColor.pacyficBlue
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("waiting_while_refreshing_data_text", comment:""))
        
        return refresh
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.backgroundGrey
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChangeStudentButton(sender:)))
        changeStudentIV.isUserInteractionEnabled = true
        changeStudentIV.addGestureRecognizer(tapGestureRecognizer)
        
        self.addSubview(changeStudentIV)
        changeStudentIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalToSuperview()
        }
        
        
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(didTapSearchButton(sender:)))
        searchIV.isUserInteractionEnabled = true
        searchIV.addGestureRecognizer(tapGestureRecognizer2)
        
        self.addSubview(searchIV)
        searchIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.right.equalToSuperview()
        }
        
        
        
 

        

        

        


        tableView.layer.cornerRadius                    = 30.0
        tableView.layer.maskedCorners                   = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        tableView.rowHeight                             = UITableView.automaticDimension
        tableView.estimatedRowHeight                    = 100
        tableView.showsVerticalScrollIndicator          = false
        tableView.allowsSelection                       = false
        tableView.allowsMultipleSelection               = false
        tableView.allowsSelectionDuringEditing          = false
        tableView.allowsMultipleSelectionDuringEditing  = false
        
        tableView.backgroundColor                       = UIColor.pacyficBlue
        tableView.separatorStyle                        = .none
        tableView.refreshControl                        = self.refreshControl
        refreshControl.addAction(for: .valueChanged, { self.delegate?.didRequestDataRefresh() })
        
        tableView.register(PaymentCellView.self, forCellReuseIdentifier: "PaymentCellView")
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(175)
        }
        
        
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.lastBaseline.equalTo(tableView.snp.top).offset(-2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapChangeStudentButton(sender: UITapGestureRecognizer) {
        delegate?.didTappedClass()
    }
    
    @objc func didTapSearchButton(sender: UITapGestureRecognizer) {
        print("search!")
    }
    
    func reloadData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }

    
}
