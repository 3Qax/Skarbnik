//
//  ReminderController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit



class ReminderController: UIViewController {
    let reminderModel: ReminderModel
    let reminderView: ReminderView
    var coordinator: MainCoordinator?
    
    
    
    override func loadView() {
        reminderView.delegate = self
        reminderView.daysBeforeEndPicker.dataSource = self
        reminderView.daysBeforeEndPicker.delegate = self
        view = reminderView
    }
    
    init(about: String, ending: Date) {
        reminderModel = ReminderModel(paymentName: about, endDate: ending)
        reminderView = ReminderView(initialText: reminderModel.defaultReminderText, maxDate: reminderModel.endDate)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reminderAddingHandler(result: ReminderModel.Result) -> () {
        switch result {
            case .succeed:
                //display affirmative animation
                coordinator?.didAddReminder()
            case .failure(let reason):
                switch reason {
                    case .permissionDenied:
                        print("permission denied")
                    case .permissionRestricted:
                        print("permission restricted")
            }
        }
    }
}

extension ReminderController: ReminderDelegate {
    
    func didTapAddReminder() {
        //selected days before end
        if reminderView.whenControl.indexOfSelectedOption == 0 {
            reminderModel.addReminder(withTitle: reminderView.reminderTextField.text!,
                                      daysBeforeEnd: reminderView.daysBeforeEndPicker.selectedRow(inComponent: 0),
                                      handler: reminderAddingHandler)
            
        //selected date
        } else if reminderView.whenControl.indexOfSelectedOption == 1 {
            reminderModel.addReminder(withTitle: reminderView.reminderTextField.text!,
                                      on: reminderView.datePicker.date,
                                      handler: reminderAddingHandler)
        }
    }
    

    
}

extension ReminderController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reminderModel.possibleDaysBeforeEnd
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        view.text = String(row+1)
        view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        view.font = UIFont(name: "PingFangTC-Light", size: 34.0)
        view.textAlignment = .center
        view.backgroundColor = UIColor.clear
        view.textColor = UIColor.black
        return view
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
}
