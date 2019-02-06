//
//  PaymentListView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit

class PaymentView: UIView {
    var delegate: PaymentViewProtocol?
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
    let blurView: UIVisualEffectView              = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.zPosition = 100
        
        return blurView
    }()
    let refreshControl: UIRefreshControl            = {
        var refresh = UIRefreshControl()
        
        refresh.tintColor = UIColor.clear
        refresh.backgroundColor = UIColor(rgb: 0xFA3CB1)
        refresh.addTarget(self, action: #selector(didTrigerResfreshControl), for: .valueChanged)
        
        let reloadLabel = UILabel()
        reloadLabel.text = NSLocalizedString("waiting_while_refreshing_data_text", comment: "waiting_while_refreshing_data_text")
        reloadLabel.font = UIFont(name: "PingFangTC-Light", size: 24.0)
        reloadLabel.textColor = UIColor.white
        
        refresh.addSubview(reloadLabel)
        reloadLabel.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalToSuperview()
        })
        
        return refresh
    }()
    
    
    
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
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        tableView.refreshControl = refreshControl
        

//        blurView.frame = tableView.bounds
//        tableView.addSubview(blurView)
        tableView.isUserInteractionEnabled = true


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
    
    @objc func didTrigerResfreshControl() {
        
        UIView.animate(withDuration: 0.5) {
            self.blurView.alpha = 1.0
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.refreshControl.backgroundColor = UIColor(rgb: 0x00A1E6)
        })
        
        delegate?.didRequestDataRefresh(completion: {
            UIView.animate(withDuration: 0.5) {
                self.blurView.alpha = 0.0
                self.refreshControl.backgroundColor = UIColor(rgb: 0xFA3CB1)
            }
            self.refreshControl.endRefreshing()
        })
        
    }
    
    func viewFor(child: Child) {
        let tmpName = NSMutableAttributedString()
        tmpName.append(NSAttributedString(string: child.name, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 26.0)!]))
        headerNameLabel.attributedText = tmpName
    }
}
