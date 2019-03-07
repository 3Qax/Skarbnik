//
//  ReminderController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 21/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation
import UIKit
import EventKit


class ReminderController: UIViewController {
    var reminderModel: ReminderModel?
    var coordinator: MainCoordinator?
    let eventStore = EKEventStore()
    
    override func loadView() {
        view = ReminderView(initialText: reminderModel!.defaultReminderText, maxDate: reminderModel!.endDate)
        (view as! ReminderView).delegate = self
    }
    
    init(about: String, ending: Date) {
        super.init(nibName: nil, bundle: nil)
        reminderModel = ReminderModel(paymentName: about, endDate: ending)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
}

extension ReminderController: ReminderDelegate {
    func didRequestedToAdd(reminder title: String, on: Date) {
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .notDetermined:
            //notificationFeedbackGenerator.notificationOccurred(.warning)
            eventStore.requestAccess(to: .reminder) { (succed, error: Error?) in
                guard succed else {
                    let permissionNotGrantedAlert = UIAlertController(  title: "Jak mamy Ci przypomnieć jak nam nie pozwalasz?",
                                                                        message: "To ty masz tu władzę! Więc skoro tak chcesz, to Ci nie przypomnimy. \u{1F910}!",
                                                                        preferredStyle: .alert)
                    permissionNotGrantedAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
                        self.coordinator?.didAddReminder()
                    }))
                    //notificationFeedbackGenerator.notificationOccurred(.error)
                    return
                }
                self.didRequestedToAdd(reminder: title, on: on)
            }
        case .authorized:
            let reminder = EKReminder(eventStore: eventStore)
            reminder.title = title
            reminder.addAlarm(EKAlarm(absoluteDate: on))
            reminder.calendar = eventStore.calendars(for: .reminder).first
            do {
                try eventStore.save(reminder, commit: true)
            } catch {
                print(error.localizedDescription)
            }
            notificationFeedbackGenerator.notificationOccurred(.success)
        case .restricted:
            print("restricted")
        case .denied:
            let permissionDenidedAlert = UIAlertController(  title: "Nie pozwoliłeś nam na to!",
                                                                message: "Nie dałeś nam wystarczających uprawnień. Może chcesz zmienić zdanie? Bo jak nie zmienisz to dalej będziemy siedzieć cicho \u{1F910}!",
                                                                preferredStyle: .alert)
            permissionDenidedAlert.addAction(UIAlertAction(title: "Zmieniam zdanie...", style: .default, handler: { _ in
                let goToSettingsAlert = UIAlertController(  title: "Wcześniej namieszałeś to teraz masz!",
                                                                 message: "Żeby zmienić uprawnienia apliakcji musisz w ustawieniach telefonu wejśc w ustawienia naszej aplikacji i pozwolić nam na przypomnienia.",
                                                                 preferredStyle: .alert)
                goToSettingsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    self.coordinator?.didAddReminder()
                }))
                self.present(goToSettingsAlert, animated: true)
            }))
            permissionDenidedAlert.addAction(UIAlertAction(title: "Cicho tam!", style: .destructive, handler: { _ in
                self.coordinator?.didAddReminder()
            }))
            self.present(permissionDenidedAlert, animated: true)
            
        }
        
        coordinator?.didAddReminder()
    }
}
