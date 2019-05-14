//
//  ImagesViewController.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class ImagesViewController: UIViewController {
    
    let imagesView: ImagesView
    var coordinator: PaymentCoordinator?
    
    
    init(of images: [Image]) {
        //TODO: handle images that still can be loading
        imagesView = ImagesView(imagesData: images.compactMap({$0.data}))
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = imagesView
    }
}
