//
//  CoordinatorProtocol.swift
//  skarbnik
//
//  Created by Jakub Towarek on 17/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
