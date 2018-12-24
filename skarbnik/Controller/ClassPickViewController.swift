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
    
    var delegate: PickerProtocol?
    
    override func loadView() {
        view = ClassPickView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        for child in userModel!.children! {
            (view as! ClassPickView).shouldAdd(child.class_field.name)
        }
        (view as! ClassPickView).delegate = self
    }
}

extension ClassPickViewController: ClassPickViewProtocol {
    func didChooseClass(at: Int) {
        delegate?.didChoose(at: at)
        self.dismiss(animated: true, completion: nil)
    }
}
