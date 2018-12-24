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
    
    let picker: UIView = {
        var view = UIView()
        
        view.backgroundColor = Color.grey.lighten4
        
        return view
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
        let blurredBackgroundView = UIVisualEffectView()
        blurredBackgroundView.frame = self.frame
        blurredBackgroundView.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.addSubview(blurredBackgroundView)

        //Show picker
        self.addSubview(picker)
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
    }
    
    @objc func didTapped(sender: PickableButton) {
        delegate?.didChooseClass(at: sender.index)
    }
    
    func shouldAdd(_ classToAdd: String!) {
        let btn = PickableButton(index: currIndex)
        btn.addTarget(self, action: #selector(didTapped(sender:)), for: .touchUpInside)
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
