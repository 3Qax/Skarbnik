//
//  PaymentListView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit

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
    var tableView: UITableView                      = UITableView()
    let refreshControl: UIRefreshControl            = {
        var refresh = UIRefreshControl()

        refresh.tintColor = UIColor.pacyficBlue
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("waiting_while_refreshing_data_text", comment:""))
        
        return refresh
    }()
    var tableViewOffset: Constraint?                = nil
    let tableViewTransitionHelper                   = TransitionHelper()
    
    
    
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
        tableView.isUserInteractionEnabled              = true
        refreshControl.addAction(for: .valueChanged, { self.delegate?.didRequestDataRefresh() })
        
        tableView.register(PaymentCellView.self, forCellReuseIdentifier: "PaymentCellView")
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            tableViewOffset = make.top.equalToSuperview().offset(175).constraint
        }
        
        
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.lastBaseline.equalTo(tableView.snp.top).offset(-2)
        }
        
        self.addSubview(tableViewTransitionHelper)
        tableViewTransitionHelper.touchesBeganHandler = { (touches, event) in
            print("began")
            self.tableView.touchesBegan(touches, with: event)
        }
        
        tableViewTransitionHelper.touchesMovedHandler = { (dy, touches, event) in
            if self.tableView.contentOffset.y == 0.0 {
                let newOffset = self.boundTableViewOffset(self.getCurrnetTableViewOffset()-Float(dy))
                if newOffset != self.getCurrnetTableViewOffset() {
                    self.tableViewOffset?.update(offset: newOffset)
                } else {
//                    print("That move wont cgange anything")
                    self.tableView.touchesMoved(touches, with: event)
                }
            } else {
                self.tableView.touchesMoved(touches, with: event)
            }
        }
        tableViewTransitionHelper.touchesEndedHandler = { (touches, event) in
            self.tableView.touchesEnded(touches, with: event)
        }
        tableViewTransitionHelper.snp.makeConstraints { (make) in
            make.edges.equalTo(tableView)
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
        print(tableView.contentOffset)
    }
    
    func reloadData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func boundTableViewOffset(_ offset: Float) -> Float {
//        if let b = tableViewOffset?.layoutConstraints[0].constant {
//            tableViewOffset?.update(offset: max(50.0, min(175.0, b)))
//        }
        return max(50.0, min(175.0, offset))
    }
    
    func getCurrnetTableViewOffset() -> Float {
        return Float(tableViewOffset!.layoutConstraints[0].constant)
    }

    
}

