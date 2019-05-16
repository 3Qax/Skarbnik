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
    var images: [Image]
    var coordinator: PaymentCoordinator?
    
    
    init(of images: inout [Image]) {
        
        self.images = images
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: .loadedImage, object: <#T##Any?#>, queue: .main) { (notification) in
            self.shouldUpdate(ImageWithId: notification.userInfo!["image_id"] as! Int)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .loadedImage, object: nil)
    }
    
    func shouldUpdate(ImageWithId id: Int) {
        imagesView.imagesData[id] = images.first(where: {$0.id == id})?.data
    }
}

extension ImagesViewController: ImagesViewDelegate {
    
    func didTapBack() {
        coordinator?.goBack()
    }
    
}
