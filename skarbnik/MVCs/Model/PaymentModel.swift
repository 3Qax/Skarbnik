//
//  PaymentModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 04/02/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation

class PaymentModel {
    private let classID: Int
    private let studentID: Int
    
    private let dispatchGroup                   = DispatchGroup()
    
    private var recivedPayments                 = [Payment]()
    private var filter: (Payment) -> Bool       = { _ in return true }
    public  var payments: [Payment] {
        get {
            return recivedPayments.filter({self.filter($0)})
        }
    }
    
    private var onRefreshCompletion: () -> ()   = { print("refreshing ended") }
    

    
    

    
    
    init(of studentID:Int, in classID: Int) {
        self.studentID = studentID
        self.classID = classID
        loadData()
    }
    
    func loadData() {
        NotificationCenter.default.post(name: .setStatus, object: nil, userInfo: ["status":"Pobieranie danych..."])
        NetworkManager.shared.get(from: .payment, adding: [URLQueryItem(name: "class_field", value: String(classID))]) { (result: ResultWithData<[Payment]>) in
            switch result {
            case .success(let recivedPayments):
                self.recivedPayments = recivedPayments
                self.recivedPayments.forEach({ (payment) in
                    self.dispatchGroup.enter()
                    let queryItems = [URLQueryItem(name: "payment", value: String(payment.id)),
                                      URLQueryItem(name: "student", value: String(self.studentID))]
                    NetworkManager.shared.get(from: .paymentDetail, adding: queryItems) { (result: ResultWithData<[Payment.Contribution]>) in
                        switch result {
                        case .success(let recivedContributions):
                            payment.contributions.append(contentsOf: recivedContributions)
                            self.dispatchGroup.leave()
                        case .failure(let error):
                            fatalError(error.localizedDescription)
                        }
                    }
                })
                self.dispatchGroup.notify(queue: .main) {
                    self.recivedPayments.sort(by: { return $0.state.rawValue < $1.state.rawValue })
                    NotificationCenter.default.post(name: .modelLoadedPayments, object: self)
                    NotificationCenter.default.post(name: .removeStatus, object: self)
                }
                
            case .failure(let error):
                print("Faild getting payments data!")
                fatalError(error.localizedDescription)
            }
        }
        
    }
    
    func refreshData() {
        recivedPayments.removeAll(keepingCapacity: true)
        loadData()
    }
    
    func setFilter(to phrase: String) {
        guard phrase != "" else {
            filter = { _ in return true }
            return
        }
        filter = { return $0.title.localizedCaseInsensitiveContains(phrase) || $0.description.localizedCaseInsensitiveContains(phrase) }
    }
    
}
