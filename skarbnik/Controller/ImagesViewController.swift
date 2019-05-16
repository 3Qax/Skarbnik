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
        NotificationCenter.default.addObserver(forName: .loadedImage, object: nil, queue: .main) { (notification) in
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
    
    func foundCorruptedImageData() {
        AlertBuilder()
            .setTitle("Coś jest nie tak...")
            .setMessage("Wygląda na to że jedno z dołączonych zdjęć jest uszkodzone lub ma nie obsługiwany format. W razie takiej potrzeby skontaktuj się z administratorem.")
            .addAction(withStyle: .default, text: "OK")
            .show(in: self)
    }
    
    func didTapBack() {
        coordinator?.goBack()
    }
    
}
