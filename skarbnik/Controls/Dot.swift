//
//  Dot.swift
//  skarbnik
//
//  Created by Jakub Towarek on 15/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



enum DotState {
    case filled
    case empty
}

class Dot: UIView {
    
    var state: DotState = .empty {
        didSet {
            switch state {
            case .filled:
                backgroundColor = UIColor.catchyPink
            case .empty:
                backgroundColor = UIColor.backgroundGrey
            }
            
        }
    }
    var tapHandler: (()->())?
    
    init(_ state: DotState) {
        super.init(frame: .zero)
        
        defer {
            self.state = state
        }
        
        layer.borderColor = UIColor.catchyPink.cgColor
        layer.borderWidth = 8
        
        snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
        }
        layer.cornerRadius = 30/2
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGR)
    }
    
    convenience init() {
        self.init(.empty)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        tapHandler?()
    }
}
