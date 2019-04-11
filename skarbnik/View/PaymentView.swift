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
        view.backgroundColor = UIColor.clear
        return view
    }()
        var changeStudentIV: UIImageView                = {
            var imageView = UIImageView(image: UIImage(named: "refresh"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.white
            return imageView
        }()
        let searchBar                                   = LightSearchBar()
        var searchIV: UIImageView                       = {
            var imageView = UIImageView(image: UIImage(named: "search"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.white
            return imageView
        }()
        var cancelIV: UIImageView                       = {
            var imageView = UIImageView(image: UIImage(named: "cancel"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.white
            return imageView
        }()
    var circle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.catchyPink

        return view
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
    

    var delegate: PaymentViewDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.pacyficBlue
        
        
        
        self.addSubview(header)
        header.clipsToBounds = true
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(50)
        }
        
        header.addSubview(changeStudentIV)
        let CSIVGRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChangeStudentButton(sender:)))
        changeStudentIV.isUserInteractionEnabled = true
        changeStudentIV.addGestureRecognizer(CSIVGRecognizer)
        changeStudentIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(5)
        }
        
        header.addSubview(searchIV)
        let SIVGRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSearchButton(sender:)))
        searchIV.isUserInteractionEnabled = true
        searchIV.addGestureRecognizer(SIVGRecognizer)
        searchIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(-5)
        }
        
        self.addSubview(circle)
        circle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-134)
            make.left.equalToSuperview().offset(136)
            make.height.width.equalTo(250)
        }
        circle.layer.cornerRadius = 250/2

        
        
        
        
        
        
        
        
        
        
        
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        //tableView.setContentOffset(CGPoint(x: 0, y: 20), animated: false)
        
        tableView.rowHeight                             = 90
        tableView.showsVerticalScrollIndicator          = false
        tableView.allowsSelection                       = false
        tableView.allowsMultipleSelection               = false
        tableView.allowsSelectionDuringEditing          = false
        tableView.allowsMultipleSelectionDuringEditing  = false
        
        tableView.backgroundColor                       = UIColor.backgroundGrey
        tableView.separatorStyle                        = .none
        tableView.refreshControl                        = self.refreshControl
        refreshControl.addAction(for: .valueChanged, { self.delegate?.didRequestDataRefresh() })
        
        tableView.register(PaymentCellView.self, forCellReuseIdentifier: "PaymentCellView")
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom).offset(185)
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
        
        searchIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(header.snp.right)
        }

        UIView.animate(withDuration: 0.25, animations: {
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
            self.searchIV.snp.remakeConstraints { (make) in
                make.top.equalTo(self.safeAreaLayoutGuide)
                make.right.equalToSuperview().offset(-5)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            })
        })
    }
    
    func reloadData() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    
    
}
