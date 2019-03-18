//
//  mainCoordinator.swift
//  skarbnik
//
//  Created by Jakub Towarek on 01/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var children: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    var asyncSafetyController: AsyncSafetyController?
    
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (i, coordinator) in children.enumerated() {
            if coordinator === child {
                children.remove(at: i)
            }
        }
    }
    
    func start() {
        let child = LoginCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        children.append(child)
        child.start()

    }
    
//
//---------------------------------------------------------------------------------------
//
    
    func didRequestStudentChange() {
        navigationController.navigationBar.isHidden = true
        let pickStudentVC = PickStudentAlertController()
        pickStudentVC.coordinator = self
        pickStudentVC.modalPresentationStyle = .overCurrentContext
        navigationController.present(pickStudentVC, animated: true)
    }
    
    func didChooseStudent(of studentID: Int, in classID: Int) {
        navigationController.dismiss(animated: true)
        let child = PaymentCoordinator(ofStudentWithID: studentID, inClassWithID: classID, navigationController: navigationController)
        child.parentCoordinator = self
        children.append(child)
        child.start()
    }
    

    
    
    
    
}
