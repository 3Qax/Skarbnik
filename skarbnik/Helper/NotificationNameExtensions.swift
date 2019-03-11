//
//  NotificationNameExtension.swift
//  skarbnik
//
//  Created by Jakub Towarek on 05/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let modelChangedPendingPayemnts = Notification.Name("modelChangedPendingPayemnts")
    static let modelChangedPaidPayemnts = Notification.Name("modelChangedPaidPayemnts")
}
