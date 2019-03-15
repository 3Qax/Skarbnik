//
//  PayView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 13/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class PayView: UIView {
    
    let slider: ProgressableSlider
    let toPayLabel = UILabel()
    let amounLabel = BigLabel(text: "", fontStyle: .thin)
    let amountFormatter: NumberFormatter
    let payButton = RaisedButton(title: "Zapłać...")
    let payOnWebButton = OptionButton(title: "Zapłać przez portal www...")
    
    
    
    init(amount: Float, remittances: [Float], amountFormatter: NumberFormatter) {
        slider = ProgressableSlider(total: amount, remittances: remittances, barHight: 5, cornerRadius: 2)
        self.amountFormatter = amountFormatter
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.backgroundGrey
        
        addSubview(slider)
        slider.slider.addTarget(self, action: #selector(didChangedSliderValue(sender:)), for: .valueChanged)
        slider.snp.makeConstraints { (make) in
            //make.top.equalTo(amountLabel.snp.bottom)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        addSubview(payOnWebButton)
        payOnWebButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(payButton)
        payButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(payOnWebButton.snp.top).offset(-10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        addSubview(amounLabel)
        amounLabel.textAlignment = .right
        amounLabel.text = amountFormatter.string(from: slider.slider.value as NSNumber)
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
    
    @objc func didChangedSliderValue(sender: ProgressableSlider.VariableHightSlider) {
        amounLabel.text = amountFormatter.string(from: sender.value as NSNumber)
        print(sender.value)
    }
    
    
    
    
}
