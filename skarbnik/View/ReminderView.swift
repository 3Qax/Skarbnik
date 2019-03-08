//
//  ReminderView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class ReminderView: UIView {
    
    //About section
    let remindMeLabel = BigLabel(text: "O czym")
    let reminderTextField: UITextField = {
        let textfield = UITextField()
        
        textfield.backgroundColor = UIColor.clear
        textfield.textColor = UIColor(rgb: 0xFA3CB1)
        textfield.placeholder = "Treść przypomnienia"
        textfield.font = UIFont(name: "PingFangTC-Light", size: 20.0)
        
        return textfield
    }()
    //When section
    let whenLabel = BigLabel(text: "Kiedy")
    let whenControl = SegmentedControl(optionsLabels: ["dni przed końcem", "data"])
    let daysBeforeEndPickerContainer = UIView()
    let datePicker = UIDatePicker(frame: .zero)
    let daysBeforeEndPicker = UIPickerView(frame: .zero)
    
    //Action section
    let addReminderButton = RaisedButton(title: "Dodaj przypomnienie...")
    
    var delegate: ReminderDelegate?
    
    init(initialText: String, maxDate: Date) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(rgb: 0xF5F5F5)
        self.isUserInteractionEnabled = true
        let outSideTap = UITapGestureRecognizer(target: self, action: #selector(didTappedOutside))
        self.addGestureRecognizer(outSideTap)
        
        self.addSubview(remindMeLabel)
        remindMeLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
        }
        
        reminderTextField.text = initialText
        self.addSubview(reminderTextField)
        reminderTextField.delegate = self
        reminderTextField.setContentCompressionResistancePriority(.required, for: .vertical)
        reminderTextField.snp.makeConstraints { (make) in
            make.top.equalTo(remindMeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
        }
        reminderTextField.becomeFirstResponder()
        
        self.addSubview(whenLabel)
        whenLabel.snp.makeConstraints { (make) in
            make.top.equalTo(reminderTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        self.addSubview(whenControl)
        whenControl.addTarget(self, action: #selector(didChangedSelection(sender:)), for: .valueChanged)
        whenControl.snp.makeConstraints { (make) in
            make.top.equalTo(whenLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.addSubview(datePicker)
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 5
        datePicker.minimumDate = Date()
        datePicker.maximumDate = maxDate
        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(whenControl.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        

        self.addSubview(daysBeforeEndPickerContainer)
        daysBeforeEndPickerContainer.isUserInteractionEnabled = true
        daysBeforeEndPickerContainer.snp.makeConstraints { (make) in
            make.top.equalTo(whenControl.snp.bottom).offset(10)
            make.left.equalTo(datePicker.snp.right).offset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(80)
        }
        
        daysBeforeEndPickerContainer.addSubview(daysBeforeEndPicker)
        daysBeforeEndPicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
        daysBeforeEndPicker.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(daysBeforeEndPickerContainer.snp.width)
            make.width.equalTo(50)
        }
        
        self.addSubview(addReminderButton)
        addReminderButton.addTarget(self, action: #selector(didTappedAddReminderButton), for: .touchUpInside)
        addReminderButton.snp.makeConstraints { (make) in
            make.top.equalTo(datePicker.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didChangedSelection(sender: SegmentedControl) {
        if sender.indexOfSelectedOption == 0 {
            datePicker.snp.remakeConstraints { (make) in
                make.top.equalTo(whenControl.snp.bottom).offset(10)
                make.right.equalTo(self.snp.left)
            }
            addReminderButton.snp.remakeConstraints { (make) in
                make.top.equalTo(daysBeforeEndPickerContainer.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else if sender.indexOfSelectedOption == 1 {
            datePicker.snp.remakeConstraints { (make) in
                make.top.equalTo(whenControl.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            addReminderButton.snp.remakeConstraints { (make) in
                make.top.equalTo(datePicker.snp.bottom).offset(10)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            fatalError("unsupported option selected - \(sender.indexOfSelectedOption)")
        }
    }
    
    @objc func didTappedAddReminderButton() {
        //delegate?.didRequestedToAdd(reminder: reminderTextField.text ?? "", on: datePicker.date)
        delegate?.didTapAddReminder()
    }
    
    @objc func didTappedOutside() {
        reminderTextField.resignFirstResponder()
    }
}

extension ReminderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
