//
//  PaymentCellView.swift
//  tableviewtest
//
//  Created by Jakub Towarek on 22/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit



enum PaymentCellStyle {
    case paid
    case pending
}

struct PaymentCellRatchetValue {
    let stickyValue: Float
    let triggerValue: Float
}

class PaymentCellView: UITableViewCell {
    
    private let foreground: UIView          = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.zPosition = 5
        return view
    }()
    private let titleLabel: UILabel         = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.pacyficBlue
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Light", size: 24.0)
        return label
    }()
    private let amountLabel: AmountLabel    = {
        let label = AmountLabel()
        return label
    }()
    private let currrencyLabel: UILabel     = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 12.0)
        label.textColor = UIColor.lightGray
        return label
    }()
    private var previousPosition: CGPoint   = CGPoint()
    
    private var ratchetValues = [PaymentCellRatchetValue]()
    private var offsetConstraint: Constraint?
    private var offset: Float = 0 {
        didSet {
            offsetConstraint?.updateOffset(amount: offset)
            foreground.layer.cornerRadius   = CGFloat(min(abs(offset), 10))
            if offset <= 0 {
                foreground.layer.maskedCorners  = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            } else {
                foreground.layer.maskedCorners  = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
        }
    }
    
    private lazy var bellIV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bell")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var walletIV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wallet")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public  let amountFormatter             = NumberFormatter()


    var style: PaymentCellStyle?             = nil {
        didSet {
            didChangeState()
        }
    }
    var delegate: PaymentCellDelegate?
    
    

    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        
        //Background
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.pacyficBlue

        //Foreground
        contentView.addSubview(foreground)
        let panGestureRecognizer        = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        panGestureRecognizer.delegate   = self
        foreground.addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer        = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        foreground.addGestureRecognizer(tapGestureRecognizer)
        foreground.snp.makeConstraints { (make) in
            make.width.top.bottom.equalToSuperview()
            offsetConstraint = make.left.equalToSuperview().constraint
        }
        
        //Amount
        foreground.addSubview(amountLabel)
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
        }
        
        //Title
        foreground.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(amountLabel.snp.left).offset(-10)
        }
        
        //Currency code
        foreground.addSubview(currrencyLabel)
        currrencyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
    }
    
    func setupContent(title: String, description: String, amount: Float, currency: String, startDate: Date) {
        
        //Title
        self.titleLabel.text = title.capitalizingFirstLetter()
        
        //Amount
        self.amountLabel.amount = amount
        
        //Currency
        self.currrencyLabel.text = currency
        
    }
    
    func didChangeState() {
        switch style {

        case .pending?:
            titleLabel.textColor    = UIColor.black
            amountLabel.textColor   = UIColor.pacyficBlue
            
            contentView.addSubview(bellIV)
            let bellTGR = UITapGestureRecognizer(target: self, action: #selector(didTapBell))
            bellIV.addGestureRecognizer(bellTGR)
            bellIV.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview().offset(14)
            }
            ratchetValues.append(PaymentCellRatchetValue(stickyValue: 80, triggerValue: 150))
            
            contentView.addSubview(walletIV)
            let walletTGR = UITapGestureRecognizer(target: self, action: #selector(didTapWallet))
            walletIV.addGestureRecognizer(walletTGR)
            walletIV.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(26)
                make.right.equalToSuperview().offset(-24)
            }
            ratchetValues.append(PaymentCellRatchetValue(stickyValue: -80, triggerValue: -150))
            
        case .paid?:
            titleLabel.textColor    = UIColor.darkGrey
            amountLabel.textColor   = UIColor.darkGrey
            
        case .none:
            fatalError("Cell have to have certain style")
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    

}

//MARK: Gesture recognizers handlers
extension PaymentCellView {
    
    @objc func tapHandler() {
        self.delegate?.didTapCell(sender: self)
    }
    
    @objc func panHandler(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: foreground).x - previousPosition.x
        
        
        offset += Float(translation)
        print("Previous position: \(previousPosition)\t Current position: \(panGestureRecognizer.translation(in: foreground))\t Current offset: \(offset)\t")
        
        if panGestureRecognizer.state == .ended {
            ratchetValues.forEach { (v) in
                if v.stickyValue < 0 && v.triggerValue < 0 {
                    if offset > v.stickyValue && offset < 0 {
                        offset = 0
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
                            self.layoutIfNeeded()
                        })
                    }
                    if offset <= v.stickyValue && offset > v.triggerValue && offset < 0 {
                        offset = v.stickyValue
                        selectionFeedbackGenerator.selectionChanged()
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
                            self.layoutIfNeeded()
                        })
                    }
                    if offset < v.triggerValue && offset < 0 {
                        //do action
                        notificationFeedbackGenerator.notificationOccurred(.success)
                    }
                } else {
                    if offset < v.stickyValue && offset > 0 {
                        offset = 0
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
                            self.layoutIfNeeded()
                        })
                    }
                    if offset >= v.stickyValue && offset < v.triggerValue && offset > 0 {
                        offset = v.stickyValue
                        selectionFeedbackGenerator.selectionChanged()
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
                            self.layoutIfNeeded()
                        })
                    }
                    if offset > v.triggerValue && offset > 0 {
                        //do action
                        notificationFeedbackGenerator.notificationOccurred(.success)
                    }
                }

                
            }
            previousPosition = CGPoint()
            return
        }
        
        previousPosition = panGestureRecognizer.translation(in: foreground)
    }
    
}

//MARK: Underneath icons taps handlers
extension PaymentCellView {
    
    @objc func didTapWallet() {
        print("Wallet tapped!")
    }
    
    @objc func didTapBell() {
        print("Bell tapped!")
    }
    
}

extension PaymentCellView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}

////Animations
//extension PaymentCellView {
//    func animateButtonTap(_ view: UIView, completion: @escaping () -> ()) {
//
//        view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
//        selectionFeedbackGenerator.selectionChanged()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
//            completion()
//        }
//
//        UIView.animate(withDuration: 0.25,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.20),
//                       initialSpringVelocity: CGFloat(6.0),
//                       options:.allowUserInteraction,
//                       animations: {
//                        view.transform = CGAffineTransform.identity
//        })
//
//    }
//
//
//
//}
