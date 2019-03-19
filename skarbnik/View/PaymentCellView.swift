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
    
    private let background: UIView          = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGrey
        return view
    }()
    private let content: UIView             = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    private let titleLabel: UILabel         = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor.pacyficBlue
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
    public  let amountFormatter             = NumberFormatter()
    private let remindButton                = OptionButton("set_reminder_button_text", hight: 30)
    private let payButton                   = RaisedButton("pay_button_text", hight: 30)
    private let moreButton                  = OptionButton("show_photos_button_text", hight: 30)
    private let startDateLabel: UILabel     = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "PingFangTC-Light", size: 15.0)
        label.textColor = UIColor.darkGrey
        return label
    }()
    var style: PaymentCellStyle             = .unknown {
        didSet {
            didChangeState()
        }
    }
    var delegate: PaymentCellDelegate?
    
    
    enum PaymentCellStyle {
        case paid
        case pending
        case awaiting
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
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear

        contentView.addSubview(background)
        background.layer.cornerRadius = CGFloat(20.0)
        background.dropShadow()
        background.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        }
        
        contentView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.edges.equalTo(background)
        }
        
                
        
        //Title
        content.addSubview(titleLabel)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
        }
        
        //Amount
        content.addSubview(amountLabel)
        self.amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        self.amountLabel.setContentHuggingPriority(.required, for: .vertical)
        amountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).priority(.required)
            make.right.equalTo(content).offset(-10)
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
        
        //Description
        content.addSubview(descriptionLabel)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        self.descriptionLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel)
            make.right.equalTo(content).offset(-20)
        })
    }
    
    func setupContent(title: String, description: String, amount: Float, currency: String, startDate: Date) {
        
        //Title
        self.titleLabel.text = title.capitalizingFirstLetter()
        
        //Amount
        amountFormatter.locale = Locale.availableIdentifiers.lazy.map({Locale(identifier: $0)}).first(where: { $0.currencyCode == currency })
        amountFormatter.numberStyle = .currency
        self.amountLabel.text = amountFormatter.string(from: amount as NSNumber)
        
        //Description
        self.descriptionLabel.text = description.capitalizingFirstLetter()
        
        //StartDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        self.startDateLabel.text = "Płatne od: " + dateFormatter.string(from: startDate)
    }
    
    func setupTargets() {
        remindButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.remindButton, completion: {self.delegate?.didTapRemindButton(sender: self)} ) })
        payButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.payButton, completion: {self.delegate?.didTapPayButton(sender: self)} ) })
        moreButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.moreButton, completion: {self.delegate?.didTapMoreButton(sender: self)} ) })
    }
    
    func didChangeState() {
        switch style {
        case .unknown:
            print("unknow")
            //fatalError("Unknown state")
        case .pending:
            amountLabel.textColor = UIColor.pacyficBlue
            
            content.addSubview(remindButton)
            remindButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.equalTo(descriptionLabel)
                make.right.equalTo(descriptionLabel.snp.centerX).offset(-5)
            }
            content.addSubview(payButton)
            payButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.equalTo(descriptionLabel.snp.centerX).offset(5)
                make.right.equalTo(descriptionLabel)
                make.bottom.equalTo(content).offset(-10)
            }
            
            moreButton.removeFromSuperview()
            startDateLabel.removeFromSuperview()
            
        case .paid:
            
            content.addSubview(moreButton)
            moreButton.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.right.equalTo(descriptionLabel)
                make.bottom.equalTo(content).offset(-10)
            }
            
            remindButton.removeFromSuperview()
            payButton.removeFromSuperview()
            startDateLabel.removeFromSuperview()
            amountLabel.removeFromSuperview()
            
            
            
        case .awaiting:
            amountLabel.textColor = UIColor.pacyficBlue
            
            content.addSubview(startDateLabel)
            startDateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            startDateLabel.snp.makeConstraints { (make) in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
                make.left.right.equalTo(descriptionLabel)
                make.bottom.equalTo(content).offset(-5)
            }
            
            remindButton.removeFromSuperview()
            payButton.removeFromSuperview()
            moreButton.removeFromSuperview()
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
