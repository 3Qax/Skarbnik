//
//  ReminderController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit



class ReminderViewController: UIViewController {
    let reminderModel: ReminderModel
    let reminderView: ReminderView
    var coordinator: MainCoordinator?
    
    
    
    
    

    
    init(about payment: Payment) {
        reminderModel = ReminderModel(for: payment)
        reminderView = ReminderView(initialText: reminderModel.defaultReminderText, maxDate: reminderModel.endDate)
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = reminderModel.paymentName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        reminderView.delegate = self
        reminderView.daysBeforeEndPicker.dataSource = self
        reminderView.daysBeforeEndPicker.delegate = self
        view = reminderView
    }
    
    func reminderAddingHandler(result: ReminderModel.Result) -> () {
        switch result {
            case .succeed:
                //display affirmative animation
                notificationFeedbackGenerator.notificationOccurred(.success)
                coordinator?.didAddReminder()
            
            case .failure(let reason):
                notificationFeedbackGenerator.notificationOccurred(.error)
                switch reason {
                    case .permissionDenied:
                        //Permission denied
                        let permissionDenidedAlert = UIAlertController(  title: NSLocalizedString("reminder_permision_denied_title", comment: ""),
                                                                         message: NSLocalizedString("reminder_permision_denied_message", comment: ""),
                                                                         preferredStyle: .alert)
                        permissionDenidedAlert.addAction(UIAlertAction(title: NSLocalizedString("reminder_permision_denied_cancel", comment: ""), style: .destructive, handler: { _ in self.coordinator?.didCancelAddingReminder() }))
                        permissionDenidedAlert.addAction(UIAlertAction(title: NSLocalizedString("reminder_permision_denied_change_permisions", comment: ""), style: .default, handler: { _ in
                            
                            let goToSettingsAlert = UIAlertController(  title: NSLocalizedString("reminder_go_to_settings_title", comment: ""),
                                                                        message: NSLocalizedString("reminder_go_to_settings_message", comment: ""),
                                                                        preferredStyle: .alert)
                            goToSettingsAlert.addAction(UIAlertAction(title: NSLocalizedString("reminder_go_to_settings_ok", comment: ""), style: .default, handler: { (_) in
                                self.coordinator?.didCancelAddingReminder()
                            }))
                            self.present(goToSettingsAlert, animated: true)
                        }))
                        self.present(permissionDenidedAlert, animated: true)
                    
                    case .permissionRestricted:
                        //Permission restricted
                        let permissionRestrictedAlert = UIAlertController(  title: NSLocalizedString("reminder_permision_restricted_title", comment: ""),
                                                                            message: NSLocalizedString("reminder_permision_restricted_message", comment: ""),
                                                                            preferredStyle: .alert)
                        permissionRestrictedAlert.addAction(UIAlertAction(title: NSLocalizedString("reminder_permision_restricted_ok", comment: ""), style: .destructive, handler: { _ in
                            self.coordinator?.didCancelAddingReminder()
                        }))
                        self.present(permissionRestrictedAlert, animated: true)
                }
        }
    }
}

extension ReminderViewController: ReminderDelegate {
    
    func didTapCancel() {
        coordinator?.didCancelAddingReminder()
    }
    
    func didTapAddReminder() {
        notificationFeedbackGenerator.prepare()
        
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

extension ReminderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
