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
    
    let titleLabel: UILabel                     = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 36)
        label.textColor = UIColor.white
        return label
    }()
    
    let card: UIView                            = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.zPosition = 5
        return view
    }()
    let cardWrapper: UIView                     = UIView()
    var cardWrapperTopOffset: Constraint?       = nil
    let descriptionLabel: UILabel               = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Regular", size: 22)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textColor = UIColor.pacyficBlue
        return label
    }()
    let cardBottomMask: UIView                  = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        view.layer.zPosition = 4
        return view
    }()

    let circle: UIView                          = {
        let view = UIView()
        view.tag = 41
        view.backgroundColor = UIColor.catchyPink
        return view
    }()
    var startingPoint: CGPoint                  = CGPoint()
    
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
    lazy var walletIV: UIImageView              = {
        let imageView = UIImageView(image: UIImage(named: "wallet-outline"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    lazy var bellIV: UIImageView                = {
        let imageView = UIImageView(image: UIImage(named: "bell-outline"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    lazy var imagesIV: UIImageView              = {
        let imageView = UIImageView(image: UIImage(named: "images-outline"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    lazy var listIV: UIImageView                = {
        let imageView = UIImageView(image: UIImage(named: "list-outline"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    
    var delegate: DetailsViewDelegate?
    
    init(showing details: [Detail], ofPaymentNamed paymentTitle: String, withDescription paymentDescription: String, inState state: Payment.PaymentState) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.pacyficBlue
        
        
        
        self.addSubview(circle)
        circle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-51)
            make.left.equalToSuperview().offset(208)
            make.width.height.equalTo(400)
        }
        circle.layer.cornerRadius = 400 / 2
        
        self.addSubview(cardWrapper)
        cardWrapper.snp.makeConstraints { (make) in
            cardWrapperTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(70).constraint
            make.left.bottom.right.equalToSuperview()
        }
        
        cardWrapper.addSubview(cardBottomMask)
        cardBottomMask.snp.makeConstraints { (make) in
            make.centerX.equalTo(cardWrapper)
            make.centerY.equalTo(cardWrapper.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(cardBottomMask.snp.width)
        }
        
        card.addSubview(descriptionLabel)
        descriptionLabel.text = paymentDescription
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview()
        }
        
        
        card.frame = CGRect(x: 0, y: self.safeAreaInsets.top + 127, width: 375, height: 500)
        cardWrapper.addSubview(card)
        let cardPGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        card.addGestureRecognizer(cardPGR)
        card.isUserInteractionEnabled = true


        card.layer.addShadow(Xoffset: 0, Yoffset: -4, blurRadius: 2)
        card.setAnchorPoint(CGPoint(x: 0.5, y: 1))
        

        
        
        for detail in details {
                    let detailLabel = DetailWithDescription(title: detail.title,
                                                                value: detail.value)
                    let mostBottomItem = card.subviews.last
                    card.addSubview(detailLabel)
                    detailLabel.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(15)
                        make.right.equalToSuperview()
                        if let bottomOfLastItem = mostBottomItem?.snp.bottom {
                            make.top.equalTo(bottomOfLastItem).offset(5)
                        } else { make.top.equalTo(card).offset(10) }
                    }
        }
        
        self.addSubview(titleLabel)
        titleLabel.text = paymentTitle
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(card.snp.top)
            make.left.equalToSuperview().offset(15)
        }
        
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
        
        switch state {
        case .awaiting:
            fatalError()
        case .pending:
            menuCard.addArrangedSubview(walletIV)
            let walletTGR = UITapGestureRecognizer(target: self, action: #selector(didTapWallet))
            walletIV.addGestureRecognizer(walletTGR)
            menuCard.addArrangedSubview(bellIV)
            let bellTGR = UITapGestureRecognizer(target: self, action: #selector(didTapBell))
            bellIV.addGestureRecognizer(bellTGR)
        case .paid:
            menuCard.addArrangedSubview(imagesIV)
            let imagesTGR = UITapGestureRecognizer(target: self, action: #selector(didTapImages))
            imagesIV.addGestureRecognizer(imagesTGR)
            menuCard.addArrangedSubview(listIV)
            let listTGR = UITapGestureRecognizer(target: self, action: #selector(didTapList))
            listIV.addGestureRecognizer(listTGR)
        }
        


        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    @objc func didTapWallet() {
        delegate?.didTapWallet()
    }
    
    @objc func didTapBell() {
        delegate?.didTapBell()
    }
    
    @objc func didTapImages() {
        
    }
    
    @objc func didTapList() {
        
    }
    
    override func layoutSubviews() {
//        print("Called layoutSubviews in detailsView")
//        print("cardWrapper bounds: \(cardWrapper.bounds)")
//        print("initial card frame: \(card.frame)")
        card.frame = cardWrapper.bounds
//        print("card frame after: \(card.frame)")
        super.layoutSubviews()
        
        cardBottomMask.layer.cornerRadius = cardBottomMask.bounds.width / 2
        
    }
    

}

extension DetailsView {
    //returns point in Cartesian coordinate system with origin
    //at the center bottom of card
    func normalized(_ point: CGPoint) -> CGPoint {
        let origin = CGPoint(x: card.frame.width/2.0, y: card.frame.height)
        return CGPoint(x: point.x - origin.x, y: origin.y - point.y)
    }
    
    //returns angle in radians between two lines, which have common point in origin
    func calculateAngleBetweenLinesComingThrough(firstPoint p1: CGPoint, secondPoint p2: CGPoint) -> CGFloat {
        return atan((p2.x/p2.y) - (p1.x/p1.y))
    }
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {

        case .began:
            startingPoint = normalized(gestureRecognizer.translation(in: card))
        case .changed:
            let currentPoint = normalized(gestureRecognizer.translation(in: card))
            
            let angle = calculateAngleBetweenLinesComingThrough(firstPoint: startingPoint, secondPoint: currentPoint)
            
            card.transform = CGAffineTransform(rotationAngle: angle)
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
                self.card.transform = CGAffineTransform(rotationAngle: 0)
            })
        case .cancelled:
            print("canceled")
        case .failed, .possible:
            print("failed/possible")
        }
    }
}

extension DetailsView: Slidable {
    
    func slideIn(completion: @escaping () -> ()) {
        cardWrapperTopOffset?.uninstall()
        cardWrapper.snp.makeConstraints { (make) in
            cardWrapperTopOffset = make.top.equalTo(self.snp.bottom).constraint
        }
        self.layoutIfNeeded()

        cardWrapperTopOffset?.uninstall()
        cardWrapper.snp.makeConstraints { (make) in
            cardWrapperTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(70).constraint
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
            self.card.frame = self.cardWrapper.bounds
        }, completion: { _ in
            self.setNeedsLayout()
            self.layoutIfNeeded()
            completion()
            
        })
        
    }
    
    func slideOut(completion: @escaping () -> ()) {
        cardWrapperTopOffset?.uninstall()
        card.snp.makeConstraints { (make) in
            cardWrapperTopOffset = make.top.equalTo(self.snp.bottom).constraint
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
            self.card.frame = self.cardWrapper.bounds
        }, completion: { _ in completion()})
    }
    
    
    
}
