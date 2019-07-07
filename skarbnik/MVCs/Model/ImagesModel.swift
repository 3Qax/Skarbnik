//
//  ImagesModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 28/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation




class ImagesModel {
    var images: [Payment.Image]
    
    
    init(images: [Payment.Image]) {
        self.images = images
        
        for i in images.indices {
            guard images[i].state == .notLoaded else {
                continue
            }
            images[i].state = .loading
            NetworkManager.shared.getImageData(from: images[i].url) { result in
                switch result {
                case .success(let data):
                    self.images[i].data = data
                    self.images[i].state = .loaded
                    NotificationCenter.default.post(name: .loadedImage, object: nil, userInfo: ["image_id" : self.images[i].id])
                case .failure(let error):
                    print("Encountered error while tring to GET image, with id = \(images[i].id), data: \(error.localizedDescription)!")
                    self.images[i].state = .error
                }
            }
        }
    }
    
}
