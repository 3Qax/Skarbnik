//
//  ChangePasswordView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit

class ChangePasswordView: UIView {
    
    @objc func injected() {
        delegate?.reloadMe()
    }
    
    var delegate: ChangePasswordProtocool?
    
    var oldPasswordInput   = LightTextField(placeholder: NSLocalizedString("old_password_placeholder", comment: ""),
                                         UIImage(named: "key"),
                                         returnKeyType: .done,
                                         hideContent: true)
    var newPasswordInput   = LightTextField(placeholder: NSLocalizedString("new_password_placeholder", comment: ""),
                                         UIImage(named: "key"),
                                         returnKeyType: .done,
                                         hideContent: true)
    var repeatNewPasswordInput   = LightTextField(placeholder: NSLocalizedString("repeat_new_password_placeholder", comment: ""),
                                         UIImage(named: "key"),
                                         returnKeyType: .done,
                                         hideContent: true)
    var changePasswordButton     = RaisedButton(title: NSLocalizedString("change_password_button_text", comment: ""))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(rgb: 0xF5F5F5)
        
        self.addSubview(newPasswordInput)
        newPasswordInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.snp.centerY).offset(-10)
        }
        
        self.addSubview(repeatNewPasswordInput)
        repeatNewPasswordInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.snp.centerY).offset(10)
        }
        
        self.addSubview(oldPasswordInput)
        oldPasswordInput.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(newPasswordInput.snp.top).offset(-20)
        }
        
        self.addSubview(changePasswordButton)
        changePasswordButton.addTarget(self, action: #selector(changePasswordButtonTapped(sender:)), for: .touchUpInside)
        changePasswordButton.snp.makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(repeatNewPasswordInput.snp.bottom).offset(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func changePasswordButtonTapped(sender: RaisedButton) {
        delegate?.didTappedChangePasswordButton(old: oldPasswordInput.text, new: newPasswordInput.text, repeatedNew: repeatNewPasswordInput.text)
    }
    
}
