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
        let id = TokenManager.shared.get(.user_id)
        switch id {
        case .success(let user_id):
            apiClient.request(
                .student,
                queryItems: [URLQueryItem(name: "user", value: String(user_id))],
                completion: { (succeed, data) in
                    guard succeed else {
                        print("Error while getting students info")
                        return
                    }
                    if let data = data {
                        let students = self.decode([Child].self, from: data)
                        var studentsWithIDs: [String: [Int]] = [String: [Int]]()
                        for student in students {
                            studentsWithIDs[student.name] = [student.id_field, student.class_field.id_field]
                        }
                        completion(studentsWithIDs)
                    }
                })
        case .notAuthorised:
            fatalError("User shouldn't pick student without authorisation!")
        }
        
    }
    
    
    
    
}
