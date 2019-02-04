//
//  ShouldChangePasswordAfterFirstLoginView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit

class ShouldChangePasswordAfterFirstLoginView: UIView {
    
    var delegate: ChangePasswordProtocool?
    
    var passwordInput   = LightTextField(placeholder: NSLocalizedString("new_password_placeholder", comment: ""),
                                         UIImage(named: "key"),
                                         returnKeyType: .done,
                                         hideContent: true)
    var repeatPasswordInput   = LightTextField(placeholder: NSLocalizedString("repeat_new_password_placeholder", comment: ""),
                                         UIImage(named: "key"),
                                         returnKeyType: .done,
                                         hideContent: true)
    var changePasswordButton     = RaisedButton(title: NSLocalizedString("change_password_button", comment: ""))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(rgb: 0xF5F5F5)
        
        self.addSubview(repeatPasswordInput)
        repeatPasswordInput.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        self.addSubview(passwordInput)
        passwordInput.snp.makeConstraints { (make) in
            make.left.right.equalTo(repeatPasswordInput)
            make.bottom.equalTo(repeatPasswordInput.snp.top).offset(-20)
        }
        
        self.addSubview(changePasswordButton)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped(sender:)), for: .touchUpInside)
        changePasswordButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(repeatPasswordInput.snp.bottom).offset(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changePasswordButtonTapped(sender: RaisedButton) {
        delegate?.didTappedChangePasswordButton(password: passwordInput.text, repeatedPassword: repeatPasswordInput.text)
    }
    
}
