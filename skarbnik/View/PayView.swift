//
//  PayView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit




class PayView: UIView {
    
    let backIV: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "back"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.catchyPink
        return imageView
    }()
    
    let howMuchLabel                            = BigLabel(text: "Ile")
    let segmentedControl                        = SegmentedControl(optionsLabels: ["wpisz kwotę", "wybierz kwotę"])
    
    let amountFormatter: NumberFormatter
    
    let sliderWrapper                           = UIView()
        let slider: ProgressableSlider
        var sliderLeftConstraint: Constraint?   = nil
        let toPayLabel                          = UILabel()
        let amountToPay: Float
        let amounLabel                          = BigLabel(text: "", fontStyle: .thin)
    
    let amountToPayWrapper                      = UIView()
        let amountToPayTextField: UITextField   = {
        let textfield = UITextField()
        
        textfield.backgroundColor = UIColor.clear
        textfield.textColor = UIColor.catchyPink
        textfield.textAlignment = .right
        textfield.placeholder = "0zł"
        textfield.keyboardType = .decimalPad
        textfield.font = UIFont(name: "PingFangTC-Light", size: 40.0)
        
        return textfield
    }()
        let tipHalfButton                           = OptionButton(title: "połowa", hight: 25)
        let tipFullButton                           = OptionButton(title: "całość", hight: 25)
    
    
    
    let payButton                               = RaisedButton(title: "Zapłać...")
    let payOnWebButton                          = OptionButton(title: "Zapłać przez portal www...")
    var delegate: PayViewDelegate?
    
    
    
    init(totalAmount: Float, amountToPay: Float, remittances: [Float], amountFormatter: NumberFormatter) {
        slider = ProgressableSlider(progressionPoints: remittances, maxValue: totalAmount)
        self.amountFormatter = amountFormatter
        self.amountToPay = amountToPay
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.backgroundGrey
        
        self.addSubview(backIV)
        let backTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackButton))
        backIV.isUserInteractionEnabled = true
        backIV.addGestureRecognizer(backTapGestureRecognizer)
        backIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.left.equalToSuperview()
        }
        
        self.addSubview(howMuchLabel)
        howMuchLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backIV.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        self.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(didChangeSelection(sender:)), for: .valueChanged)
        segmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(howMuchLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        //Slider -------------------------------------------------------------------------------------------
        self.addSubview(sliderWrapper)
        sliderWrapper.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            sliderLeftConstraint = make.left.equalToSuperview().constraint
            make.width.equalToSuperview()
        }
        
        sliderWrapper.addSubview(slider)
        slider.addTarget(self, action: #selector(didChangedSliderValue(sender:)), for: .valueChanged)
        slider.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        sliderWrapper.addSubview(amounLabel)
        amounLabel.textAlignment = .right
        amounLabel.text = amountFormatter.string(from: Float(slider.value) * amountToPay as NSNumber)
        amounLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(slider.snp.bottom).offset(10)
        }
        
        sliderWrapper.addSubview(toPayLabel)
        toPayLabel.text = "Do zapłaty:"
        toPayLabel.font = UIFont(name: "PingFangTC-Light", size: 20.0)
        toPayLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.lastBaseline.equalTo(amounLabel)
        }
        
        sliderWrapper.snp.makeConstraints { (make) in
            make.bottom.equalTo(amounLabel)
        }
        
        
        
        
        
        
        //AmountToPayTextField -----------------------------------------------------------------------------
        self.addSubview(amountToPayWrapper)
        amountToPayWrapper.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.left.equalTo(sliderWrapper.snp.right)
        }
        
        amountToPayWrapper.addSubview(amountToPayTextField)
        amountToPayTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        amountToPayWrapper.addSubview(tipHalfButton)
        tipHalfButton.snp.makeConstraints { (make) in
            make.top.equalTo(amountToPayTextField.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(amountToPayWrapper.snp.centerX).offset(-5)
        }
        
        amountToPayWrapper.addSubview(tipFullButton)
        tipFullButton.snp.makeConstraints { (make) in
            make.top.equalTo(amountToPayTextField.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(amountToPayWrapper.snp.centerX).offset(5)
        }
        
        amountToPayWrapper.snp.makeConstraints { (make) in
            make.bottom.equalTo(tipFullButton).offset(10)
        }
        

        
        //Buttons ------------------------------------------------------------------------------------------
        self.addSubview(payButton)
        payButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.payButton, completion: {self.delegate?.didTapPay()}) })
        payButton.snp.makeConstraints { (make) in
            make.top.equalTo(sliderWrapper.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.addSubview(payOnWebButton)
        payOnWebButton.addAction(for: .touchUpInside, { self.animateButtonTap(self.payOnWebButton, completion: {self.delegate?.didTapPayOnWeb()}) })
        payOnWebButton.snp.makeConstraints { (make) in
            make.top.equalTo(payButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
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
    
    @objc func didChangeSelection(sender: SegmentedControl) {
        if sender.indexOfSelectedOption == 0 {
            sliderLeftConstraint?.update(offset: -sliderWrapper.frame.width)
            self.amountToPayTextField.becomeFirstResponder()
            payButton.snp.remakeConstraints { (make) in
                make.top.equalTo(amountToPayWrapper.snp.bottom).offset(10)
                make.height.equalTo(40)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            })
            return
        }
        if sender.indexOfSelectedOption == 1 {
            sliderLeftConstraint?.update(offset: 0)
            amountToPayTextField.resignFirstResponder()
            payButton.snp.remakeConstraints { (make) in
                make.top.equalTo(sliderWrapper.snp.bottom).offset(10)
                make.height.equalTo(40)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
            return
        }
        fatalError("Selected option with unknown index: \(sender.indexOfSelectedOption)")
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

extension PayView: UITextFieldDelegate {
    
}
