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
            var imageView = UIImageView(image: UIImage(named: "users"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.white
            return imageView
        }()
        let searchBar                                   = SearchField(frame: .zero)
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
    var circle: UIView                                  = {
        let view = UIView()
        view.tag = 41
        view.backgroundColor = UIColor.catchyPink
        return view
    }()
    
    var firstNameLabel: UILabel                         = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 16)
        label.textColor = UIColor.white
        return label
    }()
    var lastNameLabel: UILabel                          = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    var statsView: UIView                               = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        let divider = UIView()
        divider.backgroundColor = UIColor.lightViolet
        view.addSubview(divider)
        divider.snp.makeConstraints({ (make) in
            make.width.equalTo(1)
            make.top.bottom.centerX.equalToSuperview()
        })
        return view
    }()
        var statsLeftNumber: UILabel                    = {
            let label = UILabel()
            label.font = UIFont(name: "OpenSans-Light", size: 48)
            label.textAlignment = .center
            label.textColor = UIColor.pacyficBlue
            return label
        }()
        var statsLeftDescription: UILabel               = {
            let label = UILabel()
            label.font = UIFont(name: "OpenSans-Light", size: 16)
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.baselineAdjustment = UIBaselineAdjustment.alignBaselines
            label.text = "oczekujące"
            return label
        }()
        var statsRightNumber: UILabel                   = {
            let label = UILabel()
            label.font = UIFont(name: "OpenSans-Light", size: 48)
            label.textAlignment = .center
            label.textColor = UIColor.darkGrey
            return label
        }()
        var statsRightDescription: UILabel              = {
            let label = UILabel()
            label.font = UIFont(name: "OpenSans-Light", size: 16)
            label.textAlignment = .center
            label.baselineAdjustment = UIBaselineAdjustment.alignBaselines
            label.textColor = UIColor.black
            label.text = "zapłacone"
            return label
        }()
    
    var tableView                                       = UITableView()
        var tableViewTopOffset: Constraint?
        let refreshControl: UIRefreshControl            = {
        var refresh = UIRefreshControl()
        
        refresh.tintColor = UIColor.pacyficBlue
        refresh.attributedTitle = NSAttributedString(string: NSLocalizedString("waiting_while_refreshing_data_text",
                                                                                comment:""),
                                                     attributes: [.foregroundColor: UIColor.pacyficBlue] )
        
        return refresh
    }()
    

    var delegate: PaymentViewDelegate?
    
    
    
    init(firstName: String, lastName: String, frame: CGRect = .zero) {
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
        
        self.addSubview(firstNameLabel)
        firstNameLabel.text = firstName
        firstNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(96)
        }
        
        self.addSubview(lastNameLabel)
        lastNameLabel.text = lastName
        lastNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(29)
            make.top.equalTo(firstNameLabel.snp.bottom)
        }
        
        
        searchBar.addTarget(self, action: #selector(didChangeSearchTerm(sender:)), for: .editingChanged)



        
        
        
        
        
        
        
        
        
        
        
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
            tableViewTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(205).constraint
        }
        
        self.addSubview(statsView)
        statsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(80)
            make.bottom.equalTo(tableView.snp.top).offset(30)
        }
        statsView.layer.addShadow()
        statsView.layer.roundCorners(radius: 10)
        
        statsView.addSubview(statsLeftNumber)
        statsLeftNumber.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.equalTo(statsView.snp.centerX)
            make.height.equalTo(59)
        }
        
        statsView.addSubview(statsRightNumber)
        statsRightNumber.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalTo(statsView.snp.centerX)
            make.height.equalTo(59)
        }
        
        statsView.addSubview(statsLeftDescription)
        statsLeftDescription.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview()
            make.right.equalTo(statsView.snp.centerX)
            make.height.equalTo(26)
        }
        
        statsView.addSubview(statsRightDescription)
        statsRightDescription.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(statsView.snp.centerX)
            make.height.equalTo(26)
        }
        
        self.bringSubviewToFront(header)
        self.bringSubviewToFront(statsView)
      
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
    
    @objc func didChangeSearchTerm(sender: UITextField) {
        delegate?.searchTermDidChanged(term: sender.text ?? "")
    }
    
    @objc func didTapCancelButton() {
        searchBar.resignFirstResponder()
        delegate?.shouldCancelSearch(in: searchBar)

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
    
    func updateStats(pending: Int, paid: Int) {
        self.statsLeftNumber.text = String(pending)
        self.statsRightNumber.text = String(paid)
    }
    

    
}

extension PaymentView: Slidable {
    func slideIn(completion: @escaping () -> ()) {
        
        
        changeStudentIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(5)
        }
        
        searchIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(-5)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            self.firstNameLabel.alpha = 1.0
            self.lastNameLabel.alpha = 1.0
        })
        
        tableViewTopOffset?.uninstall()
        tableView.snp.makeConstraints { (make) in
            tableViewTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(205).constraint
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in completion()})
    }
    
    func slideOut(completion: @escaping () -> ()) {
        tableViewTopOffset?.uninstall()
        tableView.snp.makeConstraints { (make) in
            tableViewTopOffset = make.top.equalTo(self.snp.bottom).constraint
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in completion()})
        
        changeStudentIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.right.equalTo(header.snp.left)
        }
        searchIV.snp.remakeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalTo(header.snp.right)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            self.firstNameLabel.alpha = 0.0
            self.lastNameLabel.alpha = 0.0
        })
    }
    
    
}
