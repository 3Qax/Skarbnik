//
//  DetailsView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit



class DetailsView: UIView {
    
    let backIV: UIImageView         = {
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let titleLabel: UILabel         = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 36)
        label.textColor = UIColor.white
        return label
    }()
    let descriptionLabel: UILabel   = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 22)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textColor = UIColor.pacyficBlue
        return label
    }()
    let card: UIView                = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.zPosition = 5
        return view
    }()
    var cardTopOffset: Constraint?
    let circle: UIView              = {
        let view = UIView()
        view.backgroundColor = UIColor.catchyPink
        return view
    }()
    var delegate: DetailsViewDelegate?
    
    init(showing details: [Detail], ofPaymentNamed paymentTitle: String, withDescription paymentDescription: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.pacyficBlue
        
        self.addSubview(backIV)
        let backTGR = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backIV.addGestureRecognizer(backTGR)
        backIV.snp.makeConstraints { (make) in
            make.top.left.equalTo(safeAreaLayoutGuide)
            make.height.width.equalTo(50)
        }
        
        self.addSubview(circle)
        circle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-51)
            make.left.equalToSuperview().offset(208)
            make.width.height.equalTo(400)
        }
        circle.layer.cornerRadius = 400 / 2
        
        card.addSubview(descriptionLabel)
        descriptionLabel.text = paymentDescription
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
        }
        
        self.addSubview(card)
        card.snp.makeConstraints { (make) in
            cardTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(127).constraint
            make.left.bottom.right.equalToSuperview()
        }
        
        for detail in details {
                    let detailLabel = DetailWithDescription(title: detail.title,
                                                                value: detail.value)
                    let mostBottomItem = card.subviews.last
                    card.addSubview(detailLabel)
                    detailLabel.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(15)
                        make.right.equalToSuperview()
                        if let bottomOfLastItem = mostBottomItem?.snp.bottom {
                            make.top.equalTo(bottomOfLastItem).offset(10)
                        } else { make.top.equalTo(card).offset(10) }
                    }
        }
        
        self.addSubview(titleLabel)
        titleLabel.text = paymentTitle
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(card.snp.top)
            make.left.equalToSuperview().offset(15)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    

}

extension DetailsView: Slidable {
    
    func slideIn(completion: @escaping () -> ()) {
        cardTopOffset?.uninstall()
        card.snp.makeConstraints { (make) in
            cardTopOffset = make.top.equalTo(self.snp.bottom).constraint
        }
        self.layoutIfNeeded()
        
        cardTopOffset?.uninstall()
        card.snp.makeConstraints { (make) in
            cardTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(127).constraint
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in completion()})
    }
    
    func slideOut(completion: @escaping () -> ()) {
        cardTopOffset?.uninstall()
        card.snp.makeConstraints { (make) in
            cardTopOffset = make.top.equalTo(self.snp.bottom).constraint
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in completion()})
    }
    
    
    
}
