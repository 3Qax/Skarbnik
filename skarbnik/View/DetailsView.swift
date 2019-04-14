//
//  DetailsView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class DetailsView: UIView {
    
    let backIV: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 36)
        label.textColor = UIColor.white
        return label
    }()
    let card: UIView            = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = UIColor.backgroundGrey
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
        
        self.addSubview(card)
        card.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide).offset(127)
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
        
        self.addSubview(title)
        title.text = paymentTitle
        title.snp.makeConstraints { (make) in
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
