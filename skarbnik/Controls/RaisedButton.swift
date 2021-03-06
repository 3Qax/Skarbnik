//
//  RaisedButton.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RaisedButton: UIButton {
    
    private let background: UIView
    lazy var animation = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .white)
    
    init(title: String = "Button", height: CGFloat = 40.0) {
        self.background = UIView()
        self.background.isUserInteractionEnabled = false
        self.background.backgroundColor = UIColor.catchyPink
        
        super.init(frame: .zero)
        
        self.addSubview(background)
        self.background.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setTitle(title.capitalizingFirstLetter(), for: .normal)
        titleLabel!.font = UIFont(name: "OpenSans-Light", size: 16.0)
        titleLabel!.textColor = UIColor.white
        
        self.clipsToBounds = true
        self.layer.cornerRadius = height / 2.0
        self.background.layer.cornerRadius = height / 2.0
        
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        
        self.addSubview(animation)
        animation.alpha = 0.0
        animation.snp.makeConstraints({ (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.width.equalToSuperview()
        })
        
    }
    
    convenience init(_ localizedTitle: String, height: CGFloat = 40.0) {
        self.init(title: NSLocalizedString(localizedTitle, comment: ""), height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadingAnimation() {
        titleLabel!.alpha = 0.0
        
        background.snp.remakeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(self.bounds.height)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        })
            
        animation.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.animation.alpha = 1.0
        })
        
    }
    
    func removeLoadingAnimation() {
        
        animation.stopAnimating()
        animation.alpha = 0.0
        
        self.layer.removeAllAnimations()
        self.background.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.titleLabel!.alpha = 1.0
        })
        
    }
    


}
