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
    weak var delegate: AsyncSafetyProtocool?
    private var activities: [Activity] = [Activity]()
    
    private func encode<T: Encodable>(_ data: T) -> Data {
        return try! JSONEncoder().encode(data)
    }
    
    private func decode<T: Decodable>(_: T.Type, from data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    struct Activity: Codable {
        let id: Int
        let login_datetime: String
        let login_username: String
        let status: String // S(uccessful) or F(ailed)
        let login_IP: String
    }
    
    
    
    init() {
        

        
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
        if activities.count == 1 {
            delegate?.requirePasswordChange()
        } else {
            delegate?.dontRequirePasswordChange()
        }
        
        for i in 0..<activities.count {
            if activities[i].status == "F" {
                let longDateFormatter = ISO8601DateFormatter()
                let date = longDateFormatter.date(from: activities[1].login_datetime)!
                delegate?.lastLoginUnsuccessful(date, fromIP: activities[1].login_IP)
            } else {
                delegate?.lastLoginSuccessful()
            }
        }
    }
    
    
    
}
