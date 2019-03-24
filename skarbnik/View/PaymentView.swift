//
//  PaymentListView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit

class PaymentView: UIView {
    
    var header: UIView                              = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.cornerRadius                    = 20.0
        view.layer.maskedCorners                   = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
        var changeStudentIV: UIImageView            = {
            var imageView = UIImageView(image: UIImage(named: "refresh"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.catchyPink
            return imageView
        }()
        let searchBar                               = LightSearchBar()
        var searchIV: UIImageView                   = {
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
        
        refresh.tintColor = UIColor.white
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("waiting_while_refreshing_data_text",
                                                                                comment:""),
                                                     attributes: [.foregroundColor: UIColor.white] )
        
        return refresh
    }()
    let gradientLayer: CAGradientLayer              = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.catchyPink.cgColor, UIColor.pacyficBlue.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        return gradientLayer
    }()
    var delegate: PaymentViewDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.frame = bounds
        
        self.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        header.addSubview(changeStudentIV)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChangeStudentButton(sender:)))
        changeStudentIV.isUserInteractionEnabled = true
        changeStudentIV.addGestureRecognizer(tapGestureRecognizer)
        changeStudentIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(5)
        }
        
        header.addSubview(searchIV)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(didTapSearchButton(sender:)))
        searchIV.isUserInteractionEnabled = true
        searchIV.addGestureRecognizer(tapGestureRecognizer2)
        searchIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(-5)
        }
        
        header.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(changeStudentIV.snp.right)
            make.right.equalTo(searchIV.snp.left)
            make.bottom.equalToSuperview()
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        tableView.rowHeight                             = UITableView.automaticDimension
        tableView.estimatedRowHeight                    = 100
        tableView.showsVerticalScrollIndicator          = false
        tableView.allowsSelection                       = false
        tableView.allowsMultipleSelection               = false
        tableView.allowsSelectionDuringEditing          = false
        tableView.allowsMultipleSelectionDuringEditing  = false
        
        tableView.backgroundColor                       = UIColor.clear
        tableView.separatorStyle                        = .none
        tableView.refreshControl                        = self.refreshControl
        refreshControl.addAction(for: .valueChanged, { self.delegate?.didRequestDataRefresh() })
        
        tableView.register(PaymentCellView.self, forCellReuseIdentifier: "PaymentCellView")
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
        
        
        
        //        self.addSubview(titleLabel)
        //        titleLabel.snp.makeConstraints { (make) in
        //            make.left.equalToSuperview().offset(25)
        //            make.lastBaseline.equalTo(tableView.snp.top).offset(-2)
        //        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("did layout subview")
        gradientLayer.frame = self.bounds
    }
    
    
}
