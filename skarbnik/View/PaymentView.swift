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
    
    var header: UIView                                  = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.cornerRadius                    = 20.0
        view.layer.maskedCorners                   = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
        var changeStudentIV: UIImageView                = {
            var imageView = UIImageView(image: UIImage(named: "refresh"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.catchyPink
            return imageView
        }()
        var titleLabel: UILabel                         = {
            let label = UILabel()
            label.font = UIFont(name: "OpenSans-Regular", size: 32)
            label.text = "Skarbnik"
            label.textColor = UIColor.pacyficBlue
            label.textAlignment = .center
            label.setContentHuggingPriority(.init(200), for: .horizontal)
            return label
        }()
        let searchBar                                   = LightSearchBar()
        var searchIV: UIImageView                       = {
            var imageView = UIImageView(image: UIImage(named: "search"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.catchyPink
            return imageView
        }()
        var cancelIV: UIImageView                       = {
            var imageView = UIImageView(image: UIImage(named: "cancel"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.catchyPink
            return imageView
        }()
    
    var tableView                                       = UITableView()
        let refreshControl: UIRefreshControl            = {
        var refresh = UIRefreshControl()
        
        refresh.tintColor = UIColor.white
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("waiting_while_refreshing_data_text",
                                                                                comment:""),
                                                     attributes: [.foregroundColor: UIColor.white] )
        
        return refresh
    }()
    
    let gradientLayer: CAGradientLayer                  = {
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
        header.clipsToBounds = true
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
        
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        

        
        
        
        
        
        
        
        
        
        
        
        
        tableView.setContentOffset(CGPoint(x: 0, y: 5), animated: false)
        
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
            make.top.equalTo(header.snp.bottom).offset(-5)
        }
        
        self.bringSubviewToFront(header)
        
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapChangeStudentButton(sender: UITapGestureRecognizer) {
        delegate?.didTappedClass()
    }
    
    @objc func didTapSearchButton(sender: UITapGestureRecognizer) {
        
        titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
        searchIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(header.snp.right)
        }

        UIView.animate(withDuration: 0.25, animations: {
            self.titleLabel.alpha = 0
            self.layoutIfNeeded()
        }, completion: { _ in
            
            self.header.addSubview(self.cancelIV)
            let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.didTapCancelButton))
            self.cancelIV.isUserInteractionEnabled = true
            self.cancelIV.addGestureRecognizer(tapGestureRecognizer3)
            self.cancelIV.alpha = 0.0
            self.cancelIV.snp.makeConstraints({ (make) in
                make.top.equalTo(self.safeAreaLayoutGuide)
                make.right.equalToSuperview().offset(-5)
            })
            
            self.header.addSubview(self.searchBar)
            self.searchBar.snp.remakeConstraints { (make) in
                make.top.equalTo(self.safeAreaLayoutGuide)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            self.layoutIfNeeded()
            
            self.searchBar.snp.makeConstraints { (make) in
                make.left.equalTo(self.changeStudentIV.snp.right)
                make.right.equalTo(self.cancelIV.snp.left)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.cancelIV.alpha = 1.0
                self.layoutIfNeeded()
            }, completion: { _ in
                self.searchBar.becomeFirstResponder()
            })
            
        })
    }
    
    @objc func didTapCancelButton() {
        searchBar.resignFirstResponder()
        searchBar.delegate?.searchBarCancelButtonClicked!(searchBar)
        searchBar.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.bottom.centerX.equalToSuperview()
            make.width.equalTo(0)
        }
        self.cancelIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(self.header.snp.right)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.searchBar.removeFromSuperview()
            self.cancelIV.removeFromSuperview()
            self.titleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(self.safeAreaLayoutGuide)
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            self.searchIV.snp.remakeConstraints { (make) in
                make.top.equalTo(self.safeAreaLayoutGuide)
                make.right.equalToSuperview().offset(-5)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.titleLabel.alpha = 1.0
                self.layoutIfNeeded()
            })
        })
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
