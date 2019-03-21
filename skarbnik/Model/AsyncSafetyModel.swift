//
//  AsyncPasswordModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 06/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



class AsyncSafetyModel {
    let apiClient = APIClient()
    var delegate: AsyncSafetyProtocool?
    private var activities: [Activity] = [Activity]()
    
    
    struct Activity: Codable {
        let id: Int
        let login_datetime: String
        let login_username: String
        let status: String // S(uccessful) or F(ailed)
        let login_IP: String
    }
    
    
    
    func start() {
        
        switch TokenManager.shared.get(.username) {
        case .success(let username):
            
            let queryParameters = [URLQueryItem(name: "login_username", value: username),
                                   URLQueryItem(name: "page", value: "1"),
                                   URLQueryItem(name: "page_size", value: "2"),
                                   URLQueryItem(name: "ordering", value: "-login_datetime")]

            apiClient.get(from: .activity, adding: queryParameters) { (result: APIClient.Result<[Activity]>) in
                switch result {
                case .success(let recivedActivities):
                    self.activities = recivedActivities
                    self.interpretActivities()
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
            
        case .notAuthorised:
            fatalError("AsyncSafetyModel should run only after correct authorisation!")
        }
    }
    
    func interpretActivities() {
        DispatchQueue.main.async {
            
            guard self.activities.count != 1 else {
                self.delegate?.requirePasswordChange()
                return
            }
            
            for i in 0..<self.activities.count {
                if self.activities[i].status == "F" {
                    let longDateFormatter = ISO8601DateFormatter()
                    let date = longDateFormatter.date(from: self.activities[1].login_datetime)!
                    self.delegate?.lastLoginUnsuccessful(date, fromIP: self.activities[1].login_IP)
                    return
                }
            }
            
            //        activities.forEach { (activity) in
            //            if activity.status == "F" {
            //                let longDateFormatter = ISO8601DateFormatter()
            //                let date = longDateFormatter.date(from: activity.login_datetime)!
            //                delegate?.lastLoginUnsuccessful(date, fromIP: activity.login_IP)
            //                return
            //            }
            //        }
            
            print("interpret ended with no errors")
            self.delegate?.everythingOk()
        }
    }
    
    
    
}
