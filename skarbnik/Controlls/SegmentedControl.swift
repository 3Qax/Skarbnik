//
//  SegmentedControl.swift
//  skarbnik
//
//  Created by Jakub Towarek on 06/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit
import SnapKit



class SegmentedControl: UIControl {

    var indexOfSelectedOption: Int {
        get {
            return selectedOption!
        }
    }
    private let sv = UIStackView()
    private let selector: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(rgb: 0xFA3CB1)

        
        return view
    }()
    private var options: [UIButton] = [UIButton]()
    private var selectedOption: Int? = nil
    
    private func setOption(number index: Int, animated: Bool = true) {
        selectedOption = index
        
        options.forEach { (button) in
            button.isSelected = false
        }
        
        options[index].isSelected = true
        
        self.selector.snp.remakeConstraints { (make) in
            make.height.equalToSuperview()
            make.centerY.centerX.equalTo(options[index])
            make.width.equalTo(options[index])
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.layoutIfNeeded()
            })
        }
    }
   
    init(optionsLabels: [String], borderWidth: CGFloat = 1.0, height: CGFloat = 30) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor(rgb: 0xFA3CB1).cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = height/2.0
        
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        
        selector.layer.cornerRadius = height/2.0
        self.addSubview(selector)
        
        sv.distribution = .fillEqually
        self.addSubview(sv)
        sv.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        optionsLabels.forEach { (name) in
            let button = UIButton(frame: .zero)
            button.setTitleColor(UIColor(rgb: 0xFA3CB1), for: .normal)
            button.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .selected)
            button.setTitle(name, for: .normal)
            button.setTitle(name, for: .selected)
            button.titleLabel?.font = UIFont(name: "PingFangTC-Light", size: 17.0)
            
            button.addTarget(self, action: #selector(didSelected(sender:)), for: .touchUpInside)
            
            sv.addArrangedSubview(button)
            button.snp.makeConstraints({ (make) in
                make.height.equalToSuperview()
            })
            
            options.append(button)
        }
        
        setOption(number: optionsLabels.count-1, animated: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didSelected(sender: UIButton) {
        if options.firstIndex(of: sender)! != selectedOption {
            setOption(number: options.firstIndex(of: sender) ?? 0)
            sendActions(for: .valueChanged)
        }
    }
    
    
}
