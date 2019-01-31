//
//  LoginView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 19/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    let logo: UIImageView! = {
        var img = UIImageView(image: UIImage(named: "logo"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    var loginInput      = LightTextField(placeholder: NSLocalizedString("login_placeholder", comment: ""),
                                         UIImage(named: "user"),
                                         returnKeyType: .next)
    var passwordInput   = LightTextField(placeholder: NSLocalizedString("password_placeholder", comment: ""),
                                         UIImage(named: "key"),
                                         returnKeyType: .done,
                                         hideContent: true)
    var loginButton     = RaisedButton(title: NSLocalizedString("login_button", comment: ""))
    
    @objc var delegate: LoginViewProtocol?
    
    @objc func loginTapped(sender: Any?)  {
        delegate?.tryToLoginWith(login: loginInput.text, pass: passwordInput.text)
    }
    
    @objc func outsideTapped(sender: Any?)  {
        delegate?.didTappedOutside()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let outsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(outsideTapped(sender:)))
        self.backgroundColor = UIColor(rgb: 0xF5F5F5)
        self.addGestureRecognizer(outsideTapGestureRecognizer)
        
        //UI will be presented after unsuccessfull login with token
        //So we need to set UI's alpha value to 0
        passwordInput.alpha = 0.0
        loginInput.alpha = 0.0
        loginButton.alpha = 0.0
        
        self.addSubview(passwordInput)
        passwordInput.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20+(40/2)/2)
            make.right.equalTo(self).offset(-25)
        }
        
        self.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordInput.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        loginButton.addTarget(self, action: #selector(loginTapped(sender:)), for: .touchUpInside)
        
        self.addSubview(loginInput)
        loginInput.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordInput.snp.top).offset(-20)
            make.left.equalTo(self).offset(20+(40/2)/2)
            make.right.equalTo(self).offset(-25)
        }
        
        //Initial logo position
        //Should match the launchscreen position of the logo
        self.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        self.layoutIfNeeded()
    }
    
    func showUI () {
        //Move logo up, and then show UI in "step by step" style
        self.logo.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.loginInput.snp.top).offset(10)
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.loginInput.alpha = 1.0
            })
            UIView.animate(withDuration: 0.5, delay: 0.125, animations: {
               self.passwordInput.alpha = 1.0
            })
            UIView.animate(withDuration: 0.5, delay: 0.25, animations: {
              self.loginButton.alpha  = 1.0
            })
        })
    }
    func shouldResignAnyResponder() {
        loginInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
    
    func startLoginAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loginInput.alpha = 0.0
            self.passwordInput.alpha = 0.0
        })
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.loginButton.backgroundColor = UIColor(rgb: 0x78c1e5)
        })
    }
    func stopLoginAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loginInput.alpha = 1.0
            self.passwordInput.alpha = 1.0
        })
        loginButton.layer.removeAllAnimations()
        loginButton.backgroundColor = UIColor(rgb: 0xFA3CB1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
