//
//  PayViewDelegate.swift
//  skarbnik
//
//  Created by Jakub Towarek on 17/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



protocol PayViewDelegate {
    func didTapPay()
    func didTapPayOnWeb()
    func didTapBack()
}
