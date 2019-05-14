//
//  ImagesView.swift
//  skarbnik
//
//  Created by Jakub Towarek on 14/05/2019.
//  Copyright © 2019 Jakub Towarek. All rights reserved.
//

import UIKit



class ImagesView: UIView {
    
    let scrollView = UIScrollView()
    
    
    
    
    init(imagesData: [Data]) {
        
        super.init(frame: .zero)
        
        self.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imagesData.forEach { (data) in
            //TODO: handle corrupted data by showing corrupted data image and a little note below
            let image: UIImage = UIImage(data: data) ?? UIImage(named: "corupted data image")!
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.width.height.equalToSuperview()
                make.top.equalToSuperview()
                if let last = self.scrollView.subviews.dropLast().last {
                    make.left.equalTo(last.snp.right)
                } else { make.left.equalToSuperview() }
                
            })
        }
        
        if let last = scrollView.subviews.last {
            last.snp.makeConstraints({ (make) in
                make.right.equalToSuperview()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
