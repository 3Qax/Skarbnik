//
//  ClassPickViewProtocol.swift
//  skarbnik
//
//  Created by Jakub Towarek on 23/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation

protocol ClassPickViewProtocol {
    func didChooseClass(at: Int)
    func didTappedOutside()
}