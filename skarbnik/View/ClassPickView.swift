//
//  ClassPickView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit
import Material

class PickableButton: UIButton {
    var index: Int
    
    required init(index: Int = 0) {
        self.index = index
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ClassPickView: UIView {
    
    let blurredBackgroundView = UIVisualEffectView()
    let picker: UIView = {
        var view = UIView()
        
        view.backgroundColor = Color.grey.lighten4
        
        return view
    }()
    let loadingLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "PingFangTC-Semibold", size: 20.0)
        label.text = "Chwileczkę..."
        label.textColor = Color.white
        
        return label
    }()
    let stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        
        return stack
    }()
    let stackViewHeaderLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Light", size: 23.0)
        label.text = "Wybierz klasę:"
        label.textColor = Color.black
        
        return label
    }()
    var delegate: ClassPickViewProtocol?
    var currIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Blur the background
        self.backgroundColor = Color.clear
        
        let outsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedOutside(sender:)))
        blurredBackgroundView.alpha = 0.0
        //blurredBackgroundView.frame = self.frame
        blurredBackgroundView.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.addSubview(blurredBackgroundView)
        blurredBackgroundView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        blurredBackgroundView.isUserInteractionEnabled = true
        blurredBackgroundView.addGestureRecognizer(outsideTapGestureRecognizer)

        //Show picker
        self.addSubview(picker)
        picker.alpha = 0.0
        picker.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.center.equalToSuperview()
        }
        
        //Show stackView inside the picker
        picker.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        //Add content to stackView
        stackView.addArrangedSubview(stackViewHeaderLabel)
        
        loadingLabel.isHidden = true
        picker.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc func didPicked(sender: PickableButton) {
        blurredBackgroundView.animate([.delay(0), .duration(0.75), .fadeOut, .timingFunction(.easeIn)])
        stackView.animate([.delay(0), .duration(0.5), .fadeOut])
        self.delegate?.didChooseClass(at: sender.index)
    }
    @objc func didTappedOutside(sender: UIView) {
        self.delegate?.didTappedOutside()
    }
    
    func show() {
        print("show!")
        blurredBackgroundView.animate([.delay(0), .duration(0.5), .fadeIn, .timingFunction(.easeOut)])
        stackView.animate([.delay(0), .duration(0.25), .fadeIn])
        picker.backgroundColor = Color.grey.lighten4
        picker.animate([.delay(0), .duration(0.25), .fadeIn])
    }
    
    func startWaitingAnimation() {
        UIView.animate(withDuration: 0, delay: 0.5, animations: {
        }) { (tmp) in
            self.picker.backgroundColor = UIColor(rgb: 0x78c1e5)
            self.loadingLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                self.picker.backgroundColor = UIColor(rgb: 0xFA3CB1)
            })
        }
    }

    func removeAnimations() {
        self.loadingLabel.isHidden = true
        self.picker.layer.removeAllAnimations()
    }
    
    func shouldAdd(_ classToAdd: String!) {
        let btn = PickableButton(index: currIndex)
        btn.addTarget(self, action: #selector(didPicked(sender:)), for: .touchUpInside)
        btn.fontSize = 24.0
        btn.setTitleColor(Color.blue.base, for: .normal)
        btn.setTitle(classToAdd, for: .normal)
        stackView.addArrangedSubview(btn)
        currIndex += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
