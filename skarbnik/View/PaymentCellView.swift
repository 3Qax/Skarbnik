//
//  PaymentCellView.swift
//  tableviewtest
//
//  Created by Jakub Towarek on 22/11/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//
import UIKit
import SnapKit

class PaymentCellView: UITableViewCell {
    
    //let key: Int
    private let titleLabel: UILabel         = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont(name: "PingFangTC-Regular", size: 22.0)
    return label
    }()
    private let descriptionLabel: UILabel   = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "PingFangTC-Light", size: 15.0)
        label.textColor = UIColor.darkGrey
        return label
    }()
    private let amountLabel: UILabel        = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "PingFangTC-Light", size: 22.0)
        label.textColor = UIColor.pacyficBlue
        return label
    }()
    private let remindButton                = OptionButton("set_reminder_button_text", hight: 30)
    private let payButton                   = RaisedButton("pay_button_text", hight: 30)
    private let moreButton                  = OptionButton("show_photos_button_text", hight: 30)
    var style: PaymentCellStyle             = .unknown {
        didSet {
            didChangeState()
        }
    }
    var delegate: PaymentCellDelegate?
    
    
    enum PaymentCellStyle {
        case paid
        case pending
        case unknown
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupTargets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        
        self.clipsToBounds = true
        
        //Title
        contentView.addSubview(titleLabel)
        self.titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5).priority(.required)
            make.left.equalToSuperview().offset(20)
        }
        
        //Amount
        contentView.addSubview(amountLabel)
        self.amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        self.amountLabel.setContentHuggingPriority(.required, for: .vertical)
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).priority(.required)
            make.right.equalToSuperview().offset(-self.separatorInset.left)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        //Description
        contentView.addSubview(descriptionLabel)
        self.descriptionLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(self.amountLabel)
        })
    }
    
    func setupContent(title: String, description: String, amount: Float, currency: String) {
        
        //Title
        self.titleLabel.text = title.capitalizingFirstLetter()
        
        //Amount
        let amountFormatter = NumberFormatter()
        amountFormatter.locale = Locale.availableIdentifiers.lazy.map({Locale(identifier: $0)}).first(where: { $0.currencyCode == currency })
        amountFormatter.numberStyle = .currency
        self.amountLabel.text = amountFormatter.string(from: amount as NSNumber)
        
        //Description
        self.descriptionLabel.text = description.capitalizingFirstLetter()
    }
    
    func setupTargets() {
        remindButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.remindButton, completion: {self.delegate?.didTapRemindButton(sender: self)} ) })
        payButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.payButton, completion: {self.delegate?.didTapPayButton(sender: self)} ) })
        moreButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.moreButton, completion: {self.delegate?.didTapMoreButton(sender: self)} ) })
    }
    
    func didChangeState() {
        switch style {
        case .unknown:
            fatalError("Unknown state")
        case .pending:
            contentView.addSubview(remindButton)
            remindButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.equalTo(descriptionLabel)
                make.right.equalTo(descriptionLabel.snp.centerX).offset(-5)
            }
            contentView.addSubview(payButton)
            payButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.equalTo(descriptionLabel.snp.centerX).offset(5)
                make.right.equalTo(descriptionLabel)
                make.bottom.equalToSuperview().offset(-5)
            }
            
            moreButton.removeFromSuperview()
            
        case .paid:
            amountLabel.textColor = UIColor.darkGrey
            
            contentView.addSubview(moreButton)
            moreButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.right.equalTo(descriptionLabel)
                make.bottom.equalToSuperview().offset(-5)
            }
            
            remindButton.removeFromSuperview()
            payButton.removeFromSuperview()
            
            
            
        }
    }
    

}

//Animations
extension PaymentCellView {
    func animateButtonTap(_ view: UIView, completion: @escaping () -> ()) {
        
        view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        selectionFeedbackGenerator.selectionChanged()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            completion()
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options:.allowUserInteraction,
                       animations: {
                        view.transform = CGAffineTransform.identity
        })

    }
}