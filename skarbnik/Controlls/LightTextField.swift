//
//  LightTextField.swift
//  skarbnik
//
//  Created by Jakub Towarek on 29/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

class LightTextField: UITextField {

    init(placeholder: String? = nil,_ image: UIImage? = nil, returnKeyType: UIReturnKeyType = .default, hideContent: Bool = false) {
        super.init(frame: .zero)
        let padding: CGFloat = 10.0
        
        self.returnKeyType = returnKeyType
        autocapitalizationType = .none
        autocorrectionType = .no
        self.font = UIFont(name: "PingFangTC-Light", size: 18.0)
        
        if let placeholder = placeholder {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGrey])
        }
        
        if let image = image {
            self.leftViewMode = .always
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            //give template image some color
            imageView.tintColor = UIColor.darkGrey
            let customLeftView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + padding, height: imageView.frame.height))
            
            customLeftView.addSubview(imageView)
            
            self.leftView = customLeftView
        }
        
        if hideContent {
            self.isSecureTextEntry = true
            self.clearsOnBeginEditing = true
        }
        
        self.tintColor = UIColor(rgb: 0x00CEE6)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
