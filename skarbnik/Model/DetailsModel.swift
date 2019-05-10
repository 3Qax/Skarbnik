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
            payment.images[i].state = .loading
            apiClient.getImageData(from: payment.images[i].URL) { result in
                switch result {
                case .success(let data):
                    payment.images[i].data = data
                    payment.images[i].state = .loaded
                case .failure(let error):
                    print(error.localizedDescription)
                    switch error {
                    case ImageGettingErrors.incorrectURL:
                        payment.images[i].state = .error
                        print("Can not load image from incorrect URL: \(payment.images[i].URL)")
                    default:
                        payment.images[i].state = .error
                    }
                }
            }
        }
        


    }
}
