//
//  PickStudentAlertController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 04/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit



class PickStudentViewController: UIViewController {
    let pickStudentModel = PickStudentModel()
    var coordinator: MainCoordinator?
    let pickStudentAlert = UIAlertController(title: nil,
                                             message: NSLocalizedString("choose_student_description", comment: ""),
                                             preferredStyle: .actionSheet)
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        pickStudentModel.getStudentsWithIDs { students in
            for (name, id) in students {
                DispatchQueue.main.async {
                    notificationFeedbackGenerator.notificationOccurred(.success)
                    self.pickStudentAlert.addAction(UIAlertAction(title: name,
                                                                  style: .default,
                                                                  handler: { _ in
                                                                    self.coordinator?.didChooseStudent(with: id)
                    }))
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectionFeedbackGenerator.selectionChanged()
        self.present(pickStudentAlert, animated: true)
    }
}
