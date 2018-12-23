//
//  ClassPickViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/12/2018.
//  Copyright © 2018 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit

class ClassPickViewController: UIViewController {
    
    func shouldReload(_ classesArr: [String]) {
        for c in classesArr {
            (view as! ClassPickView).shouldAdd(c)
        }
    }
    
    override func loadView() {
        view = ClassPickView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {

    }
}
