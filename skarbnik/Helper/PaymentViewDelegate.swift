//
//  PaymentViewProtocol.swift
//  skarbnik
//
//  Created by Jakub Towarek on 24/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation

protocol PaymentViewDelegate {
    func didTappedClass()
    func didRequestDataRefresh()
    func searchTermDidChanged(term: String)
    func shouldCancelSearch(in searchBar: SearchField)
}
