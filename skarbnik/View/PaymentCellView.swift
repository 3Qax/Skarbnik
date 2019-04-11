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
    
    private let foreground: UIView          = {
        let view = UIView()
        view.backgroundColor = UIColor.white
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
    private let amountLabel: UILabel        = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "OpenSans-Light", size: 24.0)
        label.textColor = UIColor.pacyficBlue
        return label
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
        setupTargets()
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
        foreground.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()//.inset(UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        }
        
        //Amount
        foreground.addSubview(amountLabel)
        amountLabel.setContentHuggingPriority(.required, for: .horizontal)
        amountLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        //Title
        foreground.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(amountLabel.snp.left).offset(-10)
        }
        
    }
    
    func setupContent(title: String, description: String, amount: Float, currency: String, startDate: Date) {
        
        //Title
        self.titleLabel.text = title.capitalizingFirstLetter()
        
        //Amount
        amountFormatter.locale = Locale.availableIdentifiers.lazy.map({Locale(identifier: $0)}).first(where: { $0.currencyCode == currency })
        amountFormatter.numberStyle = .currency
        self.amountLabel.text = amountFormatter.string(from: amount as NSNumber)
        
        
    }
    
    func setupTargets() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        foreground.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTapCell() {
        self.delegate?.didTapCell(sender: self)
    }
    
    func didChangeState() {
        switch style {

        case .pending?:
            titleLabel.textColor    = UIColor.black
            amountLabel.textColor   = UIColor.pacyficBlue
            
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
