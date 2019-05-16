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
        var convertedImages = Dictionary<Int, Data?>()
        images.forEach { (image) in
            convertedImages[image.id]=image.data
        }
        imagesView = ImagesView(imagesData: convertedImages)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = imagesView
        imagesView.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ImagesViewController: ImagesViewDelegate {
    
    func didTapBack() {
        coordinator?.goBack()
    }
    
}

extension ImagesViewController: ImagesModelDelegate {
    
    func shouldUpdate(ImageHavingId id: Int, withData data: Data?) {
        imagesView.imagesData[id] = data
    }
    
}
