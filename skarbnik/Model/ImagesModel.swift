//
//  ImagesModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 28/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation




class ImagesModel {
    private let apiClient = APIClient()
    var images: [Image]
    
    
    init(images: inout [Image]) {
        self.images = images
        
        for i in images.indices {
            guard images[i].state == .notLoaded else {
                continue
            }
            images[i].state = .loading
            apiClient.getImageData(from: images[i].URL) { result in
                switch result {
                case .success(let data):
                    self.images[i].data = data
                    self.images[i].state = .loaded
                    NotificationCenter.default.post(name: .loadedImage, object: nil, userInfo: ["image_id" : self.images[i].id])
                case .failure(let error):
                    print(error.localizedDescription)
                    switch error {
                    case ImageGettingErrors.incorrectURL:
                        self.images[i].state = .error
                        print("Can not load image from incorrect URL: \(self.images[i].URL)")
                    default:
                        self.images[i].state = .error
                    }
                }
            }
        }
    }
    
}
