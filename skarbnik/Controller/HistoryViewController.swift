//
//  HistoryViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 25/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class HistoryViewController: UIViewController {
    let historyView: HistoryView
    
    
    init() {
        historyView = HistoryView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = historyView
    }
    
}
