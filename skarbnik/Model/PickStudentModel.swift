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
    
    private func getCurrentUserID() -> Int {
        let token: String = UserDefaults.standard.string(forKey: "JWT")!
        
        struct User: Codable {
            var user_id: Int
            var username: String
        }
        
        let firstDot = token.range(of: ".")
        let withoutHeader = token[firstDot!.upperBound..<token.endIndex]
        
        let secondDot = withoutHeader.range(of: ".")
        let payload = withoutHeader[..<secondDot!.lowerBound]
        
        //Foundation implementation of base64 is so stupid that it can't calculate missing bits...
        let correctedPayload: String = payload.padding(toLength: ((payload.count+3)/4)*4,
                                  withPad: "=",
                                  startingAt: 0)
        
        
        let data = Data(base64Encoded: correctedPayload)!
        
        return decode(User.self, from: data).user_id
    
    }
        
        
    
    func getStudentsWithIDs(completion: @escaping ([String: Int]) -> ()) {
        apiClient.request(.student, queryItems: [URLQueryItem(name: "user", value: String(getCurrentUserID()))]) { (succeed, data) in
            guard succeed else {
                print("Error while getting students info")
                return
            }
            if let data = data {
                let students = self.decode([Child].self, from: data)
                var studentsWithIDs: [String: Int] = [String: Int]()
                for student in students {
                    studentsWithIDs[student.name] = student.id_field
                }
                completion(studentsWithIDs)
            }
        }
    }
}
