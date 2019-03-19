//
//  StartView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 18/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class StartView: UIView {
    
    let logo: UIImageView!  = {
        var img = UIImageView(image: UIImage(named: "logo"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangTC-Thin", size: 22.0)
        label.textColor = UIColor.darkGray
        return label
    }()
    let animationGroup = CAAnimationGroup()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.backgroundGrey
        
        
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.05
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 1.0
        pulse1.damping = 0.8
        
        
        animationGroup.duration = 2.7
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]

        
        //Initial position of logo should match the launchscreen position of the logo
        self.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        self.addSubview(activityLabel)
        activityLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ text: String) {
        activityLabel.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.5, animations: {
            self.activityLabel.alpha = 0.0
        }) { (_) in
            self.activityLabel.text = text
            UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                self.activityLabel.alpha = 1
            }, completion: { _ in self.activityLabel.layer.add(self.animationGroup, forKey: "pulse") })
        }

    }
    
}
