//
//  EasyInjection.swift
//  skarbnik
//
//  Created by Jakub Towarek on 09/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit


protocol EasyInjection {
    #if DEBUG
    func reloadMe()
    #endif
}
