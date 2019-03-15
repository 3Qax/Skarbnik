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
    var changeStudentIV: UIImageView   = {
        var imageView = UIImageView(image: UIImage(named: "users"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        return imageView
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
        
        //Setup button for navigationBar
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChangeStudentButton(sender:)))
        changeStudentIV.isUserInteractionEnabled = true
        changeStudentIV.addGestureRecognizer(tapGestureRecognizer)
        
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        

        //tableView.isUserInteractionEnabled = true


        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.allowsMultipleSelectionDuringEditing = false
        
        tableView.refreshControl = self.refreshControl
        refreshControl.addAction(for: .valueChanged, { self.delegate?.didRequestDataRefresh(completion:  {
            self.refreshControl.endRefreshing()
        }) })
        
        tableView.register(PaymentCellView.self, forCellReuseIdentifier: "PaymentCellView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapChangeStudentButton(sender: UITapGestureRecognizer) {
        delegate?.didTappedClass()
    }
    

    
}
