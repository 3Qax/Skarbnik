////
////  ReminderAlertsController.swift
////  skarbnik
////
////  Created by Jakub Towarek on 08/03/2019.
////  Copyright © 2019 Jakub Towarek. All rights reserved.
////
//
//import UIKit
//
//
//
//struct ReminderAlertsController {
//    let permissionDenidedAlert: UIAlertController
//    let permissionNotGrantedAlert: UIAlertController
//    
//    
//    
//    
//    init() {
//        let permissionDenidedAlert = UIAlertController(  title: "Nie pozwoliłeś nam na to!",
//                                                         message: "Nie dałeś nam wystarczających uprawnień. Może chcesz zmienić zdanie? Bo jak nie zmienisz to dalej będziemy siedzieć cicho \u{1F910}!",
//                                                         preferredStyle: .alert)
//        permissionDenidedAlert.addAction(UIAlertAction(title: "Zmieniam zdanie...", style: .default, handler: { _ in
//            let goToSettingsAlert = UIAlertController(  title: "Wcześniej namieszałeś to teraz masz!",
//                                                        message: "Żeby zmienić uprawnienia apliakcji musisz w ustawieniach telefonu wejśc w ustawienia naszej aplikacji i pozwolić nam na przypomnienia.",
//                                                        preferredStyle: .alert)
//            goToSettingsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
//                self.coordinator?.didAddReminder()
//            }))
//            self.present(goToSettingsAlert, animated: true)
//        }))
//        permissionDenidedAlert.addAction(UIAlertAction(title: "Cicho tam!", style: .destructive, handler: { _ in
//            self.coordinator?.didAddReminder()
//        }))
//        
//        
//        
//        let permissionNotGrantedAlert = UIAlertController(  title: "Jak mamy Ci przypomnieć jak nam nie pozwalasz?",
//                                                            message: "To ty masz tu władzę! Więc skoro tak chcesz, to Ci nie przypomnimy. \u{1F910}!",
//                                                            preferredStyle: .alert)
//        permissionNotGrantedAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
//            self.coordinator?.didAddReminder()
//        }))
//        
//        
//        
//        
//    }
//}
