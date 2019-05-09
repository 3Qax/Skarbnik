//
//  SearchField.swift
//  skarbnik
//
//  Created by Jakub Towarek on 09/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit


class SearchField: UITextField {
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // This will remove the border style, we need to do this
        // in order to configure border style through `textField.layer`
        // otherwise we'll have 2 borders.
        // You can remove `textField.borderStyle = .none` to see it yourself.
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        self.layer.borderWidth = 0.0
        self.textColor = UIColor.white
        
        self.font = UIFont(name: "OpenSans-Light", size: 18.0)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.returnKeyType = .search
        
        self.leftView = nil
        self.tintColor = UIColor.white
        
        self.clearButtonMode = .never
        
        self.contentMode = .redraw
        
        self.setContentHuggingPriority(.init(200), for: .horizontal)
        
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
