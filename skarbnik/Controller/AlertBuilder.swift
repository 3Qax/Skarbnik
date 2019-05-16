//
//  AlertBuilder.swift
//  skarbnik
//
//  Created by Jakub Towarek on 11/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit

/// This class is marked final because it is not meant to be added to or changed.
final class AlertBuilder {
    private let alertController: UIAlertController
    
    required init(withStyle style: UIAlertController.Style = .alert) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    @discardableResult
    func setTitle(_ title: String) -> AlertBuilder {
        alertController.title = title
        return self
    }
    
    @discardableResult
    func setMessage(_ message: String) -> AlertBuilder {
        alertController.message = message
        return self
    }
    
    @discardableResult
    func addAction(withStyle style: UIAlertAction.Style,
                   text: String,
                   handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        
        alertController.addAction(UIAlertAction(title: text, style: style, handler: handler))
        return self
    }
    
    @discardableResult
    func show(in viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> AlertBuilder {
        viewController.present(alertController, animated: animated, completion: completion)
        return self
    }
    
    @discardableResult
    func basicAlert(withTitle title: String?,
                    message: String? = nil,
                    actionTitle: String = "OK",
                    actionHandler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        
        alertController.title = title
        alertController.message = message
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionHandler))
        return self
    }
}
