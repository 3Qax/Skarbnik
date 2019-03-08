//
//  ReminderModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 07/03/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import EventKit



class ReminderModel {
    
    private let eventStore = EKEventStore()
    
    let paymentName: String
    let endDate: Date
    var defaultReminderText: String {
        get {
            return "Zapłacić za ".capitalizingFirstLetter() + paymentName.decapitalizeingFirstLetter()
        }
    }
    let possibleDaysBeforeEnd: Int
    
    enum Result {
        case succeed
        case failure(FailureReason)
    }
    
    enum FailureReason {
        case permissionDenied
        case permissionRestricted
    }
    
    init(paymentName: String, endDate: Date) {
        self.paymentName = paymentName
        self.endDate = endDate
        
        //calculate how many days left before end of payment
        possibleDaysBeforeEnd = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0

    }
    
    func addReminder(withTitle title: String, daysBeforeEnd: Int, handler: @escaping (Result) -> ()) {
        let designatedDate = Calendar.current.date(byAdding: .day, value: -daysBeforeEnd, to: endDate, wrappingComponents: false)
        addReminder(withTitle: title, on: designatedDate!, handler: handler)
    }

    func addReminder(withTitle title: String, on date: Date, handler: @escaping (Result) -> ()) {
        switch EKEventStore.authorizationStatus(for: .reminder) {
            case .notDetermined:
                eventStore.requestAccess(to: .reminder, completion: { _,_ in self.addReminder(withTitle: title, on: date, handler: handler) } )
            case .restricted:
                handler(.failure(.permissionRestricted))
            case .denied:
                handler(.failure(.permissionDenied))
            case .authorized:
                let reminder = EKReminder(eventStore: eventStore)
                reminder.title = title
                reminder.addAlarm(EKAlarm(absoluteDate: date))
                reminder.calendar = eventStore.calendars(for: .reminder).first
                try! eventStore.save(reminder, commit: true)
                handler(.succeed)
        }
    }
    
    
    
}


