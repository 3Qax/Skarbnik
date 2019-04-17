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
    let cardWrapper: UIView         = UIView()
    var cardWrapperTopOffset: Constraint?  = nil
    let circle: UIView              = {
        let view = UIView()
        view.backgroundColor = UIColor.catchyPink
        return view
    }()
    var startingPoint: CGPoint      = CGPoint()
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
        
        self.addSubview(cardWrapper)
        cardWrapper.snp.makeConstraints { (make) in
            cardWrapperTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(127).constraint
            make.left.bottom.right.equalToSuperview()
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


        card.layer.addShadow(Xoffset: -4, Yoffset: 0, blurRadius: 2)
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBack() {
        delegate?.didTapBack()
    }
    
    override func layoutSubviews() {
//        print("Called layoutSubviews in detailsView")
//        print("cardWrapper bounds: \(cardWrapper.bounds)")
//        print("initial card frame: \(card.frame)")
        card.frame = cardWrapper.bounds
//        print("card frame after: \(card.frame)")
        super.layoutSubviews()
        
    }
    

}

extension DetailsView {
    //returns point in Cartesian coordinate system with origin
    //at the center bottom of card
    func normalized(_ point: CGPoint) -> CGPoint {
        let origin = CGPoint(x: card.frame.width/2.0, y: card.frame.height)
        return CGPoint(x: point.x - origin.x, y: origin.y - point.y)
    }
    
    //returns angle between two lines, which have common point in origin
    func calculateAngleBetweenLinesComingThrough(firstPoint p1: CGPoint, secondPoint p2: CGPoint) -> CGFloat {
        return atan((p1.x/p1.y)-(p2.x/p2.y))
    }
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {

        case .began:
            startingPoint = normalized(gestureRecognizer.translation(in: card))
        case .changed:
            let currentPoint = normalized(gestureRecognizer.translation(in: card))
            print(calculateAngleBetweenLinesComingThrough(firstPoint: startingPoint, secondPoint: currentPoint) * 180 / CGFloat.pi)
            card.transform = CGAffineTransform.init(rotationAngle: calculateAngleBetweenLinesComingThrough(firstPoint: startingPoint, secondPoint: currentPoint) * -1.0)
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
            cardWrapperTopOffset = make.top.equalTo(safeAreaLayoutGuide).offset(127).constraint
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
