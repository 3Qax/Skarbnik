//
//  Slideable.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit




protocol Slidable where Self: UIView{
    func slideIn(completion: @escaping () -> ())
    func slideOut(completion: @escaping () -> ())
}
