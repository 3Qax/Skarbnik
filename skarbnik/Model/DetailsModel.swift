//
//  DetailsModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/04/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation



struct Detail {
    let title: String
    let value: String
}
class DetailsModel {
    let payment: Payment
    private let apiClient = APIClient()
    
    init(of payment: Payment) {
        self.payment = payment
        for i in payment.images.indices {
            guard payment.images[i].state == .notLoaded else {
                continue
            }
            payment.images[i].state = .loading
            apiClient.getImageData(from: payment.images[i].url) { result in
                switch result {
                case .success(let data):
                    payment.images[i].data = data
                    payment.images[i].state = .loaded
                    NotificationCenter.default.post(name: .loadedImage, object: nil, userInfo: ["image_id" : payment.images[i].id])
                case .failure(let error):
                    print("Encountered error while tring to GET image, with id = \(payment.images[i].id), data: \(error.localizedDescription)!")
                    payment.images[i].state = .error
                }
            }
        }
        


    }
}
