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

class PaymentCellView: UITableViewCell {
    
    //Static constant variables for sliding with ratchet mechanisms
    private static  let stickyValue: Float                      = 80
    private static  let triggerValue: Float                     = 150
    
    //UI components
    private         let foreground: UIView                      = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    private         let titleLabel: UILabel                     = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.pacyficBlue
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-Light", size: 24.0)
        return label
    }()
    private         let amountLabel: AmountLabel                = {
        let label = AmountLabel()
        return label
    }()
    private         let currrencyCodeLabel: UILabel             = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Light", size: 12.0)
        label.textColor = UIColor.lightGray
        return label
    }()
    private         let backgroundLeftImageView: UIImageView    = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let imageViewTGR = UITapGestureRecognizer(target: self, action: #selector(didTapLeftRatchetImage))
        imageView.addGestureRecognizer(imageViewTGR)
        return imageView
    }()
    private         let backgroundRightImageView: UIImageView   = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let imageViewTGR = UITapGestureRecognizer(target: self, action: #selector(didTapRightRatchetImage))
        imageView.addGestureRecognizer(imageViewTGR)
        return imageView
    }()
    
    //Indicators of being in sticky range
    private lazy    var didVibrateLeft: Bool                    = false
    private lazy    var didVibrateRight: Bool                   = false
    
    //Handling cell swiping
    private         var previousPosition: CGPoint               = CGPoint()
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

    var style: PaymentCellStyle?                                = nil {
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
        foreground.addSubview(currrencyCodeLabel)
        currrencyCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.bringSubviewToFront(foreground)
        
        //Ratchet's images
        contentView.insertSubview(backgroundLeftImageView, belowSubview: foreground)
        backgroundLeftImageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(14)
        }
        contentView.insertSubview(backgroundRightImageView, belowSubview: foreground)
        backgroundRightImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(26)
            make.right.equalToSuperview().offset(-24)
        }
        
    }
    
    func setupContent(title: String, description: String, amount: Float, currency: String, startDate: Date) {
        
        //Title
        self.titleLabel.text = title.capitalizingFirstLetter()
        
        //Amount
        self.amountLabel.amount = amount
        
        //Currency code
        self.currrencyCodeLabel.text = currency
        
    }
    
    func didChangeState() {
        switch style {

        case .pending?:
            titleLabel.textColor    = UIColor.black
            amountLabel.textColor   = UIColor.pacyficBlue
            //Add reminder
            backgroundLeftImageView.image = UIImage(named: "bell")!
            //Pay
            backgroundRightImageView.image = UIImage(named: "wallet")!
            
        case .paid?:
            titleLabel.textColor    = UIColor.darkGrey
            amountLabel.textColor   = UIColor.darkGrey
            //Images
            backgroundLeftImageView.image = UIImage(named: "images")!
            //List of contributions
            backgroundRightImageView.image = UIImage(named: "list")!
            
        case .none:
            fatalError("Cell have to have certain style")
        }
        
    }
    
    override func prepareForReuse() {
        offset = 0
        backgroundLeftImageView.image = nil
        didVibrateLeft = false
        backgroundRightImageView.image = nil
        didVibrateRight = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    private func animateForegroundMove() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .allowUserInteraction, animations: {
            self.layoutIfNeeded()
        })
    }
    

    
}

//MARK: Gesture recognizers handlers
extension PaymentCellView {
    
    @objc func tapHandler() {
        selectionFeedbackGenerator.selectionChanged()
        self.delegate?.didTapCell(sender: self)
    }
    
    @objc func panHandler(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        if panGestureRecognizer.state == .began { previousPosition = CGPoint() }
        
  
        #if DEBUG
        print("""
            Previous position: \(previousPosition)\t
            Current position: \(panGestureRecognizer.translation(in: foreground))\t
            Current offset: \(offset)\t
            State: \(panGestureRecognizer.state.rawValue)
        """)
        #endif
        
        if panGestureRecognizer.state == .changed {
            
            //Calculate translation and move the foreground accordingly
            let translation = panGestureRecognizer.translation(in: foreground).x - previousPosition.x
            offset += Float(translation)
            
            if offset > 0 {
                
                //if users moves foreground near sticky range vibrate slightly
                if abs(offset-PaymentCellView.stickyValue) < 5 && !didVibrateLeft {
                    selectionFeedbackGenerator.selectionChanged()
                    didVibrateLeft = true
                //make sure to vibrate again only if user leaves 10 points zone
                } else if (abs(offset-PaymentCellView.stickyValue) >= 5) { didVibrateLeft = false }
                
                //trigger action if triggerValue was exceeded
                if offset > PaymentCellView.triggerValue {
//                    left.action()
                    print("should trigger left action")
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    panGestureRecognizer.cancel()
                    offset = 0
                }
            }
            
            if offset < 0 {
                
                //if users moves foreground near sticky range vibrate slightly
                if abs(offset+PaymentCellView.stickyValue) < 5 && offset < 0 && !didVibrateRight {
                    selectionFeedbackGenerator.selectionChanged()
                    didVibrateRight = true
                //make sure to vibrate again only if user leaves 10 points zone
                } else if (abs(offset+PaymentCellView.stickyValue) >= 5 && offset < 0) { didVibrateRight = false }
                
                //trigger action if triggerValue was exceeded
                if abs(offset) > PaymentCellView.triggerValue && offset < 0 {
//                    right.action()
                    print("should trigger right action")
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
            
            if offset > 0 {
                
                //if foreground doesn't reach stickyValue - 5 move it back to default positon
                if offset < PaymentCellView.stickyValue - 5 {
                    offset = 0
                    animateForegroundMove()
                }
                
                //if it exceeds stickyValue - 5, but doesn't reach triggerValue move it to
                //sticky postion (where IV is visible)
                if offset >= PaymentCellView.stickyValue - 5 && offset < PaymentCellView.triggerValue {
                    offset = PaymentCellView.stickyValue
                    selectionFeedbackGenerator.selectionChanged()
                    animateForegroundMove()
                }
            }
            
            if offset < 0 {
                
                //if foreground doesn't reach stickyValue - 5 move it back to default positon
                if abs(offset) < PaymentCellView.stickyValue + 5 {
                    offset = 0
                    animateForegroundMove()
                }
                
                //if it exceeds stickyValue - 5, but doesn't reach triggerValue move it to
                //sticky postion (where IV is visible)
                if abs(offset) >= PaymentCellView.stickyValue + 5 && abs(offset) < PaymentCellView.triggerValue{
                    offset = PaymentCellView.stickyValue * -1
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
                return true
            }
            return false
        }
        return false
    }

}
