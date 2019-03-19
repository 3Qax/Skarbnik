//
//  StartViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 18/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class StartViewController: UIViewController {
    
    let startView = StartView()
    
    override func loadView() {
        view = startView
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(forName: .setStatus, object: nil, queue: nil, using: updateStatus)
        NotificationCenter.default.addObserver(forName: .removeStatus, object: nil, queue: nil, using: removeStatus)
        
    }
    
    
    func updateStatus(notification: Notification) {
        guard let userInfo = notification.userInfo, let status = userInfo["status"] as? String else {
            return
        }
        startView.setStatus(status)
    }
    
    func removeStatus(notification: Notification) {
        startView.setStatus("")
    }
}
