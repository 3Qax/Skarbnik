//
//  CustomisedTableViewDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 20/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit




protocol CustomisedTableViewDelegate {
    func shouldScroll(dy: CGFloat) -> Bool
}
