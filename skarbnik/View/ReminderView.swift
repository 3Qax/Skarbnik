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
    let picker = UIDatePicker(frame: .zero)
    
    //Action section
    let addReminderButton = RaisedButton(title: "Dodaj przypomnienie...")
    
    var delegate: ReminderDelegate?
    
    init(initialText: String, maxDate: Date) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(rgb: 0xF5F5F5)
        
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
        
        
        
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 5
        picker.minimumDate = Date()
        picker.maximumDate = maxDate
        self.addSubview(picker)
        picker.snp.makeConstraints { (make) in
            make.top.equalTo(whenControl.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        self.addSubview(addReminderButton)
        addReminderButton.addTarget(self, action: #selector(didTappedAddReminderButton), for: .touchUpInside)
        addReminderButton.snp.makeConstraints { (make) in
            make.top.equalTo(picker.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didChangedSelection(sender: SegmentedControl) {
        print(sender.indexOfSelectedOption)
    }
    
    @objc func didTappedAddReminderButton() {
        delegate?.didRequestedToAdd(reminder: reminderTextField.text ?? "", on: picker.date)
    }
}

extension ReminderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
