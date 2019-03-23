//
//  PayView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class PayView: UIView {
    
    let backIV: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    let segmentedControl = SegmentedControl(optionsLabels: ["suwak", "wpisz kwotę"])
    let slider: ProgressableSlider
    let toPayLabel = UILabel()
    let amountToPay: Float
    let amounLabel = BigLabel(text: "", fontStyle: .thin)
    let amountFormatter: NumberFormatter
    let payButton = RaisedButton(title: "Zapłać...")
    let payOnWebButton = OptionButton(title: "Zapłać przez portal www...")
    var delegate: PayViewDelegate?
    
    
    
    init(totalAmount: Float, amountToPay: Float, remittances: [Float], amountFormatter: NumberFormatter) {
        slider = ProgressableSlider(progressionPoints: remittances, maxValue: totalAmount)
        self.amountFormatter = amountFormatter
        self.amountToPay = amountToPay
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.backgroundGrey
        
        self.addSubview(backIV)
        let backTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackButton))
        backIV.isUserInteractionEnabled = true
        backIV.addGestureRecognizer(backTapGestureRecognizer)
        backIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalToSuperview()
        }
        
        self.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(backIV.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        addSubview(slider)
        slider.addTarget(self, action: #selector(didChangedSliderValue(sender:)), for: .valueChanged)
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        addSubview(payOnWebButton)
        payOnWebButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.payOnWebButton, completion: {self.delegate?.didTapPayOnWeb()}) })
        payOnWebButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(payButton)
        payButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.payButton, completion: {self.delegate?.didTapPay()}) })
        payButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(payOnWebButton.snp.top).offset(-10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(amounLabel)
        amounLabel.textAlignment = .right
        amounLabel.text = amountFormatter.string(from: Float(slider.value) * amountToPay as NSNumber)
        amounLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalTo(payButton.snp.top)
        }
        
        addSubview(toPayLabel)
        toPayLabel.text = "Do zapłaty:"
        toPayLabel.font = UIFont(name: "PingFangTC-Light", size: 20.0)
        toPayLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.lastBaseline.equalTo(amounLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didChangedSliderValue(sender: ProgressableSlider) {
        amounLabel.text = amountFormatter.string(from: Float(sender.value) * amountToPay  as NSNumber)
    }
    
    @objc func didTapBackButton() {
        delegate?.didTapBack()
    }
    
    
    
}

//Animations
extension PayView {
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
