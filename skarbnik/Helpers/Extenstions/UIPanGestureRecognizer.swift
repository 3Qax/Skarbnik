//
//  UIPanGestureRecognizer.swift
//  skarbnik
//
//  Created by Jakub Towarek on 08/07/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



extension UIPanGestureRecognizer {
    func cancel() {
        self.isEnabled = false
        self.isEnabled = true
    }
}
