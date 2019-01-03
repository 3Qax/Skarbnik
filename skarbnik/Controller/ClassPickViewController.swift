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
    var isClassChoosen = false
    var delegate: PickerProtocol?
    
    override func loadView() {
        view = ClassPickView(frame: UIScreen.main.bounds)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        (view as! ClassPickView).show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (view as! ClassPickView).removeAnimations()
    }
    
    override func viewDidLoad() {
        (view as! ClassPickView).delegate = self
        
        for child in userModel!.children! {
            (view as! ClassPickView).shouldAdd(child.class_field.name)
        }
        
    }
}

extension ClassPickViewController: ClassPickViewProtocol {
    func didTappedOutside() {
        if isClassChoosen {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func didChooseClass(at: Int) {
        isClassChoosen = true
        (view as! ClassPickView).startWaitingAnimation()
        delegate?.didChoose(at, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
}
