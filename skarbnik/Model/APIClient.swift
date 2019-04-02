//
//  ApiClient.swift
//  skarbnik
//
//  Created by Jakub Towarek on 03/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}

class APIClient {
    
    private let baseURL: URLComponents
    
    enum Endpoint: String {
        case login          = "/api/users/login"
        case refresh        = "/api/users/refresh"
        case currentUser    = "/api/users/current/"
        case changePassword = "/api/users/change_password"
        case student        = "/api/student/"
        case payment        = "/api/payment/"
        case paymentDetail  = "/api/paymentdetail/"
        case activity       = "/api/activity/"
    }
    
   private enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    

    init() {
        #if targetEnvironment(simulator)
        baseURL = URLComponents(string: "http://localhost:8000")!
        #else
        baseURL = URLComponents(string: "http://192.168.1.134:8000")!
        #endif
    }
    
    func decode<T: Decodable>(_: T.Type, from data: Data) throws -> T {
        //        return try? JSONDecoder().decode(T.self, from: data)
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch let error {
            throw error
        }
    }
    
    private func fullURL(of endpoint: Endpoint, queryItems: [URLQueryItem]? = nil) -> URL {
        var customizedURL = baseURL
        customizedURL.path = endpoint.rawValue
        
        if let queryItems = queryItems {
            customizedURL.queryItems = queryItems
        }
        
        guard customizedURL.url != nil else {
            fatalError("Provided data was incorrect - cannnot create URL from it!")
        }
        return customizedURL.url!
    }
    
    private func createRequest(_ method: RequestMethod, from url: URL, addingValueHeader headers: [String : String]? = nil, addingData data: Data? = nil, timeout: TimeInterval = 20, authorise: Bool = true) -> URLRequest {
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
        
        request.httpMethod = method.rawValue
        
        if authorise {
            request.addValue("Basic " + TokenManager.shared.getToken(), forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headers = headers {
            for (header, value) in headers {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        if let data = data {
            request.httpBody = data
        }
        
        return request
    }
    
    //POST
    func post<T: Decodable>(_ data: Data, to endpoint: Endpoint, adding queryItems: [URLQueryItem]? = nil, handler: @escaping (Result<T>) -> ()) {
        var request: URLRequest?
        
        switch endpoint {
        case .login:
            request = createRequest(.post, from: fullURL(of: endpoint, queryItems: queryItems), addingData: data, authorise: false)
        case .refresh:
            request = createRequest(.post, from: fullURL(of: endpoint, queryItems: queryItems), addingData: data, authorise: false)
        default:
            request = createRequest(.post, from: fullURL(of: endpoint, queryItems: queryItems), addingData: data)
        }
        
        let task = URLSession.shared.dataTask(with: request!) { (data, response, error) in
            self.taskCompletionHandler(data: data, response: response, error: error, requestSenderCompletion: handler)
        }
        task.resume()
    }
    
    func put<T: Decodable>(_ data: Data, to endpoint: Endpoint, addingQueryItems queryItems: [URLQueryItem]? = nil, handler: @escaping (Result<T>) -> ()) {
        let request = createRequest(.put, from: fullURL(of: endpoint, queryItems: queryItems), addingData: data)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.taskCompletionHandler(data: data, response: response, error: error, requestSenderCompletion: handler)
        }
        task.resume()
    }
    
    //GET
    func get<T: Decodable>(from endpoint: Endpoint, adding queryItems: [URLQueryItem]? = nil, handler: @escaping (Result<T>) -> ()) {
        
        let request = createRequest(.get, from: fullURL(of: endpoint, queryItems: queryItems))
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.taskCompletionHandler(data: data, response: response, error: error, requestSenderCompletion: handler)
        }
        task.resume()
        
    }
    
    
    func taskCompletionHandler<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, requestSenderCompletion: (Result<T>) -> () ) {
        if let error = error {
            requestSenderCompletion(.failure(error))
        } else {
            if let data = data, let response = response as? HTTPURLResponse {
                
                do {
                    let encodedData = try decode(T.self, from: data)
                    
                    switch response.statusCode {
                    case 200:
                        requestSenderCompletion(.success(encodedData))
                    case 201:
                        requestSenderCompletion(.success(encodedData))
                    case 204:
                        requestSenderCompletion(.success(encodedData))
                    default:
                        print("HTTP StatusCode: \(response.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))")
                        requestSenderCompletion(.success(encodedData))
                    }
                    
                } catch let error {
                    return requestSenderCompletion(.failure(error))
                }
                
                
            }
        }
    }
    
    
    
    
}
