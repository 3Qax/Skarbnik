//
//  LoginView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 19/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import UIKit
import Material
import SnapKit

class LoginView: UIView {
    let logo: UIImageView! = {
        var img = UIImageView(image: UIImage(named: "logo"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    var loginInput: TextField! = {
        var input = TextField()
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.returnKeyType = .next
        input.isPlaceholderUppercasedWhenEditing = true
        input.placeholder = "login"
        input.placeholderAnimation = .hidden
        input.leftViewActiveColor = UIColor(rgb: 0x00CEE6)
        input.dividerActiveColor = UIColor(rgb: 0x00CEE6)
        input.tintColor = UIColor(rgb: 0x00CEE6)
        
        input.leftView = {
            let img = UIImageView()
            img.image = UIImage(named: "person")
            img.contentMode = .scaleAspectFit
            return img
        }()
        input.leftView!.contentMode = .center
        
        return input
    }()
    var passwordInput: TextField! = {
        var input = TextField()
        input.autocapitalizationType = .none
        input.autocorrectionType = .no
        input.returnKeyType = .done
        input.isSecureTextEntry = true
        input.isPlaceholderUppercasedWhenEditing = true
        input.placeholder = "hasło"
        input.placeholderAnimation = .hidden
        input.leftViewActiveColor = UIColor(rgb: 0x00CEE6)
        input.dividerActiveColor = UIColor(rgb: 0x00CEE6)
        input.tintColor = UIColor(rgb: 0x00CEE6)
        
        input.leftView = {
            let img = UIImageView()
            img.image = UIImage(named: "lock")
            img.contentMode = .scaleAspectFit
            return img
        }()
        input.leftView!.contentMode = .center
        
        return input
    }()
    var loginButton: RaisedButton! = {
        var btn = RaisedButton(title: "Zaloguj", titleColor: Color.white)
        btn.pulseColor = Color.white
        btn.backgroundColor = UIColor.init(rgb: 0xFA3CB1)
        btn.titleLabel?.font = UIFont(name: "PingFangTC-Semibold", size: 20.0)
        return btn
    }()
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
        self.backgroundColor = Color.grey.lighten4
        self.addGestureRecognizer(outsideTapGestureRecognizer)
        
        //UI will be presented after unsuccessfull login with token
        //So we need to set UI's alpha value to 0
        passwordInput.alpha = 0.0
        loginInput.alpha = 0.0
        loginButton.alpha = 0.0
        
        self.addSubview(passwordInput)
        passwordInput.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).labeled("passwordInputCenterConstraint")
            make.left.equalTo(self).offset(20).labeled("passwordInputLeftConstraint")
            make.right.equalTo(self).offset(-25).labeled("passwordInputRightConstraint")
        }
        
        self.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordInput.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(45)
        }
        loginButton.addTarget(self, action: #selector(loginTapped(sender:)), for: .touchUpInside)
        
        self.addSubview(loginInput)
        loginInput.snp.makeConstraints { (make) in
            make.bottom.equalTo(passwordInput.snp.top).offset(-20)
            make.left.equalTo(self).offset(20)
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
        }, completion: { (didEnded) in
            self.loginInput.animate([.delay(0.0), .duration(0.5), .fadeIn])
            self.passwordInput.animate([.delay(0.125), .duration(0.5), .fadeIn])
            self.loginButton.animate([.delay(0.25), .duration(0.5), .fadeIn])
        })
    }
    func shouldResignAnyResponder() {
        loginInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
    
    func startLoginAnimation() {
        loginInput.animate([.delay(0.0), .duration(0.5), .fadeOut])
        passwordInput.animate([.delay(0.0), .duration(0.5), .fadeOut])

        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            self.loginButton.title! = "Logowanie..."
        }, completion: { (didEnded) in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                self.loginButton.backgroundColor = UIColor(rgb: 0x78c1e5)
            }, completion: nil)
        })
    }
    func stopLoginAnimation() {
        self.loginInput.animate([.delay(0.0), .duration(0.5), .fadeIn])
        self.passwordInput.animate([.delay(0.0), .duration(0.5), .fadeIn])
        loginButton.layer.removeAllAnimations()
        self.loginButton.title! = "Zaloguj"
        loginButton.backgroundColor = UIColor.init(rgb: 0xFA3CB1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
