//
//  PickStudentModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 04/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

class PickStudentModel {
    private let apiClient = APIClient()
    
    private struct Child: Codable {
        let id_field: Int
        let class_field: Class
        let name: String
    }
    
    private struct Class: Codable {
        let id_field: Int
        let name: String
    }
    
    private func encode<T: Encodable>(_ data: T) -> Data {
        return try! JSONEncoder().encode(data)
    }
    
    private func decode<T: Decodable>(_: T.Type, from data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    func getStudentsWithClassID(completion: @escaping ([String: [Int]]) -> ()) {
        
        switch TokenManager.shared.get(.user_id) {
        case .success(let user_id):
            NotificationCenter.default.post(name: .setStatus, object: nil, userInfo: ["status":"Aktualizowanie listy..."])
            apiClient.get(from: .student, adding: [URLQueryItem(name: "user", value: String(user_id))]) { (result: APIClient.Result<[Child]>) in
                switch result {
                case .success(let students):
                    DispatchQueue.main.async { NotificationCenter.default.post(name: .removeStatus, object: nil) }
                    var studentsWithIDs: [String: [Int]] = [String: [Int]]()
                    for student in students {
                        studentsWithIDs[student.name] = [student.id_field, student.class_field.id_field]
                    }
                    completion(studentsWithIDs)
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
            
        case .notAuthorised:
            fatalError("User shouldn't pick student without authorisation!")
        }
        
    }
    
    
    
    
}
