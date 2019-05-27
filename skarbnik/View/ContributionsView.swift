//
//  ContributionsView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 25/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit



class ContributionsView: UIView {
    
    let menuCard: UIStackView                   = {
        let stackView = UIStackView()
        stackView.distribution = UIStackView.Distribution.equalCentering
        
        let background = UIView()
        background.backgroundColor = UIColor(rgb: 0xFBFBFB)
        background.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        background.layer.cornerRadius = 15.0
        
        stackView.addSubview(background)
        background.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        background.layer.addShadow(Xoffset: 0, Yoffset: -4, opacity: 0.25, blurRadius: 2)
        
        return stackView
    }()
    let backIV: UIImageView                     = {
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let amountFormatter                         = NumberFormatter()
    let shortDateFormatter: DateFormatter       = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var delegate: ContributionViewDelegate?
    
    init(paymentCurrencyCode currencyCode: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = .backgroundGrey
        
        self.addSubview(menuCard)
        menuCard.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        menuCard.isLayoutMarginsRelativeArrangement = true
        menuCard.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        menuCard.addArrangedSubview(backIV)
        let backTGR = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backIV.addGestureRecognizer(backTGR)
        
        amountFormatter.locale = Locale.availableIdentifiers
                                    .lazy
                                    .map({Locale(identifier: $0)})
                                    .first(where: { $0.currencyCode == currencyCode })
        amountFormatter.numberStyle = .currency
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    func insertCreation(date: Date) {
        let imageIV: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "lightbulb"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.catchyPink
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        
        let labels = DetailWithDescription(title: "utworzono",
                                           value: shortDateFormatter.string(from: date))
        
        self.addSubview(labels)
        labels.tag = 123
        labels.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.safeAreaLayoutGuide.snp.top).offset(72)
            make.left.equalToSuperview().offset(79)
            make.right.equalToSuperview()
        }
        
        self.addSubview(imageIV)
        imageIV.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.left).offset(41)
            make.centerY.equalTo(labels)
            make.width.equalTo(22)
            make.height.equalTo(32)
        }
        
        insertSpacer()
        
    }
    
    func insertContribution(amount: Float, date: Date, isFinal: Bool = false) {
        let imageIV: UIImageView = {
            let imageView = UIImageView(image: isFinal ? UIImage(named: "tick-deformed") : UIImage(named: "bill"))
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.catchyPink
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        let labels = DetailWithDescription(title: shortDateFormatter.string(from: date),
                                           value: amountFormatter.string(from: amount as NSNumber)!)
        
        let lastSpacer: UIView! = self.subviews.lazy.last(where: { $0.tag == 41 })
        
        self.addSubview(labels)
        labels.tag = 123
        labels.snp.makeConstraints { (make) in
            make.top.equalTo(lastSpacer.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(79)
            make.right.equalToSuperview()
        }
        
        self.addSubview(imageIV)
        imageIV.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.left).offset(41)
            make.centerY.equalTo(labels)
            let _ = isFinal ? make.width.equalTo(32) : make.width.equalTo(40)
            make.height.equalTo(32)
        }
        
        if !isFinal { insertSpacer() }
        
    }
    
    private func insertSpacer() {
        let spacer = UIView()
        spacer.backgroundColor = .darkGray
        spacer.tag = 41
        spacer.layer.roundCorners(radius: 2)
        
        let lastLabel: UIView! = self.subviews.lazy.last(where: { $0.tag == 123 })
        
        self.addSubview(spacer)
        spacer.snp.makeConstraints { (make) in
            make.width.equalTo(4)
            make.height.equalTo(25)
            make.centerX.equalTo(self.snp.left).offset(41)
            make.top.equalTo(lastLabel.snp.bottom).offset(5)
        }
        
    }
    
}
