//
//  Slideable.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit




protocol Slidable where Self: UIViewController{
    func slideIn()
    func slideOut()
}
