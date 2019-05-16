//
//  ImagesModel.swift
//  skarbnik
//
//  Created by Jakub Towarek on 16/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import Foundation




class ImagesModel {
    
    @objc var images: [Image]
    var delegate: ImagesModelDelegate?
    
    init(images: [Image]) {
        self.images = images
        
        images.forEach { (image) in
            let _ = image.observe(\Image.data, options: .new, changeHandler: { (image, change) in
                self.delegate?.shouldUpdate(ImageHavingId: image.id, withData: image.data)
            })
        }
    }
    
    
}
