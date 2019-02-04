//
//  PaymentViewPendingPaymentCellController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/01/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import EventKit

//MARK:
extension PaymentViewController: PendingPaymentCellProtocool {
    func didTappedRemindButton(sender: PendingPaymentCellView) {
        
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .notDetermined:
            eventStore.requestAccess(to: .reminder) { (succed, error: Error?) in
                guard succed else { return }
                self.didTappedRemindButton(sender: sender)
            }
        case .authorized:
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = NSLocalizedString("reminder_prefix_before_payment_name", comment: "") + "\(paymentModel.pendingPayments[sender.index!].name)"
            let alarm = EKAlarm(absoluteDate: Calendar.current.date(byAdding: .day, value: -1, to: paymentModel.pendingPayments[sender.index!].end_date)!)
            reminder.addAlarm(alarm)
            let calendars = eventStore.calendars(for: .reminder)
            reminder.calendar = calendars.first
            do {
                try eventStore.save(reminder, commit: true)
            } catch {
                print(error.localizedDescription)
            }
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        }
    }
}
