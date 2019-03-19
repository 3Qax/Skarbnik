//
//  NotificationNameExtension.swift
//  skarbnik
//
//  Created by Jakub Towarek on 05/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let modelLoadedPayments = Notification.Name("modelLoadedPayments")
    static let setStatus = Notification.Name("setStatus")
    static let removeStatus = Notification.Name("removeStatus")
}
