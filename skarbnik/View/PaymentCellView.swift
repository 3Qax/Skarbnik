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

struct PaymentCellRatchet {
    
    let stickyValue: Float
    let triggerValue: Float
    let image: UIImage
    let action: () -> ()
    
}

class PaymentCellView: UITableViewCell {
    
    //UI components
    private         let foreground: UIView                      = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.zPosition = 5
        return view
    }()
    private         let titleLabel: UILabel                     = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.pacyficBlue
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Light", size: 24.0)
        return label
    }()
    private         let amountLabel: AmountLabel                = {
        let label = AmountLabel()
        return label
    }()
    private         let currrencyLabel: UILabel                 = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 12.0)
        label.textColor = UIColor.lightGray
        return label
    }()
    private         var previousPosition: CGPoint               = CGPoint()
    
    //Handling ratchet mechanisms
    private         var leftRatchet: PaymentCellRatchet?        = nil {
        didSet {
            if let ratchet = leftRatchet {
                let imageView = UIImageView()
                imageView.image = ratchet.image
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                
                contentView.addSubview(imageView)
                let imageViewTGR = UITapGestureRecognizer(target: self, action: #selector(didTapLeftRatchetImage))
                imageView.addGestureRecognizer(imageViewTGR)
                imageView.snp.makeConstraints { (make) in
                    make.top.left.equalToSuperview().offset(14)
                }
            }
        }
    }
    private lazy    var didVibrateLeft: Bool                    = false
    private         var rightRatchet: PaymentCellRatchet?       = nil {
        didSet {
            if let ratchet = rightRatchet {
                let imageView = UIImageView()
                imageView.image = ratchet.image
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true
                
                contentView.addSubview(imageView)
                let imageViewTGR = UITapGestureRecognizer(target: self, action: #selector(didTapRightRatchetImage))
                imageView.addGestureRecognizer(imageViewTGR)
                imageView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().offset(26)
                    make.right.equalToSuperview().offset(-24)
                }
            }
        }
    }
    private lazy    var didVibrateRight: Bool                   = false
    private lazy    var animateForegroundMove: () -> ()         = {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            self.layoutIfNeeded()
        })
    }
    
    //Handling cell swiping
    private         var offset: Float                           = 0 {
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
    private         var offsetConstraint: Constraint?
    
    public  let amountFormatter                         = NumberFormatter()

    var style: PaymentCellStyle?                        = nil {
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
        
        //Currency code
        self.currrencyLabel.text = currency
        
    }
    
    func didChangeState() {
        switch style {

        case .pending?:
            titleLabel.textColor    = UIColor.black
            amountLabel.textColor   = UIColor.pacyficBlue
            
            
            leftRatchet = PaymentCellRatchet(stickyValue: 80,
                                             triggerValue: 150,
                                             image: UIImage(named: "bell")!,
                                             action: { self.didTapLeftRatchetImage() })

            rightRatchet = PaymentCellRatchet(stickyValue: -80,
                                              triggerValue: -150,
                                              image: UIImage(named: "wallet")!,
                                              action: { self.didTapRightRatchetImage() })
            
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
        
        if panGestureRecognizer.state == .began { previousPosition = CGPoint() }
        
  
        
//        print("Previous position: \(previousPosition)\t Current position: \(panGestureRecognizer.translation(in: foreground))\t Current offset: \(offset)\t State: \(panGestureRecognizer.state.rawValue)")
        
        if panGestureRecognizer.state == .changed {
            
            //Calculate translation and move the foreground accordingly
            let translation = panGestureRecognizer.translation(in: foreground).x - previousPosition.x
            offset += Float(translation)
            
            if let left = leftRatchet {
                
                //if users moves foreground near sticky range vibrate slightly
                if abs(offset-left.stickyValue) < 5 && offset > 0 && !didVibrateLeft {
                    selectionFeedbackGenerator.selectionChanged()
                    didVibrateLeft = true
                //make sure to vibrate again only if user leaves 10 points zone
                } else if (abs(offset-left.stickyValue) >= 5 && offset > 0) { didVibrateLeft = false }
                
                //trigger action if triggerValue was exceeded
                if offset > left.triggerValue && offset > 0 {
                    left.action()
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    panGestureRecognizer.cancel()
                    offset = 0
                }
            }
            
            if let right = rightRatchet {
                
                //if users moves foreground near sticky range vibrate slightly
                if abs(offset-right.stickyValue) < 5 && offset < 0 && !didVibrateRight {
                    selectionFeedbackGenerator.selectionChanged()
                    didVibrateRight = true
                //make sure to vibrate again only if user leaves 10 points zone
                } else if (abs(offset-right.stickyValue) >= 5 && offset < 0) { didVibrateRight = false }
                
                //trigger action if triggerValue was exceeded
                if offset < right.triggerValue && offset < 0 {
                    right.action()
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    panGestureRecognizer.cancel()
                    offset = 0
                }
            }
            
            //set previous position to current position so that
            //next function call have integral data
            previousPosition = panGestureRecognizer.translation(in: foreground)
            return
        }
        
        if panGestureRecognizer.state == .ended {
            
            if leftRatchet != nil && offset > 0 {
                
                //if foreground doesn't reach stickyValue - 5 move it back to default positon
                if offset < leftRatchet!.stickyValue - 5 {
                    offset = 0
                    animateForegroundMove()
                }
                
                //if it exceeds stickyValue - 5, but doesn't reach triggerValue move it to
                //sticky postion (where IV is visible)
                if offset >= leftRatchet!.stickyValue - 5 && offset < leftRatchet!.triggerValue {
                    offset = leftRatchet!.stickyValue
                    selectionFeedbackGenerator.selectionChanged()
                    animateForegroundMove()
                }
            }
            
            if rightRatchet != nil && offset < 0 {
                
                //if foreground doesn't reach stickyValue - 5 move it back to default positon
                if offset > rightRatchet!.stickyValue + 5 {
                    offset = 0
                    animateForegroundMove()
                }
                
                //if it exceeds stickyValue - 5, but doesn't reach triggerValue move it to
                //sticky postion (where IV is visible)
                if offset <= rightRatchet!.stickyValue + 5 && offset > rightRatchet!.triggerValue{
                    offset = rightRatchet!.stickyValue
                    selectionFeedbackGenerator.selectionChanged()
                    animateForegroundMove()
                }
            }
        }
        
    }
    
    
    
}

//MARK: Underneath icons taps handlers
extension PaymentCellView {
    
    @objc func didTapRightRatchetImage() {
        delegate?.didTapPay(sender: self)
        offset = 0
        previousPosition = CGPoint()
    }
    
    @objc func didTapLeftRatchetImage() {
        delegate?.didTapRemind(sender: self)
        offset = 0
        previousPosition = CGPoint()
    }
    
}

extension PaymentCellView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview)
            if abs(translation.x) > abs(translation.y) {
                if translation.x > 0 && rightRatchet != nil { return true }
                if translation.x < 0 && leftRatchet != nil { return true }
            }
            return false
        }
        return false
    }

}
